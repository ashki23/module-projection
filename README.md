# Spack module projection
*[Ashkan Mirzaee](https://ashki23.github.io/index.html)*

Spack creates module files in both Lua or TCL formats automatically. This application screen modulefiles to only provides the list of softwares in the modulepath.

-----

## Spack and Lmod installation

``` bash
## Install Spack at /opt directory
cd /opt
git clone https://github.com/spack/spack.git
cd spack
git checkout -b releases/latest
source share/spack/setup-env.sh
spack install lmod
```

## Modulefiles

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

## Project modulefiles

Use `source setup-modules.sh` to project files. By default
`setup-modules.sh` uses `/opt/modulefiles/` for modulepath. Modify `modulefiles` variable to change the path.

## Bashrc

Add the following to the `.bashrc` file (need to modify lmod path based on your environment):

``` bash
export MODULEPATH='/opt/modulefiles/'
source /opt/spack/opt/spack/linux-ubuntu20.04*/gcc-9.3.0/lmod-8*/lmod/lmod/init/bash
alias spack-setup-env='git -C /opt/spack checkout releases/latest && git -C /opt/spack pull origin releases/latest && source /opt/spack/share/spack/setup-env.sh && module unuse /opt/spack/share/spack/modules/*'
```
