# ABOUT

Setup a Docker-based development environment and private network for Bitmessage.

This project sets up a Docker image with dependencies to run Bitmessage (PyBismessage reference client) in a local 
uration, suitable for development and local testing.

Note that you will need Docker installed, you can get Docker [here](), along with instructions to install on your platform.

Note also that I run my development environment in a Ubuntu 16.10 VM (VirtualBox), this is the platform that the following has been tested on.

## CONFIG

You will need to clone the Git repositories for the [PyBitmessage codebase](https://github.com/Bitmessage/PyBitmessage) and [this repo](https://github.com/ianco/bitmessage-dev):

I keep all my code under ~/Projects:

```
cd ~
mkdir Projects
cd Projects
git clone https://github.com/Bitmessage/PyBitmessage.git
git clone https://github.com/ianco/bitmessage-dev.git
```

Another note - I run this in a VM so I can disable external networking.  Although the code is configured for a local network, the PyBitmessage client still seems to "reach out" to external peers.  I prefer to disable this to keep a clean local test network.

## USAGE

Now cd into the bitcoin-dev directory and create the Docker image:

```
## Run make to build the Docker image (see Dockerfile for all the dependencies)
make build-base
docker images
```
Once the image is built you can run it, and use the image to run the Bitmessage client.  Note that the code is checked out on the host, but the configuration is saved on the Docker container, so that mutiple instances of the image can be run.

A couple of notes:

- The config files that are copied to the base image setup a local test network
- "knownnodes.dat" contains a single reference to "172.17.0.2:8444" - this should be the IP and port of the first Docker container you run - edit this file if you get a different IP
- There are two versions of "keys.dat", one for each Docker container - they will expose ports 8444 and 8555 respectively

Run the first image and copy the appropriate 'keys.dat" file:

```
## startup "alice" docker container, copy keys.dat and run bitmessage
make alice_shell 
make alice_daemon
docker inspect alice
```

The "docker inspect" should confirm alice's IP address, if it is not 172.17.0.2 you will need to update bob's "knownnodes.dat" file.

A bitmessage GUI should have started up when you started "alice", and it should show a status of "red".  The network should not show any connections.  If it does, make sure you disable your VM's networking, shutdown the Docker container and re-start it.





