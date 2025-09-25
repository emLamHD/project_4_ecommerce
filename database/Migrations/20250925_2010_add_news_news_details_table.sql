-- ======================================
-- Migration: Add news and news_details tables
-- Date: 2025-09-12/4:23pm  
-- Author: emlamhd
-- ======================================

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE news (
        id INT IDENTITY(1,1) PRIMARY KEY,
        title NVARCHAR(500) NOT NULL,
        image NVARCHAR(MAX),
        content NVARCHAR(MAX),
        is_deleted BIT NOT NULL DEFAULT 0,
        created_by INT NOT NULL,
        updated_by INT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_news_created_by FOREIGN KEY (created_by) REFERENCES users(id),
        CONSTRAINT FK_news_updated_by FOREIGN KEY (updated_by) REFERENCES users(id)
    );

   
    CREATE TABLE news_details (
        id INT IDENTITY(1,1) PRIMARY KEY,
        news_id INT NOT NULL,
        product_id INT NOT NULL,
        is_deleted BIT NOT NULL DEFAULT 0,
        created_by INT NOT NULL,
        updated_by INT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_news_details_news FOREIGN KEY (news_id) REFERENCES news(id) ON DELETE CASCADE,
        CONSTRAINT FK_news_details_product FOREIGN KEY (product_id) REFERENCES products(id),
        CONSTRAINT FK_news_details_created_by FOREIGN KEY (created_by) REFERENCES users(id),
        CONSTRAINT FK_news_details_updated_by FOREIGN KEY (updated_by) REFERENCES users(id)
    );
    CREATE INDEX IX_news_details_news_id ON news_details(news_id);
    CREATE INDEX IX_news_details_product_id ON news_details(product_id);
    COMMIT TRANSACTION;
    PRINT 'Migration: Add news and news_details tables applied successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

    PRINT 'Migration failed!';
    PRINT ERROR_MESSAGE();
    PRINT ERROR_LINE();
END CATCH;