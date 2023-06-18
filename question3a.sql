-- Calculates the number of installs on 2022-08-02 in Germany on Android
--
-- The CTE "installs" looks at the first event for each user to derive the install date, the install country
-- and the install os.

WITH
installs as (
    SELECT
        DISTINCT user_id,
        FIRST_VALUE(DATE(event_timestamp / 1000000.0, 'unixepoch')) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS install_date,
        FIRST_VALUE(os) over (PARTITION BY user_id ORDER BY event_timestamp) as install_os,
        FIRST_VALUE(country) over (PARTITION BY user_id ORDER BY event_timestamp) as install_country
    FROM
        events
)
SELECT
    COUNT(*)
FROM
    installs
WHERE
    install_date = '2022-08-02'
    and install_os = 'Android'
    and install_country = 'Germany'