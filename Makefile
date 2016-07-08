GIT=git
PYTHON=python
PIP=pip
GITUSER=git
GITHUB=github.com
GITLIBRABBITMQ=celery/librabbitmq
LIBRABBITMQ=librabbitmq


all: help

init:
	$(GIT) submodule update --init --recursive

develop:
	$(GIT) submodule foreach $(PYTHON) setup.py develop
	(cd billiard; $(PYTHON) setup.py install)

install:
	$(GIT) submodule foreach $(PYTHON) setup.py install

pull:
	$(GIT) submodule foreach $(GIT) pull --rebase

push:
	$(GIT) submodule foreach $(GIT) push

$(LIBRABBITMQ):
	$(GIT) clone "$(GITUSER)@$(GITHUB):$(GITLIBRABBITMQ)" $@

clean-$(LIBRABBITMQ):
	(cd $(LIBRABBITMQ); $(GIT) diff-index --quiet HEAD --)
	rm -rf $(LIBRABBITMQ)

select-$(LIBRABBITMQ): $(LIBRABBITMQ)
	(cd $(LIBRABBITMQ); $(PYTHON) setup.py install)

uninstall-$(LIBRABBITMQ):
	-$(PIP) uninstall -y $(LIBRABBITMQ)

deselect-$(LIBRABBITMQ): clean-$(LIBRABBITMQ) uninstall-$(LIBRABBITMQ)

master:
	$(GIT) submodule foreach $(GIT) checkout master

5.0-devel: master
	(cd celery; $(GIT) checkout 5.0-devel)

3.1:
	(cd py-amqp; $(GIT) checkout 1.4)
	(cd kombu; $(GIT) checkout 3.0)
	(cd billiard; $(GIT) checkout 3.3)
	(cd celery; $(GIT) checkout 3.1)

3.0:
	(cd py-amqp; $(GIT) checkout 1.0)
	(cd kombu; $(GIT) checkout 3.0)
	(cd billiard; $(GIT) checkout 2.7)
	(cd celery; $(GIT) checkout 3.0)

2.5:
	(cd kombu; $(GIT) checkout 2.1-archived)
	(cd celery; $(GIT) checkout 2.5-archived)

clean-dist:
	$(GIT) submodule foreach $(MAKE) $@

clean-git-force:
	$(GIT) submodule foreach $(MAKE) $@

clean:
	$(GIT) submodule foreach $(MAKE) $@

clean-pyc:
	$(GIT) submodule foreach $(MAKE) $@

clean-docs:
	$(GIT) submodule foreach $(MAKE) $@

clean-build:
	$(GIT) submodule foreach $(MAKE) $@

help:
	@echo "init                 - Fetch and update all submodules."
	@echo "pull                 - Pull changes from all repositories."
	@echo "push                 - Push changes from all repositories."
	@echo "develop              - Run setup.py develop for all modules."
	@echo "install              - Run setup.py install for all modules."
	@echo "master               - Select Celery development version"
	@echo "5.0-devel            - Select Celery 5.0 development version."
	@echo "3.1                  - Select Celery 3.1 series."
	@echo "3.0                  - Select Celery 3.0 series."
	@echo "2.5                  - Select Celery 2.5 series."
	@echo "clean-dist --------- - Clean all distribution build artifacts."
	@echo "  clean-git-force    - Remove all uncomitted files."
	@echo "  clean ------------ - Non-destructive clean"
	@echo "    clean-pyc        - Remove .pyc/__pycache__ files"
	@echo "    clean-docs       - Remove documentation build artifacts."
	@echo "    clean-build      - Remove setup artifacts."
	@echo "select-librabbitmq   - Add and install librabbitmq."
	@echo "deselect-librabbitmq - Remove and uninstall librabbitmq."
	@echo "clean-librabbitmq    - Remove librabbitmq directory if no changes."
