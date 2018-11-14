FROM andzuc/gentoo-stage3amd64

# emerge qemu
RUN USE="static-user" \
    QEMU_USER_TARGETS="arm" \
    emerge -pv app-emulation/qemu
