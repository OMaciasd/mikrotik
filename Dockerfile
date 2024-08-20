# Usa una imagen base de Ubuntu
FROM ubuntu:noble-20240429

# Establece las etiquetas "Name" y "Version" para identificar la imagen
LABEL Name="routeros-mikrotik-container"
LABEL Version="1.0"

# Instala QEMU, wget, unzip, binwalk y limpia los archivos de lista de apt en la misma capa
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        qemu-system \
        wget \
        unzip \
        binwalk \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://download.mikrotik.com/routeros/6.49.15/install-image-6.49.15.zip && \
    unzip install-image-6.49.15.zip && \
    binwalk --run-as=root -e install-image-6.49.15.img

# Añade un comando para listar el contenido del directorio de extracción
RUN ls -R /install-image-6.49.15.img.extracted

# Expone el puerto en el que QEMU va a funcionar (ejemplo: 8080)
EXPOSE 8080

# Define el comando de inicio del contenedor
CMD ["qemu-system-mips", "-M", "malta", "-kernel", "/install-image-6.49.15.img.extracted/vmlinux", "-append", "console=ttyS0"]
