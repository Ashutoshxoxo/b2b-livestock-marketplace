-- V11: Create shipment, shipment status history and delivery proof tables
-- B2B Livestock Marketplace


CREATE TABLE shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    shipment_number VARCHAR(50) NOT NULL UNIQUE,

    order_id UUID NOT NULL UNIQUE,

    logistics_business_id UUID,

    status shipment_status NOT NULL DEFAULT 'CREATED',

    pickup_address_id UUID,
    delivery_address_id UUID,

    scheduled_pickup_at TIMESTAMPTZ,
    actual_pickup_at TIMESTAMPTZ,

    estimated_delivery_at TIMESTAMPTZ,
    actual_delivery_at TIMESTAMPTZ,

    tracking_number VARCHAR(100) UNIQUE,

    vehicle_number VARCHAR(50),

    driver_name VARCHAR(150),
    driver_phone VARCHAR(20),

    delivery_notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_shipments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_shipments_logistics_business
        FOREIGN KEY (logistics_business_id)
        REFERENCES businesses(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_shipments_pickup_address
        FOREIGN KEY (pickup_address_id)
        REFERENCES addresses(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_shipments_delivery_address
        FOREIGN KEY (delivery_address_id)
        REFERENCES addresses(id)
        ON DELETE SET NULL
);


CREATE TABLE shipment_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    shipment_id UUID NOT NULL,

    status shipment_status NOT NULL,

    latitude NUMERIC(10, 7),
    longitude NUMERIC(10, 7),

    location_description VARCHAR(255),

    remarks TEXT,

    updated_by UUID,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_shipment_status_history_shipment
        FOREIGN KEY (shipment_id)
        REFERENCES shipments(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_shipment_status_history_updated_by
        FOREIGN KEY (updated_by)
        REFERENCES users(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_shipment_status_history_latitude
        CHECK (
            latitude IS NULL
            OR latitude >= -90
            AND latitude <= 90
        ),

    CONSTRAINT chk_shipment_status_history_longitude
        CHECK (
            longitude IS NULL
            OR longitude >= -180
            AND longitude <= 180
        )
);


CREATE TABLE delivery_proofs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    shipment_id UUID NOT NULL UNIQUE,

    recipient_name VARCHAR(150),

    recipient_phone VARCHAR(20),

    delivered_at TIMESTAMPTZ,

    proof_type VARCHAR(50),

    proof_url VARCHAR(1000),

    signature_url VARCHAR(1000),

    remarks TEXT,

    created_by UUID,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_delivery_proofs_shipment
        FOREIGN KEY (shipment_id)
        REFERENCES shipments(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_delivery_proofs_created_by
        FOREIGN KEY (created_by)
        REFERENCES users(id)
        ON DELETE SET NULL
);
