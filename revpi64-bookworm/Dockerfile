FROM docker.io/arm64v8/debian:bookworm

ARG DEBIAN_FRONTEND=noninteractive

ADD "https://gitlab.com/revolutionpi/revpi-repo/-/raw/13bed4f965efdadcc06e7d5dc274715f88f6a182/revpi/revpi.sources" etc/apt/sources.list.d/revpi.sources
ADD "https://gitlab.com/revolutionpi/revpi-repo/-/raw/13bed4f965efdadcc06e7d5dc274715f88f6a182/revpi/revpi.gpg" /usr/share/keyrings/revpi.gpg

# The revpi.gpg must be readable by group and others
RUN chmod go+r /usr/share/keyrings/revpi.gpg

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
