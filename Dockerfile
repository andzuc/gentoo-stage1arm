FROM andzuc/gentoo-stage3amd64

# emerge qemu
RUN USE="static-libs static-user" \
    QEMU_USER_TARGETS="arm" \
    emerge -v app-emulation/qemu
