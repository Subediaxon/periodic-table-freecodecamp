#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then

  echo -e "Please provide an element as an argument."

else

  if [[ $1 =~ [0-9]+ ]]
  then
      ELE_NAME=$($PSQL "SELECT name FROM elements where atomic_number = $1")
      ELE_SYMBOL=$($PSQL "SELECT symbol FROM elements where atomic_number = $1")
      ELE_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $1")
      ELE_TYPE=$($PSQL "SELECT type FROM types where type_id=$ELE_TYPE_ID")
      ELE_MASS=$($PSQL "SELECT atomic_mass from properties WHERE atomic_number = $1")
      ELE_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1")
      ELE_MELTING=$($PSQL "SELECT melting_point_celsius from properties WHERE atomic_number = $1") 
  
  echo "The element with atomic number 1 is $ELE_NAME ($ELE_SYMBOL). It's a $ELE_TYPE, with a mass of $ELE_MASS amu. $ELE_NAME has a melting point of $ELE_MELTING celsius and a boiling point of $ELE_BOILING celsius."

  elif [[ $1 =~ ^[A-Z][a-z]$ || (  (${#1} -eq 1) && ($1 =~ [[:upper:]] ) )  ]]
  then
    
    #Elements Table
    ATOM_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    ELE_NAME=$($PSQL "SELECT name FROM elements where symbol = '$1'")
    
    #Properties Table
    ELE_MASS=$($PSQL "SELECT atomic_mass from properties WHERE atomic_number = '$ATOM_NUM'")
    ELE_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$ATOM_NUM'")
    ELE_MELTING=$($PSQL "SELECT melting_point_celsius from properties WHERE atomic_number = '$ATOM_NUM'")
    ELE_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = '$ATOM_NUM'")
    
    #Types Table
    ELE_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $ELE_TYPE_ID")
        
    echo "The element with atomic number $ATOM_NUM is $ELE_NAME ($1). It's a $ELE_TYPE, with a mass of $ELE_MASS amu. $ELE_NAME has a melting point of $ELE_MELTING celsius and a boiling point of $ELE_BOILING celsius."

  elif [[ ${#1} -gt 3 && ${1:0:1} == [A-Z] ]]
  then
        
    #Elements Table
    ELE_SYMBOL=$($PSQL "SELECT symbol FROM elements where name = '$1'")
    ATOM_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ELE_SYMBOL'")
    
    #Properties Table
    ELE_MASS=$($PSQL "SELECT atomic_mass from properties WHERE atomic_number = '$ATOM_NUM'")
    ELE_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$ATOM_NUM'")
    ELE_MELTING=$($PSQL "SELECT melting_point_celsius from properties WHERE atomic_number = '$ATOM_NUM'")
    ELE_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = '$ATOM_NUM'")
    
    #Types Table
    ELE_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $ELE_TYPE_ID")
    
    echo "The element with atomic number $ATOM_NUM is $1 ($ELE_SYMBOL). It's a $ELE_TYPE, with a mass of $ELE_MASS amu. $1 has a melting point of $ELE_MELTING celsius and a boiling point of $ELE_BOILING celsius."

  else
    echo "I could not find that element in the database."
  fi 
fi

