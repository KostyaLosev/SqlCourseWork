CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Artists (
    artist_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    bio TEXT,
    birthdate DATE,
    country VARCHAR(50)
);

CREATE TABLE Artworks (
    artwork_id SERIAL PRIMARY KEY,
    artist_id INT NOT NULL REFERENCES Artists(artist_id),
    title VARCHAR(150) NOT NULL,
    description TEXT,
    original_or_print VARCHAR(20) CHECK (original_or_print IN ('original', 'print')),
    creation_date DATE
);

CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Artwork_Categories (
    artwork_id INT REFERENCES Artworks(artwork_id),
    category_id INT REFERENCES Categories(category_id),
    PRIMARY KEY (artwork_id, category_id)
);

CREATE TABLE Inventory (
    inventory_id SERIAL PRIMARY KEY,
    artwork_id INT NOT NULL REFERENCES Artworks(artwork_id),
    quantity INT CHECK (quantity >= 0),
    price NUMERIC(10,2) NOT NULL,
    availability_status VARCHAR(20) CHECK (availability_status IN ('in_stock', 'sold_out', 'preorder'))
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('pending', 'shipped', 'delivered', 'cancelled')) NOT NULL
);

CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES Orders(order_id),
    inventory_id INT NOT NULL REFERENCES Inventory(inventory_id),
    quantity INT CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES Orders(order_id),
    payment_method VARCHAR(20) CHECK (payment_method IN ('card', 'paypal', 'bank_transfer')),
    amount NUMERIC(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    artwork_id INT NOT NULL REFERENCES Artworks(artwork_id),
    user_id INT NOT NULL REFERENCES Users(user_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
