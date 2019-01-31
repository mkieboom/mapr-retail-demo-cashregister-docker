# mapr-retail-demo-cashregister-docker
#
# VERSION 0.1 - not for production, use at own risk
#

#
FROM centos

MAINTAINER mkieboom @mapr.com

# Install Drill
#RUN yum install -y mapr-drill

# Install Nginx, jq
RUN yum install -y epel-release && \
  yum install -y nginx jq


# Add the nginx.conf file to the container
# This config file has following pre-configured:
# - enabled php
# - enabled index.php file: index.html index.htm index.php;
# - allow directory browsing: autoindex on;
COPY nginx.conf /etc/nginx/nginx.conf

# Add the launch script which checks if the /mapr mountpoint is available in the container
COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

# Add the sql scripts
ADD drill_scripts/ /drill_scripts/

EXPOSE 80

# Launch nginx
CMD /launch.sh