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

export function toPublicUser(user: PublicUserSource, options?: { includeEmail?: boolean }) {
  return {
    id: user.id,
    email: options?.includeEmail ? user.email : '',
    name: user.name,
    role: user.role,
    created_at: user.createdAt,
    updated_at: user.updatedAt,
  };
}

export function toPublicRequest(request: PublicRequestSource, options?: { includeRequester?: boolean }) {
  return {
    id: request.id,
    title: request.title,
    description: request.description,
    category: request.category,
    status: request.status,
    urgency: request.urgency,
    lat: request.lat,
    lng: request.lng,
    created_at: request.createdAt,
    updated_at: request.updatedAt,
    user:
      options?.includeRequester && request.user
        ? toPublicUser(request.user, { includeEmail: false })
        : undefined,
  };
}
