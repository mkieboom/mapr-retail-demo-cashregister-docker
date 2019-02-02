#!/bin/bash

# Launch php & nginx
#nginx -g 'daemon off;'
nginx

# Write Drill REST call to json

while true
do

# Get connected Wifi Clients into: /connected_devices.json
curl -X POST -H "Content-Type: application/json" -d '{"queryType":"SQL", "query": "select t.datetime, t.mac as client_mac,t.sensor as sensor_name,t.signal as signal_strength from dfs.root.`/mapr-retail-demo/sensors-connecteddevices-db` t where t.datetime in (select t.datetime from dfs.root.`/mapr-retail-demo/sensors-connecteddevices-db` t group by t.datetime order by t.datetime desc limit 1) order by  t.signal ASC"}' http://$MAPR_IP:8047/query.json > /connected_devices.json

# Convert connected wifi client list into html
cat /connected_devices.json | jq -r '["Date Time,Client MAC,Signal strength"], (.rows[]|[.datetime,.client_mac,.signal_strength])|@tsv' > /connected_devices.html
sed -i -e 's/,/<\/td><td>/g' /connected_devices.html
sed -i -e 's/\t/<\/td><td>/g' /connected_devices.html
sed -i -e 's/^/<tr><td>/' /connected_devices.html
sed -i -e 's/$/<\/td><\/tr>/g' /connected_devices.html

# html header with auto-refresh
cat <<EOF > /index.html
<html>
  <head>
    <title>Cash Register - Shop Status</title>
    <meta http-equiv="refresh" content="1">
  </head>
  <body>
  <h3>Devices in store:</h3>
    <table border="1">
EOF

# connected devices
cat /connected_devices.html >> /index.html
#cat /connected_devices.json | jq -r '["<tr><th>Date Time</th><th>Client MAC</th><th>Signal strength</th></tr><tr><td>"], (.rows[]|[.datetime,.client_mac,.signal_strength])|@tsv' >> /usr/share/nginx/html/index.html

# html footer
cat <<EOF >> /index.html
      </tr>
    </table>
  </body>
</html>
EOF

/bin/cp -rf /index.html /usr/share/nginx/html/index.html

done
