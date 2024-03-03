FROM registry.fedoraproject.org/fedora-toolbox:39

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="Adds several useful tools I regularly use on top of the fedora container." \
      maintainer="nachtjasmin@posteo.de"

# Enforce fish as the shell
ENV SHELL=/usr/bin/fish

# Install additional packages
COPY extra-packages /
RUN dnf -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    grep -v '^#' /extra-packages | xargs dnf -y install --setopt=install_weak_deps=False && \
    rm /extra-packages && \
	dnf clean all

# Install fish script for automatic dotfile configuration.
COPY install-dotfiles.fish /etc/fish/conf.d/

# Setup shim for common host-only binaries
COPY flatpak-spawn-host.sh /usr/local/bin/flatpak-spawn-host
RUN \
    ln -sf /usr/bin/flatpak-xdg-email /usr/local/bin/xdg-email && \
    ln -sf /usr/bin/flatpak-xdg-open /usr/local/bin/xdg-open && \
    ln -sf /usr/local/bin/flatpak-spawn-host /usr/local/bin/podman
