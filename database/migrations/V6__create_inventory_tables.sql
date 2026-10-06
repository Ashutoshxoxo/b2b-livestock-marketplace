-- V6: Create inventory and inventory transaction tables
-- B2B Livestock Marketplace

CREATE TABLE inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID NOT NULL UNIQUE,

    available_quantity NUMERIC(14, 3) NOT NULL DEFAULT 0,

    reserved_quantity NUMERIC(14, 3) NOT NULL DEFAULT 0,

    sold_quantity NUMERIC(14, 3) NOT NULL DEFAULT 0,

    version BIGINT NOT NULL DEFAULT 0,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_inventory_available_quantity
        CHECK (available_quantity >= 0),

    CONSTRAINT chk_inventory_reserved_quantity
        CHECK (reserved_quantity >= 0),

    CONSTRAINT chk_inventory_sold_quantity
        CHECK (sold_quantity >= 0),

    CONSTRAINT chk_inventory_version
        CHECK (version >= 0)
);

CREATE TABLE inventory_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    inventory_id UUID NOT NULL,

    transaction_type inventory_transaction_type NOT NULL,

    quantity NUMERIC(14, 3) NOT NULL,

    reference_type VARCHAR(50),

    reference_id UUID,

    notes TEXT,

    created_by UUID,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_inventory_transactions_inventory
        FOREIGN KEY (inventory_id)
        REFERENCES inventory(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_inventory_transactions_created_by
        FOREIGN KEY (created_by)
        REFERENCES users(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_inventory_transaction_quantity
        CHECK (quantity > 0)
);
