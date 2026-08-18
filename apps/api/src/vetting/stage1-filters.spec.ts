import { matchStage1Filters } from './stage1-filters';

describe('matchStage1Filters', () => {
  it('allows ordinary help requests', () => {
    expect(
      matchStage1Filters(
        'Need a grocery run this afternoon from a nearby shop',
      ),
    ).toBeNull();
  });

  it('catches emails and phones', () => {
    expect(matchStage1Filters('Email me at pat@example.com').reasonCode).toBe(
      'PII_LEAK',
    );
    expect(matchStage1Filters('WhatsApp +27 82 555 0101').reasonCode).toBe(
      'PII_LEAK',
    );
    expect(matchStage1Filters('Call (082) 123 4567').reasonCode).toBe(
      'PII_LEAK',
    );
    expect(matchStage1Filters('Reach me on +27 (82) 123 4567').reasonCode).toBe(
      'PII_LEAK',
    );
  });

  it('does not treat bare app names as PII', () => {
    expect(matchStage1Filters('Help me install WhatsApp')).toBeNull();
    expect(
      matchStage1Filters('Pick up an item from Facebook Marketplace'),
    ).toBeNull();
  });

  it('treats contact phrases and handles as PII', () => {
    expect(matchStage1Filters('WhatsApp me after you arrive').reasonCode).toBe(
      'PII_LEAK',
    );
    expect(matchStage1Filters('Message me on telegram').reasonCode).toBe(
      'PII_LEAK',
    );
    expect(matchStage1Filters('Find me @helper_pat').reasonCode).toBe(
      'PII_LEAK',
    );
  });

  it('routes crisis language to helplines before PII', () => {
    const match = matchStage1Filters('I want to die, call me on 082 123 4567');
    expect(match?.reasonCode).toBe('CRISIS_SELF_HARM');
    expect(match?.showHelplines).toBe(true);
    expect(match?.helplines.length).toBeGreaterThan(0);
  });

  it('blocks accommodation requests', () => {
    expect(matchStage1Filters('Need a place to stay tonight').reasonCode).toBe(
      'ACCOMMODATION',
    );
  });
});
