FROM python:3.6-slim

ENV FLASK_APP=flasky.py
ENV FLASK_CONFIG=production

RUN id -u flasky >/dev/null 2>&1 || useradd -m flasky
WORKDIR /home/flasky

COPY --chown=flasky:flasky requirements requirements
RUN python -m venv venv
RUN venv/bin/pip install --upgrade pip
RUN venv/bin/pip install -r requirements/docker.txt

COPY --chown=flasky:flasky app app
COPY --chown=flasky:flasky migrations migrations
COPY --chown=flasky:flasky tests tests
COPY --chown=flasky:flasky flasky.py config.py boot.sh ./

RUN sed -i 's/\r$//' boot.sh
RUN chmod +x boot.sh
USER flasky

EXPOSE 5000
ENTRYPOINT ["bash", "./boot.sh"]