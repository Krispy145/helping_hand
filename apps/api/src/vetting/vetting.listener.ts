import { Injectable } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { RequestCreatedEvent } from '../requests/events/request-created.event';
import { VettingService } from './vetting.service';

@Injectable()
export class VettingListener {
  constructor(private readonly vettingService: VettingService) {}

  @OnEvent('request.created')
  async handleRequestCreatedEvent(event: RequestCreatedEvent) {
    // We only vet the text content (title + description)
    const textToVet = `${event.title} ${event.description}`;
    await this.vettingService.vetRequest(event.requestId, textToVet);
  }
}
