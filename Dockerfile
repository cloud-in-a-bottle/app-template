FROM python:3.12-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Install Python dependencies (source is copied first so the project itself
# builds during `uv sync`).
COPY pyproject.toml uv.lock ./
COPY src/ src/
RUN uv sync --frozen --no-dev

EXPOSE 8080

# Exec the venv's hypercorn directly rather than through `uv run`, which would stay resident as a parent process,
# and serve from this one process with `--workers 0` rather than hypercorn's default of a supervisor plus a spawned
# worker and multiprocessing resource tracker.  Together those extra processes cost more memory than the app itself.
CMD ["/app/.venv/bin/hypercorn", "server.app:app", "--workers", "0", "--bind", "0.0.0.0:8080"]
