FROM alpine:3.13 as build

ENV HUGO_VERSION 0.81.0
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

# Install Hugo
RUN set -x && \
  apk add --update wget ca-certificates && \
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
  tar xzf ${HUGO_BINARY} && \
  rm -r ${HUGO_BINARY} && \
  mv hugo /usr/bin && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*

COPY ./website /site

WORKDIR /site

RUN /usr/bin/hugo

FROM nginx:alpine

LABEL maintainer Eduardo Reyes <eduardo@reyes.im>

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /site/public /usr/share/nginx/html

WORKDIR /var/www/site
