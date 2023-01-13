FROM tianon/raspbian:buster

ARG DEBIAN_FRONTEND=noninteractive

ADD "https://raw.githubusercontent.com/RevolutionPi/imagebakery/cdb7ceab47ca5f7b3c21e5708ed6346db67e1697/templates/revpi.list" etc/apt/sources.list.d/revpi.list
ADD "https://github.com/RevolutionPi/imagebakery/raw/master/templates/revpi.gpg" revpi.gpg
RUN apt-key add revpi.gpg \
&& rm revpi.gpg

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

COPY ../run.sh /
CMD ["/run.sh"]
