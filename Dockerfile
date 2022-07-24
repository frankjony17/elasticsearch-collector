
FROM ubuntu:20.04 as build

# Define build time variables
ARG build_date
ARG vcs_ref
ARG versao=1.0.0-beta.5
ARG BOM_PATH=/docker/fks
ARG ES_TMPDIR=/tmp
ARG DOWNLOAD_URL=https://artifacts.elastic.co/downloads/elasticsearch/
ARG ELASTICSEARCH=elasticsearch-6.7.1.tar.gz
ARG SEARCH_GUARD=search-guard-6-6.7.1-25.5.zip

# Define environment variables that can be used in run time
ENV VERSAO=${versao} MODE=prod \
    PATH="/elasticsearch/bin:$PATH" \
    CLUSTER_NAME="elasticsearch-default" \
    MINIMUM_MASTER_NODES=1 \
    HOSTS="127.0.0.1, [::1]" \
    NODE_NAME=NODE-1 \
    NODE_MASTER=true \
    NODE_DATA=true \
    NODE_INGEST=true \
    HTTP_CORS_ENABLE=true \
    HTTP_CORS_ALLOW_ORIGIN=* \
    NETWORK_HOST="0.0.0.0" \
    ELASTIC_PWD="FkSolutions*2022" \
    KIBANA_PWD="FkSolutions*2022" \
    LOGSTASH_PWD="FkSolutions*2022" \
    BEATS_PWD="FkSolutions*2022" \
    CA_PWD="FkSolutions*2022" \
    TS_PWD="FkSolutions*2022" \
    KS_PWD="FkSolutions*2022" \
	HTTP_SSL=false \
    LOG_LEVEL=INFO \
    SG_ENTERPRISE_ENABLED=false

# Save Bill of Materials to image. Não remova!
COPY README.md Dockerfile ${BOM_PATH}/

RUN apt-get -y update && \
    apt-get -y install --no-install-recommends -y sed openjdk-8-jre ca-certificates util-linux openssl bash rsync wget curl && \
    mkdir /install && cd /install  && \
    wget --quiet "${DOWNLOAD_URL}${ELASTICSEARCH}" -P / && \
    tar -xzvf elasticsearch-6.7.1.tar.gz && \
    mv elasticsearch-6.7.1 /elasticsearch

RUN /elasticsearch/bin/elasticsearch-plugin install -b com.floragunn:search-guard-6:6.7.1-25.5 && \
    rm -rf /search-guard-6-6.7.1-25.5.zip && \
    # Cleanup install
    rm -rf /install && \
    rm /elasticsearch/config/elasticsearch.yml && \
    rm -rf /elasticsearch/modules/x-pack-ml && \
    rm -rf /elasticsearch/modules/x-pack-security && \
    # Copy default config
    mkdir -p /.backup/elasticsearch/

COPY config /.backup/elasticsearch/config
COPY ./src/ /run/

RUN chmod +x -R /run/

RUN echo 'vm.max_map_count=524288' >> /etc/sysctl.conf
RUN cat /etc/sysctl.conf

RUN sysctl -w vm.max_map_count=524288
RUN echo /proc/sys/vm/max_map_count

# Set user
RUN adduser elasticsearch \
  && for path in \
    /elasticsearch/config \
    /elasticsearch/config/scripts \
    /elasticsearch/plugins \
  ; do \
    mkdir -p "$path"; \
    chown -R elasticsearch:elasticsearch "$path"; \
  done

VOLUME /elasticsearch/config
VOLUME /elasticsearch/data

EXPOSE 9200 9300

ENTRYPOINT ["/run/entrypoint.sh"]

CMD ["elasticsearch"]