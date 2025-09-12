USE EcommerceDB;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    EXEC(N'
    /*
      VIEW: vw_users_active
      - Users not deleted AND not locked
      - Include default address id & line (TOP 1 where is_default=''yes'')
    */
    CREATE OR ALTER VIEW dbo.vw_users_active AS
    SELECT 
        u.id,
        u.email,
        u.name,
        u.avatar,
        u.phone,
        u.role,
        u.is_locked,
        u.created_at,
        u.updated_at,
        (SELECT TOP 1 a.id FROM dbo.addresses a WHERE a.user_id = u.id AND a.is_default = ''yes'') AS default_address_id,
        (SELECT TOP 1 a.address_line FROM dbo.addresses a WHERE a.user_id = u.id AND a.is_default = ''yes'') AS default_address_line
    FROM dbo.users u
    WHERE u.deleted_at IS NULL AND u.is_locked = ''no'';
    ');

    EXEC(N'
    /*
      VIEW: vw_addresses_active
      - Addresses of active users (user deleted_at IS NULL)
      - Keep is_default as is
    */
    CREATE OR ALTER VIEW dbo.vw_addresses_active AS
    SELECT
        a.id,
        a.user_id,
        u.email AS user_email,
        a.name,
        a.address_line,
        a.city,
        a.state,
        a.country,
        a.postal_code,
        a.phone,
        a.is_default,
        a.created_at,
        a.updated_at
    FROM dbo.addresses a
    INNER JOIN dbo.users u ON u.id = a.user_id
    WHERE u.deleted_at IS NULL;
    ');

    COMMIT TRANSACTION;
    PRINT 'User & Address views created/updated successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
    PRINT 'Error creating user/address views: ' + @Err;
    THROW;
END CATCH;
GO