FROM openjdk:8-jre-alpine

ARG kafka_version=2.2.1
ARG scala_version=2.12

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/opt/kafka 

ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY start-kafka.sh broker-list.sh create-topics.sh /tmp/

RUN apk add --update docker jq coreutils \
 && chmod a+x /tmp/*.sh \
 && mkdir /opt \
 && mv /tmp/start-kafka.sh /tmp/broker-list.sh /tmp/create-topics.sh /usr/bin \
 && sync \

 && wget -q "https://www.apache.org/dyn/closer.cgi?path=/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
 && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
 && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
 && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka \
 && rm -rf /tmp/*

VOLUME ["/kafka"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]