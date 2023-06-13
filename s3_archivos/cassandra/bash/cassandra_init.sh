#!/bin/bash

echo "* * * Ejecutando script * * * "
USER_NAME='cassandra'
PASSWORD='cassandra'

while ! cqlsh cassandra_db -u "${USER_NAME}" -p "${PASSWORD}" -e 'describe cluster' ; do
     echo "* * * Esperando al servicio principal de Cassandra... * * *"
     sleep 1
done

echo ""

for cql_file in ./cql/*.cql;
do
  cqlsh cassandra_db -u "${USER_NAME}" -p "${PASSWORD}" -f "${cql_file}" ;
  echo "* * * Script ""${cql_file}"" ejecutado !!! * * *"
done
echo "* * * Fin de la ejecucion del script"
echo "* * * Parando el contenedor temporalmente... * * * "
