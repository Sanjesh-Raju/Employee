FROM python:3.11-slim

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PIP_NO_CACHE_DIR=off \
    PYTHONUNBUFFERED=1 \
    FRAPPE_ENV=production

RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    mariadb-client \
    wkhtmltopdf \
    nodejs \
    npm \
    && npm install -g yarn \
    && apt-get clean

RUN useradd -ms /bin/bash frappe
WORKDIR /home/frappe

COPY . /home/frappe/frappe-bench
WORKDIR /home/frappe/frappe-bench

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

RUN bench setup requirements
RUN bench build

EXPOSE 8000
CMD ["bench", "start"]
