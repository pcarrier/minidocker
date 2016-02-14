[![Build status](https://travis-ci.org/pcarrier/minidocker.svg?branch=master)](https://travis-ci.org/pcarrier/minidocker)

# minidocker

A few minimal images based on Alpine Linux, exposed via https://hub.docker.com/u/grab/

`./build.sh` should work from any Unix with a configured docker client (tested on OSX and Alpine).

To get a new repo, open a PR dropping a new directory in `images/`. `FROM` will be injected at the top of the Dockerfile, to be an up-to-date Alpine 3.3.

Travis automatically builds and pushes from master.

## Environment variables

### `push`

If set, we'll push do Docker.

### `names`

Entries in the `images` directory that should be built. If not set, defaults to all.

### `skip`

Entries in the `images` directory that should be skipped. Takes precedence over `names`. The special value `alpine` skips building a base Alpine image, which can speed iterations up tremendously. However you'll need an Alpine image from that UTC day.
