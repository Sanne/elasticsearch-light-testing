FROM fedora:25
LABEL maintainer "Sanne Grinovero <sanne.grinovero@gmail.com>"

ENV ES_VERSION=5.5.0

USER root

# Update system and install JDK
RUN \
	dnf update -y && \
	dnf install -y java-1.8.0-openjdk-headless && \
	dnf clean all

# Download and install Elasticsearch
RUN \
	mkdir -p /opt/elasticsearch && \
	cd /opt/elasticsearch && \
	curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION.tar.gz && \
	tar zxvf elasticsearch-${ES_VERSION}.tar.gz -C /opt/elasticsearch --strip-components=1 && \
	rm -f elasticsearch-${ES_VERSION}.tar.gz && \
	useradd elasticsearch && \
	mkdir -p /opt/elasticsearch/volatile/data /opt/elasticsearch/volatile/logs && \
	chown -R elasticsearch:elasticsearch /opt/elasticsearch

COPY log4j2.properties /opt/elasticsearch/config/
COPY elasticsearch.yml /opt/elasticsearch/config/
COPY jvm.options /opt/elasticsearch/config/

ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk

USER elasticsearch

WORKDIR /opt/elasticsearch

CMD ["/bin/bash", "bin/elasticsearch"]

EXPOSE 9200 9300

