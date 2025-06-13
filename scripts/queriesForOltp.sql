SELECT a.name AS artist_name, COUNT(i.artwork_id) AS artworks_sold
FROM Artists a
JOIN Artworks ar ON a.artist_id = ar.artist_id
JOIN Inventory i ON ar.artwork_id = i.artwork_id
JOIN Order_Items oi ON i.inventory_id = oi.inventory_id
GROUP BY a.name
ORDER BY artworks_sold DESC;

SELECT ar.title, AVG(r.rating) AS avg_rating
FROM Artworks ar
JOIN Reviews r ON ar.artwork_id = r.artwork_id
GROUP BY ar.title
ORDER BY avg_rating DESC;

SELECT status, COUNT(*) AS total_orders
FROM Orders
GROUP BY status;
