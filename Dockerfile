FROM andzuc/gentoo-stage3amd64

RUN USE="static-user" \
    QEMU_USER_TARGETS="arm" \
    emerge -pv app-emulation/qemu
