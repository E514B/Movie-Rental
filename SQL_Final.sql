/*Query 1- Query used for the first insight*/
SELECT
    category_name,
    SUM(count_name)
FROM (
    SELECT
        f.title film_title,
        c.name category_name,
        COUNT(c.name) count_name
    FROM
        category c
        JOIN film_category fc ON c.category_id = fc.category_id
        JOIN film f ON f.film_id = fc.film_id
    GROUP BY
        1,
        2
    ORDER BY
        3) AS t1
GROUP BY
    1;

/*Query 2-Query used for the second insight*/
SELECT
    film_title,
    category_name,
    rental_count,
    row_num
FROM (
    SELECT
        film_title,
        category_name,
        rental_count,
        ROW_NUMBER()
        OVER (PARTITION BY
                category_name
            ORDER BY
                category_name) AS row_num
        FROM (
            SELECT
                f.title film_title,
                c.name category_name,
                COUNT(r.rental_date) rental_count
            FROM
                category c
                JOIN film_category fc ON c.category_id = fc.category_id
                JOIN film f ON fc.film_id = f.film_id
                JOIN inventory i ON f.film_id = i.film_id
                JOIN rental r ON i.inventory_id = r.inventory_id
            WHERE
                c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
            GROUP BY
                1,
                2
            ORDER BY
                2,
                3 DESC) sub) sub_2
    WHERE
        row_num <= 10;

/*Query 3-Query used for the third insight*/
SELECT
    standard_quartile,
    AVG(rental_duration) avg_rental_length
FROM (
    SELECT
        f.title film_title,
        c.name,
        f.rental_duration,
        NTILE(4)
        OVER (
        ORDER BY
            f.rental_duration) AS standard_quartile
    FROM
        category c
        JOIN film_category fc ON c.category_id = fc.category_id
        JOIN film f ON fc.film_id = f.film_id
    WHERE
        c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) sub
GROUP BY
    1
ORDER BY
    1;

/*Query 4-Query used for the fourth insight*/
SELECT
    rental_length_cat,
    COUNT(*)
FROM (
    SELECT
        f.title film_title,
        c.name,
        f.rental_duration,
        CASE WHEN f.rental_duration > 6 THEN
            '7_nights'
            WHEN f.rental_duration > 5 THEN
            '6_nights'
            WHEN f.rental_duration > 4 THEN
            '5_nights'
            WHEN f.rental_duration > 3 THEN
            '4_nights'
        ELSE
            '3_nights'
        END AS rental_length_cat
    FROM
        category c
        JOIN film_category fc ON c.category_id = fc.category_id
        JOIN film f ON fc.film_id = f.film_id
    WHERE
        c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) sub
GROUP BY
    1
ORDER BY
    1;
