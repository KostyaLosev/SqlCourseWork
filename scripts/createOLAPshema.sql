CREATE TABLE Dim_Date (
    date_id SERIAL PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT,
    month INT,
    quarter INT,
    year INT
);

CREATE TABLE Dim_Artwork (
    artwork_id INT PRIMARY KEY,
    title VARCHAR(150),
    original_or_print VARCHAR(20),
    category_name VARCHAR(50)
);

CREATE TABLE Dim_Artist (
    artist_sk SERIAL PRIMARY KEY,
    artist_id INT NOT NULL,
    name VARCHAR(100),
    country VARCHAR(50),
    effective_from DATE,
    effective_to DATE,
    is_current BOOLEAN
);

CREATE TABLE Dim_User (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email_domain VARCHAR(50)
);

CREATE TABLE Bridge_Artwork_Category (
    artwork_id INT NOT NULL,
    category_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (artwork_id, category_name)
);

CREATE TABLE Fact_Sales (
    sales_id SERIAL PRIMARY KEY,
    date_id INT NOT NULL REFERENCES Dim_Date(date_id),
    artwork_id INT NOT NULL REFERENCES Dim_Artwork(artwork_id),
    user_id INT NOT NULL REFERENCES Dim_User(user_id),
    artist_id INT NOT NULL REFERENCES Dim_Artist(artist_sk),
    quantity INT,
    total_amount NUMERIC(10, 2)
);

CREATE TABLE Fact_Reviews (
    review_id INT PRIMARY KEY,
    date_id INT NOT NULL REFERENCES Dim_Date(date_id),
    artwork_id INT NOT NULL REFERENCES Dim_Artwork(artwork_id),
    user_id INT NOT NULL REFERENCES Dim_User(user_id),
    rating INT CHECK (rating BETWEEN 1 AND 5)
);
