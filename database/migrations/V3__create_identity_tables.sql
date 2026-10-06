-- V3: Create identity and authorization tables
-- B2B Livestock Marketplace

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,

    password_hash VARCHAR(255),

    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),

    status user_status NOT NULL DEFAULT 'PENDING',

    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    phone_verified BOOLEAN NOT NULL DEFAULT FALSE,

    last_login_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_roles (
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,

    PRIMARY KEY (user_id, role_id),

    CONSTRAINT fk_user_roles_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_user_roles_role
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
        ON DELETE RESTRICT
);

-- Seed application roles
INSERT INTO roles (name, description)
VALUES
    ('ADMIN', 'Platform administrator'),
    ('SUPPLIER', 'Livestock supplier or farmer'),
    ('BUYER', 'Retailer, wholesaler, hotel, restaurant or other buyer'),
    ('LOGISTICS', 'Logistics and delivery provider')
ON CONFLICT (name) DO NOTHING;