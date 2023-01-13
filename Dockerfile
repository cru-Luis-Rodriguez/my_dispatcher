FROM centos:7
ARG MODULE_URL
ENV PUBLISH_DOCROOT=/mnt/var/www/html
ENV APACHE_USER=apache
#ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV DOCROOT=/mnt/var/www/html
ENV APACHE_RUN_DIR=/run/apache2
ENV IMAGE_REVISION=95cc9b860ac63fe90a8e3fff471861612791b7dc
ENV SHLVL=2
ENV TERM=xterm
ENV APACHE_PREFIX=/etc/httpd
ENV IMAGE_NAME=aem-ethos/dispatcher-publish:2.0.90
ENV APACHE_DOCROOT=/mnt/var/www/html
ENV HOME=/root
ENV DISPATCHER_REVISION=224f18889e1103ff25c57a3d4c583e3e88f89ecb
ENV POD_NAME="dummypodname"
ENV EXPIRATION_TIME="300"
ENV DISP_LOG_LEVEL="Debug"
ENV REWRITE_LOG_LEVEL="Debug"
ENV FORWARDED_HOST_SETTING="Off"
ENV COMMERCE_ENDPOINT=""
ENV AEM_HTTP_PROXY_HOST=""
ENV AEM_HTTP_PROXY_PORT=""
ENV COMMERCE_ENDPOINT=""

RUN yum -y update && \
    yum -y install httpd && \
    yum -y install openssl && \
    yum -y install epel-release && \
    yum -y install mod_qos && \
    yum -y install mod_security && \
    yum -y install mod_ssl && \
    yum clean all && \
    mv $(curl --insecure --silent ${MODULE_URL} | \
    tar xzvf - --wildcards "*.so" | head -1) /etc/httpd/modules/mod_dispatcher.so && \
    chown root:root /etc/httpd/modules/mod_dispatcher.so
RUN rm /etc/httpd/conf.modules.d/*.conf && \
    rm /etc/httpd/conf.d/*.conf && \
    rm /etc/httpd/conf/*.conf
COPY docker /

EXPOSE 80

#RUN mkdir -p /mnt/var/www/author && \
#    mkdir -p /mnt/var/www/html && \
#    mkdir -p /mnt/var/www/default && \
#    chown -R apache:apache /mnt/var/www

WORKDIR /etc/httpd
CMD "/docker_entrypoint.sh"
CMD [ "apachectl", "-DFOREGROUND" ]
