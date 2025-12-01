Create OR Alter VIEW Fact_Applications_View AS
SELECT
appid as 'App ID',
release_date as 'Release Date',
mat_final_price as 'Price',
required_age as 'Required Age',
metacritic_score as 'Metacritic Score',
recommendations_total AS 'Recommendations Total'
FROM Applications
GO

-- Dim Views
--Applications View
CREATE OR ALTER VIEW Dim_Applications_View AS
SELECT 
appid as 'App ID',
name as 'Game',
type as 'Type',
is_free AS 'Is Free',
mat_pc_graphics_min AS 'Minimum Graphics',
mat_pc_memory_rec AS 'Required Memory',
mat_pc_os_min AS 'Minimum OS',
mat_pc_memory_min AS 'Minimum Memory',
mat_pc_processor_min AS 'Minimum Processor',
mat_pc_processor_rec AS 'Required Processor',
mat_pc_graphics_rec AS 'Required Graphics',
mat_pc_os_rec AS 'Required OS',
price_category AS 'Price Category'
FROM Applications
GO

--Categories View
CREATE OR ALTER VIEW Dim_Categories_View AS
SELECT ac.appid,
       STRING_AGG(c.name, ', ') AS Categories
FROM application_categories ac
JOIN Categories c ON ac.category_id = c.id
GROUP BY ac.appid;
GO

--Developers View
CREATE OR ALTER VIEW Dim_Developers_View AS
SELECT
ad.appid as 'App ID',
ad.developer_id as 'Developer ID',
d.name as 'Developer'
FROM application_developers ad 
LEFT JOIN Developers d ON ad.developer_id = d.id
GO

--Genres View
CREATE OR ALTER VIEW Dim_Genres_View AS
SELECT
ag.appid as 'App ID',
ag.genre_id as ' Genre ID',
g.name as 'Genre'
FROM application_genres ag
LEFT JOIN Genres g ON ag.genre_id = g.id
GO

--Publishers View
CREATE OR ALTER VIEW Dim_Publishers_View AS
SELECT
ap.appid as 'App ID',
ap.publisher_id as 'Publisher ID',
p.name as 'Publisher'
FROM application_publishers ap
LEFT JOIN Publishers p ON ap.publisher_id = p.id
GO

--Platforms View
CREATE OR ALTER VIEW Dim_Platforms_View AS
SELECT app.appid as 'App ID',
app.platform_id as 'Platform ID',
pp.name as 'Platform'
FROM application_platforms app
LEFT JOIN Platforms pp ON app.platform_id = pp.id
GO
