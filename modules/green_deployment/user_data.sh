#!/bin/bash
yum -y update
yum -y install httpd

myip=$(curl -s https://api.ipify.org)

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="grey">
<h2>
<font color="gold">Build by Power of Terraform </font><font color="red"> v1.3.6</font>
<br>
<font color="green">Server PrivateIP: <font color="aqua">$myip</font></font>
<br>
<font color="magenta"><b>Version 0.2.0</b></font>
</h2>
</body>
</html>
EOF

sudo service httpd start
chkconfig httpd on