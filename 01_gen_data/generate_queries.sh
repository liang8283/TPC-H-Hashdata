#!/bin/bash

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../functions.sh
source_bashrc

set -e

query_id=1
schema_name="tpch"

if [ "${GEN_DATA_SCALE}" == "" ] || [ "${BENCH_ROLE}" == "" ]; then
	echo "Usage: generate_queries.sh scale rolename"
	echo "Example: ./generate_queries.sh 100 hbench"
	echo "This creates queries for 100GB of data."
	exit 1
fi

echo "rm -f $PWD/../05_sql/*.tpch.*.sql"
rm -f ${TPC_H_DIR}/05_sql/*.${BENCH_ROLE}.*.sql*

cd $PWD/queries

for i in $(ls $PWD/*.sql |  xargs -n 1 basename); do
	q=$(echo $i | awk -F '.' '{print $1}')
	id=$(printf %02d $q)
	file_id="1""$id"
	filename=${file_id}.${BENCH_ROLE}.${id}.sql

	echo "echo \":EXPLAIN_ANALYZE\" > $PWD/../../05_sql/$filename"
	printf "set role ${BENCH_ROLE};\nset search_path=$schema_name,public;\nset optimizer=${ORCA_OPTIMIZER};\nset statement_mem=\"${STATEMENT_MEM}\";\n:EXPLAIN_ANALYZE\n" > $PWD/../../05_sql/$filename
	echo "./qgen $q >> $PWD/../../05_sql/$filename"
	$PWD/qgen $q >> $PWD/../../05_sql/$filename
done

cd ..

echo "COMPLETE: qgen scale ${GEN_DATA_SCALE}"
