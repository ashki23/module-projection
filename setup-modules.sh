#!/bin/bash
## --------------------------
## By Ashkan Mirzaee Nov 2020
## --------------------------

core=( "/opt/spack/share/spack/lmod/linux-*-x86_64/Core" )
dest="/opt/modulefiles"

##rm -r /opt/modulefiles/*
for dir in ${core[*]}; do
    for i in $(ls ${dir}); do
        if echo ${i} | grep -Pqv "^lib.*|^util-.*|^perl-.*|^py-.*|^r-.*|^xcb-.*|^go-.*|^lua-.*|^at-.*|.*font.*|^autoconf-.*|^docbook-.*|.*-util$"; then	    
            for f in $(ls ${dir}/${i}/*); do
		v=$(basename ${f})
		k=$(echo ${v} | grep -Po ".*(?=-\w{4}\.lua)");
		install -dvp ${dest}/${i};
                ln -sf ${dir}/${i}/${v} ${dest}/${i}/${k}.lua;
            done
        fi
    done
done

## Remove broken links
for bl in $(find ${dest} -xtype l); do rm -v ${bl}; done

## Unset variables
unset core dest dir i f v k bl
