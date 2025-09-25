-- ======================================
-- Migration: Add News
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
		created_by INT NULL,
        updated_by INT NULL,
		created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE(),
		CONSTRAINT FK_news_createdby FOREIGN KEY (created_by) REFERENCES users(id),
        CONSTRAINT FK_news_updatedby FOREIGN KEY (updated_by) REFERENCES users(id)
    );
    CREATE INDEX IX_news_created_at ON news(created_at);

    COMMIT TRANSACTION;
    PRINT 'Table news created successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Failed to create news table: ' + ERROR_MESSAGE();
END CATCH;