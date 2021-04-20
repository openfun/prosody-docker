FROM debian:10

ARG JITSI_PROSODY_PLUGINS_VERSION=stable/jitsi-meet_5390

# Upgrade system packages to install security updates and install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      curl \
      wget \
      gettext-base \
      gpg \
      lua5.2 \
      liblua5.2-dev \
      libsasl2-dev \
      libssl1.1 \
      libssl-dev \
      luarocks \
      lua-event && \
    luarocks install basexx 0.4.1-1 && \
    luarocks install luajwtjitsi 2.0-0 && \
    rm -rf /var/lib/apt/lists/*

# Install prosody
RUN wget -q https://prosody.im/files/prosody-debian-packages.key -O - | gpg --enarmor > /etc/apt/trusted.gpg.d/prosody.asc \
    && echo "deb http://packages.prosody.im/debian buster main" > /etc/apt/sources.list.d/prosody.list \
    && apt-get update \
    && apt-get install -y \
      prosody && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /etc/prosody/conf.d && \
    chown -R prosody. /etc/prosody
      
# Install prosody modules
RUN mkdir -p /usr/share/prosody/modules && \
    cd /tmp && \
    mkdir jitsi-meet && \
    curl -sLo jitsi-meet.tgz https://github.com/jitsi/jitsi-meet/archive/refs/tags/${JITSI_PROSODY_PLUGINS_VERSION}.tar.gz && \
    tar xzf jitsi-meet.tgz -C jitsi-meet --strip-components 1 && \
    cp -r ./jitsi-meet/resources/prosody-plugins/* /usr/share/prosody/modules && \
    curl -so /usr/share/prosody/modules/mod_token_affiliation.lua https://raw.githubusercontent.com/emrahcom/emrah-buster-templates/6ae86bbff1459b669b311f3ec00946921cd683c9/machines/eb-jitsi/usr/share/jitsi-meet/prosody-plugins/mod_token_affiliation.lua && \
    rm -rf jitsi-meet.tgz jitsi-meet && \
    chown -R prosody. /usr/share/prosody/modules

COPY --chown=prosody:prosody files/etc/prosody/prosody.cfg.lua /etc/prosody/prosody.cfg.lua

VOLUME [ "/etc/prosody" ]
USER prosody

EXPOSE 5222 5347 5280

CMD ["prosody", "-F"]
