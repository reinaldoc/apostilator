# mysql -p
> CREATE DATABASE novoportal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
> CREATE USER 'novoportal'@'localhost' IDENTIFIED BY 'top-secret';
> GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, CREATE, DROP, INDEX, LOCK TABLES, REFERENCES ON novoportal.* TO 'novoportal'@'localhost';
> QUIT;
