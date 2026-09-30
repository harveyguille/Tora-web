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

# Registrar dependencias ActiveX de VB6 e iniciar TORA en el autostart de LXDE
RUN mkdir -p /root/.config/lxsession/LXDE && \
    echo '@wine /app/TORA/tora.exe' >> /root/.config/lxsession/LXDE/autostart