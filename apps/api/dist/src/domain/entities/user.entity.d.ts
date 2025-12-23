export declare enum UserRole {
    USER = "USER",
    ADMIN = "ADMIN",
    MODERATOR = "MODERATOR"
}
export declare class User {
    id: string;
    email: string;
    password?: string;
    name?: string | null;
    role: UserRole;
    createdAt: Date;
    updatedAt: Date;
    constructor(partial: Partial<User>);
}
