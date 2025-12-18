import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { RequestStatus } from '@prisma/client';

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
    
    // Normalize text (lowercase)
    const normalizedText = textToVet.toLowerCase();
    
    // Check for restricted keywords
    const hasRestrictedContent = this.restrictedKeywords.some((keyword) => 
      normalizedText.includes(keyword)
    );

    const newStatus = hasRestrictedContent 
      ? RequestStatus.REJECTED 
      : RequestStatus.APPROVED;

    // Update Request Status
    await this.prisma.request.update({
      where: { id: requestId },
      data: { status: newStatus },
    });

    this.logger.log(
      `Request ${requestId} vetted. Status: ${newStatus} ${hasRestrictedContent ? '(Restricted content found)' : ''}`
    );
  }
}
