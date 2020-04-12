# GCC support can be specified at major, minor, or micro version
# (e.g. 8, 8.2 or 8.2.0).
# See https://hub.docker.com/r/library/gcc/ for all supported GCC
# tags from Docker Hub.
# See https://docs.docker.com/samples/library/gcc/ for more on how to use this image
FROM gcc:latest

RUN apt-get update && \
apt-get upgrade -y && apt-get install -y python-docutils pandoc postgresql dnsutils autoconf autoconf-doc automake udns-utils curl gcc libc-dev libevent-dev libtool make man libssl-dev pkg-config libudns-dev
# These commands copy your files into the specified directory in the image
# and set that as the working location
COPY . /usr/src/pgbouncer
COPY ivy-dev/pgbouncer.ini /etc/pgbouncer/pgbouncer.ini
COPY ivy-dev/userlist.txt /etc/pgbouncer/userlist.txt
WORKDIR /usr/src/pgbouncer

# This command compiles your app using GCC, adjust for your source code
RUN ./autogen.sh
RUN ./configure --with-udns
RUN make
RUN make install
# This command runs your application, comment out this line to compile only
USER postgres
EXPOSE 5432
CMD ["pgbouncer", "-v", "/etc/pgbouncer/pgbouncer.ini"]

LABEL Name=pgbouncer Version=0.0.1
