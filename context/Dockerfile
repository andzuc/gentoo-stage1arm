FROM andzuc/gentoo-armbuilder-seed0 as seed
FROM andzuc/gentoo-armqemu as qemu
FROM scratch

COPY --from=seed /builder/seed /
COPY --from=qemu /usr/bin/qemu-arm /usr/bin/

RUN [ "/usr/bin/qemu-arm", "--execve", "/usr/bin/qemu-arm", "/bin/bash", "-c", "/bin/echo Hello from ARM container" ]

ENTRYPOINT [ "/usr/bin/qemu-arm", "-execve", "/usr/bin/qemu-arm" ]
CMD [ "/bin/bash" ]
