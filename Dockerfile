FROM legionus/altlinux-initroot:x86_64

USER root

ENV EJABBERD_USER=ejabberd \
    EJABBERD_HTTPS=true \
    EJABBERD_STARTTLS=true \
    EJABBERD_S2S_SSL=true \
    EJABBERD_HOME=/var/lib/ejabberd \
    EJABBERD_DEBUG_MODE=true \
    HOME=$EJABBERD_HOME \
    XMPP_DOMAIN=localhost \
    LANG=en_US.UTF-8

RUN \
 apt-get -y update;\
 apt-get -y install ejabberd gosu python-module-jinja2 openssl tzdata;\
 apt-get -y clean;

RUN mkdir $EJABBERD_HOME/ssl \
    && mkdir $EJABBERD_HOME/conf \
    && mkdir $EJABBERD_HOME/backup \
    && mkdir $EJABBERD_HOME/upload \
    && mkdir $EJABBERD_HOME/database

RUN chown -R $EJABBERD_USER $EJABBERD_HOME; \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime;

ADD ./ejabberd.init /sbin/run
ADD ./scripts $EJABBERD_HOME/scripts

# Add config templates
ADD ./conf /etc/ejabberd

USER ejabberd

EXPOSE 4560 5222 5269 5280 5443

# Set workdir to ejabberd root
WORKDIR $EJABBERD_HOME

VOLUME ["$EJABBERD_HOME/database", "$EJABBERD_HOME/ssl", "$EJABBERD_HOME/backup", "$EJABBERD_HOME/upload"]

ENTRYPOINT ["run"]
CMD ["start"]
