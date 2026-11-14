FROM python:3.11-alpine As builder
RUN adduser -D appuser
USER appuser
WORKDIR /home/appuser/
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt 

FROM python:3.11-alpine As runtime
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
RUN adduser -D appuser && \ 
    mkdir -p /home/appuser/flask-app && \
    chown -R appuser:appuser /home/appuser/flask-app
WORKDIR /home/appuser/flask-app
USER appuser
COPY --from=builder --chown=appuser:appuser /home/appuser/.local /home/appuser/.local
ENV PATH="/home/appuser/.local/bin:$PATH"
COPY app.py .
EXPOSE 5000
HEALTHCHECK --interval=10s --timeout=5s --retries=3 --start-period=20s \
            CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000')" || exit 1
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]
