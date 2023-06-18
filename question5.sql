-- Calculates the CPI on August 6, 2022, for campaign “google_campaign1” using the "marketing" view
SELECT
    costs / num_installs AS CPI
FROM
    marketing
WHERE
    date = '2022-08-06'
    AND tracker_name = 'google_campaign1'