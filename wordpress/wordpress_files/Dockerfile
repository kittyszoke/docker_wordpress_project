FROM wordpress:6.0-php8.1

RUN apt update

#Copying updated wp-config file
COPY $PWD/k8s/wp-config.php /var/www/html/wp-config.php
#RDS Endpoint
ENV WORDPRESS_DB_HOST: '<rds_endpoint>'
ENV WORDPRESS_DB_USER: '<username>'
ENV WORDPRESS_DB_PASSWORD: '<password>'
ENV WORDPRESS_DB_NAME: '<dbname>'


      
      
      