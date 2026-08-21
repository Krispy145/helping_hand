export enum UserRole {
  USER = 'USER',
  ADMIN = 'ADMIN',
  MODERATOR = 'MODERATOR',
}

export class User {
  id: string;
  email: string;
  password?: string;
  name?: string | null;
  role: UserRole;
  verificationStatus?: string;
  verificationProvider?: string | null;
  verificationProviderRef?: string | null;
  verifiedAt?: Date | null;
  verificationFailureReason?: string | null;
  ageThreshold?: number | null;
  createdAt: Date;
  updatedAt: Date;

  constructor(partial: Partial<User>) {
    Object.assign(this, partial);
  }
}
