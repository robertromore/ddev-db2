#ddev-generated

RUN (apt-get update || true) && DEBIAN_FRONTEND=noninteractive apt-get install -y -o Dpkg::Options::="--force-confold" --no-install-recommends --no-install-suggests apt-utils curl gnupg2 ca-certificates

RUN curl https://public.dhe.ibm.com/software/ibmi/products/odbc/debs/dists/1.1.0/ibmi-acs-1.1.0.list | sudo tee /etc/apt/sources.list.d/ibmi-acs-1.1.0.list

RUN (apt-get update || true) && DEBIAN_FRONTEND=noninteractive apt-get install -y -o Dpkg::Options::="--force-confold" --no-install-recommends --no-install-suggests \
    build-essential \
    dialog \
    php-pear \
    php$DDEV_PHP_VERSION-dev \
    unixodbc \
    odbcinst \
    odbcinst1debian2 \
    unixodbc-dev \
    locales

RUN apt-get install -y ibm-iaccess
