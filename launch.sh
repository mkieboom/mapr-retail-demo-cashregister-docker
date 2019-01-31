#!/bin/bash

# Launch php & nginx
#nginx -g 'daemon off;'
nginx

# Write Drill REST call to json

# Get connected Wifi Clients into: /connected_devices.json
curl -X POST -H "Content-Type: application/json" -d '{"queryType":"SQL", "query": "select t.datetime, t.mac as client_mac,t.sensor as sensor_name,t.signal as signal_strength from dfs.root.`/mapr-retail-demo/sensors-connecteddevices-db` t where t.datetime in (select t.datetime from dfs.root.`/mapr-retail-demo/sensors-connecteddevices-db` t group by t.datetime order by t.datetime desc limit 1)"}' http://$MAPR_IP:8047/query.json > /connected_devices.json

# html header with auto-refresh
cat <<EOF > /usr/share/nginx/html/index.html
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
cat /connected_devices.json | jq -r '["<tr><th>Date Time</th><th>Client MAC</th><th>Signal strength</th></tr><tr><td>"], (.rows[]|[.datetime,.client_mac,.signal_strength])|@tsv' >> /usr/share/nginx/html/index.html

# html footer
cat <<EOF >> /usr/share/nginx/html/index.html
      </tr>
    </table>
  </body>
</html>
EOF

# Fix the html table layout
sed -i -e 's/\t/<\/td><td>/g' /usr/share/nginx/html/index.html

