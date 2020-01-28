# Docker Image for TeXLive

with some useful tools.

## Usage

```bash
docker login registry.gitlab.com
docker run -it --volume "$(pwd):/workdir" \
  registry.gitlab.com/mizunashi-mana/docker-texlive \
  latexmk -pdfdvi sample.tex
```
