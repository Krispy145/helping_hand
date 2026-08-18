import { Inject, Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { RequestStatus, SafetyIncidentSource } from '@prisma/client';
import {
  ZA_CRISIS_HELPLINES,
  containsPii,
  matchStage1Filters,
  type Helpline,
  type Stage1Match,
} from './stage1-filters';
import { ContentRiskClassifier, IntentAnalyzer } from './vetting-providers';

export type VettingResult = {
  status: RequestStatus;
  triggeredRule: string | null;
  reasonCode: string | null;
  userMessage: string | null;
  showHelplines: boolean;
  helplines: Helpline[];
  confidenceScore: number | null;
};

@Injectable()
export class VettingService {
  private readonly logger = new Logger(VettingService.name);

  constructor(
    private readonly prisma: PrismaService,
    @Inject('ContentRiskClassifier')
    private readonly riskClassifier: ContentRiskClassifier,
    @Inject('IntentAnalyzer')
    private readonly intentAnalyzer: IntentAnalyzer,
  ) {}

  async vetRequest(
    requestId: string,
    textToVet: string,
  ): Promise<VettingResult> {
    this.logger.log(`Vetting request ${requestId}`);

    const stage1 = matchStage1Filters(textToVet);
    if (stage1) {
      return this.reject(requestId, stage1, textToVet);
    }

    const risk = await this.riskClassifier.classify(textToVet);
    if (risk.flagged) {
      const crisis = risk.scores.selfHarm >= 0.8;
      return this.reject(
        requestId,
        {
          triggeredRule: 'Stage 2: Toxicity classifier',
          reasonCode: 'TOXICITY',
          userMessage:
            'This request was blocked because it looks unsafe or threatening.',
          showHelplines: crisis,
          helplines: crisis ? ZA_CRISIS_HELPLINES : [],
          confidenceScore: Math.max(
            risk.scores.severeToxicity,
            risk.scores.threat,
            risk.scores.selfHarm,
            risk.scores.sexual,
          ),
        },
        textToVet,
      );
    }

    const intent = await this.intentAnalyzer.analyze(textToVet);
    if (!intent.approved) {
      return this.reject(
        requestId,
        {
          triggeredRule: intent.triggeredRule ?? 'Stage 3: Intent policy',
          reasonCode: 'INTENT_POLICY',
          userMessage:
            intent.reason ??
            'This request does not meet Helping Hand safety rules.',
          showHelplines: false,
          helplines: [],
          confidenceScore: 0.7,
        },
        textToVet,
      );
    }

    await this.prisma.request.update({
      where: { id: requestId },
      data: { status: RequestStatus.APPROVED },
    });
    this.logger.log(`Request ${requestId} vetted. Status: APPROVED`);
    return {
      status: RequestStatus.APPROVED,
      triggeredRule: null,
      reasonCode: null,
      userMessage: null,
      showHelplines: false,
      helplines: [],
      confidenceScore: null,
    };
  }

  private async reject(
    requestId: string,
    match: Stage1Match,
    originalText: string,
  ): Promise<VettingResult> {
    await this.prisma.request.update({
      where: { id: requestId },
      data: {
        status: RequestStatus.REJECTED,
        ...(containsPii(originalText)
          ? {
              title: '[details removed]',
              description: 'Contact details were removed after vetting.',
            }
          : {}),
      },
    });

    const request = await this.prisma.request.findUnique({
      where: { id: requestId },
      select: { userId: true },
    });
    if (request) {
      await this.prisma.safetyIncident.create({
        data: {
          userId: request.userId,
          source: SafetyIncidentSource.REQUEST_VETTING,
          reasonCode: match.reasonCode,
          triggeredRule: match.triggeredRule,
          confidenceScore: match.confidenceScore,
          detailsRedacted: 'Stage filter matched. Original text not stored.',
          requestId,
        },
      });
    }

    this.logger.log(
      `Request ${requestId} vetted. Status: REJECTED (${match.triggeredRule})`,
    );
    return {
      status: RequestStatus.REJECTED,
      triggeredRule: match.triggeredRule,
      reasonCode: match.reasonCode,
      userMessage: match.userMessage,
      showHelplines: match.showHelplines,
      helplines: match.helplines,
      confidenceScore: match.confidenceScore,
    };
  }
}
