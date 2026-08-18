import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { VerificationService } from './verification.service';

@Injectable()
export class VerifiedAdultGuard implements CanActivate {
  constructor(private readonly verification: VerificationService) {}

  async canActivate(context: ExecutionContext) {
    const request = context
      .switchToHttp()
      .getRequest<{ user?: { userId?: string } }>();
    const userId = request.user?.userId;
    if (!userId) return false;
    await this.verification.assertVerifiedAdult(userId);
    return true;
  }
}
