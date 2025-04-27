# --- Build Stage (Build dependencies) ---
FROM python:3.11-slim as builder

# Install build dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip freeze > requirements.txt  # freeze for reproducibility

# --- Final Stage (Minimal Runtime) ---
FROM python:3.11-slim as runtime

# Copy only necessary files from builder image
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Now copy only the application code (not unnecessary files)
WORKDIR /app
COPY . .

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

# Run the application
CMD ["python", "main.py"]
