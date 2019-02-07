FROM alpine:3.6 as builder
RUN apk add --update-cache make gcc libc-dev cairo-dev poppler-dev git
ENV PDF2SVG_VERSION v0.2.3
RUN git clone https://github.com/dawbarton/pdf2svg pdf2svg
WORKDIR /pdf2svg
RUN git checkout $PDF2SVG_VERSION && ./configure && make


FROM frolvlad/alpine-glibc:alpine-3.8_glibc-2.28
RUN mkdir /tmp/install-tl-unx
WORKDIR /tmp/install-tl-unx
COPY --from=builder /pdf2svg/pdf2svg /usr/local/bin/pdf2svg
COPY texlive.profile .

# Install TeX Live 2016 with some basic collections
RUN apk add --update-cache --virtual .fetch-deps ca-certificates openssl \
    && update-ca-certificates \
    && apk add --no-cache poppler-glib poppler-utils msttcorefonts-installer \
    && update-ms-fonts \
    && fc-cache -f \
    && apk del .fetch-deps \
    && apk --no-cache add perl wget xz tar \
    && wget ftp://tug.org/historic/systems/texlive/2018/install-tl-unx.tar.gz \
    && tar --strip-components=1 -xvf install-tl-unx.tar.gz \
    && ./install-tl --repository http://mirror.ctan.org/systems/texlive/tlnet/ --profile=texlive.profile \
    && tlmgr install collection-latex collection-latexextra \
    && apk del perl wget xz tar \
    && cd && rm -rf /tmp/install-tl-unx && mkdir /code

ENV PATH="/usr/local/texlive/2016/bin/x86_64-linux:${PATH}"
WORKDIR /code
COPY entrypoint.sh /code/

# ENTRYPOINT ["./entrypoint.sh"]
