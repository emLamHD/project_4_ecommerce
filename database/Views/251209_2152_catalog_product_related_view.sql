-- Comprehensive Denormalization: Tính toán trước các giá trị tổng hợp phức tạp

-- Soft Delete Handling: Lọc các sản phẩm đã bị xóa mềm (deleted_at IS NULL)

-- Correlated Subqueries: Sử dụng nhiều subquery để lấy thông tin tổng hợp

-- Data Aggregation: Tính toán min, max, avg, count từ các bảng liên quan

-- Transaction Safety: Đảm bảo tính atomicity cho toàn bộ operation


BEGIN TRY
    BEGIN TRANSACTION;

    EXEC(N'
    /*
      VIEW: vw_categories_active
      - All categories (no deleted_at yet; add filter if implemented)
    */
    CREATE OR ALTER VIEW dbo.vw_categories_active AS
    SELECT id, name, images, created_at, updated_at
    FROM dbo.categories;
    ');

    EXEC(N'
    /*
      VIEW: vw_brands_active
      - All brands (no deleted_at)
    */
    CREATE OR ALTER VIEW dbo.vw_brands_active AS
    SELECT id, name, images, created_at, updated_at
    FROM dbo.brands;
    ');

    EXEC(N'
    /*
      VIEW: vw_products_active
      - Products not deleted
      - Denormalize: brand_name, category_name, main_image, variant_count, min_price, max_price, avg_star (from feedbacks)
    */
    CREATE OR ALTER VIEW dbo.vw_products_active AS
    SELECT
        p.id,
        p.name,
        p.description,
        p.specification,
        p.purchase_count,
        p.brand_id,
        b.name AS brand_name,
        p.category_id,
        c.name AS category_name,
        p.created_at,
        p.updated_at,
        (SELECT TOP 1 pi.image_url FROM dbo.product_images pi WHERE pi.product_id = p.id ORDER BY pi.id) AS main_image_url,
        (SELECT COUNT(1) FROM dbo.product_variants pv WHERE pv.product_id = p.id) AS variant_count,
        (SELECT MIN(pv.price) FROM dbo.product_variants pv WHERE pv.product_id = p.id) AS min_price,
        (SELECT MAX(pv.price) FROM dbo.product_variants pv WHERE pv.product_id = p.id) AS max_price,
        (SELECT AVG(f.star * 1.0) FROM dbo.feedbacks f WHERE f.product_id = p.id AND f.is_approved = 1) AS avg_star
    FROM dbo.products p
    LEFT JOIN dbo.brands b ON b.id = p.brand_id
    LEFT JOIN dbo.categories c ON c.id = p.category_id
    WHERE p.deleted_at IS NULL;
    ');

    EXEC(N'
    /*
      VIEW: vw_product_variants_active
      - Variants of active products
      - Denormalize: product_name, attributes (JSON aggregate if needed, but simple here)
    */
    CREATE OR ALTER VIEW dbo.vw_product_variants_active AS
    SELECT
        pv.id,
        pv.product_id,
        p.name AS product_name,
        pv.price,
        pv.old_price,
        pv.stock,
        pv.sku,
        pv.created_at,
        pv.updated_at
    FROM dbo.product_variants pv
    INNER JOIN dbo.products p ON p.id = pv.product_id
    WHERE p.deleted_at IS NULL;
    ');

    EXEC(N'
    /*
      VIEW: vw_product_images_active
      - Images of active products
    */
    CREATE OR ALTER VIEW dbo.vw_product_images_active AS
    SELECT
        pi.id,
        pi.product_id,
        pi.image_url,
        pi.created_at,
        pi.updated_at
    FROM dbo.product_images pi
    INNER JOIN dbo.products p ON p.id = pi.product_id
    WHERE p.deleted_at IS NULL;
    ');

    EXEC(N'
    /*
      VIEW: vw_product_attributes_active
      - All attributes (no soft delete)
    */
    CREATE OR ALTER VIEW dbo.vw_product_attributes_active AS
    SELECT id, name, created_at, updated_at
    FROM dbo.product_attributes;
    ');

    EXEC(N'
    /*
      VIEW: vw_product_attribute_values_active
      - All values (no soft delete)
    */
    CREATE OR ALTER VIEW dbo.vw_product_attribute_values_active AS
    SELECT id, attribute_id, value, created_at, updated_at
    FROM dbo.product_attribute_values;
    ');

    EXEC(N'
    /*
      VIEW: vw_product_variant_combinations_active
      - Combinations of active variants (via join)
    */
    CREATE OR ALTER VIEW dbo.vw_product_variant_combinations_active AS
    SELECT
        pvc.id,
        pvc.variant_id,
        pvc.attribute_value_id,
        pvc.created_at,
        pvc.updated_at
    FROM dbo.product_variant_combinations pvc
    INNER JOIN dbo.product_variants pv ON pv.id = pvc.variant_id
    INNER JOIN dbo.products p ON p.id = pv.product_id
    WHERE p.deleted_at IS NULL;
    ');

    COMMIT TRANSACTION;
    PRINT 'Catalog & Product views created/updated successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
    PRINT 'Error creating catalog/product views: ' + @Err;
    THROW;
END CATCH;
