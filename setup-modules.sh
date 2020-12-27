#!/bin/bash
## --------------------------
## By Ashkan Mirzaee Nov 2020
## --------------------------

core=( "/opt/spack/share/spack/lmod/linux-centos7-x86_64/Core"
       "/opt/spack/share/spack/lmod/linux-centos7-x86_64/gcc/9.3.0" 
       "/opt/spack/share/spack/lmod/linux-centos7-x86_64/openmpi/4.0.5-twjcwul/gcc/9.3.0" )

modulefiles="/opt/modulefiles"
##rm -r ${modulefiles}/*

for dir in ${core[*]}; do
    for i in $(ls $dir); do
	if echo $i | grep -Pqv "^lib.*|^util-.*|^perl-.*|^py-.*|^xcb-.*|^go-.*|^at-.*|^docbook-.*|.*proto$|.*font.*"; then
	    ver=$(echo $dir/$i/* | tr " " "\n" | grep -Po "(?<=/$i/).*");
	    if echo $ver | grep -q "9.3.0/gcc/"; then 
		ver=$(echo $ver | grep -Po "(?<=9.3.0/gcc/).*"); 
	    fi
	    install -dvp ${modulefiles}/$i;
	    for j in $ver; do
		k=$(echo $j | grep -Po ".*(?=-\w{4}\.lua)");
		ln -sf $dir/$i/$j* ${modulefiles}/$i/$k.lua;
	    done
	fi
    done
done 
