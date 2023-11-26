# syntax=docker/dockerfile:1.4

FROM debian:bookworm-slim AS basic

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ENV TEXLIVE_VERSION=2023 \
    TEXDIR=/usr/local/texlive \
    INSTALL_DIR=/tmp/install-tl \
    TEXLIVE_MIRROR_URL=https://mirror.ctan.org/systems/texlive

RUN <<EOT
apt-get update -y
apt-get install -y \
  tar \
  zlib1g \
  perl \
  fontconfig

apt-get clean -y
rm -rf /var/lib/apt/lists/*
EOT

RUN mkdir -p "${INSTALL_DIR}"
ADD texlive.profile "${INSTALL_DIR}/texlive.profile"

ENV PATH="${TEXDIR}/bin/default:${PATH}"

RUN <<EOT
INSTALL_DEPS=(wget xzdec)

apt-get update -y
apt-get install -y "${INSTALL_DEPS[@]}"

wget -O- "${TEXLIVE_MIRROR_URL}/tlnet/install-tl-unx.tar.gz" \
  | tar -xz -C "${INSTALL_DIR}" --strip-components=1

"${INSTALL_DIR}/install-tl" \
  "--profile=${INSTALL_DIR}/texlive.profile"
ln -sf "${TEXDIR}/bin/"*-linux "${TEXDIR}/bin/default"

rm -rf "${INSTALL_DIR}"
apt-get remove -y "${INSTALL_DEPS[@]}"
apt-get autoremove -y
apt-get clean -y
rm -rf /var/lib/apt/lists/*
EOT

SHELL ["/bin/sh"]

WORKDIR /workdir

CMD ["sh"]


FROM basic AS recommended

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# for tlmgr
RUN <<EOT
apt-get update -y
apt-get install -y wget xzdec

apt-get clean -y
rm -rf /var/lib/apt/lists/*
EOT

RUN <<EOT
tlmgr update --self --all
tlmgr install \
  collection-latex \
  collection-fontsrecommended \
  collection-latexrecommended
EOT

SHELL ["/bin/sh"]

WORKDIR /workdir

CMD ["sh"]


FROM recommended AS extra

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN <<EOT
tlmgr update --self --all
tlmgr install \
  collection-pictures \
  collection-latexextra \
  collection-fontsextra \
  collection-mathscience
EOT

SHELL ["/bin/sh"]

WORKDIR /workdir

CMD ["sh"]


FROM extra AS full

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN <<EOT
apt-get update -y
apt-get install -y \
  gcc \
  libffi-dev \
  make

apt-get clean -y
rm -rf /var/lib/apt/lists/*
EOT

RUN <<EOT
apt-get update -y
apt-get install -y python3

wget -O- https://install.python-poetry.org | python3 -

apt-get clean -y
rm -rf /var/lib/apt/lists/*
EOT

RUN <<EOT
tlmgr update --self --all
tlmgr install \
  collection-langjapanese \
  collection-luatex \
  latexmk \
  latexpand \
  latexdiff
EOT

SHELL ["/bin/sh"]

WORKDIR /workdir

CMD ["sh"]
