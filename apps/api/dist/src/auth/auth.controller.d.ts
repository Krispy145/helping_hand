import { AuthService } from './auth.service';
import { LoginRequestDto } from './dto/login-request.dto';
import { RegisterRequestDto } from './dto/register-request.dto';
export declare class AuthController {
    private authService;
    constructor(authService: AuthService);
    login(loginDto: LoginRequestDto): Promise<{
        access_token: string;
        user: {
            id: string;
            email: string;
            name: string | null | undefined;
            role: import("../domain/entities/user.entity").UserRole;
            created_at: Date;
            updated_at: Date;
        };
    }>;
    register(registerDto: RegisterRequestDto): Promise<import("../domain/entities/user.entity").User>;
    getProfile(req: any): Promise<{
        id: string;
        email: string;
        name: string | null | undefined;
        role: import("../domain/entities/user.entity").UserRole;
        created_at: Date;
        updated_at: Date;
    }>;
}
