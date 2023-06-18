-- Calculates the number of installs per country
--
-- The install event simply is the first event of a particular user, and the country the user installed
-- the app in therefore is the country of this first event.
-- We cannot simply count the number of distinct users per country in the events table because this would 
-- count installs multiple times if a user has events (after the install event) from other countries as well.

SELECT
    install_country,
    COUNT(user_id)
FROM (
    SELECT
        distinct user_id,
        FIRST_VALUE(country) over (PARTITION BY user_id ORDER BY event_timestamp) as install_country
    FROM
        events
    )
GROUP BY
    1