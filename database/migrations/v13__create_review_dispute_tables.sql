-- V13: Create review and dispute tables
-- B2B Livestock Marketplace


CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    order_id UUID NOT NULL,

    reviewer_business_id UUID NOT NULL,

    reviewed_business_id UUID NOT NULL,

    rating INTEGER NOT NULL,

    title VARCHAR(255),

    comment TEXT,

    is_verified_purchase BOOLEAN NOT NULL DEFAULT TRUE,

    is_visible BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reviews_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_reviews_reviewer_business
        FOREIGN KEY (reviewer_business_id)
        REFERENCES businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_reviews_reviewed_business
        FOREIGN KEY (reviewed_business_id)
        REFERENCES businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_reviews_rating
        CHECK (rating >= 1 AND rating <= 5),

    CONSTRAINT chk_reviews_different_businesses
        CHECK (reviewer_business_id <> reviewed_business_id),

    CONSTRAINT uq_reviews_order_reviewer
        UNIQUE (order_id, reviewer_business_id)
);


CREATE TABLE disputes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    dispute_number VARCHAR(50) NOT NULL UNIQUE,

    order_id UUID NOT NULL,

    raised_by_business_id UUID NOT NULL,

    against_business_id UUID NOT NULL,

    status dispute_status NOT NULL DEFAULT 'OPEN',

    reason VARCHAR(255) NOT NULL,

    description TEXT NOT NULL,

    requested_resolution TEXT,

    resolution TEXT,

    resolved_by UUID,

    resolved_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_disputes_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_disputes_raised_by_business
        FOREIGN KEY (raised_by_business_id)
        REFERENCES businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_disputes_against_business
        FOREIGN KEY (against_business_id)
        REFERENCES businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_disputes_resolved_by
        FOREIGN KEY (resolved_by)
        REFERENCES users(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_disputes_different_businesses
        CHECK (raised_by_business_id <> against_business_id)
);


CREATE TABLE dispute_evidence (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    dispute_id UUID NOT NULL,

    uploaded_by UUID NOT NULL,

    file_name VARCHAR(255) NOT NULL,

    file_url VARCHAR(1000) NOT NULL,

    file_type VARCHAR(100),

    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_dispute_evidence_dispute
        FOREIGN KEY (dispute_id)
        REFERENCES disputes(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_dispute_evidence_uploaded_by
        FOREIGN KEY (uploaded_by)
        REFERENCES users(id)
        ON DELETE RESTRICT
);