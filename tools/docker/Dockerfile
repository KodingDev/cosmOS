FROM phusion/baseimage:0.11

# Install the binaries we need to build an ISO
RUN apt-get update
RUN apt-get install -y mtools grub-pc-bin xorriso

# Required for this base image
CMD ["/sbin/my_init"]
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*