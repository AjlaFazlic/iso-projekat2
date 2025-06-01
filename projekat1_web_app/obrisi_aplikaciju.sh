#!/bin/bash
echo "Brisanje aplikacije i svih podataka..."

docker-compose down -v --rmi all

echo "Aplikacija, kontejneri, slike i podaci su obrisani!"


