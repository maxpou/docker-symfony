FROM sebp/elk

RUN apt-get update && apt-get install -y \
    geoip-database \
    python-geoip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${LOGSTASH_HOME}
RUN gosu logstash bin/logstash-plugin install logstash-input-jdbc
