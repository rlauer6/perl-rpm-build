RPMROOT = ~/rpm

ifeq ($(MAKECMDGOALS), clean)
else
ifndef MODULE
$(error MODULE is not set)
else
include VERSION
endif
endif


ifneq ($(MAKECMDGOALS), clean)
# name of the file containing VERSION_NUM = version

VERSION_FILE = VERSION

MODULE_NORMALIZED = $(subst ::,-,$(MODULE))

SPEC_FILE = \
    perl-$(MODULE_NORMALIZED).spec.in

GSPEC_FILE = $(SPEC_FILE:.spec.in=.spec)

TARBALL = $(GSPEC_FILE:.spec=)-$(VERSION_NUM).tar.gz

RPM = $(GSPEC_FILE:.spec=)-$(VERSION_NUM)-0.noarch.rpm

all: rpm

$(SPEC_FILE): perl-module.spec.in
	cp $< $@

$(VERSION_FILE):
	if test -z "$(VERSION)"; then \
	  module=$$(echo $(MODULE) | sed 's/::/-/g'); \
	  info=$$(cpanm --info -l . $(MODULE)); \
	  version=$$(echo $$info | perl -npe 's/^(.*?)$$module\-([0-9\.]+)(\-[0-9]*)?\.tar\.gz$$/$$2/'); \
	  echo "VERSION_NUM = $$version" > $@; \
	else \
	  echo "VERSION_NUM = $(VERSION)" > $@; \
	  $(eval VERSION := '') \
	  $(MAKE); \
	fi

$(GSPEC_FILE): $(SPEC_FILE)
	module=$$(echo $(MODULE) | sed 's/::/-/g'); \
	package=$$(echo perl-$$module); \
	sed -e 's/@VERSION@/'$(VERSION_NUM)'/g' \
	    -e 's/@MODULE@/'$(MODULE)'/g' \
	    -e 's/@PACKAGE@/'$$package'/g' < $< > $@

.PHONY: tarball

tarball: $(TARBALL)

$(TARBALL): $(GSPEC_FILE) VERSION
	builddir="$$(basename $< .spec)-$(VERSION_NUM)"; \
	echo $$builddir; \
	mkdir $$builddir || true; \
	cp $< $$builddir/; \
	tar cfvz $@ $$builddir/;

$(RPM):	$(TARBALL)
	rpmbuild --clean -tb $<
	cp $(RPMROOT)/RPMS/noarch/$@ $@

.PHONY: rpm

rpm: $(RPM)

endif

clean:
	rm -f *.tar.gz
	rm -f *.rpm
	rm -f VERSION
	for a in $$(ls *.spec.in *.spec); do \
	  echo $$a | grep -v "^perl\-module" && rm -f $$a || true; \
	done
	for a in $$(ls -1 | grep '^perl'); do \
	  if test -d $$a;  then \
	    rm -rf $$a || true; \
	  fi; \
	done
