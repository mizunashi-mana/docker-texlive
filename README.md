# Docker Image for TeXLive

[![GitHub Actions - Docker](https://github.com/mizunashi-mana/docker-texlive/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/mizunashi-mana/docker-texlive/actions/workflows/docker-publish.yml)

with some useful tools.

## Usage

```bash
docker login docker.pkg.github.com
docker run -it --volume "$(pwd)/example/full:/workdir" \
  docker.pkg.github.com/mizunashi-mana/docker-texlive/full \
  latexmk -pdfdvi sample.tex
```
