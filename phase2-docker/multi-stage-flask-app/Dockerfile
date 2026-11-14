#stage 1
FROM python:3.11-slim As builder
ENV PYTHONDONTWRITEBITECODE=1 \
    PYTHONUNBUFFERED=1
RUN useradd -m appuser
USER appuser
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

#stage 2
FROM python:3.11-slim As runtime
WORKDIR /flask-app
RUN useradd -m appuser
USER appuser
COPY --from=builder --chown=appuser:appuser /home/appuser/.local /home/appuser/.local
ENV PATH="/home/appuser/.local/bin:$PATH"
COPY --chown=appuser:appuser . .
EXPOSE 5000
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]

