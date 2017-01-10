FROM buildpack-deps:jessie

MAINTAINER Sitesh Jalan <sitesh.jalan@gmail.com>

# Install bats for testing
RUN wget -O bats.tar.gz 'https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz' \
	&& tar xzvf bats.tar.gz -C /tmp \
	&& cd /tmp/bats-0.4.0 \
	&& ./install.sh /usr/local

# Add the mongo repo
RUN	apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 \
	&& echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" > /etc/apt/sources.list.d/mongodb-org-3.0.list

# Update the repositories
RUN apt-get update -y \
	&& apt-get install -y redis-tools mongodb-org-shell \
	&& apt-get install -y python python-dev python-distribute python-pip

# Add aws cli
RUN pip install awscli

RUN mkdir -p /usr/src/await/bin /usr/src/await/test
WORKDIR /usr/src/await

COPY bin /usr/src/await/bin/
COPY test /usr/src/await/test/

ENV PATH /usr/src/await/bin:$PATH

CMD [ "await", "--help" ]
