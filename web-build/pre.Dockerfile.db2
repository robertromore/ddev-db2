#ddev-generated
ARG odbc_version=2.3.7

ENV IBM_DB_HOME="/opt/ibm/clidriver"
ENV LD_LIBRARY_PATH="${IBM_DB_HOME}/lib"
ENV PATH="${PATH}:/opt/ibm/clidriver"
RUN (apt-get update || true) && DEBIAN_FRONTEND=noninteractive apt-get install -y -o Dpkg::Options::="--force-confold" --no-install-recommends --no-install-suggests apt-utils curl gnupg2 ca-certificates

RUN curl -sSL -O https://packages.microsoft.com/keys/microsoft.asc
RUN apt-key add <microsoft.asc
RUN curl -sSL -o /etc/apt/sources.list.d/mssql-release.list https://packages.microsoft.com/config/debian/11/prod.list

RUN (apt-get update || true) && DEBIAN_FRONTEND=noninteractive apt-get install -y -o Dpkg::Options::="--force-confold" --no-install-recommends --no-install-suggests \
    build-essential \
    dialog \
    php-pear \
    php$DDEV_PHP_VERSION-dev \
    unixodbc=$odbc_version \
    odbcinst=$odbc_version \
    odbcinst1debian2=$odbc_version \
    unixodbc-dev=$odbc_version \
    locales

# Change the PHP version to what you want. It is currently set to version 8.0.
RUN pecl channel-update pecl.php.net
RUN pecl -d php_suffix=$DDEV_PHP_VERSION install ibm_db2

RUN echo 'extension=ibm_db2.so' >> /etc/php/$DDEV_PHP_VERSION/mods-available/ibm_db2.ini

RUN phpenmod -v $DDEV_PHP_VERSION ibm_db2
# Something about this install has set /run/php to 755, so php-fpm can't write pidfile
RUN chmod 777 /run/php
