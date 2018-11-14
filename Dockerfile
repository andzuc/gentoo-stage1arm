FROM andzuc/gentoo-stage3amd64

RUN USE="static" \
    QEMU_USER_TARGETS="arm" \
    emerge -pv app-emulation/qemu
