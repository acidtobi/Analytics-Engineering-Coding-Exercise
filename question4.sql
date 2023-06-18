-- Creates a view with number of installs, costs and total ad revenue per day and campaign
--
-- CTE "users" generates a list of all users with their campaign name, install date and total as revenue
-- CTE "installs" summarizes ad revenue for each campaign and install date
-- The cost for each campaign and day is then joined from the user_acquisition table

CREATE VIEW IF NOT EXISTS marketing AS
    WITH
    users AS (
        SELECT
            user_id,
            tracker_name,
            DATE(MIN(event_timestamp) / 1000000.0, 'unixepoch') AS install_date,
            SUM(ad_revenue) AS total_ad_revenue
        FROM
            events
        GROUP BY
            1,2
    ),
    installs AS (
        SELECT
            install_date AS date,
            tracker_name,
            COUNT(user_id) AS num_installs,
            SUM(total_ad_revenue) AS total_ad_revenue
        FROM
            users
        GROUP BY
            1,2
    )
    SELECT
        installs.date AS date,
        tracker_name,
        num_installs,
        user_acquisition.costs,
        total_ad_revenue
    FROM
        installs
    JOIN
        user_acquisition
    USING (tracker_name, date)