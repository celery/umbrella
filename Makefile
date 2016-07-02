GIT=git
PYTHON=python


all:
	$(GIT) submodule update --init --recursive

develop:
	$(GIT) submodule foreach $(PYTHON) setup.py develop
	(cd billiard; $(PYTHON) setup.py install)

master:
	$(GIT) submodule foreach $(GIT) checkout master

3.1:
	(cd py-amqp; $(GIT) checkout 1.4)
	(cd kombu; $(GIT) checkout 3.0)
	(cd billiard; $(GIT) checkout 3.3)
	(cd celery; $(GIT) checkout 3.1)
