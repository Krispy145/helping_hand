type PublicUserSource = {
    id: string;
    email: string;
    name?: string | null;
    role: string;
    createdAt: Date;
    updatedAt: Date;
};
type PublicRequestSource = {
    id: string;
    title: string;
    description: string;
    category?: string | null;
    status: string;
    urgency: string;
    lat?: number | null;
    lng?: number | null;
    createdAt: Date;
    updatedAt: Date;
    user?: PublicUserSource | null;
};
export declare function toPublicUser(user: PublicUserSource, options?: {
    includeEmail?: boolean;
}): {
    id: string;
    email: string;
    name: string | null | undefined;
    role: string;
    created_at: Date;
    updated_at: Date;
};
export declare function toPublicRequest(request: PublicRequestSource, options?: {
    includeRequester?: boolean;
}): {
    id: string;
    title: string;
    description: string;
    category: string | null | undefined;
    status: string;
    urgency: string;
    lat: number | null | undefined;
    lng: number | null | undefined;
    created_at: Date;
    updated_at: Date;
    user: {
        id: string;
        email: string;
        name: string | null | undefined;
        role: string;
        created_at: Date;
        updated_at: Date;
    } | undefined;
};
export {};
