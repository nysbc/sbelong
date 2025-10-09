#!/bin/bash

# TODO Convert this to a makefile/containerfile.  Create an automated build pipeline.

wget https://github.com/niess/python-appimage/releases/download/python3.10/python3.10.18-cp310-cp310-manylinux2014_x86_64.AppImage
chmod +x python3.10.18-cp310-cp310-manylinux2014_x86_64.AppImage
./python3.10.18-cp310-cp310-manylinux2014_x86_64.AppImage --appimage-extract
mv squashfs-root python3.10.18-cp310-cp310-manylinux2014_x86_64.AppDir
ln -s python3.10 python3.10.18-cp310-cp310-manylinux2014_x86_64.AppDir/opt/python3.10/bin/python
export PATH=/h2/jpellman/partition_set_membership/python3.10.18-cp310-cp310-manylinux2014_x86_64.AppDir/opt/python3.10/bin:${PATH}
export PYTHONHOME=/h2/jpellman/partition_set_membership/python3.10.18-cp310-cp310-manylinux2014_x86_64.AppDir/opt/python3.10/
export VIRTUAL_ENV=/h2/jpellman/partition_set_membership/python3.10.18-cp310-cp310-manylinux2014_x86_64.AppDir/opt/python3.10
cp ./bin/sbelong /h2/jpellman/partition_set_membership/python3.10.18-cp310-cp310-manylinux2014_x86_64.AppDir/opt/python3.10/bin
cat << 'EOF' > ./python3.10.18-cp310-cp310-manylinux2014_x86_64.AppDir/AppRun
#! /bin/bash

# If running from an extracted image, then export ARGV0 and APPDIR
if [ -z "${APPIMAGE}" ]; then
    export ARGV0="$0"

    self=$(readlink -f -- "$0") # Protect spaces (issue 55)
    here="${self%/*}"
    tmp="${here%/*}"
    export APPDIR="${tmp%/*}"
fi

# Resolve the calling command (preserving symbolic links).
export APPIMAGE_COMMAND=$(command -v -- "$ARGV0")

# Export TCl/Tk
export TCL_LIBRARY="${APPDIR}/usr/share/tcltk/tcl8.6"
export TK_LIBRARY="${APPDIR}/usr/share/tcltk/tk8.6"
export TKPATH="${TK_LIBRARY}"

# Export SSL certificate
export SSL_CERT_FILE="${APPDIR}/opt/_internal/certs.pem"

# Call Python
"$APPDIR/opt/python3.10/bin/python3.10" "$APPDIR/opt/python3.10/bin/${ARGV0}" 
EOF
python -m pip install poetry
poetry install
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage 
./appimagetool-x86_64.AppImage python3.10.18-cp310-cp310-manylinux2014_x86_64.AppDir sbelong
chmod +x sbelong
