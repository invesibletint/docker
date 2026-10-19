# SSH images for Railway VPS bot

9 Docker images with an entrypoint that reads `ROOT_PASSWORD` from the
environment and sets it as the root password, then runs sshd.

Built & pushed automatically by GitHub Actions (`.github/workflows/build.yml`).

## Secrets required

- `DOCKERHUB_USERNAME` — Docker Hub username (e.g. `maxtechnical`)
- `DOCKERHUB_TOKEN` — Docker Hub Personal Access Token (Read & Write)
