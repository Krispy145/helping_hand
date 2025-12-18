export class RequestCreatedEvent {
  constructor(
    public readonly requestId: string,
    public readonly title: string,
    public readonly description: string,
  ) {}
}
