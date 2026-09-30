# Lab 1: an API from process to container

**Difficulty:** beginner. **Architecture:** client → Python HTTP server → JSON response. **Cost:** local runtime only; no AWS charges. **Prerequisites:** Python 3.10+; Docker optional.

## Goal

Observe the same application as a local process, then a container. Explain the difference between the listening address inside a container and the published host port.

## Steps

From this directory:

```sh
python3 app.py
```

In another terminal:

```sh
curl -i http://127.0.0.1:8080/health
curl -i http://127.0.0.1:8080/
```

Stop with Ctrl-C. If Docker is installed and its daemon is running:

```sh
docker build -t demo-api:local .
docker run --rm -p 8080:8080 demo-api:local
```

`FROM` chooses a Python runtime. `WORKDIR` sets the working directory. `COPY` adds the app. `USER` drops root privileges. `EXPOSE` documents the container port; `-p` actually publishes it. `CMD` starts the server. The app listens on `0.0.0.0` inside the container so the published port can reach it.

## Verify and debug

`/health` must return HTTP 200 and JSON `{"status":"ok"}`. If connection is refused, check whether process exists, `docker ps`, port mapping and host port occupancy. If image fails to start, `docker logs CONTAINER` and `docker inspect CONTAINER` show details. A missing variable is deliberate in [failure lab](../03-failure-lab/README.md). Do not put secrets in Docker build arguments or image layers.

## Cleanup

Stop process/container with Ctrl-C. Remove image with `docker image rm demo-api:local` if desired. Check `docker ps -a` for leftovers.

## Knowledge check

Why does `EXPOSE` alone not publish a host port? What changes between image and container? Why should app avoid root privileges?
