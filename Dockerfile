FROM andzuc/gentoo-armbuilder-s4

# system config
ENV DOCKER_ACCEPT_KEYWORDS="arm"
RUN sed -i \
    's/ACCEPT_KEYWORDS=".*"/ACCEPT_KEYWORDS="'"${DOCKER_ACCEPT_KEYWORDS}"'"/' \
    "/usr/${DOCKER_TARGET}/etc/portage/make.conf"

ENV DOCKER_FEATURES="-collision-protect -sandbox -usersandbox noman noinfo nodoc"
RUN sed -i \
    's/FEATURES=".*"/FEATURES="'"${DOCKER_FEATURES}"'"/' \
    "/usr/${DOCKER_TARGET}/etc/portage/make.conf"

# ENV DOCKER_CFLAGS="-Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s -fomit-frame-pointer -pipe -fno-stack-protector -U_FORTIFY_SOURCE"
# RUN sed -i \
#     's/CFLAGS=".*"/CFLAGS="'"${DOCKER_CFLAGS}"'"/' \
#     "/usr/${DOCKER_TARGET}/etc/portage/make.conf"

RUN cat "/usr/${DOCKER_TARGET}/etc/portage/make.conf"

ENV DOCKER_PROFILE=hardened/linux/arm/armv6j
RUN ARCH=arm PORTAGE_CONFIGROOT="/usr/${DOCKER_TARGET}/" eselect profile set "${DOCKER_PROFILE}"

# stage0: binutils
RUN time "${DOCKER_TARGET}-emerge" -v --color n \
    sys-devel/binutils
# stage1: gcc (C only)
RUN time USE="headers-only" "${DOCKER_TARGET}-emerge" -v --color n \
    sys-kernel/linux-headers
RUN time USE="headers-only" "${DOCKER_TARGET}-emerge" -v --color n --nodeps \
    sys-libs/glibc
RUN cp -f
RUN rm -f /usr/bin/gcc; rm -f /usr/bin/g++; alias gcc=${DOCKER_TARGET}-gcc; alias g++=${DOCKER_TARGET}-g++; g++ -dumpmachine; \
    time USE="nls nptl pch pie ssp -cilk -cxx -debug -doc -fortran -go -graphite -hardened -jit -libssp -mpx -multilib -objc -objc++ -objc-gc -openmp -pgo -regression-test -sanitize -vanilla -vtv" \
    "${DOCKER_TARGET}-emerge" -v --color n \
    sys-devel/gcc

# setup QEMU
#RUN cp /usr/bin/qemu-arm "/usr/${DOCKER_TARGET}/usr/bin/qemu-arm"
#RUN time emerge -v dev-util/catalyst

#RUN catalyst -s "$(date +%Y.%m)"
#COPY builder /builder

# build @sysnodev
#RUN "${DOCKER_TARGET}-emerge" --info
#RUN time "${DOCKER_TARGET}-emerge" -ev --color n --keep-going @system --exclude "sys-devel/gcc"
