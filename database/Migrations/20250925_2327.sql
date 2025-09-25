CREATE TABLE banners (
  id INT PRIMARY KEY IDENTITY(1,1),
  name VARCHAR(255),
  image TEXT,
  status VARCHAR(20) CHECK (status IN ('active', 'inactive')),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME DEFAULT GETDATE(),
  is_deleted BIT DEFAULT 0,
  created_by INT,
  updated_by INT
);

CREATE TABLE banner_details (
  id INT PRIMARY KEY IDENTITY(1,1),
  product_id INT,
  banner_id INT,
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME DEFAULT GETDATE(),
  is_deleted BIT DEFAULT 0,
  created_by INT,
  updated_by INT
);

ALTER TABLE banner_details
ADD CONSTRAINT FK_banner_details_banners
FOREIGN KEY (banner_id)
REFERENCES banners(id);