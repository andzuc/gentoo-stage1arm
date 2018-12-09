FROM andzuc/gentoo-armbuilder-s4

# system config
ENV ACCEPTED_KEYWORDS="arm"
RUN sed -i \
    's/ACCEPTED_KEYWORDS=".*"/ACCEPTED_KEYWORDS="'"${DOCKER_ACCEPTED_KEYWORDS}"'"/' \
    "/usr/${TARGET}/etc/portage/make.conf"

ENV DOCKER_FEATURES="-collision-protect -sandbox -usersandbox noman noinfo nodoc"
RUN sed -i \
    's/FEATURES=".*"/FEATURES="'"${DOCKER_FEATURES}"'"/' \
    "/usr/${TARGET}/etc/portage/make.conf"

ENV DOCKER_CFLAGS="-Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s -fomit-frame-pointer -pipe -fno-stack-protector -U_FORTIFY_SOURCE"
RUN sed -i \
    's/CFLAGS=".*"/CFLAGS="'"${DOCKER_CFLAGS}"'"/' \
    "/usr/${TARGET}/etc/portage/make.conf"
RUN cat "/usr/${TARGET}/etc/portage/make.conf"

ENV DOCKER_PROFILE=hardened/linux/arm/armv6j
RUN ARCH=arm PORTAGE_CONFIGROOT="/usr/${TARGET}/" eselect profile set "${DOCKER_PROFILE}"

# catalyst seed tarball
RUN time "${TARGET}-emerge" -v --color n \
    sys-apps/baselayout \
    sys-devel/binutils \
    sys-kernel/linux-headers \
    sys-devel/make \
    sys-devel/gcc

# setup QEMU
#RUN cp /usr/bin/qemu-arm "/usr/${TARGET}/usr/bin/qemu-arm"
#RUN time emerge -v dev-util/catalyst

#RUN catalyst -s "$(date +%Y.%m)"
#COPY builder /builder

# build @sysnodev
#RUN "${TARGET}-emerge" --info
#RUN time "${TARGET}-emerge" -ev --color n --keep-going @system --exclude "sys-devel/gcc"
