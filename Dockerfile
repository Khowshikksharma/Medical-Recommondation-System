FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

COPY . .

RUN pip install --upgrade pip
RUN pip install maturin
RUN pip install .

EXPOSE 8000

CMD ["python", "main.py"]
