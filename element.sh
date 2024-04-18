#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  
  if [[ $1 ]]
  then
    # if input is a number
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT_TEST=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number=$1;")
    fi

    # if input is a symbol
    if [[ $1 =~ ^[A-Z]$|^[A-Z][a-z]$ ]]
    then
      ELEMENT_TEST=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE symbol='$1';")
    fi

    # if input is a name
    if [[ $1 =~ ^[A-Z][a-z]+$ ]]
    then
      ELEMENT_TEST=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE name='$1';")
    fi

    # if the element doesn't exist
    if [[ -z $ELEMENT_TEST ]]
    then
      echo I could not find that element in the database.

    else
    # if it does exist
    echo "$ELEMENT_TEST" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME MASS MELT_PT BOIL_PT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_PT celsius and a boiling point of $BOIL_PT celsius."
    done
    fi

  else
    echo Please provide an element as an argument.
  fi
