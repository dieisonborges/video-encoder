FROM golang:1.14-alpine3.11
ENV PATH="$PATH:/bin/bash" \
    BENTO4_BIN="/opt/bento4/bin" \
    PATH="$PATH:/opt/bento4/bin"

# FFMPEG
RUN apk add --update ffmpeg bash curl make

# Install Bento
WORKDIR /tmp/bento4

ENV BENTO4_BASE_URL="https://www.bok.net/Bento4/source/" \
    BENTO4_VERSION="1-6-0-640" \
    BENTO4_CHECKSUM="" \
    BENTO4_TARGET="" \
    BENTO4_PATH="/opt/bento4" \
    BENTO4_TYPE="SRC"

# Install dependencies
RUN echo "download and unzip bento4"&& \
    apk add --update --upgrade curl python unzip bash gcc g++ scons

# Download Bento4
RUN echo "Downloading Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}${BENTO4_TARGET}.zip from ${BENTO4_BASE_URL}" && \
    curl -O -s ${BENTO4_BASE_URL}Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}${BENTO4_TARGET}.zip

# Create directory and unzip Bento4
RUN echo "Creating directory ${BENTO4_PATH}" && \
    mkdir -p ${BENTO4_PATH} && \
    echo "Unzipping Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}${BENTO4_TARGET}.zip to ${BENTO4_PATH}" && \
    unzip Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}${BENTO4_TARGET}.zip -d ${BENTO4_PATH} && \
    echo "Removing Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}${BENTO4_TARGET}.zip" && \
    rm -rf Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}${BENTO4_TARGET}.zip

# Remove unnecessary package
RUN echo "Removing unnecessary packages" && \
    apk del unzip

# Build Bento4
RUN echo "Building Bento4" && \
    cd ${BENTO4_PATH} && scons -u build_config=Release target=x86_64-unknown-linux

# Copy built files
RUN echo "Copying built files" && \
    cp -R ${BENTO4_PATH}/Build/Targets/x86_64-unknown-linux/Release ${BENTO4_PATH}/bin && \
    cp -R ${BENTO4_PATH}/Source/Python/utils ${BENTO4_PATH}/utils && \
    cp -a ${BENTO4_PATH}/Source/Python/wrappers/. ${BENTO4_PATH}/bin



WORKDIR /go/src

#vamos mudar para o endpoint correto. Usando top apenas para segurar o processo rodando
ENTRYPOINT [ "top" ]