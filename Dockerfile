FROM ghcr.io/nysbc/python-appimage-buildenv:latest
ENV WORKDIR=/build/work
WORKDIR $WORKDIR

RUN wget https://github.com/niess/python-appimage/releases/download/python3.10/python3.10.18-cp310-cp310-manylinux2014_x86_64.AppImage && \
	chmod +x python3.10.18-cp310-cp310-manylinux2014_x86_64.AppImage && \
	./python3.10.18-cp310-cp310-manylinux2014_x86_64.AppImage --appimage-extract && \
	mv squashfs-root sbelong.AppDir

RUN  ln -s python3.10 sbelong.AppDir/opt/python3.10/bin/python
ADD "https://api.github.com/repos/nysbc/sbelong/commits?per_page=1" latest_commit
RUN git clone https://github.com/nysbc/sbelong.git sbelong
RUN cp ./sbelong/src/sbelong $WORKDIR/sbelong.AppDir/opt/python3.10/bin/
RUN cp ./sbelong/src/AppRun $WORKDIR/sbelong.AppDir/AppRun

#ENV PATH=/$WORKDIR/sbelong.AppDir/opt/python3.10/bin:$PATH
#ENV PYTHONHOME /$WORKDIR/sbelong.AppDir/opt/python3.10/
ENV VIRTUAL_ENV $WORKDIR/sbelong.AppDir/opt/python3.10

RUN cd sbelong && poetry install

# This needs to be run on host.
#RUN /opt/appimagetool-x86_64.AppImage sbelong.AppDir sbelong && mv sbelong /build/artifacts
