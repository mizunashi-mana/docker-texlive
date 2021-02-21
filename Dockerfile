FROM frolvlad/alpine-glibc:latest AS core

ENV TEXLIVE_VERSION=2020 \
    TEXDIR=/usr/local/texlive \
    INSTALL_DIR=/tmp/install-tl

RUN apk add --no-cache \
      curl \
      perl \
      fontconfig-dev \
      freetype-dev

RUN mkdir -p "${INSTALL_DIR}"
ADD texlive.profile "${INSTALL_DIR}/texlive.profile"

ENV PATH="${TEXDIR}/bin/x86_64-linuxmusl:${PATH}"

RUN apk add --no-cache --virtual .fetch-deps xz tar wget \
 && curl -L "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz" \
      | tar -xz -C "${INSTALL_DIR}" --strip-components=1 \
 && "${INSTALL_DIR}/install-tl" \
      "--profile=${INSTALL_DIR}/texlive.profile" \
 && rm -rf "${INSTALL_DIR}" \
 && apk del .fetch-deps

WORKDIR /workdir

CMD ["sh"]


FROM core AS full

RUN apk add --no-cache \
      bash \
      make

RUN apk add --no-cache python3 py3-pip \
 && pip3 install --upgrade pip \
 && pip3 install \
      pipenv \
      pygments

RUN apk add --no-cache xz tar wget \
 && tlmgr update --self --all \
 && tlmgr install \
      collection-fontsrecommended \
      collection-latexrecommended \
      collection-pictures \
      collection-latexextra \
      collection-mathscience \
      collection-langjapanese \
      stix2-type1 \
      latexmk \
      latexpand \
      latexdiff

WORKDIR /workdir

CMD ["sh"]
