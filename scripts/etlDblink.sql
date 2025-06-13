SELECT dblink_connect(
    'oltp_conn',
    'dbname=CourseProject user=postgres password=тайна'
);

INSERT INTO Dim_Date (full_date, day, month, quarter, year)
SELECT DISTINCT date::DATE,
       EXTRACT(DAY FROM date),
       EXTRACT(MONTH FROM date),
       EXTRACT(QUARTER FROM date),
       EXTRACT(YEAR FROM date)
FROM (
    SELECT order_date::DATE AS date
    FROM dblink('oltp_conn', 'SELECT order_date FROM Orders')
    AS t(order_date DATE)
    UNION
    SELECT payment_date::DATE
    FROM dblink('oltp_conn', 'SELECT payment_date FROM Payments')
    AS t(payment_date DATE)
    UNION
    SELECT review_date::DATE
    FROM dblink('oltp_conn', 'SELECT review_date FROM Reviews')
    AS t(review_date DATE)
) AS all_dates
WHERE NOT EXISTS (
    SELECT 1 FROM Dim_Date d WHERE d.full_date = all_dates.date
);

INSERT INTO Dim_User (user_id, username, email_domain)
SELECT user_id, username, SPLIT_PART(email, '@', 2)
FROM dblink('oltp_conn', 'SELECT user_id, username, email FROM Users')
AS t(user_id INT, username TEXT, email TEXT)
WHERE NOT EXISTS (
    SELECT 1 FROM Dim_User du WHERE du.user_id = t.user_id
);

INSERT INTO Dim_Artist (artist_id, name, country, effective_from, effective_to, is_current)
SELECT artist_id, name, country, CURRENT_DATE, NULL, TRUE
FROM dblink('oltp_conn', 'SELECT artist_id, name, country FROM Artists')
AS t(artist_id INT, name TEXT, country TEXT)
WHERE NOT EXISTS (
    SELECT 1 FROM Dim_Artist da WHERE da.artist_id = t.artist_id AND da.is_current = TRUE
);

INSERT INTO Dim_Artwork (artwork_id, title, original_or_print, category_name)
SELECT a.artwork_id, a.title, a.original_or_print, c.name
FROM dblink('oltp_conn', 'SELECT artwork_id, title, original_or_print FROM Artworks')
AS a(artwork_id INT, title TEXT, original_or_print TEXT)
JOIN dblink('oltp_conn', 'SELECT artwork_id, category_id FROM Artwork_Categories')
AS ac(artwork_id INT, category_id INT) ON a.artwork_id = ac.artwork_id
JOIN dblink('oltp_conn', 'SELECT category_id, name FROM Categories')
AS c(category_id INT, name TEXT) ON ac.category_id = c.category_id
WHERE NOT EXISTS (
    SELECT 1 FROM Dim_Artwork da WHERE da.artwork_id = a.artwork_id AND da.category_name = c.name
);

INSERT INTO Bridge_Artwork_Category (artwork_id, category_name)
SELECT a.artwork_id, c.name
FROM dblink('oltp_conn', 'SELECT artwork_id, category_id FROM Artwork_Categories')
AS a(artwork_id INT, category_id INT)
JOIN dblink('oltp_conn', 'SELECT category_id, name FROM Categories')
AS c(category_id INT, name TEXT) ON a.category_id = c.category_id
WHERE NOT EXISTS (
    SELECT 1 FROM Bridge_Artwork_Category b WHERE b.artwork_id = a.artwork_id AND b.category_name = c.name
);


INSERT INTO Fact_Sales (date_id, artwork_id, user_id, artist_id, quantity, total_amount)
SELECT
    d.date_id,
    i.artwork_id,
    o.user_id,
    da.artist_sk,
    oi.quantity,
    (oi.quantity * oi.unit_price)
FROM dblink('oltp_conn', 'SELECT order_item_id, order_id, inventory_id, quantity, unit_price FROM Order_Items')
AS oi(order_item_id INT, order_id INT, inventory_id INT, quantity INT, unit_price NUMERIC)
JOIN dblink('oltp_conn', 'SELECT order_id, user_id, order_date FROM Orders')
AS o(order_id INT, user_id INT, order_date DATE) ON oi.order_id = o.order_id
JOIN dblink('oltp_conn', 'SELECT inventory_id, artwork_id FROM Inventory')
AS i(inventory_id INT, artwork_id INT) ON oi.inventory_id = i.inventory_id
JOIN dblink('oltp_conn', 'SELECT artwork_id, artist_id FROM Artworks')
AS a(artwork_id INT, artist_id INT) ON i.artwork_id = a.artwork_id
JOIN Dim_Date d ON d.full_date = o.order_date
JOIN Dim_Artist da ON da.artist_id = a.artist_id AND da.is_current = TRUE
WHERE NOT EXISTS (
    SELECT 1 FROM Fact_Sales fs
    WHERE fs.date_id = d.date_id AND fs.artwork_id = i.artwork_id AND fs.user_id = o.user_id
);

INSERT INTO Fact_Reviews (review_id, date_id, artwork_id, user_id, rating)
SELECT
    r.review_id,
    d.date_id,
    r.artwork_id,
    r.user_id,
    r.rating
FROM dblink('oltp_conn', 'SELECT review_id, artwork_id, user_id, rating, review_date FROM Reviews')
AS r(review_id INT, artwork_id INT, user_id INT, rating INT, review_date DATE)
JOIN Dim_Date d ON d.full_date = r.review_date
WHERE NOT EXISTS (
    SELECT 1 FROM Fact_Reviews fr WHERE fr.review_id = r.review_id
);
