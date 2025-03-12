FROM python:3.9-alpine3.13
LABEL maintainer="Kishore"

ENV PYTHONUNBUFFERED=1
ARG DEV=false
# Build-time argument
ENV DEV=${DEV}  
# Convert ARG to ENV for runtime access

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Install dependencies
RUN apk add --no-cache gcc musl-dev python3-dev libffi-dev && \
    python -m venv /py && \
    /py/bin/python -m ensurepip --default-pip && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt ; fi && \
    rm -rf /tmp && \
    adduser -D -h /home/appuser appuser

# Set PATH so virtualenv is used by default
ENV PATH="/py/bin:$PATH"
