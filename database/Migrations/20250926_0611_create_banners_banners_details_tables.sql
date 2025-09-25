-- ======================================
-- Migration: Add banners and banner_details tables
-- Date: 2025-09-12/4:23pm  
-- Author: emlamhd
-- ======================================

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE banners (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        image NVARCHAR(MAX),
        status VARCHAR(10) NOT NULL CHECK (status IN ('active', 'inactive')) DEFAULT 'active',
        is_deleted BIT NOT NULL DEFAULT 0,
        created_by INT NOT NULL,
        updated_by INT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_banners_created_by FOREIGN KEY (created_by) REFERENCES users(id),
        CONSTRAINT FK_banners_updated_by FOREIGN KEY (updated_by) REFERENCES users(id)
    );

    CREATE TABLE banner_details (
        id INT IDENTITY(1,1) PRIMARY KEY,
        banner_id INT NOT NULL,
        product_id INT NOT NULL,
        is_deleted BIT NOT NULL DEFAULT 0,
        created_by INT NOT NULL,
        updated_by INT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_banner_details_banner FOREIGN KEY (banner_id) REFERENCES banners(id) ON DELETE CASCADE,
        CONSTRAINT FK_banner_details_product FOREIGN KEY (product_id) REFERENCES products(id),
        CONSTRAINT FK_banner_details_created_by FOREIGN KEY (created_by) REFERENCES users(id),
        CONSTRAINT FK_banner_details_updated_by FOREIGN KEY (updated_by) REFERENCES users(id)
    );

    CREATE INDEX IX_banner_details_banner_id ON banner_details(banner_id);
    
    CREATE INDEX IX_banner_details_product_id ON banner_details(product_id);

    CREATE INDEX IX_banners_status ON banners(status);

    COMMIT TRANSACTION;
    PRINT 'Migration: Add banners and banner_details tables applied successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

    PRINT 'Migration failed!';
    PRINT ERROR_MESSAGE();
    PRINT ERROR_LINE();
END CATCH;