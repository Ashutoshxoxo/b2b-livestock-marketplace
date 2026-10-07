-- V7: Create RFQ, RFQ item, quote and quote item tables
-- B2B Livestock Marketplace

CREATE TABLE rfqs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    buyer_business_id UUID NOT NULL,

    rfq_number VARCHAR(50) NOT NULL UNIQUE,

    title VARCHAR(255) NOT NULL,

    description TEXT,

    status rfq_status NOT NULL DEFAULT 'DRAFT',

    delivery_address_id UUID,

    requested_delivery_date DATE,

    valid_until DATE,

    created_by UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_rfqs_buyer_business
        FOREIGN KEY (buyer_business_id)
        REFERENCES businesses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_rfqs_delivery_address
        FOREIGN KEY (delivery_address_id)
        REFERENCES addresses(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_rfqs_created_by
        FOREIGN KEY (created_by)
        REFERENCES users(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_rfqs_dates
        CHECK (
            valid_until IS NULL
            OR requested_delivery_date IS NULL
            OR valid_until <= requested_delivery_date
        )
);

CREATE TABLE rfq_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    rfq_id UUID NOT NULL,

    product_id UUID,

    product_name VARCHAR(255) NOT NULL,

    quantity NUMERIC(14, 3) NOT NULL,

    unit VARCHAR(50) NOT NULL,

    target_price NUMERIC(14, 2),

    specifications TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_rfq_items_rfq
        FOREIGN KEY (rfq_id)
        REFERENCES rfqs(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_rfq_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_rfq_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_rfq_items_target_price
        CHECK (target_price IS NULL OR target_price >= 0)
);

CREATE TABLE quotes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    rfq_id UUID NOT NULL,

    supplier_business_id UUID NOT NULL,

    quote_number VARCHAR(50) NOT NULL UNIQUE,

    status quote_status NOT NULL DEFAULT 'DRAFT',

    total_amount NUMERIC(14, 2),

    delivery_charge NUMERIC(14, 2) NOT NULL DEFAULT 0,

    tax_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,

    valid_until DATE,

    delivery_date DATE,

    terms_and_conditions TEXT,

    notes TEXT,

    submitted_by UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_quotes_rfq
        FOREIGN KEY (rfq_id)
        REFERENCES rfqs(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_quotes_supplier_business
        FOREIGN KEY (supplier_business_id)
        REFERENCES businesses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_quotes_submitted_by
        FOREIGN KEY (submitted_by)
        REFERENCES users(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_quotes_total_amount
        CHECK (total_amount IS NULL OR total_amount >= 0),

    CONSTRAINT chk_quotes_delivery_charge
        CHECK (delivery_charge >= 0),

    CONSTRAINT chk_quotes_tax_amount
        CHECK (tax_amount >= 0)
);

CREATE TABLE quote_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    quote_id UUID NOT NULL,

    rfq_item_id UUID NOT NULL,

    product_id UUID,

    product_name VARCHAR(255) NOT NULL,

    quantity NUMERIC(14, 3) NOT NULL,

    unit VARCHAR(50) NOT NULL,

    unit_price NUMERIC(14, 2) NOT NULL,

    total_price NUMERIC(14, 2) NOT NULL,

    specifications TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_quote_items_quote
        FOREIGN KEY (quote_id)
        REFERENCES quotes(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_quote_items_rfq_item
        FOREIGN KEY (rfq_item_id)
        REFERENCES rfq_items(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_quote_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_quote_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_quote_items_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_quote_items_total_price
        CHECK (total_price >= 0)
);