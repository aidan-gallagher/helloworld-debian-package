FROM debian:11
USER root

# Prevent apt from asking the user questions like which time zone.
ARG DEBIAN_FRONTEND=noninteractive

# --------------------- Add docker user & set working dir -------------------- #
# Add docker user and set the user ID.
ARG UID=1000
RUN echo $UID
RUN useradd --shell /bin/bash --uid $UID --create-home docker
# Set password to `docker`.
RUN echo "docker:docker" | chpasswd
# Provide sudo permissions.
RUN apt-get update --yes \
    && apt-get install --yes sudo
RUN adduser docker sudo
WORKDIR /home/docker/code
# ---------------------------------------------------------------------------- #


# ---------------------- Install useful developer tools ---------------------- #
RUN apt-get update --yes \
    && apt-get install --yes \
    iputils-ping \
    openssh-client \
    nano
# ---------------------------------------------------------------------------- #


# ---------------- Install Debian build/packaging dependencies --------------- #
# Install mk-build-deps program.
RUN apt-get install --yes devscripts equivs
# Only copy the debian control file as it describes the projects build/packaging dependencies.
COPY ./debian/control /tmp/control
# Create build/packaging dependency package.
RUN mk-build-deps /tmp/control
# Install build/packaging dependency package.
RUN apt install --yes ./*-build-deps*.deb
# Remove generated files.
RUN rm *.buildinfo *.changes *.deb
# ---------------------------------------------------------------------------- #


# ----------------- Parent directory permissions work around ----------------- #
# dpkg-buildpackage deposits debs (and temp files) in the parent directory.
# Currently there is no way to specify a different directory (https://groups.google.com/g/linux.debian.bugs.dist/c/1KiGKfuFH3Y).
# Non root users do not always have permission to write to the parent directory (depending on where the workspace is mounted).
# Change parent directories of known mount location to have write permissions for all users.

# Jenkins mounts the directory at /var/lib/jenkins/workspace/DANOS_{REPO}_PR-XXX.
RUN mkdir -p /var/lib/jenkins/workspace/ \
    && chmod -R a+w /var/lib/jenkins/workspace/

# VSCode mounts the directory at /workspaces/{REPO}
RUN mkdir -p /workspaces \
    && chmod -R a+w /workspaces
# ---------------------------------------------------------------------------- #
