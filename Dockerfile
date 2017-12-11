FROM fedora:27
LABEL maintainer "Sanne Grinovero <sanne.grinovero@gmail.com>"

ENV ES_VERSION=5.6.5

USER root

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
COPY jvm.options /opt/elasticsearch/config/

# Update system and install JDK
# (After Elasticsearch download so to enable better cache reuse)
RUN \
	dnf update -y && \
	dnf install -y java-9-openjdk-headless && \
	dnf clean all

ENV JAVA_HOME /usr/lib/jvm/java-9-openjdk

USER elasticsearch

WORKDIR /opt/elasticsearch

CMD ["/bin/bash", "bin/elasticsearch"]

EXPOSE 9200 9300

