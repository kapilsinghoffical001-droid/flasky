FROM python:3.6-slim

ENV FLASK_APP=flasky.py
ENV FLASK_CONFIG=production

RUN useradd -m flasky
WORKDIR /home/flasky

COPY requirements requirements
RUN python -m venv venv
RUN venv/bin/pip install --upgrade pip
RUN venv/bin/pip install -r requirements/docker.txt

COPY app app
COPY migrations migrations
COPY flasky.py config.py boot.sh ./

RUN sed -i 's/\r$//' boot.sh
RUN chown -R flasky:flasky ./ && chmod +x boot.sh
USER flasky

EXPOSE 5000
ENTRYPOINT ["bash", "./boot.sh"]