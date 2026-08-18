import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { RequestStatus, SafetyIncidentSource } from '@prisma/client';

@Injectable()
export class VettingService {
  private readonly logger = new Logger(VettingService.name);

  // Basic list of restricted keywords for MVP
  private readonly restrictedKeywords = [
    'scam',
    'money',
    'bank transfer',
    'password',
    'credit card',
    'gift card',
    'crypto',
    'bitcoin',
  ];

  constructor(private readonly prisma: PrismaService) {}

  async vetRequest(requestId: string, textToVet: string): Promise<void> {
    this.logger.log(`Vetting request ${requestId}`);

    const normalizedText = textToVet.toLowerCase();
    const hasRestrictedContent = this.restrictedKeywords.some((keyword) =>
      normalizedText.includes(keyword),
    );
    const newStatus = hasRestrictedContent
      ? RequestStatus.REJECTED
      : RequestStatus.APPROVED;

    await this.prisma.request.update({
      where: { id: requestId },
      data: { status: newStatus },
    });

    if (hasRestrictedContent) {
      const request = await this.prisma.request.findUnique({
        where: { id: requestId },
        select: { userId: true },
      });
      if (request) {
        await this.prisma.safetyIncident.create({
          data: {
            userId: request.userId,
            source: SafetyIncidentSource.REQUEST_VETTING,
            reasonCode: 'RESTRICTED_CONTENT',
            detailsRedacted: 'Keyword filter matched restricted content.',
            requestId,
          },
        });
      }
    }

    this.logger.log(
      `Request ${requestId} vetted. Status: ${newStatus} ${hasRestrictedContent ? '(Restricted content found)' : ''}`,
    );
  }
}
