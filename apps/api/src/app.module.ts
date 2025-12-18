import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UsersModule } from './users/users.module';
import { NotificationsModule } from './notifications/notifications.module';
import { AuthModule } from './auth/auth.module';
import { RequestsModule } from './requests/requests.module';

@Module({
  imports: [UsersModule, NotificationsModule, AuthModule, RequestsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
