-- V10: Create invoice and invoice item tables
-- B2B Livestock Marketplace

CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    order_id UUID NOT NULL UNIQUE,

    invoice_number VARCHAR(50) NOT NULL UNIQUE,

    invoice_status VARCHAR(30) NOT NULL DEFAULT 'ISSUED',

    buyer_business_id UUID NOT NULL,
    supplier_business_id UUID NOT NULL,

    billing_address_id UUID,
    shipping_address_id UUID,

    subtotal NUMERIC(14, 2) NOT NULL DEFAULT 0,
    taxable_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,
    tax_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,
    shipping_charge NUMERIC(14, 2) NOT NULL DEFAULT 0,
    discount_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,
    total_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,

    currency VARCHAR(10) NOT NULL DEFAULT 'INR',

    issue_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE,

    paid_at TIMESTAMPTZ,

    pdf_url VARCHAR(1000),

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_invoices_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_invoices_buyer_business
        FOREIGN KEY (buyer_business_id)
        REFERENCES businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_invoices_supplier_business
        FOREIGN KEY (supplier_business_id)
        REFERENCES businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_invoices_billing_address
        FOREIGN KEY (billing_address_id)
        REFERENCES addresses(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_invoices_shipping_address
        FOREIGN KEY (shipping_address_id)
        REFERENCES addresses(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_invoices_subtotal
        CHECK (subtotal >= 0),

    CONSTRAINT chk_invoices_taxable_amount
        CHECK (taxable_amount >= 0),

    CONSTRAINT chk_invoices_tax_amount
        CHECK (tax_amount >= 0),

    CONSTRAINT chk_invoices_shipping_charge
        CHECK (shipping_charge >= 0),

    CONSTRAINT chk_invoices_discount_amount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_invoices_total_amount
        CHECK (total_amount >= 0),

    CONSTRAINT chk_invoices_dates
        CHECK (due_date IS NULL OR due_date >= issue_date)
);


CREATE TABLE invoice_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    invoice_id UUID NOT NULL,

    order_item_id UUID,

    product_id UUID,

    product_name VARCHAR(255) NOT NULL,

    quantity NUMERIC(14, 3) NOT NULL,

    unit VARCHAR(50) NOT NULL,

    unit_price NUMERIC(14, 2) NOT NULL,

    taxable_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,

    tax_rate NUMERIC(5, 2) NOT NULL DEFAULT 0,

    tax_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,

    discount_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,

    total_price NUMERIC(14, 2) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_invoice_items_invoice
        FOREIGN KEY (invoice_id)
        REFERENCES invoices(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_invoice_items_order_item
        FOREIGN KEY (order_item_id)
        REFERENCES order_items(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_invoice_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_invoice_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_invoice_items_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_invoice_items_taxable_amount
        CHECK (taxable_amount >= 0),

    CONSTRAINT chk_invoice_items_tax_rate
        CHECK (tax_rate >= 0 AND tax_rate <= 100),

    CONSTRAINT chk_invoice_items_tax_amount
        CHECK (tax_amount >= 0),

    CONSTRAINT chk_invoice_items_discount_amount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_invoice_items_total_price
        CHECK (total_price >= 0)
);