FROM python:3.11-slim
ENV PYTHONDONTWRITEBITECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /flask-app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN useradd -m -r appuser &&\
    chown -R appuser:appuser /flask-app

COPY app.py .
USER appuser

EXPOSE 5000


