#!/bin/sh
targetdir=/home/hadoopdev/SSM/smart-dist/target

filename=smart-data-0.1-SNAPSHOT

rootdir=./${filename}
tarfilename=${filename}.tar.gz


dbg=

run: ${rootdir}
	${rootdir}/bin/start-smart.sh -D dfs.smart.namenode.rpcserver=hdfs://localhost:9000

debug: ${rootdir}
	${rootdir}/bin/start-smart.sh -D dfs.smart.namenode.rpcserver=hdfs://localhost:9000 -debug

${rootdir}: ${targetdir}/smart-data-0.1-SNAPSHOT.tar.gz
	rm -f ${tarfilename}; cp ${targetdir}/${tarfilename} . ; rm -fr ${filename} ; tar -zxf ${tarfilename}

${targetdir}/smart-data-0.1-SNAPSHOT.tar.gz:
	cd ${targetdir}/../..; mvn package -DskipTests -Pdist


my:./lib
	./sbin/start-smart.sh -D dfs.smart.namenode.rpcserver=hdfs://localhost:9000

./lib:${rootdir}/lib
	rm -fr ./lib; rm -fr ./conf; cp -r ${rootdir}/lib .; cp -r ${rootdir}/conf .
