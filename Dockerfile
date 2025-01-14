# syntax=docker/dockerfile:1.4

ARG PYTHON_VERSION=3.10

FROM python:${PYTHON_VERSION}-slim as base

# Environment setup
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    wget \
    gnupg \
    git \
    cmake \
    pkg-config \
    python3-dev \
    libjpeg-dev \
    libpng-dev \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxcb1 \
    libxkbcommon0 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    libatspi2.0-0 \
    locales \
    fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*

# Create and set working directory
WORKDIR /app

# Copy the entire project
COPY . .

# Install base requirements
RUN pip install --no-cache-dir -r requirements.txt

# Install required library for FastAPI
RUN pip install fastapi uvicorn psutil

# Install Playwright and its browsers
RUN pip install playwright && \
    python -m playwright install

# 安装中文字体和语言包
RUN apt-get update && \
    apt-get install -y locales fonts-noto-cjk && \
    locale-gen zh_CN.UTF-8

# 设置环境变量
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# Expose port
EXPOSE 8000 11235 9222 8080

# Start the FastAPI server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "11235"]