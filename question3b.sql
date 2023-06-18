-- Calculates the number of installs on 2022-08-02 in Germany on Android
--
-- The CTE "installs" looks at the first event for each user to derive the install date, the install country
-- and the install os.
-- The CTE "cohort_users" selects the list of users which installed the app on 2022-08-02 in Germany on Android.
-- We then calculate the number of days since 2022-08-02 for each event and count the number of users who have been
-- active on that day and are in the list of users returned by "cohort_users".

WITH
installs as (
    SELECT
        DISTINCT user_id,
        FIRST_VALUE(DATE(event_timestamp / 1000000.0, 'unixepoch')) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS install_date,
        FIRST_VALUE(os) over (PARTITION BY user_id ORDER BY event_timestamp) AS install_os,
        FIRST_VALUE(country) over (PARTITION BY user_id ORDER BY event_timestamp) AS install_country
    FROM
        events
),
cohort_users AS (
    SELECT
        user_id
    FROM
        installs
    WHERE
        install_date = '2022-08-02'
        and install_os = 'Android'
        and install_country = 'Germany'
)
SELECT
    JULIANDAY(DATE(event_timestamp / 1000000.0, 'unixepoch')) - JULIANDAY(DATE('2022-08-02')) AS days_since_install,
    COUNT(distinct user_id)
FROM
    events
WHERE
    user_id IN (SELECT user_id FROM cohort_users)
GROUP BY
    1