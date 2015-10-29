all: 
	$(MAKE) clean
	$(MAKE) build unittest check_convention CONFIGURATION=DEBUG
	$(MAKE) clean
	$(MAKE) build unittest egg

clean:
	rm -fr build dist osmosis.egg-info

.PHONY: build
build: build/cpp-netlib-0.11.1-final/.unpacked
	$(MAKE) -f build.Makefile

build/cpp-netlib-0.11.1-final/.unpacked: cpp-netlib-0.11.1-final.tar.gz
	mkdir build > /dev/null 2> /dev/null || true
	tar -xf $< -C build
	touch $@

.PHONY: egg
egg: dist/osmosis-1.0.linux-x86_64.tar.gz

unittest: build
	PYTHONPATH=py python tests/main.py
	build/cpp/testtaskqueue.bin

check_convention:
	pep8 py tests --max-line-length=109

install:
	-sudo systemctl stop osmosis
	-sudo service osmosis stop
	sudo cp build/cpp/osmosis.bin /usr/bin/osmosis
	make install_service

SYSTEMD_SERVICE_DIR_RHEL_FORM=/usr/lib/systemd/system
SYSTEMD_SERVICE_DIR_UBUNTU_FORM=/lib/systemd/system
SYSTEMD_SERVICE_FILES_DIR = $(shell \
if [ -e ${SYSTEMD_SERVICE_DIR_RHEL_FORM} ]; then \
	echo ${SYSTEMD_SERVICE_DIR_RHEL_FORM}; \
else \
	echo ${SYSTEMD_SERVICE_DIR_UBUNTU_FORM}; \
fi)
install_service:
	sudo cp osmosis.service ${SYSTEMD_SERVICE_FILES_DIR}
	sudo systemctl enable osmosis.service
	if ["$(DONT_START_SERVICE)" == ""]; then sudo systemctl start osmosis; fi

uninstall:
	-sudo systemctl stop osmosis
	-sudo service osmosis stop
	-sudo systemctl disable osmosis.service
	sudo rm -f /usr/bin/osmosis
	sudo rm -f /usr/lib/systemd/system/osmosis.service /etc/init/osmosis.conf
	echo "CONSIDER ERASING /var/lib/osmosis"

dist/osmosis-1.0.linux-x86_64.tar.gz:
	cd py; python ../setup.py build
	cd py; python ../setup.py bdist
	cd py; python ../setup.py bdist_egg
	rm -fr dict osmosis.egg-info build/pybuild
	mv py/dist ./
	-mkdir build
	mv py/build build/pybuild
	mv py/osmosis.egg-info ./

prepareForCleanBuild:
	sudo yum install boost-static --assumeyes
