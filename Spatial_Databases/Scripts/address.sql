CREATE TABLE results_tmax AS
SELECT
    a.id AS id,
    a.longitude AS longitude,
    a.latitude AS latitude,
    b.filedate AS day,
    ROUND(ST_Value(b.rast, ST_Transform(a.geom, 4269))::NUMERIC, 4) AS tmax
FROM
    addresses a
INNER JOIN
    tmax2023 b
    ON ST_Intersects(ST_Envelope(b.rast), ST_Transform(a.geom, 4269))
WHERE
    a.startdate <= b.filedate
    AND a.enddate >= b.filedate;Delete from results_tmax where tmax is NULL;

