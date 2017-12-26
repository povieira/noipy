VERSION := $(shell python -c "from __future__ import print_function; import noipy; print('v%s' % noipy.__version__)")

.PHONY: all
all: clean test dist
	@echo "=> All set up."
	@echo "=> execute *make publish* to upload to PyPI repository."

init:
	@echo "=> Installing dev dependencies"
	pip install -r requirements-dev.txt

dist: clean
	@echo "=> Building packages"
	python setup.py sdist bdist_wheel

.PHONY: test
test: init
	@echo "=> Running tests"
	tox --skip-missing-interpreters

pep8:
	@echo "=> Running pep8"
	tox --skip-missing-interpreters -e pep8

.PHONY: clean
clean:
	@echo "=> Cleaning..."
	find . -type f -name "*.pyc" -delete
	rm -rf dist/
	rm -rf build/

.PHONY: publish
publish: dist
	@echo "=> Publishing [noipy $(VERSION)] on PyPI test repository"
	twine upload -r test dist/*
	@echo "=> execute *twine upload -r test dist/* to upload to PyPI repository."
