-- V9: Create payment and refund tables
-- B2B Livestock Marketplace

CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    order_id UUID NOT NULL,

    payment_reference VARCHAR(100) NOT NULL UNIQUE,

    gateway_transaction_id VARCHAR(150),

    amount NUMERIC(14, 2) NOT NULL,

    currency VARCHAR(10) NOT NULL DEFAULT 'INR',

    payment_method payment_method NOT NULL,

    status payment_status NOT NULL DEFAULT 'INITIATED',

    gateway_name VARCHAR(100),

    gateway_response TEXT,

    paid_at TIMESTAMPTZ,

    failure_reason TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_payments_amount
        CHECK (amount > 0)
);


CREATE TABLE refunds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    payment_id UUID NOT NULL,

    refund_reference VARCHAR(100) NOT NULL UNIQUE,

    gateway_refund_id VARCHAR(150),

    amount NUMERIC(14, 2) NOT NULL,

    status refund_status NOT NULL DEFAULT 'REQUESTED',

    reason TEXT,

    processed_at TIMESTAMPTZ,

    failure_reason TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_refunds_payment
        FOREIGN KEY (payment_id)
        REFERENCES payments(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_refunds_amount
        CHECK (amount > 0)
);