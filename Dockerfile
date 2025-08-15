FROM python:3.12-slim


WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends locales python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools gcc gosu

RUN echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

COPY requirements.txt /app
COPY VERSION /app

RUN pip install --no-cache --upgrade pip setuptools

RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN apt-get remove -y python3-dev build-essential libssl-dev libffi-dev python3-setuptools gcc

RUN apt-get autoremove -y

RUN mkdir -p /app/config

COPY source /app/source
COPY main.py /app
COPY template /app/template
COPY assets /app/assets
COPY entrypoint.sh /app/entrypoint.sh
COPY config/config-example.yml /app/default/config-example.yml

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]