FROM alpine:latest
RUN mkdir /scripts
COPY ./scripts/* /scripts
WORKDIR /
RUN ls -l /scripts
RUN bash -c /scripts/install_helm.sh
#ENTRYPOINT ["/scripts/helm-lint.sh"]
