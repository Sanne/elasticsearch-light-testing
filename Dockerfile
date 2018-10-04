FROM fedora:28
LABEL maintainer "Sanne Grinovero <sanne.grinovero@gmail.com>"

ENV ES_VERSION=6.4.2

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
	tar zxf elasticsearch-${ES_VERSION}.tar.gz -C /opt/elasticsearch --strip-components=1 && \
	rm /opt/elasticsearch/bin/*.bat /opt/elasticsearch/bin/*.exe \
	rm -Rf /opt/elasticsearch/modules/lang-mustache /opt/elasticsearch/modules/lang-groovy /opt/elasticsearch/modules/lang-expression /opt/elasticsearch/modules/transport-netty3 \
	rm -f elasticsearch-${ES_VERSION}.tar.gz && \
	useradd elasticsearch && \
	mkdir -p /opt/elasticsearch/volatile/data /opt/elasticsearch/volatile/logs && \
	chown -R elasticsearch:elasticsearch /opt/elasticsearch

COPY log4j2.properties /opt/elasticsearch/config/
COPY elasticsearch.yml /opt/elasticsearch/config/
COPY jvm.options-override /opt/elasticsearch/config/
RUN cd /opt/elasticsearch/config/ && cat jvm.options-override >> jvm.options && rm jvm.options-override

ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk

USER elasticsearch

WORKDIR /opt/elasticsearch

CMD ["/bin/bash", "bin/elasticsearch"]

EXPOSE 9200 9300

