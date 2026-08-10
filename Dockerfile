FROM debian:12-slim

ARG KAMAILIO_VERSION=5.6

ENV DEBIAN_FRONTEND=noninteractive
ENV KAMAILIO_VERSION=${KAMAILIO_VERSION}

# --------------------------------------------------
# Install build dependencies
# --------------------------------------------------
RUN apt-get update && apt-get install -y \
    git \
    git-core \
    gcc \
    g++ \
    flex \
    bison \
    make \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libpcre2-dev \
    libpq-dev \
    postgresql-client \
    ca-certificates \
    iproute2 \
    net-tools \
    curl \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# Download Kamailio source
# --------------------------------------------------
WORKDIR /usr/local/src

RUN git clone \
    --depth 1 \
    --branch ${KAMAILIO_VERSION} \
    https://github.com/kamailio/kamailio.git \
    kamailio-${KAMAILIO_VERSION}

WORKDIR /usr/local/src/kamailio-${KAMAILIO_VERSION}

# --------------------------------------------------
# Enable required modules
# --------------------------------------------------
RUN make cfg

# Enable PostgreSQL module
RUN make include_modules="db_postgres" cfg
# --------------------------------------------------
# Compile Kamailio
# --------------------------------------------------
RUN make -j"$(nproc)"

RUN make install

# --------------------------------------------------
# Runtime directories
# --------------------------------------------------
RUN mkdir -p \
    /usr/local/etc/kamailio \
    /var/run/kamailio \
    /var/log/kamailio

# --------------------------------------------------
# Copy configuration
# --------------------------------------------------
COPY ./config/ /usr/local/etc/kamailio/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# --------------------------------------------------
# Kamailio SIP ports
# --------------------------------------------------
EXPOSE 5060/udp
EXPOSE 5060/tcp

ENTRYPOINT ["/entrypoint.sh"]
