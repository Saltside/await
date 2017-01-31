FROM alpine:3.5

RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
	&& apk add --update --no-cache \
		bash \
		bats \
		curl \
		py2-pip \
	&& pip install \
		boto3 \
		pymemcache \
		pymongo \
		PyMySQL \
		redis \
		awscli

RUN mkdir -p /usr/src/await/bin /usr/src/await/test
WORKDIR /usr/src/await

COPY bin /usr/src/await/bin/
COPY test /usr/src/await/test/

ENV PATH /usr/src/await/bin:$PATH

CMD [ "await", "--help" ]
