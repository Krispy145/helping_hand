export type RiskScores = {
  severeToxicity: number;
  threat: number;
  selfHarm: number;
  sexual: number;
};

export type RiskClassification = {
  scores: RiskScores;
  flagged: boolean;
};

export interface ContentRiskClassifier {
  classify(text: string): Promise<RiskClassification>;
}

/** MVP stub. Swap for Perspective / OpenAI Moderation later. */
export class StubContentRiskClassifier implements ContentRiskClassifier {
  classify(): Promise<RiskClassification> {
    return Promise.resolve({
      scores: {
        severeToxicity: 0,
        threat: 0,
        selfHarm: 0,
        sexual: 0,
      },
      flagged: false,
    });
  }
}

export type IntentDecision = {
  approved: boolean;
  triggeredRule: string | null;
  reason: string | null;
};

export interface IntentAnalyzer {
  analyze(text: string): Promise<IntentDecision>;
}

/** MVP stub. Swap for a small LLM later. */
export class StubIntentAnalyzer implements IntentAnalyzer {
  analyze(): Promise<IntentDecision> {
    return Promise.resolve({
      approved: true,
      triggeredRule: null,
      reason: null,
    });
  }
}
