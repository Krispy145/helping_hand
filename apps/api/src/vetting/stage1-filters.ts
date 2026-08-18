export type Helpline = {
  name: string;
  phone: string;
  region: string;
};

export const ZA_CRISIS_HELPLINES: Helpline[] = [
  { name: 'SADAG suicide crisis line', phone: '0800 567 567', region: 'ZA' },
  { name: 'SADAG SMS', phone: '31393', region: 'ZA' },
  { name: 'Emergency services', phone: '112', region: 'ZA' },
];

export type Stage1Match = {
  triggeredRule: string;
  reasonCode: string;
  userMessage: string;
  showHelplines: boolean;
  helplines: Helpline[];
  confidenceScore: number;
};

const PII_EMAIL = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i;
const PII_PHONE =
  /(?:\+|00)\d{1,3}[\s.-]?(?:\d{2,4}[\s.-]?){2,3}\d{3,4}|\b0\d{2}[\s.-]?\d{3}[\s.-]?\d{4}\b/;
const PII_HANDLE =
  /(?:\b(?:whatsapp|telegram|instagram|facebook|tiktok)\b|\bt\.me\/|instagram\.com\/)|(?:^|[\s])@[a-z0-9._]{3,}\b/i;

const CRISIS_PATTERNS = [
  /\bsuicid(?:e|al)\b/i,
  /\bkill myself\b/i,
  /\bwant to die\b/i,
  /\bend my life\b/i,
  /\bself[-\s]?harm\b/i,
];

const ACCOMMODATION_PATTERNS = [
  /\bplace to stay\b/i,
  /\bsleep(?:ing)? over\b/i,
  /\bcrash (?:at|on)\b/i,
  /\bneed a (?:bed|couch|room)\b/i,
];

const MONEY_KEYWORDS = [
  'scam',
  'bank transfer',
  'password',
  'credit card',
  'gift card',
  'crypto',
  'bitcoin',
  'cashapp',
  'venmo',
  'send money',
  'wire me',
];

export function matchStage1Filters(text: string): Stage1Match | null {
  if (PII_EMAIL.test(text) || PII_PHONE.test(text) || PII_HANDLE.test(text)) {
    return {
      triggeredRule: 'Stage 1: PII leak',
      reasonCode: 'PII_LEAK',
      userMessage:
        'Please remove phone numbers, emails, or social handles. Keep contact inside the app.',
      showHelplines: false,
      helplines: [],
      confidenceScore: 1,
    };
  }

  if (CRISIS_PATTERNS.some((pattern) => pattern.test(text))) {
    return {
      triggeredRule: 'Stage 1: Crisis / self-harm',
      reasonCode: 'CRISIS_SELF_HARM',
      userMessage:
        'Helping Hand is not an emergency service. If you are in crisis, please contact a helpline now.',
      showHelplines: true,
      helplines: ZA_CRISIS_HELPLINES,
      confidenceScore: 1,
    };
  }

  if (ACCOMMODATION_PATTERNS.some((pattern) => pattern.test(text))) {
    return {
      triggeredRule: 'Stage 1: Accommodation policy',
      reasonCode: 'ACCOMMODATION',
      userMessage:
        'Person-to-person places to stay are not allowed. Ask for help finding official local resources instead.',
      showHelplines: false,
      helplines: [],
      confidenceScore: 1,
    };
  }

  const normalized = text.toLowerCase();
  const keyword = MONEY_KEYWORDS.find((item) => normalized.includes(item));
  if (keyword || normalized.includes('money')) {
    return {
      triggeredRule: `Stage 1: Restricted keyword (${keyword ?? 'money'})`,
      reasonCode: 'RESTRICTED_CONTENT',
      userMessage:
        'This request looks like it involves money or a scam pattern, so it cannot be shown to helpers.',
      showHelplines: false,
      helplines: [],
      confidenceScore: 1,
    };
  }

  return null;
}
