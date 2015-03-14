#!/usr/bin/env bash

echo 'Installing Latest Ruby!'
sudo apt-get update
sudo rm /usr/bin/ruby
sudo apt-get -y install ruby1.9.1
sudo apt-get -y install ruby1.9.1-dev
sudo apt-get -y install build-essential
sudo ln -s /usr/bin/ruby1.9.1 /usr/bin/ruby
cd /opt
echo 'Downloading RubyGems'
wget -q http://production.cf.rubygems.org/rubygems/rubygems-2.4.6.tgz
echo 'Downloading done, Extracting'
tar -xvzf rubygems-2.4.6.tgz
cd rubygems-2.4.6
sudo ruby setup.rb
echo 'Installing Mysql5'
sudo apt-get -y install mysql-server
sudo apt-get -y install libmysql-ruby libmysqlclient-dev
echo 'Downloading Redmine'
cd /opt
wget -q http://www.redmine.org/releases/redmine-3.0.0.tar.gz
echo 'Downloading done, Extracting'
tar -zxvf redmine-3.0.0.tar.gz
sudo mv redmine-3.0.0 redmine
cd /opt/
cat <<EOF > /opt/create_db.sql
CREATE DATABASE redmine CHARACTER SET utf8;
CREATE USER 'redmine'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'localhost';
EOF
echo 'Creating DB'
sudo mysql mysql <  /opt/create_db.sql
echo 'Done!'
cd /opt/redmine
cat <<EOF > /opt/redmine/config/database.yml
production:
  adapter: mysql2
  database: redmine
  host: localhost
  username: redmine
  password: password
EOF
echo 'Install bundler and Mysql Extensions..'
sudo apt-get -y install mysql-client libmysqlclient-dev
sudo gem install bundler
sudo gem install mysql2
sudo apt-get -y install libapache2-mod-fastcgi libfcgi-ruby1.9.1
sudo apt-get -y install libmysql-ruby libopenssl-ruby1.9.1
echo 'done!'
cd /opt/redmine
echo 'Install Gems - Will take a while!'
sudo bundle install --without development test rmagick --jobs 9
echo 'Configuring Redmine!'
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake redmine:load_default_data
sudo mkdir -p tmp tmp/pdf public/plugin_assets
sudo chmod -R 755 files log tmp public/plugin_asset

echo 'Installing phusion passenger'
sudo apt-get -y install libcurl4-openssl-dev apache2-threaded-dev libapr1-dev libaprutil1-dev
sudo apt-get -y remove nginx nginx-full nginx-light nginx-naxsi nginx-common
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
sudo echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger precise main' > /etc/apt/sources.list.d/passenger.list
sudo apt-get update
sudo apt-get install nginx-extras passenger
sudo passenger-install-nginx-module
