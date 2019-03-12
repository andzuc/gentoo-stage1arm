FROM andzuc/gentoo-armbuilder-seed0 as seed
FROM scratch

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
    && gcc -dumpmachine

#RUN wget https://dev.gentoo.org/~vapier/bootstrap-portage

RUN [ "/usr/bin/cross-build-end" ]
RUN [ "/emu/qemu-arm", "-execve", "/emu/qemu-arm", "/bin/bash", "-c", "/emu/xbuild.uninstall" ]

ENTRYPOINT [ "/emu/qemu-arm", "-execve", "/emu/qemu-arm" ]
CMD [ "/bin/bash" ]
