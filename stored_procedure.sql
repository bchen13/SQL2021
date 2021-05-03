CREATE TABLE category_average_view (
  category_name varchar(400) DEFAULT NULL,
  avg_view_count decimal(14,4) DEFAULT NULL,
  rec_create_date date
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


TRUNCATE TABLE category_average_view;

SELECT * 
FROM category_average_view;

DROP PROCEDURE IF EXISTS  populate_avg_category_view_count;

-- We use this stored procedure to insert a record for each category amd their average view count. 
-- We will update the rec_create_date with the parameter passed into the procedure. 

DELIMITER $$
CREATE PROCEDURE populate_avg_category_view_count(create_date varchar(100))
BEGIN
	SET @in_date:= create_date; 
	
    INSERT INTO category_average_view (category_name, avg_view_count) 
			SELECT sc.title, AVG(ss.statistics_viewCount)
			FROM site_category sc 
				JOIN site_table st 
					ON st.snippet_categoryId = sc.categoryid
				JOIN site_stats ss 
					ON ss.site_id = st.site_id
			GROUP BY sc.title;

	PREPARE apd_stmt FROM  
	'update category_average_view set rec_create_date = ?'; 
			
    EXECUTE apd_stmt USING @in_date;
    
    DEALLOCATE PREPARE apd_stmt; 
    

	END$$
DELIMITER ;	
	
CALL populate_avg_category_view_count('2021-04-22');
	
SELECT * 
FROM category_average_view;