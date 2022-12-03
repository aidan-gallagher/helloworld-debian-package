# Introduction

This is an example project to demonstrate how to implement a continuous integration pipeline using Docker and GNU Make.
The benefits of this design are covered in my [Continuous Integration Pipeline article](https://aidan-gallagher.github.io/blog/continuous-integration-pipeline/).

# Contents Description

## HelloWorld/

This is where your business logic will reside. This example application will simply print "Hello World" to the terminal.

## Debian/

This contains the packaging information for the project. More information on debian packaging can be found on the [Debian Wiki](https://wiki.debian.org/Packaging).
The `Build-Depends:` section of the Debian/control file describes the dependencies needed to build this repository.

## Makefile

This is used as a task runner to invoke other tools correctly.

## Dockerfile

This describes the environment for the developer or CI system to run in.

## .github/workflows

This describes the CI pipeline.

# How to use

## Locally

1. Clone the repository and enter the directory.

```
git clone git@github.com:aidan-gallagher/ci-pipeline-example.git
cd ci-pipeline-example
```

1. Build the container.

```
make build-container
```

2. Run the container.

```
make run-container
```

3. Make some dummy change to the program.  
   Change the `hello_world()` function to return a different string.

4. Verify your changes pass all the automatic checks.

```
make all
```

5. Install your newly created debian package.

```
sudo apt install ./deb_packages/hello-world_1.0.0_all.deb
```

6. Run your new program.

```
hello-world
```

## On Server

Github actions will:

1. Build the development container and upload it to [dockerhub](https://hub.docker.com/repository/docker/aidangallagher/helloworld-build-container).
2. Enter the build container
3. Run all the code checks via the makefile.

The results can be viewed on the [Actions tab](https://github.com/aidan-gallagher/ci-pipeline-example/actions) on Github.
