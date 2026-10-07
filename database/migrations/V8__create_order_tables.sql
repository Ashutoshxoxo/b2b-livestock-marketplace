-- V8: Create order and order item tables
-- B2B Livestock Marketplace

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    order_number VARCHAR(50) NOT NULL UNIQUE,

    buyer_business_id UUID NOT NULL,
    supplier_business_id UUID NOT NULL,

    rfq_id UUID,
    quote_id UUID,

    source order_source NOT NULL DEFAULT 'DIRECT',
    status order_status NOT NULL DEFAULT 'CREATED',

    subtotal NUMERIC(14, 2) NOT NULL DEFAULT 0,
    tax_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,
    shipping_charge NUMERIC(14, 2) NOT NULL DEFAULT 0,
    discount_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,
    total_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,

    billing_address_id UUID,
    shipping_address_id UUID,

    notes TEXT,

    ordered_by UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_buyer_business
        FOREIGN KEY (buyer_business_id)
        REFERENCES businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_supplier_business
        FOREIGN KEY (supplier_business_id)
        REFERENCES businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_rfq
        FOREIGN KEY (rfq_id)
        REFERENCES rfqs(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_orders_quote
        FOREIGN KEY (quote_id)
        REFERENCES quotes(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_orders_billing_address
        FOREIGN KEY (billing_address_id)
        REFERENCES addresses(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_orders_shipping_address
        FOREIGN KEY (shipping_address_id)
        REFERENCES addresses(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_orders_ordered_by
        FOREIGN KEY (ordered_by)
        REFERENCES users(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_orders_subtotal
        CHECK (subtotal >= 0),

    CONSTRAINT chk_orders_tax_amount
        CHECK (tax_amount >= 0),

    CONSTRAINT chk_orders_shipping_charge
        CHECK (shipping_charge >= 0),

    CONSTRAINT chk_orders_discount_amount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_orders_total_amount
        CHECK (total_amount >= 0)
);


CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    order_id UUID NOT NULL,

    product_id UUID,

    product_name VARCHAR(255) NOT NULL,

    quantity NUMERIC(14, 3) NOT NULL,

    unit VARCHAR(50) NOT NULL,

    unit_price NUMERIC(14, 2) NOT NULL,

    tax_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,

    discount_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,

    total_price NUMERIC(14, 2) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_items_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_order_items_tax_amount
        CHECK (tax_amount >= 0),

    CONSTRAINT chk_order_items_discount_amount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_order_items_total_price
        CHECK (total_price >= 0)
);