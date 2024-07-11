USE rev_optmzn;
SELECT * FROM food_orders;
SET SQL_SAFE_UPDATES=0;


-- D A T A   C L E A N I N G --

-- Change datatype of Order_Date, Order_Time & Delivery_Time Columns from text to date and time respectively
ALTER TABLE food_orders MODIFY COLUMN Order_Date DATE;
ALTER TABLE food_orders MODIFY COLUMN Order_Time TIME;
ALTER TABLE food_orders MODIFY COLUMN Delivery_Time TIME;


-- Separate out the Discount type Amount from Discounts_and_Offers coulumn--
SELECT DISTINCT Discounts_and_Offers FROM food_orders ;
ALTER TABLE food_orders ADD COLUMN Discount_Type VARCHAR(20);
UPDATE food_orders SET Discount_Type='ON APP' WHERE Discounts_and_Offers LIKE '%On App%';
UPDATE food_orders SET Discount_Type='NEW USER' WHERE Discounts_and_Offers LIKE '%New User%';
UPDATE food_orders SET Discount_Type='PROMO' WHERE Discounts_and_Offers LIKE '%off Promo%';
UPDATE food_orders SET Discount_Type='NONE' WHERE Discounts_and_Offers LIKE 'None';
UPDATE food_orders SET Discount_Type='BASIC' WHERE Discount_Type IS NULL;

-- Separate out the Discount Amount in % from Discounts_and_Offers coulumn--
UPDATE food_orders SET Discounts_and_Offers='0.05' WHERE Discounts_and_Offers LIKE '%On App%';
UPDATE food_orders SET Discounts_and_Offers='0.15' WHERE Discounts_and_Offers LIKE '%New User%';
UPDATE food_orders SET Discounts_and_Offers='0.10' WHERE Discounts_and_Offers LIKE '10%';
UPDATE food_orders SET Discounts_and_Offers='50' WHERE Discounts_and_Offers LIKE '%off Promo%';
UPDATE food_orders SET Discounts_and_Offers='0' WHERE Discounts_and_Offers LIKE 'None';

-- Separate out the Discount Amount in Rupees from Discounts_and_Offers coulumn--
ALTER TABLE food_orders ADD COLUMN Discount_Amount INT;
UPDATE food_orders SET Discount_Amount=0.05*Order_Value WHERE Discount_Type LIKE '%ON APP%';
UPDATE food_orders SET Discount_Amount=0.1*Order_Value WHERE Discount_Type LIKE '%BASIC%';
UPDATE food_orders SET Discount_Amount=0.15*Order_Value WHERE Discount_Type LIKE '%NEW USER%';
UPDATE food_orders SET Discount_Amount=50 WHERE Discount_Type LIKE '%PROMO%';
UPDATE food_orders SET Discount_Amount=0 WHERE Discount_Type LIKE '%NONE%';


-- D E F I N I N G   K P I S  &  M E T R I C S
-- i. Cost
ALTER TABLE food_orders ADD COLUMN Cost FLOAT;
UPDATE food_orders SET Cost=Delivery_Fee + Discount_Amount + Refunds + Payment_Processing_Fee ;

-- ii. Revenue
ALTER TABLE food_orders ADD COLUMN Revenue FLOAT;
UPDATE food_orders SET Revenue = Commission_Fee ;

-- iii. Profit
ALTER TABLE food_orders ADD COLUMN Profit FLOAT;
UPDATE food_orders SET Profit = Revenue-Cost ;

-- iv. Profit Margin
ALTER TABLE food_orders ADD COLUMN Profit_Margin FLOAT;
UPDATE food_orders SET Profit_Margin = Profit/Revenue ;

-- v. Commission Percentage
ALTER TABLE food_orders ADD COLUMN Commission_Percentage FLOAT;
UPDATE food_orders SET Commission_Percentage=Commission_Fee/Order_Value ;
