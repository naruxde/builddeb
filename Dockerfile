FROM debian:bullseye

ARG DEBIAN_FRONTEND=noninteractive

# install build basics
RUN apt-get update \
&& apt-get -y install \
	build-essential \
	fakeroot \
	devscripts \
	git-buildpackage \
	eatmydata \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN install -d /work
RUN install -d -m 0700 /root/gnupg

COPY run.sh /usr/local/bin
CMD ["/usr/local/bin/run.sh"]