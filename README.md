# Introduction

This is an example project to demonstrate how to create a Debian package.

# Contents Description

## HelloWorld/

This is where your business logic will reside. This example application will simply print "Hello World" to the terminal.

## Debian/

This contains the packaging information for the project. More information on debian packaging can be found on the [Debian Wiki](https://wiki.debian.org/Packaging).
The `Build-Depends:` section of the Debian/control file describes the dependencies needed to build this repository.

# How to use
## Basic Approach

1. Clone the repository and enter the directory.

```
git clone git@github.com:aidan-gallagher/helloworld-debian-package.git
cd helloworld-debian-package
```

1. Install the dependencies

```
sudo apt-get update
sudo apt-get install --yes --fix-missing devscripts equivs
sudo mk-build-deps --install --remove
```

2. Build the package (without signing it)

```
dpkg-buildpackage --no-sign
```

3. Clean up build files
```
dh_clean
```

3. Install your newly created package
```
dpkg -i ../hello-world_1.0.0_all.deb 
```

6. Run your new program.

```
hello-world
```

## Debpic Approach
Using the approach above you do the building and packaging on your host OS. This means your limited to building for the distro which are currently using, you are required to download and install all the build dependencies.

Alternatively you can use [debpic](https://github.com/aidan-gallagher/debpic) which will run all the build and packaging steps inside a docker container.

1. Clone the repository and enter the directory.

```
git clone git@github.com:aidan-gallagher/helloworld-debian-package.git
cd helloworld-debian-package
```

2. Build the package (without signing it)
```
debpic -- --no-sign
```

3. Install your newly created package
```
dpkg -i ./built_packages/hello-world_1.0.0_all.deb 
```