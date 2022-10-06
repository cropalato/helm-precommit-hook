FROM alpine:latest
RUN apk add --update --no-cache bash curl openssl
RUN mkdir /scripts
COPY ./scripts/* /scripts/
WORKDIR /
RUN ls -l /scripts
RUN /scripts/install_helm.sh
#ENTRYPOINT ["/scripts/helm-lint.sh"]
