BASEDIR := $(shell git rev-parse --show-toplevel)
BUILDDIR := $(BASEDIR)/builddir
VPATH = src $(BUILDDIR)

PYTHON_APPIMAGE := /opt/appimage/bin/python3.10.19-cp310-cp310-manylinux2014_x86_64.AppImage
APPIMAGETOOL := /opt/appimage/bin/appimagetool-x86_64.AppImage
CHMOD := /usr/bin/chmod
RM := /usr/bin/rm

$(BUILDDIR):
	mkdir -p $@

sbelong.AppDir: | $(BUILDDIR)
	cd $(BUILDDIR) ; \
	$(PYTHON_APPIMAGE) --appimage-extract ; \
	mv squashfs-root sbelong.AppDir 

PYTHON_VENV := PATH=$(BUILDDIR)/sbelong.AppDir/opt/python3.10/bin:$$PATH PYTHONHOME=$(BUILDDIR)/sbelong.AppDir/opt/python3.10/ VIRTUAL_ENV=$(BUILDDIR)/sbelong.AppDir/opt/python3.10 

sbelong: AppRun sbelong.py poetry.lock pyproject.toml sbelong.AppDir
	cd $(BASEDIR) ; \
	$(PYTHON_VENV) python3.10 -m pip install poetry ; \
	$(PYTHON_VENV) poetry lock ; \
	$(PYTHON_VENV) poetry install
	cd $(BUILDDIR) ; \
	cp $(BASEDIR)/src/sbelong.py sbelong.AppDir/opt/python3.10/bin/sbelong ; \
	cp $(BASEDIR)/src/AppRun sbelong.AppDir/AppRun ; \
	$(APPIMAGETOOL) sbelong.AppDir sbelong ; \
	$(CHMOD) +x sbelong

clean:
	if [ -d $(BUILDDIR) ] ; then \
		$(RM) -rf $(BUILDDIR);\
	fi
