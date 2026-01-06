# https://github.com/instructure/canvas-self-hosted
# https://docs.google.com/document/d/1Y9TymZmUOlnr351IQmWslN_TZ_DI-zYBNLZ5y8vWPO8/edit?tab=t.0

FROM ubuntu:20.04 AS ubuntu-base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
    && apt-get  install -y curl \
    dirmngr gnupg2 build-essential software-properties-common autoconf lsb-release automake bison  \
    libtool libssl-dev git-core zlib1g-dev libreadline-dev libyaml-dev \
    libsqlite3-dev sqlite3 \
    libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev \
    libldap2-dev libidn11-dev libgdbm-dev libgmp-dev libncurses-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM ubuntu-base AS ruby-base

RUN add-apt-repository ppa:brightbox/ruby-ng
RUN apt-get update -y \
    && apt-get install -y ruby2.7 ruby2.7-dev zlib1g-dev libxml2-dev \
    libsqlite3-dev libpq-dev \
    libxmlsec1-dev curl make g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ruby -v

FROM ruby-base AS python-interpreter

RUN apt-get update -y && apt-get install -y python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM python-interpreter AS nodejs-interpreter

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

RUN apt-get update -y && apt-get install -y nodejs  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN node -v

RUN npm -v

RUN npm install --global yarn

RUN yarn -v

FROM nodejs-interpreter AS canvas-base

RUN apt-get update -y && apt-get install -y libldap2-dev libidn11-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.4.2

FROM canvas-base AS passenger-base

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
    && sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger focal main > /etc/apt/sources.list.d/passenger.list' \
    && apt-get update -y \
    && apt-get install -y dirmngr gnupg apt-transport-https ca-certificates passenger \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM passenger-base AS apache-base

RUN apt-get update -y \
    && apt-get install -y apache2 libapache2-mod-passenger libapache2-mod-xsendfile \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

# Apache will be started via entrypoint/CMD, not during build

FROM apache-base AS canvas-runtime

# Install useful tools
RUN apt-get update -y \
    && apt-get install -y vim htop git less nano net-tools postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create canvas user
RUN useradd --create-home --shell /bin/bash --comment "Canvas LMS User" canvasuser

# Create canvas directory structure
RUN mkdir -p /var/canvas/log \
    /var/canvas/tmp/pids \
    /var/canvas/public/assets \
    /var/canvas/app/stylesheets/brandable_css_brands

# Set working directory
WORKDIR /var/canvas
