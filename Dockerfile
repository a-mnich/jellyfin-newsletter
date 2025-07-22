FROM python:3.12-slim

LABEL org.opencontainers.image.title="Jellyfin Newsletter" \
      org.opencontainers.image.description="A Dockerized newsletter service that connects to Jellyfin  API to notify your users of newly added media." \
      org.opencontainers.image.authors="Seaweedbrain github.com/SeaweedbrainCY" \
      org.opencontainers.image.url="https://github.com/seaweedbraincy/jellyfin-newsletter" \
      org.opencontainers.image.source="https://github.com/seaweedbraincy/jellyfin-newsletter" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.documentation="https://github.com/seaweedbraincy/jellyfin-newsletter#readme" \
      org.opencontainers.image.vendor="Seaweedbrain" \
      org.opencontainers.image.base.name="python:3.12-slim"


WORKDIR /app

RUN apt update && apt install -y --no-install-recommends locales python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools gcc gosu

RUN echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

COPY requirements.txt /app

RUN pip install --no-cache --upgrade pip setuptools

RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN apt remove -y python3-dev build-essential libssl-dev libffi-dev python3-setuptools gcc

RUN apt autoremove -y

RUN mkdir -p /app/config

COPY source /app/source
COPY main.py /app
COPY template /app/template
COPY assets /app/assets
COPY entrypoint.sh /app/entrypoint.sh
COPY config/config-example.yml /app/default/config-example.yml

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]