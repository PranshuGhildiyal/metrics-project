FROM alpine:latest

# Install curl, bash, and kubectl
RUN apk add --no-cache curl bash ca-certificates \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

COPY fetch-metrics.sh /fetch-metrics.sh

RUN chmod +x /fetch-metrics.sh

ENTRYPOINT ["/fetch-metrics.sh"]

