
SELECT
  ro.date,
  s.first_name,
  s.last_name,
  s.hourly_rate,
  sh.start_time,
  sh.end_time,
  ((HOUR(TIMEDIFF(sh.end_time, sh.start_time)) * 60) + (MINUTE(TIMEDIFF(sh.end_time, sh.start_time)))) / 60 AS hours_in_shift,
  ((HOUR(TIMEDIFF(sh.end_time, sh.start_time)) * 60) + (MINUTE(TIMEDIFF(sh.end_time, sh.start_time)))) / 60 * s.hourly_rate AS staff_cost
FROM Rota ro
LEFT JOIN staff s ON ro.staff_id = s.staff_id
LEFT JOIN shift sh ON ro.shift_id = sh.shift_id;
