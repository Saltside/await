FROM alpine:3.5

MAINTAINER Sitesh Jalan <sitesh.jalan@gmail.com>

RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
	&& apk add --no-cache \
			bash \
			ca-certificates \
			curl \
			mongodb \
			py2-pip \
			redis \
	&& pip install \
		awscli \
	&& curl -sSL -o /tmp/bats.tar.gz 'https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz' \
	&& tar xzvf /tmp/bats.tar.gz -C /tmp \
	&& cd /tmp/bats-0.4.0 \
	&& ./install.sh /usr/local \
	&& rm /tmp/bats.tar.gz

# Install bats for testing

RUN mkdir -p /usr/src/await/bin /usr/src/await/test
WORKDIR /usr/src/await

COPY bin /usr/src/await/bin/
COPY test /usr/src/await/test/

ENV PATH /usr/src/await/bin:$PATH

CMD [ "await", "--help" ]
