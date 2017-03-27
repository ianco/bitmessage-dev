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

The resulting Docker image is configured to run a local network.  There are config files that are loaded into the container to specify a local "known node" and to disable the DNS lookup for external hosts.  However there is one change you will need to make, edit "defaultknownnodes.py", comment out the "known nodes" and add the IP for your local instance, like so:

```
    ############## Stream 1 ################
    stream1 = {}

    #stream1[state.Peer('2604:2000:1380:9f:82e:148b:2746:d0c7', 8080)] = int(time.time())
    # ...
    #stream1[state.Peer('178.11.46.221', 8444)] = int(time.time())
    stream1[state.Peer('172.17.0.2', 8444)] = int(time.time())
```

## USAGE

Now cd into the bitmsg-dev directory and create the Docker image:

```
## Run make to build the Docker image (see Dockerfile for all the dependencies)
make build-base
docker images
```
Once the image is built you can run it, and use the image to run the Bitmessage client.  Note that the code is checked out on the host, but the configuration is saved on the Docker container, so that mutiple instances of the image can be run.

A couple of notes:

- The config files are copied to the base image setup a local test network
- "knownnodes.dat" contains a single reference to "172.17.0.2:8444" - this should be the IP and port of the first Docker container you run - edit this file if you get a different IP
- There are two versions of "keys.dat", one for each Docker container - they will expose ports 8444 and 8555 respectively

Note that at this point (before running either image), I disable networking on my dev VM.  This ensures that the images will connect to the local test network and not to the production Bitmessage network.  Note also that you may need top open up X security ("xhost +") to allow the Docker containers to access the host X window server - this is a "security issue" (since anyone can now connect to your X server) which is another good reason to disable the VM network.  Otherwise you can setup a more restrictive security policy for your Docker "bitmsg user.

Run the first image and copy the appropriate 'keys.dat" file:

```
## startup "alice" docker container, copy keys.dat and run bitmessage
make alice_shell 
make alice_daemon
docker inspect alice
```

The "docker inspect" should confirm alice's IP address, if it is not 172.17.0.2 you will need to update bob's "knownnodes.dat" file.

A bitmessage GUI should have started up when you started "alice", and it should show a status of "red".  The network should not show any connections.  If it does, make sure you disable your VM's networking, shutdown the Docker container and re-start it.

Now startup "bob" - it should connect to alice and both bob and alice should show "yellow" and one peer connection:

```
## startup "bob" docker container and run bitmessage

make bob_shell 
make bob_daemon
docker inspect bob
docker ps
```

Once you have both containers running, they should connect to each other and should both turn green (or yellow).

You can now create identities and send messages between the two nodes.  If you like you can spawn additional instances of the Docker container and add more nodes to your network!



