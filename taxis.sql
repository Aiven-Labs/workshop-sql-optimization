
-- correlation between distance, area and tips

SELECT
    tz_borough.Borough AS pickup_borough,
    AVG(tt.Trip_distance) AS avg_trip_distance,
    AVG(tt.Tip_amount) AS avg_tip_amount,
    AVG(CASE WHEN tt.Trip_distance > 0 THEN tt.Tip_amount / tt.Trip_distance ELSE NULL END) AS avg_tip_per_mile
FROM
    taxi_trips tt
JOIN
    taxi_zones tz_pickup
    ON tz_pickup.LocationID = tt.PULocationID
JOIN
    taxi_zones tz_dropoff
    ON tz_dropoff.LocationID = tt.DOLocationID
JOIN
    taxi_zones tz_borough
    ON tz_borough.LocationID = tt.PULocationID
GROUP BY
    tz_borough.Borough;

-- getting  average total amount spent on taxi trips for some specific conditions

SELECT
    src_taxi_zone.zone AS src,
    dest_taxi_zone.zone AS dest,
    AVG(total_amount) AS avg_total_amount
FROM
    taxi_trips
JOIN
    taxi_zones src_taxi_zone
    ON src_taxi_zone.LocationID = taxi_trips.PULocationID
JOIN
    taxi_zones dest_taxi_zone
    ON dest_taxi_zone.LocationID = taxi_trips.DOLocationID
WHERE
    src_taxi_zone.zone IN
        (SELECT zone FROM taxi_zones WHERE Borough IN ('Queens', 'Manhattan'))
    AND payment_type = 2
    AND DATE(tpep_pickup_datetime) = '2019-01-01'
GROUP BY
    src_taxi_zone.zone, dest_taxi_zone.zone;

-- taxi trips where either the fare amount is exactly $100 or the tip amount exceeds $600.
SELECT
  tpep_pickup_datetime
FROM
  taxi_trips
WHERE
  fare_amount = 187
  OR tip_amount > 500
ORDER BY
  tip_amount desc LIMIT 100;