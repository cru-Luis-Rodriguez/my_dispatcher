docker build \
    --platform linux/amd64 \
    -t mysite/dispatcher:latest \
    --build-arg MODULE_URL=https://download.macromedia.com/dispatcher/download/dispatcher-apache2.4-linux-x86_64-ssl1.1-4.3.4.tar.gz \
    .
