FROM alpine:latest AS basic

ENV TEXLIVE_VERSION=2021 \
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


FROM basic AS recommended

# for tlmgr
RUN apk add --no-cache xz tar wget

RUN tlmgr update --self --all \
 && tlmgr install \
      collection-latex \
      collection-fontsrecommended \
      collection-latexrecommended

WORKDIR /workdir

CMD ["sh"]


FROM recommended AS extra

RUN tlmgr update --self --all \
 && tlmgr install \
      collection-pictures \
      collection-latexextra \
      collection-fontsextra \
      collection-mathscience

WORKDIR /workdir

CMD ["sh"]


FROM extra AS full

RUN apk add --no-cache \
      gcc \
      musl-dev \
      libffi-dev \
      bash \
      make

RUN apk add --no-cache \
      python3 \
      python3-dev \
      py3-pip \
 && pip3 install --upgrade pip \
 && pip3 install \
      poetry \
      pygments

RUN tlmgr update --self --all \
 && tlmgr install \
      collection-langjapanese \
      collection-luatex \
      latexmk \
      latexpand \
      latexdiff

WORKDIR /workdir

CMD ["sh"]
