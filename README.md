# app-template


## using this as a template (remove me!)

1. `name` in `pyproject.toml` and `openhost.toml`, and the description in both.
2. Rename the package if you want something other than `server` (update
   `[tool.hatch.build.targets.wheel]`, `[tool.mypy]`, `[tool.ruff.lint.isort]`,
   the `Dockerfile` CMD, and `tests/conftest.py`).
3. Fill in this README and `openhost.toml` (resources, data, public paths).
4. Build your app in `src/server/`.

## development

```bash
just setup   # install deps, pre-commit hooks, and the playwright chromium browser
just run     # run locally on http://localhost:8080
just test    # run the test suite
just check   # lint, format, typecheck
```

Python work uses [uv](https://docs.astral.sh/uv/). Use `uv add <pkg>` to add a
dependency and `uv add --group dev <pkg>` for a dev-only one.

CI (`.github/workflows/ci.yml`) runs the test suite on every PR and push to main via the reusable
`.github/workflows/app-test.yml`, which other app repos also call.

`just test` uses the OpenHost test harness (the `openhost[test-harness]` package),
which builds the Dockerfile and runs the app under **podman** (so podman must be
running on the host) fronted by the real OpenHost router. `stack.url` requires
owner auth (use `stack.owner_session` for requests, or `stack.playwright_login(page)`
for browser tests); `stack.app_url` hits the container directly. See `tests/` for the
`stack` fixture.
