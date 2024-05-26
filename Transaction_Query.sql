/*This SQL analysis provides a comprehensive overview of the credit card transaction data. 
It covers various aspects such as total transactions, transaction trends over daily, weekly, and monthly periods, peak transaction days, 
and merchant analysis including identifying top merchants by transaction count and total transaction amount. 
Additionally, it analyzes merchant categories, card holder patterns, and offers insights into customer segmentation based on transaction behavior. 
Overall, this analysis facilitates informed decision-making, risk mitigation, and strategic planning for business growth */

SELECT *
  FROM card_holder
SELECT *
  FROM credit_card
SELECT *
  FROM merchant
SELECT *
  FROM merchant_category
SELECT *
  FROM transactions

--Total Transactions Analysis:	
--Calculate the total number of transactions.
SELECT COUNT(*) AS total_transactions
FROM transactions;

--Calculate the total transaction amount.
SELECT SUM(amount) AS total_transaction_amount
FROM transactions;

--Find the average transaction amount.
SELECT AVG(amount) AS average_transaction_amount
FROM transactions;

--Transaction Trends Analysis:
--Analyze transaction trends over daily
SELECT
    cast(DATE as date) AS transaction_date,
    COUNT(*) AS transaction_count
FROM
    transactions
GROUP BY
    cast(DATE as date)
ORDER BY
    transaction_date;

--Analyze transaction trends over weekly
SELECT
    YEAR(date) AS transaction_year,
	DATEPART(WEEK, date) AS transaction_week,
    COUNT(*) AS transaction_count
FROM
    transactions
GROUP BY
    YEAR(date),
    DATEPART(WEEK, date) 
ORDER BY
    transaction_year,transaction_week;

--Analyze transaction trends over Monthly
SELECT
    YEAR(date) AS transaction_year,
	MONTH(date) AS transaction_month,
    COUNT(*) AS transaction_count
FROM
    transactions
GROUP BY
    YEAR(date),
    MONTH(date) 
ORDER BY
 transaction_year,transaction_month;

--Identify peak transaction days or times.

 SELECT
    YEAR(date) AS transaction_year,
    MONTH(date) AS transaction_month,
    COUNT(*) AS transaction_count
FROM
    transactions
GROUP BY
    YEAR(date),
    MONTH(date)
ORDER BY
    COUNT(*) DESC;

 -- Peak transaction by transaction months by max amt transaction
SELECT
	
    YEAR(date) AS transaction_year,
    MONTH(date) AS transaction_month,
    max(amount) AS Maximum_amount
FROM
    transactions
GROUP BY
    YEAR(date),
    MONTH(date)
ORDER BY
   Maximum_amount DESC;

--Merchant Analysis:
--Count the number of unique merchants.
SELECT COUNT(DISTINCT merchant.id) AS distinct_merchant_count
FROM merchant;

--Identify the top merchants based on the number of transactions.
SELECT m.id,m.name,count(t.id_merchant) as no_of_transaction
FROM merchant as m
join transactions as t
on m.id = t.id_merchant 
group by m.id,m.name
order by no_of_transaction desc

--Identify the top merchants based on the total transaction amount.
SELECT m.id,m.name,sum(t.amount) as total_amount_transaction
FROM merchant as m
join transactions as t
on m.id = t.id_merchant 
group by m.id,m.name
order by total_amount_transaction desc

--Merchant Category Analysis:
--Count the number of unique merchant categories.
SELECT COUNT(DISTINCT  merchant_category.id ) as unique_merchant_categories
FROM merchant_category

--Analyze transaction distribution across different merchant categories.
SELECT
    mc.id AS merchant_category_id,
    mc.name AS merchant_category_name,
    COUNT(*) AS transaction_count,
	sum(amount) as total_transaction_amount
FROM transactions t
JOIN merchant m ON t.id_merchant = m.id
JOIN merchant_category mc ON m.id_merchant_category = mc.id
GROUP BY mc.id, mc.name
ORDER BY transaction_count DESC;

--Card Holder Analysis:
--Count the number of unique card holders.
SELECT COUNT(DISTINCT card_holder.id) as  unique_card_holders
FROM card_holder
--Analyze transaction patterns for each card holder (e.g., average transaction amount, frequency).
SELECT
    ch.id AS card_holder_id,
    ch.name AS card_holder_name,
    COUNT(t.id) AS total_transactions,
    AVG(t.amount) AS average_transaction_amount
FROM card_holder ch
JOIN credit_card cc ON ch.id = cc.id_card_holder
JOIN transactions t ON cc.card = t.card
GROUP BY ch.id, ch.name
ORDER BY total_transactions DESC;
 
 --Customer Segmentation based on transaction behavior:

 SELECT
    ch.id AS card_holder_id,
    ch.name AS card_holder_name,
    SUM(t.amount) AS total_spending,
    COUNT(t.id) AS total_transactions
FROM card_holder ch
JOIN credit_card cc ON ch.id = cc.id_card_holder
JOIN transactions t ON cc.card = t.card
GROUP BY ch.id, ch.name
ORDER BY total_spending DESC;

--Calculating avg transaction all card holder name
SELECT
    ch.id AS card_holder_id,
    ch.name AS card_holder_name,
    AVG(t.amount) AS average_transaction_amount,
    MAX(t.date) AS last_transaction_date
FROM card_holder ch
JOIN credit_card cc ON ch.id = cc.id_card_holder
JOIN transactions t ON cc.card = t.card
GROUP BY ch.id, ch.name
ORDER BY last_transaction_date ASC;



