FROM dorowu/ubuntu-desktop-lxde-vnc:focal

USER root

# Eliminar repositorios caducados y configurar Wine 32-bit
RUN rm -f /etc/apt/sources.list.d/google-chrome.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wine \
        wine32 \
        cabextract \
    && rm -rf /var/lib/apt/lists/*

# Fijar resolución para TORA (800x600)
ENV RESOLUTION=800x600

# Directorio de trabajo y binarios
WORKDIR /app
COPY ./TORA /app/TORA

# Script lanzador asegurando el directorio de trabajo de los archivos
RUN printf '#!/bin/bash\ncd /app/TORA\nwine tora.exe\n' > /app/run-tora.sh && \
    chmod +x /app/run-tora.sh

# 1) Acceso directo visible en el escritorio
RUN mkdir -p /root/Desktop && \
    printf '[Desktop Entry]\nType=Application\nName=TORA\nExec=/app/run-tora.sh\nIcon=system-run\nTerminal=false\n' > /root/Desktop/TORA.desktop && \
    chmod +x /root/Desktop/TORA.desktop

# 2) Autostart para que abra apenas cargue LXDE
RUN mkdir -p /root/.config/lxsession/LXDE && \
    echo '@/app/run-tora.sh' >> /root/.config/lxsession/LXDE/autostart