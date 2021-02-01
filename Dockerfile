FROM php:7.4-apache

# Install prerequisities for getMD script
RUN apt-get update && \
    apt-get install -y libappconfig-perl libproc-processtable-perl perlmagick libjson-perl sqlite3 xsltproc xmlsec1 optipng libtext-iconv-perl && \
    apt-get clean

# Download metadata
COPY ./scripts/ /opt/getMD/
COPY ./doc/getMDrc.dist /opt/getMD/etc/getMDrc
RUN mkdir /opt/getMD/var
RUN /opt/getMD/bin/getMD.pl

# Install prerequisites for DS/WAYF application
RUN apt-get update && \
    apt-get install -y libicu-dev && \
    docker-php-ext-install intl && \
    apt-get remove -y libicu-dev && \
    apt-get autoremove -y && \
    apt-get clean

# Install DS/WAYF application
COPY ./ /opt/wayf/
COPY ./ /var/www/html/
RUN mkdir /var/www/html/feed/ && \
    cp /opt/getMD/var/pub/current/feed/* /var/www/html/feed/ && \
    cp /opt/getMD/var/pub/current/logo/* /var/www/html/logo/ && \
    chown -R www-data:www-data /var/www/html