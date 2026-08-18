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
  });

  it('routes crisis language to helplines', () => {
    const match = matchStage1Filters('I feel suicidal tonight');
    expect(match?.reasonCode).toBe('CRISIS_SELF_HARM');
    expect(match?.showHelplines).toBe(true);
  });

  it('blocks accommodation requests', () => {
    expect(matchStage1Filters('Need a place to stay tonight').reasonCode).toBe(
      'ACCOMMODATION',
    );
  });
});
