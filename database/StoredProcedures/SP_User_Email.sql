IF OBJECT_ID('sp_user_email', 'P') IS NOT NULL
    DROP PROCEDURE sp_user_email;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    EXEC(N'
    /*
        STORED PROCEDURE: sp_user_email
    */
    CREATE OR ALTER PROCEDURE dbo.sp_user_email
        @Email VARCHAR(255)
    AS
    BEGIN
        SET NOCOUNT ON;

        SELECT 
            u.id,
            u.email,
            u.name,
            u.role,
            u.avatar,
            u.phone,
            u.is_locked,
            u.is_deleted,
            u.created_at,
            u.updated_at
        FROM dbo.users u
        WHERE u.email = @Email
          AND u.is_deleted = 0;
    END
    ');

    COMMIT TRANSACTION;
    PRINT 'Stored Procedure sp_user_email created/updated successfully.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
    PRINT 'Error creating sp_user_email: ' + @Err;
    THROW;
END CATCH;
GO
