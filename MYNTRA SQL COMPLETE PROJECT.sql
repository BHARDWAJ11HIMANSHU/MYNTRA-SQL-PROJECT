CREATE DATABASE MYNTRA;
USE MYNTRA;
SELECT * FROM CLOTHING;


# Deleting unnecessary columns.
ALTER TABLE CLOTHING
DROP COLUMN URL;

ALTER TABLE CLOTHING
DROP COLUMN Description;

# CHECKING THE DATA TYPE
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'MYNTRA' 
AND table_name = 'CLOTHING'; 

# FORMATTING THE COLUMNS NAME
ALTER TABLE CLOTHING
CHANGE `DiscountPrice (in Rs)` DiscountPrice text,
CHANGE `OriginalPrice (in Rs)` OriginalPrice INT;

# Retrieve the total number of unique brands in the dataset.
SELECT COUNT(DISTINCT BrandName) AS BRAND_NAME
FROM CLOTHING;

# Find the average discount percentage across all products.
SELECT Individual_category, ROUND(AVG(DiscountOffer),1) AS AVG_DISCOUNT_PERCENTAGE
FROM CLOTHING
GROUP BY Individual_category
ORDER BY AVG_DISCOUNT_PERCENTAGE DESC;

#Create a view that displays the product_id, brand name, and discounted price for all products in the 'BOTTOM WEAR' category.
CREATE OR REPLACE VIEW  BOTTOM_WEAR_CATEGORY AS
SELECT Product_id, BrandName,DiscountPrice
FROM CLOTHING
WHERE Category = 'BOTTOM WEAR';

SELECT * FROM BOTTOM_WEAR_CATEGORY;

# Identify the top 5 brands with the highest average ratings.
SELECT BrandName, AVG(Ratings) AS AVERAGE_RATINGS
FROM CLOTHING
GROUP BY BrandName
ORDER BY AVERAGE_RATINGS DESC
LIMIT 5;

# Calculate the total revenue generated by Myntra, considering the discounted prices.
SELECT SUM(OriginalPrice - DiscountOffer) AS TOTAL_REVENUE
FROM CLOTHING;

# Determine the most common category of products available on Myntra.
SELECT Category, COUNT(*) AS MOST_COMMON_CATEGORY
FROM CLOTHING
GROUP BY Category
ORDER BY MOST_COMMON_CATEGORY DESC;

/* Write a function to calculate the average rating for a given brand.
 Use this function to find the average rating for the brand 'Nike'. */
 
Delimiter $$
create function AVERAGE_RATING(BrandName text)     
 Returns DOUBLE
 deterministic
 Begin
      DECLARE AVG_RATING DOUBLE;
      
      SELECT AVG(Ratings) INTO AVG_RATING
      FROM CLOTHING
      WHERE BrandName=BrandName;
      RETURN AVG_RATING;
          
end $$
delimiter $$      
SELECT AVERAGE_RATING('Nike');

# Design a procedure to update the discount price of all products in the 'JEANS' category by increasing it by 10%.
DELIMITER $$
CREATE PROCEDURE UPDATED_DISCOUNT_PRICE ()
BEGIN
     UPDATE CLOTHING
     SET DiscountPrice = DiscountPrice*1.1
     WHERE Individual_category ='JEANS';
END $$
DELIMITER ;

CALL UPDATED_DISCOUNT_PRICE ();

# Find the product with the highest discount percentage.
SELECT BrandName,Individual_category, MAX(DiscountOffer) AS HIGHEST_DISCOUNT_PERCENTAGE
FROM CLOTHING
GROUP BY BrandName,Individual_category
ORDER BY HIGHEST_DISCOUNT_PERCENTAGE DESC;

# Calculate the average original price for each category.
SELECT Category, ROUND(AVG(OriginalPrice),2) AS AVERAGE_ORIGINAL_PRICE
FROM CLOTHING
GROUP BY Category
ORDER BY AVERAGE_ORIGINAL_PRICE DESC;

# Identify the brands that have products in more than one category.
SELECT BrandName
FROM CLOTHING
GROUP BY BrandName
HAVING COUNT(DISTINCT Individual_category) > 1;

# Create a view that shows the product_id, brand name, and original price for products with a discount offer of more than 30%.
CREATE VIEW Discount_Offer_MORETHAN_30 AS
SELECT Product_id,BrandName,OriginalPrice
FROM CLOTHING
WHERE DiscountOffer >= '30% OFF';

SELECT * FROM Discount_Offer_MORETHAN_30;

# Find the product_id and reviews of products with the highest ratings in each category.
SELECT Product_id, Reviews
FROM CLOTHING
WHERE (RATINGS) IN
(SELECT MAX(Ratings) AS MAXIMUM_RATING
FROM CLOTHING
GROUP BY Category);

# Develop a function to calculate the total revenue generated by the 'Adidas' brand.

DELIMITER $$
CREATE FUNCTION TOTAL_REVENUE (BrandName TEXT)
RETURNS INT 
DETERMINISTIC
BEGIN

     DECLARE TOTALREVENUE int;
     SELECT  SUM(OriginalPrice - DiscountOffer) INTO TOTALREVENUE
	 FROM CLOTHING
     WHERE BRANDNAME= BRANDNAME;
     
	IF totalRevenue IS NULL THEN
	SET totalRevenue = 0;
    END IF;
    
     RETURN  TOTALREVENUE;
     
END $$
DELIMITER $$

SELECT TOTAL_REVENUE('ADIDAS');

# Design a procedure to add a new size option 'XXL' to the 'WESTERN' category.
DELIMITER $$
CREATE PROCEDURE INSERT_XXL_SIZE ()  
BEGIN 
     DECLARE CATEGORYEXISTS INT;
     
     SELECT COUNT(*) INTO CATEGORYEXISTS
     FROM CLOTHING
     WHERE CATEGORY = 'WESTERN';
     
     IF CATEGORYEXISTS >0 THEN
     INSERT INTO CLOTHING (Category,SizeOption) VALUES ('WESTERN','XXL');
     
     SELECT 'SIZE OPTIION XXL ADDED TO WESTERN CATEGORY.' AS RESULT;

     ELSE 
     SELECT ' CATEGORY WESTERN DOESNOT EXIST.' AS RESULT;
     END IF;
     END $$
     DELIMITER ;
     
CALL INSERT_XXL_SIZE;

# Retrieve the product details with the lowest rating.
SELECT Individual_category,BrandName , MIN(Ratings) AS LOWEST_RATINGS
FROM CLOTHING
GROUP BY Individual_category,BrandName
ORDER BY LOWEST_RATINGS;

# Calculate the average discount percentage for each brand.
SELECT BrandName, ROUND(AVG(DiscountOffer),2) AS AVERAGE_DISCOUNT_PERCENTAGE
FROM CLOTHING
GROUP BY BrandName
ORDER BY AVERAGE_DISCOUNT_PERCENTAGE DESC;

# Create a view that displays the product_id, brand name, and category for products with more than 100 reviews

CREATE OR REPLACE VIEW MORE_100_REVIEWS AS 
SELECT Product_id,BrandName,Category,REVIEWS
FROM CLOTHING
WHERE REVIEWS >= 100
GROUP BY Product_id,BrandName,Category
ORDER BY REVIEWS DESC;

SELECT * FROM MORE_100_REVIEWS;


# Develop a function that returns the number of products in a given category. Use it to find the count of products in the 'Indian Wear' category.
DELIMITER $$
CREATE FUNCTION NUMBER_OF_PRODUCTS(CATEGORY_PARAM TEXT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE COUNT_OF_PRODUCT INT;
    
    SELECT COUNT(Individual_category) INTO COUNT_OF_PRODUCT
    FROM CLOTHING
    WHERE CATEGORY = CATEGORY_PARAM;  
       
    RETURN COUNT_OF_PRODUCT; 
END $$
DELIMITER ;

SELECT NUMBER_OF_PRODUCTS('Indian Wear');

# Create a procedure to apply a 20% discount to the original price of all products with a rating less than 3.

DELIMITER $$
CREATE PROCEDURE 20_DISCOUNT()
BEGIN 
     
     UPDATE CLOTHING
     SET DiscountOffer = OriginalPrice* 0.2
     WHERE Ratings < 3;
END $$
DELIMITER ;     

CALL 20_DISCOUNT();

# Retrieve the query to find the brand names that have products in both the 'Men' and 'Women' categories.
SELECT BrandName, Individual_category,category_by_Gender
FROM CLOTHING
WHERE category_by_Gender IN ('Men', 'Women')
GROUP BY BrandName, Individual_category
HAVING COUNT(DISTINCT category_by_Gender) = 2;

# Create a view that shows the product_id, brand name, and ratings for the top 5 products with the highest original prices.
CREATE OR REPLACE VIEW TOP_5_PRODUCT AS
SELECT Product_id,BrandName,Individual_category,OriginalPrice AS HIGHEST_ORIGINAL_PRICE,Ratings
FROM CLOTHING
GROUP BY Product_id,BrandName
ORDER BY HIGHEST_ORIGINAL_PRICE DESC
LIMIT 5;

SELECT * FROM  TOP_5_PRODUCT;

#  Fetch the product_id and brand names of products that have the same original price as another product.
SELECT Product_id, BrandName, OriginalPrice
FROM CLOTHING
WHERE OriginalPrice IN (
    SELECT OriginalPrice
    FROM CLOTHING
    GROUP BY OriginalPrice
    HAVING COUNT(*) > 1);

/* Create a function to calculate the average discount percentage for a given category. 
Apply it to find the average discount for the 'Sports Wear' category. */

DELIMITER $$
CREATE FUNCTION AVERAGE_DISCOUNT_PERCENTAGE (CATEGORY_PARAM TEXT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE AVG_DISCOUNT_PERCENTAGE DECIMAL(5,2);

    SELECT AVG(DiscountOffer) INTO AVG_DISCOUNT_PERCENTAGE
    FROM CLOTHING
    WHERE Category = CATEGORY_PARAM;

    RETURN AVG_DISCOUNT_PERCENTAGE;
END $$
DELIMITER ;
 
SELECT AVERAGE_DISCOUNT_PERCENTAGE ('Sports Wear');

/* Fetch the product_id and brand names of products that have both high ratings (4 and above) 
and low original prices (less than 500 Rs). */

SELECT Product_id,BrandName,Individual_category,Ratings,OriginalPrice
FROM CLOTHING
WHERE Ratings >= 4 AND 
OriginalPrice IN (
SELECT OriginalPrice FROM CLOTHING
WHERE OriginalPrice < 500);

# Design a procedure to increase the ratings of all products in the 'Sports' category by 0.5.
DELIMITER $$
CREATE PROCEDURE RATING_INCREMENT()
BEGIN
    UPDATE CLOTHING
    SET ratings = ratings + 0.5
    WHERE Category = 'Sports Wear';
END $$
DELIMITER ;    
CALL RATING_INCREMENT();

/*  Create a view that displays the product_id, brand name, and category for products with a discount price lower than
 the average discount price across all categories. */
 
CREATE VIEW LOWERTHAN_average_discount AS
SELECT Product_id, BrandName, Individual_category
FROM CLOTHING
WHERE DiscountPrice < (
    SELECT AVG(DiscountPrice)
    FROM CLOTHING);
    
SELECT * FROM LOWERTHAN_average_discount ;




