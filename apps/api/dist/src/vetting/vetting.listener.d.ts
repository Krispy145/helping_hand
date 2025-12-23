import { RequestCreatedEvent } from '../requests/events/request-created.event';
import { VettingService } from './vetting.service';
export declare class VettingListener {
    private readonly vettingService;
    constructor(vettingService: VettingService);
    handleRequestCreatedEvent(event: RequestCreatedEvent): Promise<void>;
}
