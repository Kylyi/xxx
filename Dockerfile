# Use Ubuntu 20.04 as base image
FROM ubuntu:20.04

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    ghostscript \
    wget \
    unzip && \
    apt-get clean

# Set working directory for the application
WORKDIR /app

# Copy the necessary files into the container
COPY PDFA_def.ps ./PDFA_def.ps
COPY sRGB.icc ./sRGB.icc
COPY Zadost.pdf ./Zadost.pdf

# Adjust permissions for all files to ensure readability
RUN chmod 644 PDFA_def.ps sRGB.icc Zadost.pdf

# Run the Ghostscript command to process the PDF
CMD gs \
    # --permit-devices=pdfwrite \
    # --permit-file-read='*' \
    -dPDFA=3 \
    -dBATCH \
    -dNOPAUSE \
    -dNOOUTERSAVE \
    -dUseCIEColor=true \
    -sColorConversionStrategy=sRGB \
    -sProcessColorModel=DeviceRGB \
    -dConvertCMYKImagesToRGB=true \
    -dConvertGrayImagesToRGB=true \
    -sDEVICE=pdfwrite \
    -dPDFACompatibilityPolicy=1 \
    -dEmbedAllFonts=true \
    -sFONTPATH=/usr/share/fonts \
    -sOutputFile=./Zadost-a3.pdf \
    ./PDFA_def.ps \
    ./Zadost.pdf && \
    echo "PDF transformation complete. Output: Zadost-a3.pdf"
