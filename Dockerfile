# DOCKER-VERSION 1.0

FROM mretegan/base:latest
MAINTAINER marius.retegan@esrf.fr

# Install
# - MESA DRI drivers for software GLX rendering
# - X11 dummy & void drivers
# - RandR utility
# - X11 xinit binary
# - reasonable fonts for UI
# - x11vnc
# - python-websockify
# - xfce4
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libgl1-mesa-dri \
  xserver-xorg-video-dummy \
  xserver-xorg-input-void \
  x11-xserver-utils \
  xinit \
  fonts-dejavu \
  x11vnc \
  websockify \
  apt-utils \
  xfce4 xfce4-goodies gnome-icon-theme && \
  rm -f /usr/share/applications/x11vnc.desktop && \
  apt-get clean

# Get modified build of noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
  rm -rf /opt/noVNC/.git

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY usr /usr
COPY var /var

RUN echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

# Check nginx config is OK
RUN nginx -t
