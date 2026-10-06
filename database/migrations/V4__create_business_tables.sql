-- V4: Create business, profile, address and KYC tables
-- B2B Livestock Marketplace

CREATE TABLE businesses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_name VARCHAR(255) NOT NULL,

    business_type business_type NOT NULL,

    registration_number VARCHAR(100),
    gst_number VARCHAR(20),
    pan_number VARCHAR(20),

    email VARCHAR(255),
    phone VARCHAR(20),
    website VARCHAR(500),

    description TEXT,

    status business_status NOT NULL DEFAULT 'PENDING',

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE business_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,
    user_id UUID NOT NULL,

    member_role VARCHAR(50) NOT NULL,

    status member_status NOT NULL DEFAULT 'INVITED',

    joined_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_business_members_business
        FOREIGN KEY (business_id)
        REFERENCES businesses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_business_members_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_business_members_business_user
        UNIQUE (business_id, user_id)
);

CREATE TABLE supplier_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL UNIQUE,

    verification_status kyc_status NOT NULL DEFAULT 'PENDING',

    minimum_order_value NUMERIC(14, 2) NOT NULL DEFAULT 0,

    rating NUMERIC(3, 2) NOT NULL DEFAULT 0,

    total_orders INTEGER NOT NULL DEFAULT 0,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_supplier_profiles_business
        FOREIGN KEY (business_id)
        REFERENCES businesses(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_supplier_minimum_order_value
        CHECK (minimum_order_value >= 0),

    CONSTRAINT chk_supplier_rating
        CHECK (rating >= 0 AND rating <= 5),

    CONSTRAINT chk_supplier_total_orders
        CHECK (total_orders >= 0)
);

CREATE TABLE buyer_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL UNIQUE,

    verification_status kyc_status NOT NULL DEFAULT 'PENDING',

    credit_limit NUMERIC(14, 2) NOT NULL DEFAULT 0,

    rating NUMERIC(3, 2) NOT NULL DEFAULT 0,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_buyer_profiles_business
        FOREIGN KEY (business_id)
        REFERENCES businesses(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_buyer_credit_limit
        CHECK (credit_limit >= 0),

    CONSTRAINT chk_buyer_rating
        CHECK (rating >= 0 AND rating <= 5)
);

CREATE TABLE logistics_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL UNIQUE,

    verification_status kyc_status NOT NULL DEFAULT 'PENDING',

    service_radius_km NUMERIC(8, 2),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_logistics_profiles_business
        FOREIGN KEY (business_id)
        REFERENCES businesses(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_logistics_service_radius
        CHECK (service_radius_km IS NULL OR service_radius_km >= 0)
);

CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,

    address_type address_type NOT NULL,

    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),

    village VARCHAR(150),
    city VARCHAR(150),
    district VARCHAR(150),

    state VARCHAR(150) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'India',

    postal_code VARCHAR(10) NOT NULL,

    latitude NUMERIC(10, 7),
    longitude NUMERIC(10, 7),

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_addresses_business
        FOREIGN KEY (business_id)
        REFERENCES businesses(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_addresses_latitude
        CHECK (latitude IS NULL OR latitude >= -90 AND latitude <= 90),

    CONSTRAINT chk_addresses_longitude
        CHECK (longitude IS NULL OR longitude >= -180 AND longitude <= 180)
);

CREATE TABLE kyc_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,

    document_type VARCHAR(50) NOT NULL,
    document_number VARCHAR(100),

    document_url VARCHAR(1000) NOT NULL,

    status kyc_status NOT NULL DEFAULT 'PENDING',

    verified_by UUID,

    verified_at TIMESTAMPTZ,

    rejection_reason TEXT,

    expires_at DATE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_kyc_documents_business
        FOREIGN KEY (business_id)
        REFERENCES businesses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_kyc_documents_verified_by
        FOREIGN KEY (verified_by)
        REFERENCES users(id)
        ON DELETE SET NULL
);
