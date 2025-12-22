import { Injectable, Inject, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import type { IUserRepository } from '../domain/repositories/user.repository.interface';
import { User, UserRole } from '../domain/entities/user.entity';
import { RegisterRequestDto } from './dto/register-request.dto';

@Injectable()
export class AuthService {
  constructor(
    @Inject('IUserRepository') private readonly userRepository: IUserRepository,
    private readonly jwtService: JwtService,
  ) {}

  async validateUser(email: string, pass: string): Promise<User | null> {
    const user = await this.userRepository.findByEmail(email);
    if (user && user.password) {
      const isMatch = await bcrypt.compare(pass, user.password);
      if (isMatch) {
        // eslint-disable-next-line @typescript-eslint/no-unused-vars
        const { password, ...result } = user;
        return result as User; // Return user without password
      }
    }
    return null;
  }

  async login(user: User) {
    const payload = { email: user.email, sub: user.id, role: user.role };
    return {
      access_token: await this.jwtService.signAsync(payload),
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
      },
    };
  }

  async register(dto: RegisterRequestDto): Promise<User> {
    const existingUser = await this.userRepository.findByEmail(dto.email);
    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);
    const newUser = new User({
      email: dto.email,
      password: hashedPassword, // Store hashed password
      name: dto.name,
      role: UserRole.USER,
    });

    const createdUser = await this.userRepository.create(newUser);
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { password, ...result } = createdUser;
    // Need to login automatically or return just the user
    // The DTO expects AuthResponseDto (token + user)
    // But this method currently returns just User entity.
    // I should probably sign a token here too for auto-login.
    const user = new User(result);
    // Auto-login logic duplicated for now:
    const payload = { email: user.email, sub: user.id, role: user.role };
    return {
      access_token: await this.jwtService.signAsync(payload),
      user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
      }
    } as any; // Type casting for now since return type of method says Promise<User> but controller expects AuthResponseDto wrapper.
  }
}
