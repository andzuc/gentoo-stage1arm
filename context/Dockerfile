FROM andzuc/gentoo-armbuilder-seed0 as seed
FROM scratch

COPY --from=seed /builder/seed /

ENTRYPOINT [ "/usr/bin/qemu-arm", "-execve", "/usr/bin/qemu-arm" ]
CMD [ "/bin/bash" ]
