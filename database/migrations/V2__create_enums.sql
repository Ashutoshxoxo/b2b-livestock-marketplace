-- V2: Create application enums
-- B2B Livestock Marketplace

CREATE TYPE user_status AS ENUM (
    'PENDING',
    'ACTIVE',
    'SUSPENDED',
    'BLOCKED',
    'DEACTIVATED'
);

CREATE TYPE business_status AS ENUM (
    'PENDING',
    'ACTIVE',
    'SUSPENDED',
    'BLOCKED',
    'DEACTIVATED'
);

CREATE TYPE business_type AS ENUM (
    'FARM',
    'WHOLESALER',
    'RETAILER',
    'HOTEL',
    'RESTAURANT',
    'PROCESSOR',
    'EXPORTER',
    'LOGISTICS_PROVIDER',
    'OTHER'
);

CREATE TYPE member_status AS ENUM (
    'INVITED',
    'ACTIVE',
    'SUSPENDED',
    'REMOVED'
);

CREATE TYPE kyc_status AS ENUM (
    'PENDING',
    'UNDER_REVIEW',
    'VERIFIED',
    'REJECTED',
    'EXPIRED'
);

CREATE TYPE address_type AS ENUM (
    'REGISTERED',
    'FARM',
    'WAREHOUSE',
    'BILLING',
    'SHIPPING',
    'OTHER'
);

CREATE TYPE product_status AS ENUM (
    'DRAFT',
    'ACTIVE',
    'INACTIVE',
    'OUT_OF_STOCK',
    'DISCONTINUED'
);

CREATE TYPE inventory_transaction_type AS ENUM (
    'STOCK_IN',
    'RESERVED',
    'RELEASED',
    'SOLD',
    'RETURNED',
    'ADJUSTMENT'
);

CREATE TYPE rfq_status AS ENUM (
    'DRAFT',
    'OPEN',
    'QUOTED',
    'NEGOTIATING',
    'AWARDED',
    'CANCELLED',
    'EXPIRED',
    'CLOSED'
);

CREATE TYPE quote_status AS ENUM (
    'DRAFT',
    'SUBMITTED',
    'NEGOTIATING',
    'ACCEPTED',
    'REJECTED',
    'EXPIRED',
    'WITHDRAWN'
);

CREATE TYPE order_source AS ENUM (
    'DIRECT',
    'RFQ'
);

CREATE TYPE order_status AS ENUM (
    'CREATED',
    'AWAITING_PAYMENT',
    'PAID',
    'SUPPLIER_CONFIRMED',
    'PREPARING',
    'READY_FOR_PICKUP',
    'PICKED_UP',
    'IN_TRANSIT',
    'OUT_FOR_DELIVERY',
    'DELIVERED',
    'COMPLETED',
    'CANCELLED',
    'REFUND_PENDING',
    'REFUNDED',
    'DISPUTED'
);

CREATE TYPE payment_status AS ENUM (
    'INITIATED',
    'PENDING',
    'SUCCESS',
    'FAILED',
    'CANCELLED',
    'REFUNDED',
    'PARTIALLY_REFUNDED'
);

CREATE TYPE payment_method AS ENUM (
    'UPI',
    'CARD',
    'NET_BANKING',
    'BANK_TRANSFER',
    'WALLET',
    'CASH_ON_DELIVERY'
);

CREATE TYPE refund_status AS ENUM (
    'REQUESTED',
    'PROCESSING',
    'SUCCESS',
    'FAILED',
    'CANCELLED'
);

CREATE TYPE shipment_status AS ENUM (
    'CREATED',
    'ASSIGNED',
    'PICKUP_SCHEDULED',
    'PICKED_UP',
    'IN_TRANSIT',
    'OUT_FOR_DELIVERY',
    'DELIVERED',
    'FAILED',
    'CANCELLED',
    'RETURNED'
);

CREATE TYPE dispute_status AS ENUM (
    'OPEN',
    'UNDER_REVIEW',
    'WAITING_FOR_BUYER',
    'WAITING_FOR_SUPPLIER',
    'RESOLVED',
    'REJECTED',
    'CLOSED'
);

CREATE TYPE notification_type AS ENUM (
    'ORDER',
    'PAYMENT',
    'RFQ',
    'QUOTE',
    'SHIPMENT',
    'DELIVERY',
    'KYC',
    'DISPUTE',
    'SYSTEM'
);