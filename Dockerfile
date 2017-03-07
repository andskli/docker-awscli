FROM alpine:3.5

ENV AWSCLI_VERSION 1.11.57

RUN apk --no-cache --update add ca-certificates py-pip py-setuptools groff less \
 && rm -rf /var/cache/apk/* \
 && pip --no-cache-dir install awscli==$AWSCLI_VERSION

ENTRYPOINT ["/usr/bin/python", "/usr/bin/aws"]
CMD ["help"]
