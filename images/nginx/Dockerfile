ARG BASE_IMAGE
FROM $BASE_IMAGE as src

FROM bitnami/nginx:latest
USER root

RUN install_packages vim

RUN echo -e "\\nalias ll='ls -alF'\\nalias ls='ls --color=auto'\\n" >> /.bashrc && \
    rm -rf /app/*

COPY --from=src /app/html /app/html/
