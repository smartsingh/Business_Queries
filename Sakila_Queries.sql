USE sakila;
-- 1A
SELECT first_name, last_name FROM actor;

-- 1B
SELECT concat(first_name, " ",last_name) AS "Actor Name" FROM actor;

-- 2A
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "Joe";

-- 2B
SELECT first_name, last_name FROM actor
WHERE last_name LIKE "%GEN%";

-- 2C
SELECT first_name, last_name FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

-- 2D
SELECT country_id, country FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China")
;

-- 3A
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3B
ALTER TABLE actor
DROP COLUMN description;

-- 4A
SELECT last_name, COUNT(last_name) AS "Number of Matches" FROM actor
GROUP BY last_name;

-- 4B
SELECT last_name, COUNT(last_name) AS "Number of Matches"FROM actor
GROUP BY last_name 
HAVING COUNT(last_name) >=2;

-- 4C
UPDATE  actor
SET first_name = "Harpo"
WHERE 
(first_name = "Groucho" AND last_name = "Williams") ;

-- 4D
UPDATE  actor
SET first_name = "Groucho"
WHERE first_name = "Harpo";

-- 5A
SHOW CREATE TABLE address;

CREATE TABLE IF NOT EXISTS address(
	address_id SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50) DEFAULT NULL,
    district VARCHAR(20) NOT NULL,
    city_id SMALLINT(5) UNSIGNED NOT NULL,
    postal_code VARCHAR(10) DEFAULT NULL,
    phone VARCHAR(20) NOT NULL,
    location GEOMETRY NOT NULL,
    last_update TIMESTAMP NOT NULL,
    PRIMARY KEY(address_id),
    FOREIGN KEY(city_id) REFERENCES city (city_id)
)
;

-- 6A
SELECT staff.first_name, staff.last_name, address.address FROM staff
JOIN address ON address.address_id = staff.address_id;

-- 6B
SELECT payment.staff_id, staff.first_name, staff.last_name, SUM(amount) AS "Total Revenue" FROM payment
INNER JOIN staff ON staff.staff_id = payment.staff_id
WHERE MONTH(payment_date) = 8
GROUP BY payment.staff_id
;

-- 6C
SELECT title, COUNT(actor_id) AS "Number of Actors" FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY title
;

-- 6D
SELECT title, COUNT(inventory.film_id) AS "Number of Copies" FROM inventory
JOIN film ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible";

-- 6E
SELECT first_name, last_name, SUM(amount) AS "Total Amount Paid" FROM customer
JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY last_name;

-- 7A
SELECT title FROM(
	SELECT film.title, film.language_id FROM film
		WHERE (title LIKE "Q%") OR (title LIKE "K%")
	) as f
WHERE f.language_id = "1";

-- 7B
SELECT first_name, last_name FROM actor
WHERE actor_id IN 
(
		SELECT actor_id FROM film_actor
		WHERE film_id = 
        (
				SELECT film_id FROM film
				WHERE title = "Alone Trip"
		)
)
;

-- 7C
SELECT * FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
WHERE country = "Canada"
;

-- 7D
SELECT title FROM film
WHERE film_id IN
(
		SELECT film_category.film_id FROM category
		JOIN film_category ON category.category_id = film_category.category_id
		WHERE category.name = "Family"
)
;

-- 7E
SELECT film.title, COUNT(rental_id) AS "Number of Rentals" FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY rental.inventory_id
ORDER BY COUNT(rental_id) DESC;

-- 7F
SELECT store.store_id, CONCAT('$', FORMAT(SUM(amount), 2)) AS Revenue FROM payment
JOIN staff ON payment.staff_id = staff.staff_id
JOIN store ON staff.store_id = store.store_id
GROUP BY payment.staff_id;

-- 7G
SELECT store.store_id, city.city, country.country FROM store
JOIN address on store.address_id = address.address_id
JOIN city on address.city_id = city.city_id
JOIN country on city.country_id = country.country_id
;

-- 7H
SELECT category.name, CONCAT('$', FORMAT(SUM(payment.amount), 2)) AS Revenue FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5
;

-- 8A
CREATE VIEW top_five_genres AS
(
SELECT category.name, CONCAT('$', FORMAT(SUM(payment.amount), 2)) AS Revenue FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5
)
;

-- 8B
SELECT * FROM top_five_genres;

-- 8C
DROP VIEW top_five_genres;
