BEGIN TRY
    BEGIN TRANSACTION;

    EXEC(N'
    /*
      STORED PROCEDURE: SP_User_GetActiveList
    */
    CREATE OR ALTER PROCEDURE dbo.SP_User_GetActiveList AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            id,
            email,
            name,
            role,
            avatar,
            phone,
            created_at,
            updated_at
        FROM
            dbo.vw_users_active
        ORDER BY
            created_at DESC;
    END
    ');

    COMMIT TRANSACTION;
    PRINT 'Stored Procedure SP_User_GetActiveList created/updated successfully.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
    PRINT 'Error creating active user SP: ' + @Err;
    THROW;
END CATCH;