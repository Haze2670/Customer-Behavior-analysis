select * from customer limit 20

SELECT
    gender,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY gender
ORDER BY total_revenue DESC;

SELECT
    customer_id,
    item_purchased,
    purchase_amount,
    discount_applied
FROM customer
WHERE discount_applied = 'Yes'
  AND purchase_amount > (
      SELECT AVG(purchase_amount)
      FROM customer)
ORDER BY purchase_amount DESC;


WITH product_sales AS (
    SELECT
        category,
        item_purchased,
        COUNT(*) AS purchase_count
    FROM customer
    GROUP BY category, item_purchased
),
ranked_products AS (
    SELECT
        category,
        item_purchased,
        purchase_count,
        RANK() OVER (
            PARTITION BY category
            ORDER BY purchase_count DESC
        ) AS rank
    FROM product_sales
)
SELECT
    category,
    item_purchased,
    purchase_count
FROM ranked_products
WHERE rank <= 3
ORDER BY category, purchase_count DESC;