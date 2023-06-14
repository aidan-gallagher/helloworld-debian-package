commits := main..HEAD

all: black mypy pytest coverage gitlint whitespace package lintian clean
	@echo SUCCESS

black:
	black --check .

mypy:
	mypy .

pytest:
	python3-coverage run -m pytest 

coverage:
	python3-coverage html
	python3-coverage report

gitlint:
	gitlint --commits $(commits)

whitespace:
#	Check changed files for trailing whitespace.
	$(eval changed_files := $(shell git diff -G'.' --diff-filter=rd --find-renames=100% --name-only $(commits) | tr '\n' ' '))
#	/dev/null prevents grep from hanging if changed_files is empty
	! grep --with-filename --line-number --only-matching "\s$$" $(changed_files) /dev/null

package:
	dpkg-buildpackage -uc -us
	mkdir -p deb_packages
	cp ../*.deb ./deb_packages/
	dh_clean

lintian:
	lintian --fail-on warning

clean:
	dh_clean
	py3clean .
	rm -rf htmlcov/ .coverage

build-container:
	sudo docker image build \
		--build-arg UID=$$(id -u) \
		--tag example-project \
		.

run-container:
	sudo docker run \
		--interactive \
		--tty \
		--mount type=bind,src=${PWD},dst=/workspaces/code \
		--mount type=bind,src=${HOME}/.gitconfig,dst=/home/docker/.gitconfig \
		--mount type=bind,src=${HOME}/.ssh,dst=/home/docker/.ssh \
		--mount type=bind,src=${HOME}/.bash_history,dst=/home/docker/.bash_history \
		--user $$(id -u):$$(id -g) \
		--rm \
		example-project
