import { JwtService } from '@nestjs/jwt';
import type { IUserRepository } from '../domain/repositories/user.repository.interface';
import { User } from '../domain/entities/user.entity';
import { RegisterRequestDto } from './dto/register-request.dto';
export declare class AuthService {
    private readonly userRepository;
    private readonly jwtService;
    constructor(userRepository: IUserRepository, jwtService: JwtService);
    validateUser(email: string, pass: string): Promise<User | null>;
    login(user: User): Promise<{
        access_token: string;
        user: User;
    }>;
    register(dto: RegisterRequestDto): Promise<User>;
}
