import { JwtService } from '@nestjs/jwt';
import type { IUserRepository } from '../domain/repositories/user.repository.interface';
import { User, UserRole } from '../domain/entities/user.entity';
import { RegisterRequestDto } from './dto/register-request.dto';
export declare class AuthService {
    private readonly userRepository;
    private readonly jwtService;
    constructor(userRepository: IUserRepository, jwtService: JwtService);
    validateUser(email: string, pass: string): Promise<User | null>;
    login(user: User): Promise<{
        access_token: string;
        user: {
            id: string;
            email: string;
            name: string | null | undefined;
            role: UserRole;
            created_at: Date;
            updated_at: Date;
        };
    }>;
    register(dto: RegisterRequestDto): Promise<User>;
    getUserById(id: string): Promise<User | null>;
}
