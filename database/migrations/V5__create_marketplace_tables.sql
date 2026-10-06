-- V5: Create marketplace catalog tables
-- B2B Livestock Marketplace

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    parent_id UUID,

    name VARCHAR(150) NOT NULL,
    slug VARCHAR(180) NOT NULL UNIQUE,

    description TEXT,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_categories_parent
        FOREIGN KEY (parent_id)
        REFERENCES categories(id)
        ON DELETE SET NULL
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,
    category_id UUID NOT NULL,

    name VARCHAR(255) NOT NULL,
    slug VARCHAR(280) NOT NULL UNIQUE,

    description TEXT,

    unit VARCHAR(50) NOT NULL,

    status product_status NOT NULL DEFAULT 'DRAFT',

    base_price NUMERIC(14, 2),

    minimum_order_quantity NUMERIC(14, 3) NOT NULL DEFAULT 1,

    is_negotiable BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_business
        FOREIGN KEY (business_id)
        REFERENCES businesses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_products_base_price
        CHECK (base_price IS NULL OR base_price >= 0),

    CONSTRAINT chk_products_minimum_order_quantity
        CHECK (minimum_order_quantity > 0)
);

CREATE TABLE product_translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID NOT NULL,

    language_code VARCHAR(10) NOT NULL,

    name VARCHAR(255) NOT NULL,

    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product_translations_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_product_translation_language
        UNIQUE (product_id, language_code)
);

CREATE TABLE product_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID NOT NULL,

    image_url VARCHAR(1000) NOT NULL,

    alt_text VARCHAR(255),

    display_order INTEGER NOT NULL DEFAULT 0,

    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product_images_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_product_images_display_order
        CHECK (display_order >= 0)
);