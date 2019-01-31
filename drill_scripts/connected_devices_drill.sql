select t.datetime,
       t.mac as client_mac,
       t.sensor as sensor_name, 
       t.signal as signal_strength
from dfs.root.`/mapr-retail-demo/sensors-connecteddevices-db` t
where t.datetime in (
  select t.datetime
  from dfs.root.`/mapr-retail-demo/sensors-connecteddevices-db` t
  group by t.datetime
  order by t.datetime desc
  limit 1
)