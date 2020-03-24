FROM bitnami/minideb
LABEL maintainer="klaus.azesberger@gmail.com"

RUN install_packages qemu-utils

RUN mkdir -p /home/imguser && \
  groupadd -r imguser -g 433 && \
  useradd -u 431 -r -g imguser -d /home/imguser -s /sbin/nologin -c "Docker image user" imguser && \
  chown -R imguser:imguser /home/imguser

RUN install_packages python2.7-dev libffi-dev curl gcc
RUN curl --silent -k https://bootstrap.pypa.io/get-pip.py | python2.7
RUN pip install pipenv

# -- Install Application into container:
RUN set -ex && mkdir /app

WORKDIR /app

# -- Adding Pipfiles
COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

# -- Install dependencies:
RUN set -ex && pipenv install --deploy --system

# USER imguser

VOLUME ["/data"]
VOLUME ["/output"]
