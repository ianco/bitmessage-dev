DOCKER_RUN=docker run -d -it --rm --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"  
DOCKER_ALICE=$(DOCKER_RUN) -p 8444:8444 --name=alice --hostname=alice
DOCKER_BOB  =$(DOCKER_RUN) -p 8555:8555 --name=bob --hostname=bob

IMG=anon-sol/bitmsg-dev

BITMSG_SRC=/home/osboxes/Projects/PyBitmessage
RUN_DAEMON=/home/osboxes/Projects/PyBitmessage/src/bitmessagemain.py
RUN_SHELL=bash

build-base:
	docker build -t anon-sol/bitmsg-dev bm-docker

alice_rm:
	-docker rm -f alice

bob_rm:
	-docker rm -f bob

alice_daemon: 
	docker exec alice cp \~/.config/PyBitmessage/keys.dat.8444 \~/.config/PyBitmessage/keys.dat
	docker exec alice $(RUN_DAEMON) &

alice_shell: alice_rm
	$(DOCKER_ALICE) -i -v $(BITMSG_SRC):$(BITMSG_SRC) $(IMG) $(RUN_SHELL)

bob_daemon: 
	docker exec bob cp \~/.config/PyBitmessage/keys.dat.8555 \~/.config/PyBitmessage/keys.dat
	docker exec bob $(RUN_DAEMON) &

bob_shell: bob_rm
	$(DOCKER_BOB) -i -v $(BITMSG_SRC):$(BITMSG_SRC) $(IMG) $(RUN_SHELL)

