-- ======================================
-- Migration: Init Schema
-- Date: 2025-09-12/4:23pm
-- Author: emlamhd
-- ======================================

-- 2. Users
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin','user','seller')),
    avatar VARCHAR(500),
    phone VARCHAR(50),
    is_locked VARCHAR(3) NOT NULL DEFAULT 'no' CHECK (is_locked IN ('yes','no')),
    deleted_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);
CREATE INDEX IX_users_email ON users(email);

-- 3. Categories
CREATE TABLE categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    images NVARCHAR(MAX), -- JSON array
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);
CREATE INDEX IX_categories_name ON categories(name);

-- 4. Brands
CREATE TABLE brands (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    images NVARCHAR(MAX),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);
CREATE INDEX IX_brands_name ON brands(name);

-- 5. Products
CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    specification NVARCHAR(MAX),
    purchase_count INT NOT NULL DEFAULT 0,
    brand_id INT,
    category_id INT,
    deleted_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_products_category FOREIGN KEY (category_id) REFERENCES categories(id),
    CONSTRAINT FK_products_brand FOREIGN KEY (brand_id) REFERENCES brands(id)
);
-- Index cho filter category + brand
CREATE INDEX IX_products_category_brand ON products(category_id, brand_id);

-- 6. Product Images
CREATE TABLE product_images (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_product_images_product FOREIGN KEY (product_id) REFERENCES products(id)
);
CREATE INDEX IX_product_images_product ON product_images(product_id);

-- 7. Product Attributes
CREATE TABLE product_attributes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- 8. Product Attribute Values
CREATE TABLE product_attribute_values (
    id INT IDENTITY(1,1) PRIMARY KEY,
    attribute_id INT NOT NULL,
    value VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_attrval_attr FOREIGN KEY (attribute_id) REFERENCES product_attributes(id)
);

-- 9. Product Variants
CREATE TABLE product_variants (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    old_price DECIMAL(18,2),
    stock INT NOT NULL DEFAULT 0,
    sku VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_variant_product FOREIGN KEY (product_id) REFERENCES products(id)
);
CREATE INDEX IX_variants_product ON product_variants(product_id);

-- 10. Product Variant Combinations
CREATE TABLE product_variant_combinations (
    id INT IDENTITY(1,1) PRIMARY KEY,
    variant_id INT NOT NULL,
    attribute_value_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_variant_comb_variant FOREIGN KEY (variant_id) REFERENCES product_variants(id),
    CONSTRAINT FK_variant_comb_attrval FOREIGN KEY (attribute_value_id) REFERENCES product_attribute_values(id)
);
CREATE INDEX IX_variant_combination ON product_variant_combinations(variant_id, attribute_value_id);

-- 11. Carts
CREATE TABLE carts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NULL,
    session_id VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_carts_user FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE INDEX IX_carts_user ON carts(user_id);

-- 12. Cart Items
CREATE TABLE cart_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    variant_id INT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_cartitem_cart FOREIGN KEY (cart_id) REFERENCES carts(id),
    CONSTRAINT FK_cartitem_product FOREIGN KEY (product_id) REFERENCES products(id),
    CONSTRAINT FK_cartitem_variant FOREIGN KEY (variant_id) REFERENCES product_variants(id)
);
CREATE INDEX IX_cart_items_cart ON cart_items(cart_id);
CREATE INDEX IX_cart_items_product ON cart_items(product_id);

-- 13. Orders
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NULL,
    session_id VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending','processing','shipped','delivered','cancelled')),
    note NVARCHAR(MAX),
    total DECIMAL(18,2) NOT NULL,
    subtotal DECIMAL(18,2) NOT NULL,
    discount_total DECIMAL(18,2) NOT NULL DEFAULT 0,
    shipping_fee DECIMAL(18,2) NOT NULL DEFAULT 0,
    tax_fee DECIMAL(18,2) NOT NULL DEFAULT 0,
    shipping_address_id INT NULL,
    deleted_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_orders_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT FK_orders_address FOREIGN KEY (shipping_address_id) REFERENCES addresses(id)
);
CREATE INDEX IX_orders_user ON orders(user_id);

-- 14. Order Details
CREATE TABLE order_details (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    variant_id INT NULL,
    price DECIMAL(18,2) NOT NULL,
    quantity INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_orderdetails_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT FK_orderdetails_product FOREIGN KEY (product_id) REFERENCES products(id),
    CONSTRAINT FK_orderdetails_variant FOREIGN KEY (variant_id) REFERENCES product_variants(id)
);
CREATE INDEX IX_order_details_order ON order_details(order_id);

-- 15. Addresses
CREATE TABLE addresses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    address_line NVARCHAR(500),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(50),
    is_default VARCHAR(3) NOT NULL DEFAULT 'no' CHECK (is_default IN ('yes','no')),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_addresses_user FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE INDEX IX_addresses_user ON addresses(user_id);

-- 16. Payments
CREATE TABLE payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    method VARCHAR(50) NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending','paid','failed')),
    transaction_id VARCHAR(255),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_payments_order FOREIGN KEY (order_id) REFERENCES orders(id)
);
CREATE INDEX IX_payments_order ON payments(order_id);

-- 17. Discounts
CREATE TABLE discounts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('percentage','fixed')),
    value DECIMAL(18,2) NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    min_order_amount DECIMAL(18,2) NULL,
    max_uses INT NULL,
    applies_to_type VARCHAR(20) NULL CHECK (applies_to_type IN ('all','product','category')),
    applies_to_id INT NULL,
    deleted_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- 18. Order Discounts
CREATE TABLE order_discounts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    discount_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_orderdiscount_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT FK_orderdiscount_discount FOREIGN KEY (discount_id) REFERENCES discounts(id)
);

-- 19. Inventory Logs
CREATE TABLE inventory_logs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    variant_id INT NOT NULL,
    change_amount INT NOT NULL,
    reason VARCHAR(100),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_inventorylog_variant FOREIGN KEY (variant_id) REFERENCES product_variants(id)
);
CREATE INDEX IX_inventory_logs_variant ON inventory_logs(variant_id);

-- 20. Wishlists
CREATE TABLE wishlists (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_wishlist_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT FK_wishlist_product FOREIGN KEY (product_id) REFERENCES products(id)
);
CREATE INDEX IX_wishlist_user ON wishlists(user_id);

-- 21. Feedbacks
CREATE TABLE feedbacks (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    star INT NOT NULL CHECK (star BETWEEN 1 AND 5),
    content NVARCHAR(MAX),
    is_approved BIT NOT NULL DEFAULT 0,
    images NVARCHAR(MAX),
    order_detail_id INT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_feedback_product FOREIGN KEY (product_id) REFERENCES products(id),
    CONSTRAINT FK_feedback_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT FK_feedback_orderdetail FOREIGN KEY (order_detail_id) REFERENCES order_details(id)
);
CREATE INDEX IX_feedback_product ON feedbacks(product_id);
CREATE INDEX IX_feedback_user ON feedbacks(user_id);