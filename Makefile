DOCKER_RUN=docker run -d -it --rm --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" -u bitmsg
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
	docker exec alice $(RUN_DAEMON) &

alice_shell: alice_rm
	$(DOCKER_ALICE) -v $(BITMSG_SRC):$(BITMSG_SRC) -v /home/osboxes/Projects/bitmessage-dev/config-alice/:/home/bitmsg/.config/PyBitmessage/ $(IMG) $(RUN_SHELL)

bob_daemon: 
	docker exec bob $(RUN_DAEMON) &

bob_shell: bob_rm
	$(DOCKER_BOB) -v $(BITMSG_SRC):$(BITMSG_SRC) -v /home/osboxes/Projects/bitmessage-dev/config-bob/:/home/bitmsg/.config/PyBitmessage/ $(IMG) $(RUN_SHELL)

