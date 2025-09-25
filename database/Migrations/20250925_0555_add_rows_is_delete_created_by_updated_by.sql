-- ======================================
-- Migration: Add is_deleted, created_by, updated_by fields
-- Date: 2025-09-12/4:30pm  
-- Author: emlamhd
-- ======================================

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. add is_deleted for table soft delete
    ALTER TABLE users ADD is_deleted BIT NOT NULL DEFAULT 0;
    ALTER TABLE products ADD is_deleted BIT NOT NULL DEFAULT 0;
    ALTER TABLE categories ADD is_deleted BIT NOT NULL DEFAULT 0;
    ALTER TABLE brands ADD is_deleted BIT NOT NULL DEFAULT 0;
    ALTER TABLE discounts ADD is_deleted BIT NOT NULL DEFAULT 0;
    ALTER TABLE orders ADD is_deleted BIT NOT NULL DEFAULT 0;

    -- 2. add created_by, updated_by for table master data
    ALTER TABLE products ADD created_by INT NULL, updated_by INT NULL;
    ALTER TABLE categories ADD created_by INT NULL, updated_by INT NULL;
    ALTER TABLE brands ADD created_by INT NULL, updated_by INT NULL;
    ALTER TABLE discounts ADD created_by INT NULL, updated_by INT NULL;

    -- 3. add foreign keys for created_by, updated_by
    ALTER TABLE products 
    ADD CONSTRAINT FK_products_created_by FOREIGN KEY (created_by) REFERENCES users(id),
        CONSTRAINT FK_products_updated_by FOREIGN KEY (updated_by) REFERENCES users(id);

    ALTER TABLE categories 
    ADD CONSTRAINT FK_categories_created_by FOREIGN KEY (created_by) REFERENCES users(id),
        CONSTRAINT FK_categories_updated_by FOREIGN KEY (updated_by) REFERENCES users(id);

    ALTER TABLE brands 
    ADD CONSTRAINT FK_brands_created_by FOREIGN KEY (created_by) REFERENCES users(id),
        CONSTRAINT FK_brands_updated_by FOREIGN KEY (updated_by) REFERENCES users(id);

    ALTER TABLE discounts 
    ADD CONSTRAINT FK_discounts_created_by FOREIGN KEY (created_by) REFERENCES users(id),
        CONSTRAINT FK_discounts_updated_by FOREIGN KEY (updated_by) REFERENCES users(id);

    -- 4. create indexes for new rows
    CREATE INDEX IX_products_is_deleted ON products(is_deleted);
    CREATE INDEX IX_users_is_deleted ON users(is_deleted);
    CREATE INDEX IX_categories_is_deleted ON categories(is_deleted);
    CREATE INDEX IX_products_created_by ON products(created_by);
    CREATE INDEX IX_categories_created_by ON categories(created_by);

    PRINT 'Migration: Add audit fields applied successfully.';

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Migration failed!';
    PRINT ERROR_MESSAGE();
    PRINT ERROR_LINE();
END CATCH;