#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
elif [[ $1 =~ ^[0-9]+$ ]]
  then
    NUMBER_QUERY_RESULT=$($PSQL "select elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties on elements.atomic_number = properties.atomic_number inner join types on properties.type_id = types.type_id where elements.atomic_number = '$1'")
    if [[ -z $NUMBER_QUERY_RESULT ]]
    then
      echo -e "I could not find that element in the database."
      exit
    else
      echo "$NUMBER_QUERY_RESULT" | while IFS='|' read NUMBER NAME SYMBOL TYPE MASS MELT BOIL
      do
        echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
else
  SYMBOL_QUERY_RESULT=$($PSQL "select elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties on elements.atomic_number = properties.atomic_number inner join types on properties.type_id = types.type_id where symbol = '$1'")
  if [[ ! -z $SYMBOL_QUERY_RESULT ]]
  then
    echo "$SYMBOL_QUERY_RESULT" | while IFS='|' read NUMBER NAME SYMBOL TYPE MASS MELT BOIL
    do
      echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  else
    NAME_QUERY_RESULT=$($PSQL "select elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties on elements.atomic_number = properties.atomic_number inner join types on properties.type_id = types.type_id where name = '$1'")
    if [[ ! -z $NAME_QUERY_RESULT ]]
    then
      echo "$NAME_QUERY_RESULT" | while IFS='|' read NUMBER NAME SYMBOL TYPE MASS MELT BOIL
      do
        echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    else
      echo -e "I could not find that element in the database."
      exit
    fi
  fi
fi
