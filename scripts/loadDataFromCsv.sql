COPY Users(username, email, password_hash)
FROM 'D:/SQLCourseWork/users.csv' DELIMITER ',' CSV HEADER;

COPY Artists(name, bio, birthdate, country)
FROM 'D:/SQLCourseWork/artists.csv' DELIMITER ',' CSV HEADER;

COPY Artworks(artist_id, title, description, original_or_print, creation_date)
FROM 'D:/SQLCourseWork/artworks.csv' DELIMITER ',' CSV HEADER;

COPY Categories(name)
FROM 'D:/SQLCourseWork/categories.csv' DELIMITER ',' CSV HEADER;

COPY Artwork_Categories(artwork_id, category_id)
FROM 'D:/SQLCourseWork/artwork_categories.csv' DELIMITER ',' CSV HEADER;

COPY Inventory(artwork_id, quantity, price, availability_status)
FROM 'D:/SQLCourseWork/inventory.csv' DELIMITER ',' CSV HEADER;

COPY Orders(user_id, order_date, status)
FROM 'D:/SQLCourseWork/orders.csv' DELIMITER ',' CSV HEADER;

COPY Order_Items(order_id, inventory_id, quantity, unit_price)
FROM 'D:/SQLCourseWork/order_items.csv' DELIMITER ',' CSV HEADER;

COPY Payments(order_id, payment_method, amount, payment_date)
FROM 'D:/SQLCourseWork/payments.csv' DELIMITER ',' CSV HEADER;

COPY Reviews(artwork_id, user_id, rating, comment, review_date)
FROM 'D:/SQLCourseWork/reviews.csv' DELIMITER ',' CSV HEADER;
