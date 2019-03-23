FROM andzuc/gentoo-armbuilder-seed0 as seed
FROM scratch

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

# Installs portage from Gentoo GIT repository
RUN gcc --version \
    && gcc -dumpmachine \
    && python --version \
    && echo "FEATURES='${STAGE1_FEATURES}'" >>/etc/portage/make.conf \
    && sed -i \
	   's/CFLAGS=".*"/CFLAGS="'"${STAGE1_CFLAGS}"'"/' \
	   /etc/portage/make.conf \
    && mkdir /opt \
    && cd /opt \
    && git clone --depth 1 --branch master https://anongit.gentoo.org/git/proj/portage.git \
    && cd portage \
    && python setup.py install \
    && cd / \
    && emerge --info \
    && mkdir /stage1

RUN emerge --root /stage1 -ev @system

#RUN wget https://dev.gentoo.org/~vapier/bootstrap-portage

RUN [ "/usr/bin/cross-build-end" ]
RUN [ "/emu/qemu-arm", "-execve", "/emu/qemu-arm", "/bin/bash", "-c", "/emu/xbuild.uninstall" ]

ENTRYPOINT [ "/emu/qemu-arm", "-execve", "/emu/qemu-arm" ]
CMD [ "/bin/bash" ]
