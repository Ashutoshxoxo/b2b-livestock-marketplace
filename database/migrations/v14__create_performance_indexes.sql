-- V14: Create performance indexes
-- B2B Livestock Marketplace


-- ============================================================
-- USERS & BUSINESS
-- ============================================================

CREATE INDEX idx_users_status
    ON users(status);

CREATE INDEX idx_businesses_type_status
    ON businesses(business_type, status);

CREATE INDEX idx_business_members_user
    ON business_members(user_id);

CREATE INDEX idx_business_members_business_status
    ON business_members(business_id, status);

CREATE INDEX idx_kyc_documents_business_status
    ON kyc_documents(business_id, status);


-- ============================================================
-- ADDRESSES
-- ============================================================

CREATE INDEX idx_addresses_business
    ON addresses(business_id);

CREATE INDEX idx_addresses_business_type
    ON addresses(business_id, address_type);


-- ============================================================
-- CATEGORIES & PRODUCTS
-- ============================================================

CREATE INDEX idx_categories_parent
    ON categories(parent_id);

CREATE INDEX idx_categories_active
    ON categories(is_active);

CREATE INDEX idx_products_business
    ON products(business_id);

CREATE INDEX idx_products_category_status
    ON products(category_id, status);

CREATE INDEX idx_products_status
    ON products(status);

CREATE INDEX idx_products_business_status
    ON products(business_id, status);

CREATE INDEX idx_product_translations_language
    ON product_translations(language_code);

CREATE INDEX idx_product_images_product
    ON product_images(product_id);


-- ============================================================
-- INVENTORY
-- ============================================================

CREATE INDEX idx_inventory_transactions_inventory
    ON inventory_transactions(inventory_id);

CREATE INDEX idx_inventory_transactions_reference
    ON inventory_transactions(reference_type, reference_id);

CREATE INDEX idx_inventory_transactions_created_at
    ON inventory_transactions(created_at);


-- ============================================================
-- RFQ
-- ============================================================

CREATE INDEX idx_rfqs_buyer_business
    ON rfqs(buyer_business_id);

CREATE INDEX idx_rfqs_status
    ON rfqs(status);

CREATE INDEX idx_rfqs_buyer_status
    ON rfqs(buyer_business_id, status);

CREATE INDEX idx_rfqs_valid_until
    ON rfqs(valid_until);

CREATE INDEX idx_rfq_items_rfq
    ON rfq_items(rfq_id);

CREATE INDEX idx_rfq_items_product
    ON rfq_items(product_id);


-- ============================================================
-- QUOTES
-- ============================================================

CREATE INDEX idx_quotes_rfq
    ON quotes(rfq_id);

CREATE INDEX idx_quotes_supplier
    ON quotes(supplier_business_id);

CREATE INDEX idx_quotes_status
    ON quotes(status);

CREATE INDEX idx_quotes_supplier_status
    ON quotes(supplier_business_id, status);

CREATE INDEX idx_quote_items_quote
    ON quote_items(quote_id);

CREATE INDEX idx_quote_items_rfq_item
    ON quote_items(rfq_item_id);


-- ============================================================
-- ORDERS
-- ============================================================

CREATE INDEX idx_orders_buyer
    ON orders(buyer_business_id);

CREATE INDEX idx_orders_supplier
    ON orders(supplier_business_id);

CREATE INDEX idx_orders_status
    ON orders(status);

CREATE INDEX idx_orders_buyer_status
    ON orders(buyer_business_id, status);

CREATE INDEX idx_orders_supplier_status
    ON orders(supplier_business_id, status);

CREATE INDEX idx_orders_created_at
    ON orders(created_at);

CREATE INDEX idx_orders_rfq
    ON orders(rfq_id);

CREATE INDEX idx_orders_quote
    ON orders(quote_id);

CREATE INDEX idx_order_items_order
    ON order_items(order_id);

CREATE INDEX idx_order_items_product
    ON order_items(product_id);


-- ============================================================
-- PAYMENTS & REFUNDS
-- ============================================================

CREATE INDEX idx_payments_order
    ON payments(order_id);

CREATE INDEX idx_payments_status
    ON payments(status);

CREATE INDEX idx_payments_order_status
    ON payments(order_id, status);

CREATE INDEX idx_payments_created_at
    ON payments(created_at);

CREATE INDEX idx_refunds_payment
    ON refunds(payment_id);

CREATE INDEX idx_refunds_status
    ON refunds(status);


-- ============================================================
-- INVOICES
-- ============================================================

CREATE INDEX idx_invoices_buyer
    ON invoices(buyer_business_id);

CREATE INDEX idx_invoices_supplier
    ON invoices(supplier_business_id);

CREATE INDEX idx_invoices_issue_date
    ON invoices(issue_date);

CREATE INDEX idx_invoices_buyer_issue_date
    ON invoices(buyer_business_id, issue_date);

CREATE INDEX idx_invoice_items_invoice
    ON invoice_items(invoice_id);

CREATE INDEX idx_invoice_items_product
    ON invoice_items(product_id);


-- ============================================================
-- SHIPMENTS & DELIVERY
-- ============================================================

CREATE INDEX idx_shipments_status
    ON shipments(status);

CREATE INDEX idx_shipments_logistics_business
    ON shipments(logistics_business_id);

CREATE INDEX idx_shipments_order_status
    ON shipments(order_id, status);

CREATE INDEX idx_shipments_scheduled_pickup
    ON shipments(scheduled_pickup_at);

CREATE INDEX idx_shipments_estimated_delivery
    ON shipments(estimated_delivery_at);

CREATE INDEX idx_shipment_status_history_shipment
    ON shipment_status_history(shipment_id);

CREATE INDEX idx_shipment_status_history_created_at
    ON shipment_status_history(created_at);

CREATE INDEX idx_shipment_status_history_shipment_created
    ON shipment_status_history(shipment_id, created_at);

CREATE INDEX idx_delivery_proofs_shipment
    ON delivery_proofs(shipment_id);


-- ============================================================
-- NOTIFICATIONS
-- ============================================================

CREATE INDEX idx_notifications_user
    ON notifications(user_id);

CREATE INDEX idx_notifications_user_read
    ON notifications(user_id, is_read);

CREATE INDEX idx_notifications_user_created
    ON notifications(user_id, created_at);

CREATE INDEX idx_notifications_reference
    ON notifications(reference_type, reference_id);

CREATE INDEX idx_notification_preferences_user
    ON notification_preferences(user_id);


-- ============================================================
-- REVIEWS & DISPUTES
-- ============================================================

CREATE INDEX idx_reviews_order
    ON reviews(order_id);

CREATE INDEX idx_reviews_reviewer_business
    ON reviews(reviewer_business_id);

CREATE INDEX idx_reviews_reviewed_business
    ON reviews(reviewed_business_id);

CREATE INDEX idx_reviews_reviewed_visible
    ON reviews(reviewed_business_id, is_visible);

CREATE INDEX idx_disputes_order
    ON disputes(order_id);

CREATE INDEX idx_disputes_raised_by
    ON disputes(raised_by_business_id);

CREATE INDEX idx_disputes_against
    ON disputes(against_business_id);

CREATE INDEX idx_disputes_status
    ON disputes(status);

CREATE INDEX idx_disputes_order_status
    ON disputes(order_id, status);

CREATE INDEX idx_dispute_evidence_dispute
    ON dispute_evidence(dispute_id);

CREATE INDEX idx_dispute_evidence_uploaded_by
    ON dispute_evidence(uploaded_by);