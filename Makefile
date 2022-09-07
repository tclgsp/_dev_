ifeq ($(GSP_ALLMODS),1)
$(info here)
GSP_MODS := $(shell $(MAKE) --no-print-directory -C core -f gsp.mk show_gsp_mods)
endif

all: core-current
	$(MAKE) GSP_ALLMODS=1 _all_

all-%: core-%
	$(MAKE) GSP_ALLMODS=1 _all_

ifdef GSP_MODS
$(info here1)
_all_: $(GSP_MODS)
	@true
endif

%-current:
	cd $*; \
	  tar -c * | xz > ../$*-current.txz

%-last:
	cd $*; \
	  git checkout master; \
	  git ls-files | tar -cT- | xz > ../$*-last.txz

%:
	MODNAME=`echo $@ | sed -r 's/^([^-]+)-.+$$/\1/'`; \
	  MODVER=`echo $@ | sed -r 's/^[^-]+-(.+)$$/\1/'`; \
	  cd $$MODNAME; \
	  git checkout $$MODVER; \
	  git ls-files | tar -cT- | xz > ../$@.txz

