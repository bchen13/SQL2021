-- We are creating an audit table for the category_average_view.  
-- Every time there is a record inserted into the category_average_view table, 
-- we will insert a record into the audit table (category_count_audit) 

CREATE TABLE category_count_audit
(category_name varchar(200), avg_view_count int, changeat datetime default null, action varchar(50) default null);

DROP TABLE category_count_audit;

DELIMITER $$
CREATE TRIGGER category_count_AFTER_INSERT
AFTER INSERT ON category_average_view FOR EACH ROW BEGIN
INSERT INTO category_count_audit (category_name, avg_view_count, changeat, action)
values(new.category_name, new.avg_view_count, now(), 'add');
END$$
DELIMITER ;

SELECT * 
FROM category_count_audit;