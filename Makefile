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

upgrade-pip:
	$(PIP) install -U pip

reqs: reqs-vine reqs-amqp reqs-kombu reqs-celery reqs-case reqs-billiard reqs-sphinx_celery reqs-django-celery reqs-cyanide

reqs-celery: upgrade-pip
	$(PIP) install -U -r celery/requirements/default.txt
	$(PIP) install -U -r celery/requirements/test.txt
	$(PIP) install -U -r celery/requirements/pkgutils.txt
	$(PIP) install -U -r celery/requirements/docs.txt

reqs-kombu: upgrade-pip
	$(PIP) install -U -r kombu/requirements/default.txt
	$(PIP) install -U -r kombu/requirements/test.txt
	$(PIP) install -U -r kombu/requirements/pkgutils.txt
	$(PIP) install -U -r kombu/requirements/docs.txt

reqs-amqp: upgrade-pip
	$(PIP) install -U -r py-amqp/requirements/default.txt
	$(PIP) install -U -r py-amqp/requirements/test.txt
	$(PIP) install -U -r py-amqp/requirements/pkgutils.txt
	$(PIP) install -U -r py-amqp/requirements/docs.txt

reqs-vine: upgrade-pip
	-$(PIP) install -U -r vine/requirements/default.txt
	$(PIP) install -U -r vine/requirements/test.txt
	$(PIP) install -U -r vine/requirements/pkgutils.txt
	$(PIP) install -U -r vine/requirements/docs.txt

reqs-billiard: upgrade-pip
	-$(PIP) install -U -r case/requirements/default.txt
	$(PIP) install -U -r billiard/requirements/test.txt
	$(PIP) install -U -r billiard/requirements/pkgutils.txt

reqs-django-celery:
	$(PIP) install -U -r django-celery/requirements/default.txt
	$(PIP) install -U -r django-celery/requirements/test.txt
	$(PIP) install -U -r django-celery/requirements/pkgutils.txt
	$(PIP) install -U -r django-celery/requirements/docs.txt

reqs-case:
	$(PIP) install -U -r case/requirements/default.txt
	$(PIP) install -U -r case/requirements/test.txt
	$(PIP) install -U -r case/requirements/pkgutils.txt
	$(PIP) install -U -r case/requirements/docs.txt

reqs-cyanide:
	$(PIP) install -U -r cyanide/requirements/default.txt
	$(PIP) install -U -r cyanide/requirements/test.txt
	$(PIP) install -U -r cyanide/requirements/pkgutils.txt
	$(PIP) install -U -r cyanide/requirements/docs.txt

reqs-sphinx_celery:
	$(PIP) install -U -r sphinx_celery/requirements/default.txt
	$(PIP) install -U -r sphinx_celery/requirements/test.txt
	$(PIP) install -U -r sphinx_celery/requirements/pkgutils.txt

develop:
	$(GIT) submodule foreach $(PYTHON) setup.py develop
	(cd billiard; $(PYTHON) setup.py install)

install:
	$(GIT) submodule foreach $(PYTHON) setup.py install

pull:
	$(GIT) submodule foreach $(GIT) pull --rebase

push:
	$(GIT) submodule foreach $(GIT) push

assert-clean:
	$(GIT) submodule foreach $(GIT) diff-index --quiet HEAD --

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
	(cd kombu; $(GIT) checkout 5.0-devel)
	(cd py-amqp; $(GIT) checkout 3.0-devel)
	(cd vine; $(GIT) checkout 2.0-devel)

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
	@echo "reqs --------------- - Install all requirements."
	@echo "  reqs-celery        - Install Celery requirements."
	@echo "  reqs-kombu         - Install Kombu requirements."
	@echo "  reqs-amqp          - Install AMQP requirements."
	@echo "  reqs-vine          - Install Vine requirements."
	@echo "  reqs-case          - Install Case requirements."
	@echo "  reqs-cyanide       - Install Cyanide requirements."
	@echo "  reqs-django-celery - Install Django-Celery requirements."
	@echo "  reqs-sphinx_celery - Install Sphinx-Celery requirements."
	@echo "  assert-clean       - Error if any repositories changed."
	@echo "pull                 - Pull changes from all repositories."
	@echo "push                 - Push changes from all repositories."
	@echo "develop              - Run setup.py develop for all modules."
	@echo "install              - Run setup.py install for all modules."
	@echo "master               - Select Celery development version."
	@echo "5.0-devel            - Select Celery 5.0 development version."
	@echo "3.1                  - Select Celery 3.1 series."
	@echo "3.0                  - Select Celery 3.0 series."
	@echo "2.5                  - Select Celery 2.5 series."
	@echo "clean-dist --------- - Clean all distribution build artifacts."
	@echo "  clean-git-force    - Remove all uncomitted files."
	@echo "  clean ------------ - Non-destructive clean."
	@echo "    clean-pyc        - Remove .pyc/__pycache__ files"
	@echo "    clean-docs       - Remove documentation build artifacts."
	@echo "    clean-build      - Remove setup artifacts."
	@echo "select-librabbitmq   - Add and install librabbitmq."
	@echo "deselect-librabbitmq - Remove and uninstall librabbitmq."
	@echo "clean-librabbitmq    - Remove librabbitmq directory if no changes."
