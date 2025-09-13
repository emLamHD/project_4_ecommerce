--Soft Delete Handling: Tất cả views đều lọc các bản ghi đã bị xóa mềm (deleted_at IS NULL)

-- Active State Management: Kiểm tra trạng thái hoạt động của users (is_locked = 'no')

-- Denormalization: Tính toán trước các giá trị như item_count, total_value

-- Transaction Safety: Toàn bộ được thực thi trong transaction để đảm bảo tính atomicity

-- Error Handling: Xử lý lỗi chi tiết và rollback khi cần thiết
BEGIN TRY
    BEGIN TRANSACTION;

    EXEC(N'
    /*
      VIEW: vw_carts_active
      - Carts of active users (or guest via session_id)
      - Denormalize: item_count, total_value
    */
    CREATE OR ALTER VIEW dbo.vw_carts_active AS
    SELECT
        c.id,
        c.user_id,
        c.session_id,
        c.created_at,
        c.updated_at,
        (SELECT COUNT(1) FROM dbo.cart_items ci WHERE ci.cart_id = c.id) AS item_count,
        (SELECT SUM(ci.quantity * pv.price) FROM dbo.cart_items ci INNER JOIN dbo.product_variants pv ON pv.id = ci.variant_id WHERE ci.cart_id = c.id) AS total_value
    FROM dbo.carts c
    LEFT JOIN dbo.users u ON u.id = c.user_id
    WHERE (u.id IS NULL OR (u.deleted_at IS NULL AND u.is_locked = ''no''));
    ');

    EXEC(N'
    /*
      VIEW: vw_cart_items_active
      - Items in active carts, with active products/variants
    */
    CREATE OR ALTER VIEW dbo.vw_cart_items_active AS
    SELECT
        ci.id,
        ci.cart_id,
        ci.product_id,
        p.name AS product_name,
        ci.variant_id,
        ci.quantity,
        ci.created_at,
        ci.updated_at
    FROM dbo.cart_items ci
    INNER JOIN dbo.carts c ON c.id = ci.cart_id
    INNER JOIN dbo.products p ON p.id = ci.product_id
    LEFT JOIN dbo.users u ON u.id = c.user_id
    WHERE p.deleted_at IS NULL
      AND (u.id IS NULL OR (u.deleted_at IS NULL AND u.is_locked = ''no''));
    ');

    EXEC(N'
    /*
      VIEW: vw_orders_active
      - Orders not deleted
      - Denormalize: user_email, shipping_address_line, item_count, payment_status
    */
    CREATE OR ALTER VIEW dbo.vw_orders_active AS
    SELECT
        o.id,
        o.user_id,
        u.email AS user_email,
        o.session_id,
        o.status,
        o.note,
        o.total,
        o.subtotal,
        o.discount_total,
        o.shipping_fee,
        o.tax_fee,
        o.shipping_address_id,
        a.address_line AS shipping_address_line,
        o.created_at,
        o.updated_at,
        (SELECT COUNT(1) FROM dbo.order_details od WHERE od.order_id = o.id) AS item_count,
        (SELECT TOP 1 p.status FROM dbo.payments p WHERE p.order_id = o.id ORDER BY p.id DESC) AS latest_payment_status
    FROM dbo.orders o
    LEFT JOIN dbo.users u ON u.id = o.user_id
    LEFT JOIN dbo.addresses a ON a.id = o.shipping_address_id
    WHERE o.deleted_at IS NULL
      AND (u.id IS NULL OR (u.deleted_at IS NULL AND u.is_locked = ''no''));
    ');

    EXEC(N'
    /*
      VIEW: vw_order_details_active
      - Details of active orders, with active products
    */
    CREATE OR ALTER VIEW dbo.vw_order_details_active AS
    SELECT
        od.id,
        od.order_id,
        od.product_id,
        p.name AS product_name,
        od.variant_id,
        od.price,
        od.quantity,
        od.created_at,
        od.updated_at
    FROM dbo.order_details od
    INNER JOIN dbo.orders o ON o.id = od.order_id
    INNER JOIN dbo.products p ON p.id = od.product_id
    WHERE o.deleted_at IS NULL AND p.deleted_at IS NULL;
    ');

    EXEC(N'
    /*
      VIEW: vw_payments_active
      - Payments of active orders
    */
    CREATE OR ALTER VIEW dbo.vw_payments_active AS
    SELECT
        p.id,
        p.order_id,
        p.method,
        p.amount,
        p.status,
        p.transaction_id,
        p.created_at,
        p.updated_at
    FROM dbo.payments p
    INNER JOIN dbo.orders o ON o.id = p.order_id
    WHERE o.deleted_at IS NULL;
    ');

    EXEC(N'
    /*
      VIEW: vw_discounts_active
      - Discounts not deleted, and active (start_date <= NOW <= end_date)
    */
    CREATE OR ALTER VIEW dbo.vw_discounts_active AS
    SELECT
        d.id,
        d.code,
        d.discount_type,
        d.value,
        d.start_date,
        d.end_date,
        d.min_order_amount,
        d.max_uses,
        d.applies_to_type,
        d.applies_to_id,
        d.created_at,
        d.updated_at
    FROM dbo.discounts d
    WHERE d.deleted_at IS NULL AND GETDATE() BETWEEN d.start_date AND d.end_date;
    ');

    EXEC(N'
    /*
      VIEW: vw_order_discounts_active
      - Discounts applied to active orders
    */
    CREATE OR ALTER VIEW dbo.vw_order_discounts_active AS
    SELECT
        od.id,
        od.order_id,
        od.discount_id,
        od.created_at
    FROM dbo.order_discounts od
    INNER JOIN dbo.orders o ON o.id = od.order_id
    WHERE o.deleted_at IS NULL;
    ');

    EXEC(N'
    /*
      VIEW: vw_feedbacks_active
      - Approved feedbacks of active products and users
      - Denormalize: user_name, product_name
    */
    CREATE OR ALTER VIEW dbo.vw_feedbacks_active AS
    SELECT
        f.id,
        f.product_id,
        p.name AS product_name,
        f.user_id,
        u.name AS user_name,
        f.star,
        f.content,
        f.is_approved,
        f.images,
        f.order_detail_id,
        f.created_at,
        f.updated_at
    FROM dbo.feedbacks f
    INNER JOIN dbo.products p ON p.id = f.product_id
    INNER JOIN dbo.users u ON u.id = f.user_id
    WHERE f.is_approved = 1 AND p.deleted_at IS NULL AND u.deleted_at IS NULL AND u.is_locked = ''no'';
    ');

    EXEC(N'
    /*
      VIEW: vw_wishlists_active
      - Wishlists of active users and products
    */
    CREATE OR ALTER VIEW dbo.vw_wishlists_active AS
    SELECT
        w.id,
        w.user_id,
        w.product_id,
        p.name AS product_name,
        w.created_at
    FROM dbo.wishlists w
    INNER JOIN dbo.users u ON u.id = w.user_id
    INNER JOIN dbo.products p ON p.id = w.product_id
    WHERE u.deleted_at IS NULL AND u.is_locked = ''no'' AND p.deleted_at IS NULL;
    ');

    COMMIT TRANSACTION;
    PRINT 'Cart/Order/Related views created/updated successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
    PRINT 'Error creating cart/order views: ' + @Err;
    THROW;
END CATCH;