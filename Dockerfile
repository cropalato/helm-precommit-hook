FROM alpine:latest
RUN mkdir /scripts
COPY ./scripts/* /scripts
WORKDIR /
RUN /scripts/install-helm.sh
#ENTRYPOINT ["/scripts/helm-lint.sh"]
