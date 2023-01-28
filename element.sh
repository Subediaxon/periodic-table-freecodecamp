#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# Function to get element details
get_element_details() {
  local atom_num=$1
  local ele_name=$($PSQL "SELECT name FROM elements where atomic_number = $atom_num")
  local ele_symbol=$($PSQL "SELECT symbol FROM elements where atomic_number = $atom_num")
  local ele_type_id=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $atom_num")
  local ele_type=$($PSQL "SELECT type FROM types where type_id=$ele_type_id")
  local ele_mass=$($PSQL "SELECT atomic_mass from properties WHERE atomic_number = $atom_num")
  local ele_boiling=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $atom_num")
  local ele_melting=$($PSQL "SELECT melting_point_celsius from properties WHERE atomic_number = $atom_num")
  
  echo "The element with atomic number $atom_num is $ele_name ($ele_symbol). It's a $ele_type, with a mass of $ele_mass amu. $ele_name has a melting point of $ele_melting celsius and a boiling point of $ele_boiling celsius."
}

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ [0-9]+ ]]; then
    get_element_details $1
  elif [[ $1 =~ ^[A-Z][a-z]$ || (  (${#1} -eq 1) && ($1 =~ [[:upper:]] ) )  ]]; then
    local atom_num=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    get_element_details $atom_num
  elif [[ ${#1} -gt 3 && ${1:0:1} == [A-Z] ]]; then
    local ele_symbol=$($PSQL "SELECT symbol FROM elements where name = '$1'")
    local atom_num=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ele_symbol'")
    get_element_details $atom_num
  else
    echo "I could not find that element in the database."
  fi
fi


