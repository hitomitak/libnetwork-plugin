[![Build Status](https://semaphoreci.com/api/v1/projects/d51a0276-7939-409e-80ac-aa5df9421fef/510521/badge.svg)](https://semaphoreci.com/calico/libnetwork-plugin)

# Libnetwork plugin for Calico

This plugin for Docker networking ([libnetwork](https://github.com/docker/libnetwork)) is intended for use with [Project Calico](http://www.projectcalico.org).
The plugin is integrated with the `calico/node` image which is created from the [calicoctl](https://github.com/projectcalico/calicoctl) repository, but it can also be run in it's own Docker container or as a standalone binary.

Guides on how to get started with the plugin and further documentation is available from http://docs.projectcalico.org

## Supported options for confguration
To change the prefix used for the interface in containers that Docker runs, set the `CALICO_LIBNETWORK_IFPREFIX` environment variable.
* The default value is "cali"

### Working with Networks
* When creating a network, the `--subnet` option can be passed to `docker network create`. The subnet must match an existing Calico pool, and any containers created on that network will use an IP address from that Calico Pool.
* Other than `--driver` and `--ipam-driver`, no other options are supported on the `docker network create` command.

### Working with Containers
When creating containers, use the `--net` option to connect them to a network previously created with `docker network create`

* The `--ip` option can be passed to `docker run` to assign a specific IP to a container.
* The `--mac` and `--link-local` options are currently unsupported.

## Working with the code

* Clone the repo (clone it into your GOPATH and make sure you use projectcalico in the path, not your fork name).
* Create the vendor directory (`make vendor`). This uses `glide` in a docker container to create the vendor directory.
* Build it in a container using `make dist/libnetwork-plugin`. The plugin binary will appear in the `dist` directory.
* Running tests can be done in a container using `make test-containerized`. Note: This works on linux, but can require additional steps on Mac.
* Submit PRs through GitHub. Before merging, you'll be asked to squash your commits together, so 1 PR = 1 commit.
* Before submitting your PR, please make sure tests pass and run `make static-checks`. Both these will be done by the CI system too though.

## How to Run It During Development
`make run-plugin`

Running the plugin in a container requires a few specific options
 `docker run --rm --net=host --privileged -e CALICO_ETCD_AUTHORITY=$(LOCAL_IP_ENV):2379 -v /run/docker/plugins:/run/docker/plugins -v /var/run/docker.sock:/var/run/docker.sock --name calico-node-libnetwork calico/node-libnetwork /calico`

- `--net=host` Host network is used since the network changes need to occur in the host namespace
- `privileged` since the plugin creates network interfaces
- `-e CALICO_ETCD_AUTHORITY=a.b.c.d:2379` to allow the plugin to find a backend datastore for storing information
- `-v /run/docker/plugins:/run/docker/plugins` allows the docker daemon to discover the plugin
- `-v /var/run/docker.sock:/var/run/docker.sock` allows the plugin to query the docker daemon

## Known limitations
The following is a list of known limitations when using the Calico libnetwork
driver:
-  It is not possible to add multiple networks to a single container.  However,
   once a container endpoint is created, it is possible to manually add 
   additional Calico profiles to that endpoint (effectively adding the 
   container into another network).
- IPv6 is not currently supported

## Troubleshooting

### Logging
Logs are sent to STDOUT. If using Docker these can be viewed with the 
`docker logs` command.


[![Analytics](https://calico-ga-beacon.appspot.com/UA-52125893-3/libnetwork-plugin/README.md?pixel)](https://github.com/igrigorik/ga-beacon)
