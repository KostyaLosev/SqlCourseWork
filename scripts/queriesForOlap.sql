SELECT dd.year, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_date dd ON fs.date_id = dd.date_id
GROUP BY dd.year
ORDER BY dd.year;

SELECT bac.category_name, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_artwork da ON fs.artwork_id = da.artwork_id
JOIN bridge_artwork_category bac ON da.artwork_id = bac.artwork_id
GROUP BY bac.category_name
ORDER BY total_sales DESC;

SELECT bac.category_name, AVG(fr.rating) AS avg_rating
FROM fact_reviews fr
JOIN dim_artwork da ON fr.artwork_id = da.artwork_id
JOIN bridge_artwork_category bac ON da.artwork_id = bac.artwork_id
GROUP BY bac.category_name
ORDER BY avg_rating DESC;
