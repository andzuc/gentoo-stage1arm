FROM andzuc/gentoo-armbuilder-seed0 as seed
FROM scratch as seedsys

ENV STAGE1_FEATURES="-sandbox -usersandbox buildpkg noman noinfo nodoc"
ENV STAGE1_CFLAGS="-Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s -fomit-frame-pointer -pipe -fno-stack-protector -U_FORTIFY_SOURCE"

COPY --from=seed /builder/seed /
COPY --from=seed /usr/portage /usr/portage
COPY --from=seed /builder/ext/qemu /emu/
COPY --from=seed /builder/ext/resin/resin-xbuild /emu/
COPY emu /emu/

RUN [ "/emu/qemu-arm", "-help" ]
RUN [ "/emu/qemu-arm", "-execve", "/emu/qemu-arm", "/bin/bash", "-c", "echo Hello from ARM container: ${TC_PROFILE}" ]

RUN [ "/emu/qemu-arm", "-execve", "/emu/qemu-arm", "/bin/bash", "-c", "/emu/xbuild.install" ]
RUN [ "/usr/bin/cross-build-start" ]

RUN gcc --version \
    && gcc -dumpmachine \
    && python --version \
    && echo "FEATURES='${STAGE1_FEATURES}'" >>/etc/portage/make.conf \
    && sed -i \
	   's/CFLAGS=".*"/CFLAGS="'"${STAGE1_CFLAGS}"'"/' \
	   /etc/portage/make.conf

FROM seedsys as portage
# Installs portage from Gentoo GIT repository
# Then use ebuild to build a stable sys-apps/portage
RUN mkdir /opt \
    && cd /opt \
    && git clone --depth 1 --branch master https://anongit.gentoo.org/git/proj/portage.git \
    && cd portage \
    && echo "[build_ext]" >>setup.cfg \
    && echo "portage-ext-modules=true" >>setup.cfg \
    && python setup.py install \
    && cd / \
    && emerge --info \
    && PYTHON_TARGETS="python3_6" ebuild /usr/portage/sys-apps/portage/portage-2.3.51-r1.ebuild package

FROM seedsys as stage1
# Use sys-apps/portage pakage from portage stage
COPY --from=portage /usr/portage/packages /usr/portage/packages
RUN tar -xvjf /usr/portage/packages/sys-apps/portage-2.3.51-r1.tbz2 -C /

RUN mkdir /st1 \
    && emerge --root /st1 --sysroot /st1 --root-deps=rdeps -pv @system

RUN [ "/usr/bin/cross-build-end" ]
RUN [ "/emu/qemu-arm", "-execve", "/emu/qemu-arm", "/bin/bash", "-c", "/emu/xbuild.uninstall" ]

ENTRYPOINT [ "/emu/qemu-arm", "-execve", "/emu/qemu-arm" ]
CMD [ "/bin/bash" ]
