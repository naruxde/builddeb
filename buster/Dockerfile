FROM docker.io/debian:buster

ARG DEBIAN_FRONTEND=noninteractive

# install build basics
RUN apt-get update \
&& apt-get dist-upgrade -y \
&& apt-get -y install \
	apt-utils \
	build-essential \
	fakeroot \
	devscripts \
	equivs \
	git-buildpackage \
	eatmydata \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN install -d /work
RUN install -d -m 0700 /root/gnupg

COPY ./run.sh /
CMD ["/run.sh"]
