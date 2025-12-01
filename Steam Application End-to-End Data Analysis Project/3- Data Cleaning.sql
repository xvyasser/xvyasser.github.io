--Joining application tables
SELECT t1.*,
t2.*
FROM application_categories t1
INNER JOIN Applications t2 ON t1.appid =t2.appid;
GO
--Cleaning the supported languages colummn

Update Applications
SET supported_languages = 
REPLACE(
		REPLACE(
				REPLACE(
						REPLACE(
								REPLACE(supported_languages,'<strong>*</strong>', ''),
								                    '<strong>', ''
                ),
                '</strong>', ''
            ),
            '<br>*languages with full audio support', ''
        ),
        '<br>', ''
    );
GO

UPDATE Applications
SET supported_languages =
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
        supported_languages,
        'Inglês', 'English'
    ),
        'Francês', 'French'
    ),
        'Italiano', 'Italian'
    ),
        'Alemão', 'German'
    ),
        'Espanhol (Espanha)', 'Spanish (Spain)'
    ),
        'Japonês', 'Japanese'
    ),
        'Coreano', 'Korean'
    ),
        'Português (Brasil)', 'Portuguese (Brazil)'
    ),
        'Russo', 'Russian'
    ),
        'Chinês simplificado', 'Simplified Chinese'
    ),
        'Chinês tradicional', 'Traditional Chinese'
    ),
        'Espanhol (América Latina)', 'Spanish (Latin America)'
    ),
        'Koreanlanguages with full audio support', ''
    ),
        'Spanish - Spain', 'Spain'
    ),
        'Portuguese - Portugal', 'Portuguese'
    );
GO

UPDATE Applications
SET supported_languages =
CASE
    WHEN supported_languages LIKE '%languages with full audio support'
    THEN LEFT(supported_languages,LEN(supported_languages)-LEN('%languages with full audio support'))
ELSE supported_languages
END
GO

-- Converting release date data type
ALTER TABLE Applications
ALTER COLUMN release_date DATE;

-- Converting is_free data type
Update Applications
SET is_free =
CASE WHEN is_free = 0 THEN 'NO'
     WHEN is_free = 1 THEN 'YES'
Else 'Unknown'
END
GO

--Removing Spaces

UPDATE Developers
SET name = TRIM(name)
GO

UPDATE Categories
SET name = TRIM(name)
GO

UPDATE Genres
SET name = TRIM(name)
GO


UPDATE Publishers
SET name = TRIM(name)
GO

--Capitalizing OS names

Update Platforms
SET name =
UPPER(LEFT(name,1))+SUBSTRING(name,2,LEN(name))
GO

-- Adding a price category
ALTER TABLE Applications
ADD price_category AS
(
    CASE 
        WHEN mat_final_price = 0 THEN 'Free'
        WHEN mat_final_price BETWEEN 1 AND 999 THEN 'LOW'
        WHEN mat_final_price BETWEEN 1000 AND 2999 THEN 'MEDIUM'
        WHEN mat_final_price >= 3000 THEN 'HIGH'
END
)

-- Checking for Duplicates and excluding them

SELECT * FROM(
Select appid,name,short_description,release_date,ROW_NUMBER() OVER(Partition By name ORDER BY appid) as num
FROM Applications) t
WHERE num>1
GO

;WITH Duplicates AS(Select appid,name,short_description,release_date,ROW_NUMBER() OVER(Partition By name ORDER BY appid) as num
FROM Applications) 
DELETE FROM Duplicates
WHERE num>1
GO
