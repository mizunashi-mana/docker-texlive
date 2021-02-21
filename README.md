# Docker Image for TeXLive

with some useful tools.

## Usage

```bash
docker login docker.pkg.github.com
docker run -it --volume "$(pwd):/workdir" \
  docker.pkg.github.com/mizunashi-mana/docker-texlive/full \
  latexmk -pdfdvi sample.tex
```
