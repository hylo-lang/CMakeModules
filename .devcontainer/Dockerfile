ARG SWIFT_VERSION

FROM swift:${SWIFT_VERSION}

RUN apt update
RUN apt install -y make wget ninja-build lsb-release software-properties-common gnupg

#
# Get a recent cmake (https://askubuntu.com/a/865294)
#

# A-1. Uninstall the default version provided by Ubuntu's package manager and configuration
RUN if $(/usr/bin/which cmake) ; then apt purge --auto-remove cmake ; fi

# A-2. Prepare for installation
RUN apt clean all

# A-3. Obtain a copy of kitware's signing key.
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

# A-4. Add kitware's repository to your sources list
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"

# A-5. As an optional step, is recommended that we also install the kitware-archive-keyring package to ensure that Kitware's keyring stays up to date as they rotate their keys.
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1A127079A92F09ED
RUN apt update
RUN apt install -y kitware-archive-keyring
RUN rm /etc/apt/trusted.gpg.d/kitware.gpg

# A-6. Finally we can update and install the cmake package.
RUN apt update
RUN apt install -y cmake

# Despite the fact that we have installed the key with apt-key above,
# this presence of repository creates GPG signing errors for
# devcontainer feature installation such as common-utils (see
# devcontainer.json).  Now that we have cmake installed we can drop it.
RUN apt-add-repository --remove "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"

