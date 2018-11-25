FROM andzuc/gentoo-armbuilder-s4

ENV CFLAGS="-Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s -fomit-frame-pointer -pipe -fno-stack-protector -U_FORTIFY_SOURCE"
ENV PROFILE=hardened/linux/arm/armv6j

RUN sed -i \
    's/CFLAGS=".*"/CFLAGS="${CFLAGS}"/' \
    "/usr/${TARGET}/etc/portage/make.conf"
RUN ARCH=arm PORTAGE_CONFIGROOT="/usr/${TARGET}/" eselect profile set ${PROFILE}
RUN "${TARGET}-emerge" -vuDN --keep-going @system
