FROM andzuc/gentoo-stage3amd64

# emerge qemu
RUN USE="static-libs" emerge -v =dev-libs/glib-2.52.3:2
RUN USE="static-user" \
    QEMU_USER_TARGETS="arm" \
    emerge -pv app-emulation/qemu
