-- vw_inventory_logs_active ghi lai thong tin cac bien the san pham dang hoat dong bao gom SKU va ten san pham.

BEGIN TRY
    BEGIN TRANSACTION;

    EXEC(N'
    /*
      VIEW: vw_inventory_logs_active
      - Logs of active variants/products
      - Denormalize: product_name, variant_sku
    */
    CREATE OR ALTER VIEW dbo.vw_inventory_logs_active AS
    SELECT
        il.id,
        il.variant_id,
        pv.sku AS variant_sku,
        p.name AS product_name,
        il.change_amount,
        il.reason,
        il.created_at
    FROM dbo.inventory_logs il
    INNER JOIN dbo.product_variants pv ON pv.id = il.variant_id
    INNER JOIN dbo.products p ON p.id = pv.product_id
    WHERE p.deleted_at IS NULL;
    ');

    COMMIT TRANSACTION;
    PRINT 'Inventory & Other views created/updated successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
    PRINT 'Error creating inventory views: ' + @Err;
    THROW;
END CATCH;
