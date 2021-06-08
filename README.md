# Spack module projection
*[Ashkan Mirzaee](https://ashki23.github.io/index.html)*

Spack creates modulefiles in both Lua or Tcl formats. But the generated modulefiles includes hash numbers and located in in the Spack path. We can modify Spack to generate modulefules with no hash but it can cause many problems when there are modules with the same name. Also, Spack creates modulefile for all the depecndencies that many of them not using directly by users. This software orgenizes the namespace of the modulefiles and creates a symbolic link from them to a more familiar path (i.e., `/opt/modulefiles/`) and let users to exclude modulefiles by using wildcards.

-----

## Spack and Lmod installation

``` bash
## Install Spack at /opt directory
cd /opt
git clone https://github.com/spack/spack.git
cd spack
git checkout -b spack-latest
git pull origin releases/latest
source share/spack/setup-env.sh
spack install lmod
```

## Modulefiles config
Create the following module config file (`modules.yaml`) at `/opt/spack/etc/spack/`:

```yaml
modules:
  enable:
    - lmod
    - tcl
  lmod:
    hierarchy:
      - mpi
    core_compilers:
      - gcc@9.3.0
    blacklist:
      - '^lua'
      - autoconf-archive
      - autoconf
      - automake
      - bzip2
      - cairo
      - harfbuzz
      - openssh
      - openssl
    whitelist:
      - gcc
      - openmpi
    all:
      environment:
        set:
          '{name}_ROOT': '{prefix}'
      filter:
        environment_blacklist:
          - 'MODULEPATH'
    hash_length: 4
    projections:
      '^mpi ^cuda': '{name}/{version}-{^mpi.name}-cuda-{^cuda.version}'
      ^mpi: '{name}/{version}-{^mpi.name}'
      all: '{name}/{version}'
```

To refresh modulefiles run:

``` bash
spack module lmod refresh --delete-tree -y
```

This will create modulefiles under `/opt/spack/share/spack/lmod/linux-*-x86_64/Core/`. Here we keep hashes in the namesapce to prevent possible confilcts. Note that Lmod does not create modulefile for libraries listed under the `blacklist` which helps to exclude some modulefiles. Later we use `setup-modules.sh` to censor libraries by using wildcards.

## Project modulefiles
Use `source setup-modules.sh` to project files. By default `setup-modules.sh` uses `/opt/modulefiles/` for modulepath. Modify `modulefiles` variable to change the path. `setup-modules.sh` does three tasks:

 1. Censors libraries and dependencies by wildcards, eg. `^lib.*` `^util-.*` `.*font.*`
 1. Drops hashes
 1. Creates links from actual modulefiles to `/opt/modulefiles/`

## Bashrc
To activat lmod and update the modulepath, add the following to `.bashrc` file (need to modify lmod path based on your environment):

``` bash
export MODULEPATH='/opt/modulefiles/'
source /opt/spack/opt/spack/linux-ubuntu20.04*/gcc-9.3.0/lmod-8*/lmod/lmod/init/bash
alias spack-setup-env='git -C /opt/spack checkout spack-latest && git -C /opt/spack pull origin releases/latest && source /opt/spack/share/spack/setup-env.sh && module unuse /opt/spack/share/spack/modules/*'
```

## Workflow
We are using Spack to install software:

- Activate Spack env and update the branch: `spack-setup-env`
- Check specs: `spack spec -I <software>`
- Install: `spack install <software>`

Now use the following to project modulefiles:

```bash
source setup-modules.sh
```
