sudo apt-get update
sudo apt-get -y install apache2
sudo apt-get install -y php5 libapache2-mod-php5
sudo /etc/init.d/apache2 restart
sudo rm /var/www/index.html
sudo su
echo '<?php header("Content-Type: text/plain");echo "Server IP: ".$_SERVER["SERVER_ADDR"];echo "\nClient IP: ".$_SERVER["REMOTE_ADDR"];echo "\nX-Forwarded-for: ".$_SERVER["HTTP_X_FORWARDED_FOR"];?>' > /var/www/index.php
