FROM ubuntu:focal

MAINTAINER G00fts goofts@icloud.com

USER root

EXPOSE 80
EXPOSE 443

WORKDIR /root

COPY humlib /humlib
COPY humlog /humlog
COPY humsys /humsys

ENV CONFIG_NAME='hub'
ENV CONFIG='cp -rf /humsys/supervisord.d/"$i".ini /etc/supervisor/conf.d/"$i".ini'

RUN bash /humsys/provision --help

RUN echo "$CONFIG_NAME"|awk '{for(i=1;i<=NF;i++){print "'"$CONFIG"'"|"/bin/bash";}}' && \
    rm -rf /humsys/supervisord.d /humsys/nginx.d /humlib/config.d /humlib/*.sh

CMD ["/bin/bash", "-c", "/bin/bash /humsys/provision"]
