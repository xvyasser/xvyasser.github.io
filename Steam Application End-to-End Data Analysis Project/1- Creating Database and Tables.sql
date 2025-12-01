CREATE DATABASE STEAM
  GO

IF OBJECT_ID('application_categories', 'U') IS NOT NULL
    DROP TABLE application_categories;
GO
CREATE TABLE application_categories(
    appid INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (appid, category_id)
);
GO

-- A2- Creating application_developers table
IF OBJECT_ID('application_developers','U') IS NOT NULL
    DROP TABLE application_developers;
GO
CREATE TABLE application_developers(
    appid INT NOT NULL,
    developer_id INT NOT NULL,
    PRIMARY KEY (appid, developer_id)
);
GO

-- A3 - Creating application_genres table
IF OBJECT_ID('application_genres','U') IS NOT NULL
    DROP TABLE application_genres;
GO
CREATE TABLE application_genres(
    appid INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (appid, genre_id)
);
GO

-- A4- Creating Application_platforms table
IF OBJECT_ID('application_platforms','U') IS NOT NULL
    DROP TABLE application_platforms;
GO
CREATE TABLE application_platforms(
    appid INT NOT NULL,
    platform_id INT NOT NULL,
    PRIMARY KEY (appid, platform_id)
);
GO

-- A5- Creating application_publishers table
IF OBJECT_ID('application_publishers','U') IS NOT NULL
    DROP TABLE application_publishers;
GO
CREATE TABLE application_publishers(
    appid INT NOT NULL,
    publisher_id INT NOT NULL,
    PRIMARY KEY (appid, publisher_id)
);
GO

-- B-Creating DimTables (Dimension Tables)
-- B1-Creating Applications table
IF OBJECT_ID('Applications','U') IS NOT NULL
    DROP TABLE applications;
GO
CREATE TABLE Applications(
    appid INT PRIMARY KEY NOT NULL,
    name NVARCHAR(MAX) NOT NULL,
    type NVARCHAR(MAX),
    is_free NVARCHAR(10),
    release_date DATE,
    required_age INT,
    short_description NVARCHAR(MAX),
    supported_languages NVARCHAR(MAX),
    header_image NVARCHAR(MAX),
    background NVARCHAR(MAX),
    metacritic_score INT,
    recommendations_total INT,
    mat_supports_windows NVARCHAR(MAX),
    mat_supports_mac NVARCHAR(MAX),
    mat_supports_linux NVARCHAR(MAX),
    mat_initial_price INT,
    mat_final_price INT,
    mat_discount_percent INT,
    mat_currency NVARCHAR(MAX),
    mat_achievement_count INT,
    mat_pc_os_min NVARCHAR(MAX),
    mat_pc_processor_min NVARCHAR(MAX),
    mat_pc_memory_min NVARCHAR(MAX),
    mat_pc_graphics_min NVARCHAR(MAX),
    mat_pc_os_rec NVARCHAR(MAX),
    mat_pc_processor_rec NVARCHAR(MAX),
    mat_pc_memory_rec NVARCHAR(MAX),
    mat_pc_graphics_rec NVARCHAR(MAX),
    created_at DATETIMEOFFSET(7),
    updated_at DATETIMEOFFSET(7)
);
GO

-- B2- Creating Categories Table (FIXED: lowercase 'name' to match CSV)
IF OBJECT_ID('Categories','U') IS NOT NULL
    DROP TABLE Categories;
GO
CREATE TABLE Categories(
    id INT PRIMARY KEY,
    name NVARCHAR(MAX)
);
GO

-- B3- Creating Developers Table (FIXED: lowercase 'name' to match CSV)
IF OBJECT_ID('Developers','U') IS NOT NULL
    DROP TABLE Developers;
GO
CREATE TABLE Developers(
    id INT PRIMARY KEY,
    name NVARCHAR(MAX)
);
GO

-- B4 Creating Genres Table (FIXED: lowercase 'name' to match CSV)
IF OBJECT_ID('Genres','U') IS NOT NULL
    DROP TABLE Genres;
GO
CREATE TABLE Genres(
    id INT PRIMARY KEY,
    name NVARCHAR(MAX)
);
GO

-- B5 Creating Platforms Table
IF OBJECT_ID('Platforms','U') IS NOT NULL
    DROP TABLE Platforms;
GO
CREATE TABLE Platforms(
    id INT PRIMARY KEY,
    name NVARCHAR(MAX)
);
GO

-- B6- Creating Publishers Table
IF OBJECT_ID('Publishers','U') IS NOT NULL
    DROP TABLE Publishers;
GO
CREATE TABLE Publishers(
    id INT PRIMARY KEY,
    name NVARCHAR(MAX)
);
GO
