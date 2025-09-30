FROM python:3.11-slim

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PIP_NO_CACHE_DIR=off \
    PYTHONUNBUFFERED=1 \
    FRAPPE_ENV=production

# Install system dependencies (without wkhtmltopdf yet)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    mariadb-client \
    nodejs \
    npm \
    wget \
    xz-utils \
    fontconfig \
    libfreetype6 \
    libx11-6 \
    libxcb1 \
    libxext6 \
    libxrender1 \
    && npm install -g yarn \
    && apt-get clean

# Install wkhtmltopdf from precompiled .deb
# Install wkhtmltopdf from a working deb
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bullseye_amd64.deb && \
    dpkg -i wkhtmltox_0.12.6-1.bullseye_amd64.deb || true && \
    apt-get install -f -y && \
    rm wkhtmltox_0.12.6-1.bullseye_amd64.deb


# Create frappe user
RUN useradd -ms /bin/bash frappe
WORKDIR /home/frappe

# Copy repo
COPY . /home/frappe/frappe-bench
WORKDIR /home/frappe/frappe-bench

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Setup bench
RUN bench setup requirements
RUN bench build

EXPOSE 8000
CMD ["bench", "start"]
