FROM registry.gitlab.com/mizunashi-mana/docker-texlive-core:latest

RUN apk add --no-cache --virtual .fetch-deps xz tar wget \
 && tlmgr update --self --all \
 && tlmgr install \
      collection-fontsrecommended \
      collection-latexrecommended \
      collection-pictures \
      collection-latexextra \
      collection-mathscience \
      collection-langjapanese \
      latexmk \
      latexpand \
      latexdiff \
 && apk del .fetch-deps

WORKDIR /workdir

CMD ["sh"]
