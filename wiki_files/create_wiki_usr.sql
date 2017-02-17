CREATE DATABASE wiki;

CREATE USER 'wiki_admin'@'localhost' IDENTIFIED BY '1234PASS';
GRANT ALL PRIVILEGES on wiki.* to 'wiki_admin'@'localhost' WITH GRANT OPTION;

CREATE USER 'wiki_admin'@'%' IDENTIFIED BY '1234PASS';
GRANT ALL PRIVILEGES on wiki.* to 'wiki_admin'@'%' WITH GRANT OPTION;

