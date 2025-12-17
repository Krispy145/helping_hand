import { Module } from '@nestjs/common';
import { PrismaService } from '../infrastructure/persistence/prisma/prisma.service';
import { PrismaUserRepository } from '../infrastructure/persistence/repositories/prisma-user.repository';

@Module({
  providers: [
    PrismaService,
    {
      provide: 'IUserRepository',
      useClass: PrismaUserRepository,
    },
  ],
  exports: ['IUserRepository'],
})
export class UsersModule {}
