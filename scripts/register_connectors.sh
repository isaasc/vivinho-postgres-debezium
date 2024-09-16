#!/bin/bash

for db in vivopos vivofibra
do
  response=$(curl -s -o response.txt -w "%{http_code}" -X POST -H "Content-Type: application/json" --data @postgres_${db}-connector.json http://localhost:8083/connectors)
  
  if [ "$response" -eq 201 ]; then
    echo "Successfully registered connector for postgres_${db}"
  else
    echo "Failed to register connector for postgres_${db} with response code: $response"
    echo "Response body:"
    cat response.txt
  fi
done
