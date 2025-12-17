export interface INotificationService {
    send(tokens: string[], title: string, body: string, data?: Record<string, string>): Promise<void>;
}
