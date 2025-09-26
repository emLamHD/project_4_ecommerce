CREATE PROCEDURE sp_Login
    @email VARCHAR(255),
    @password VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @userId INT;
        DECLARE @hashedPassword VARCHAR(255);
        DECLARE @isLocked VARCHAR(3);
        DECLARE @userRole VARCHAR(20);

        -- Kiểm tra xem email có tồn tại không
        SELECT 
            @userId = id,
            @hashedPassword = password,
            @isLocked = is_locked,
            @userRole = role
        FROM users 
        WHERE email = @email 
            AND deleted_at IS NULL;

        -- Nếu không tìm thấy email
        IF @userId IS NULL
        BEGIN
            SELECT 
                'error' AS status,
                'Email không tồn tại hoặc tài khoản đã bị xóa' AS message,
                NULL AS user_data;
            RETURN;
        END

        -- Kiểm tra tài khoản có bị khóa không
        IF @isLocked = 'yes'
        BEGIN
            SELECT 
                'error' AS status,
                'Tài khoản đã bị khóa' AS message,
                NULL AS user_data;
            RETURN;
        END

        -- Kiểm tra mật khẩu (giả sử mật khẩu đã được hash và lưu trữ)
        -- TRONG THỰC TẾ: Bạn nên sử dụng hàm hash phù hợp (như bcrypt) để so sánh
        -- Ở đây tôi giả định bạn đã hash mật khẩu trước khi lưu vào database
        IF @hashedPassword != @password -- THAY THẾ BẰNG HÀM SO SÁNH HASH PHÙ HỢP
        BEGIN
            SELECT 
                'error' AS status,
                'Mật khẩu không chính xác' AS message,
                NULL AS user_data;
            RETURN;
        END

        -- Đăng nhập thành công - trả về thông tin người dùng (loại bỏ mật khẩu)
        SELECT 
            'success' AS status,
            'Đăng nhập thành công' AS message,
            (SELECT 
                id,
                email,
                name,
                role,
                avatar,
                phone,
                is_locked,
                created_at,
                updated_at
             FROM users 
             WHERE id = @userId
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS user_data;

    END TRY
    BEGIN CATCH
        SELECT 
            'error' AS status,
            'Đã xảy ra lỗi trong quá trình đăng nhập' AS message,
            NULL AS user_data;
    END CATCH
END