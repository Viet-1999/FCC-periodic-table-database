#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_PROGRAM() {
  # Check if argument is provided
  if [[ -z $1 ]]; 
  then
    echo -e "Please provide an element as an argument."
  else
    PRINT_ELEMENT $1
  fi
}

PRINT_ELEMENT() {
  # Query for the atomic number using the provided input
  INPUT=$1
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT'" | sed 's/ //g')
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT" | sed 's/ //g')
  fi

  # If the atomic number is not found, print an error and exit
  if [[ -z $ATOMIC_NUMBER ]]; 
  then
    echo -e "I could not find that element in the database."
  else
    # Fetch details about the element
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    SYMBOL=$($#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_PROGRAM() {
  # Check if argument is provided
  if [[ -z $1 ]]; 
  then
    echo -e "Please provide an element as an argument."
  else
    PRINT_ELEMENT $1
  fi
}

PRINT_ELEMENT() {
  # Query for the atomic number using the provided input
  INPUT=$1
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT'" | sed 's/ //g')
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT" | sed 's/ //g')
  fi

  # If the atomic number is not found, print an error and exit
  if [[ -z $ATOMIC_NUMBER ]]; 
  then
    echo -e "I could not find that element in the database."
  else
    # Fetch details about the element
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types ON properties.type_id=types.type_id WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')

    # Print the element details
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
}

FIX_DATABASE() {
  # Rename the weight column to atomic_mass
  RENAME_PROPERTIES_WEIGHT=$($PSQL "ALTER TABLE properties RENAME COLUMN weight to atomic_mass")
  echo -e "RENAME_PROPERTIES_WEIGHT : $RENAME_PROPERTIES_WEIGHT"

  # Rename the melting_point column to melting_point_celsius
  RENAME_PROPERTIES_MELTING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point to melting_point_celsius")
  echo -e "RENAME_PROPERTIES_MELTING_POINT : $RENAME_PROPERTIES_MELTING_POINT"

  # Rename the boiling_point column to boiling_point_celsius
  RENAME_PROPERTIES_BOILING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point to boiling_point_celsius")
  echo -e "RENAME_PROPERTIES_BOILING_POINT : $RENAME_PROPERTIES_BOILING_POINT"

  # Make the melting_point_celsius and boiling_point_celsius columns not accept null values
  ALTER_PROPERTIES_MELTING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL")
  ALTER_PROPERTIES_BOILING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL")
  echo -e "ALTER_PROPERTIES_MELTING_POINT_NOT_NULL : $ALTER_PROPERTIES_MELTING_POINT_NOT_NULL"
  echo -e "ALTER_PROPERTIES_BOILING_POINT_NOT_NULL : $ALTER_PROPERTIES_BOILING_POINT_NOT_NULL"

  # Add a UNIQUE constraint to the symbol and name columns from the elements table
  ALTER_ELEMENTS_SYMBOL_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol)")
  ALTER_ELEMENTS_NAME_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE(name)")
  echo -e "ALTER_ELEMENTS_SYMBOL_UNIQUE : $ALTER_ELEMENTS_SYMBOL_UNIQUE"
  echo -e "ALTER_ELEMENTS_NAME_UNIQUE : $ALTER_ELEMENTS_NAME_UNIQUE"

  # Make the symbol and name columns not accept null values
  ALTER_ELEMENTS_SYMBOL_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL")
  ALTER_ELEMENTS_NAME_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL")
  echo -e "ALTER_ELEMENTS_SYMBOL_NOT_NULL : $ALTER_ELEMENTS_SYMBOL_NOT_NULL"
  echo -e "ALTER_ELEMENTS_NAME_NOT_NULL : $ALTER_ELEMENTS_NAME_NOT_NULL"

  # Set the atomic_number column from the properties table as a foreign key that references the column of the same name in the elements table
  ALTER_PROPERTIES_ATOMIC_NUMBER_FOREIGN_KEY=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements (atomic_number)") 
  echo -e "ALTER_PROPERTIES_ATOMIC_NUMBER_FOREIGN_KEY : $ALTER_PROPERTIES_ATOMIC_NUMBER_FOREIGN_KEY"

  # Capitalize the first letter of all the symbol values in the elements table
  CAPITALIZE_FIRST_LETTER_HELIUM=$($PSQL "UPDATE elements SET symbol = 'He' WHERE symbol = 'he'")
  CAPITALIZE_FIRST_LETTER_LITHIUM=$($PSQL "UPDATE elements SET symbol = 'Li' WHERE symbol = 'li'")
  CAPITALIZE_FIRST_LETTER_MOTANIUM=$($PSQL "UPDATE elements SET symbol = 'Mt' WHERE symbol = 'mT'")
  echo -e "CAPITALIZE_FIRST_LETTER_HELIUM : $CAPITALIZE_FIRST_LETTER_HELIUM"
  echo -e "CAPITALIZE_FIRST_LETTER_LITHIUM : $CAPITALIZE_FIRST_LETTER_LITHIUM"
  echo -e "CAPITALIZE_FIRST_LETTER_MOTANIUM : $CAPITALIZE_FIRST_LETTER_MOTANIUM"

  # Rename the name moTanium to Motanium
  RENAME_MOTANIUM=$($PSQL "UPDATE elements SET name = 'Motanium' WHERE name = 'moTanium'")
  echo -e "RENAME_MOTANIUM : $RENAME_MOTANIUM"

  # Delete the element Motanium in properties and elements tables
  DELETE_MOTANIUM_IN_PROPERTIES_TABLE=$($PSQL "DELETE FROM properties WHERE atomic_number=1000")
  DELETE_MOTANIUM_IN_ELEMENTS_TABLE=$($PSQL "DELETE FROM elements WHERE atomic_number=1000")
  echo -e "DELETE_MOTANIUM_IN_PROPERTIES_TABLE : $DELETE_MOTANIUM_IN_PROPERTIES_TABLE"
  echo -e "DELETE_MOTANIUM_IN_ELEMENTS_TABLE : $DELETE_MOTANIUM_IN_ELEMENTS_TABLE"

  # Make the atomic_mass column accept decimal values in properties table
  ALTER_TABLE_ATOMIC_MASS_DECIMAL=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL")
  UPDATE_PROPERTIES_ATOMIC_MASS=$($PSQL "UPDATE properties SET atomic_mass=trim(trailing '00' FROM atomic_mass::TEXT)::DECIMAL")
  echo -e "ALTER_TABLE_ATOMIC_MASS_DECIMAL : $ALTER_TABLE_ATOMIC_MASS_DECIMAL"
  echo -e "UPDATE_PROPERTIES_ATOMIC_MASS : $UPDATE_PROPERTIES_ATOMIC_MASS"

  # Create a types table that stores three types of elements
  CREATE_TABLE_TYPES=$($PSQL "CREATE TABLE types (type_id INT NOT NULL, type VARCHAR(40) NOT NULL)")
  echo -e "CREATE_TABLE_TYPES : $CREATE_TABLE_TYPES"

  # Create 3 rows to the types table
  INSERT_COLUMNS_TYPES_TYPE_METAL=$($PSQL "INSERT INTO types(type_id, type) VALUES(1, 'metal')")
  INSERT_COLUMNS_TYPES_TYPE_NONMETAL=$($PSQL "INSERT INTO types(type_id, type) VALUES(2, 'nonmetal')")
  INSERT_COLUMNS_TYPES_TYPE_METALLOID=$($PSQL "INSERT INTO types(type_id, type) VALUES(3, 'metalloid')")
  echo -e "INSERT_COLUMNS_TYPES_TYPE_METAL : $INSERT_COLUMNS_TYPES_TYPE_METAL"
  echo -e "INSERT_COLUMNS_TYPES_TYPE_NONMETAL : $INSERT_COLUMNS_TYPES_TYPE_NONMETAL"
  echo -e "INSERT_COLUMNS_TYPES_TYPE_METALLOID : $INSERT_COLUMNS_TYPES_TYPE_METALLOID"

  # Make properties table have a type_id foreign key column that references the type_id column from the types table. It should be an INT with the NOT NULL constraint
  ADD_COLUMN_PROPERTIES_TYPE_ID=$($PSQL "ALTER TABLE types ADD PRIMARY KEY (type_id)")
  RENAME_TYPES_TO_TYPE_ID=$($PSQL "ALTER TABLE properties RENAME COLUMN type TO type_id")
  ADD_COLUMN_TEMP_TYPE=$($PSQL "ALTER TABLE properties ADD COLUMN temp_type INT NULL")
  UPDATE_PROPERTIES_METAL=$($PSQL "UPDATE properties SET temp_type = 1 WHERE type_id = 'metal'")
  UPDATE_PROPERTIES_NONMETAL=$($PSQL "UPDATE properties SET temp_type = 2 WHERE type_id = 'nonmetal'")
  UPDATE_PROPERTIES_METALLOID=$($PSQL "UPDATE properties SET temp_type = 3 WHERE type_id = 'metalloid'")
  DROP_COLUMN_TYPE_ID=$($PSQL "ALTER TABLE properties DROP COLUMN type_id")
  RENAME_COLUMN_TEMP_TYPE_TO_TYPE_ID=$($PSQL "ALTER TABLE properties RENAME COLUMN temp_type to type_id")
  ADD_FOREIGN_KEY_PROPERTIES_TYPE_ID=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (type_id) REFERENCES types (type_id)")
  ALTER_FOREIGN_KEY_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL")
  echo -e "ADD_COLUMN_PROPERTIES_TYPE_ID : $ADD_COLUMN_PROPERTIES_TYPE_ID"
  echo -e "RENAME_TYPES_TO_TYPE_ID : $RENAME_TYPES_TO_TYPE_ID"
  echo -e "ADD_COLUMN_TEMP_TYPE : $ADD_COLUMN_TEMP_TYPE"
  echo -e "UPDATE_PROPERTIES_METAL : $UPDATE_PROPERTIES_METAL"
  echo -e "UPDATE_PROPERTIES_NONMETAL : $UPDATE_PROPERTIES_NONMETAL"
  echo -e "UPDATE_PROPERTIES_METALLOID : $UPDATE_PROPERTIES_METALLOID"
  echo -e "DROP_COLUMN_TYPE_ID : $DROP_COLUMN_TYPE_ID"
  echo -e "RENAME_COLUMN_TEMP_TYPE_TO_TYPE_ID : $RENAME_COLUMN_TEMP_TYPE_TO_TYPE_ID"
  echo -e "ADD_FOREIGN_KEY_PROPERTIES_TYPE_ID : $ADD_FOREIGN_KEY_PROPERTIES_TYPE_ID"
  echo -e "ALTER_FOREIGN_KEY_NOT_NULL : $ADD_FOREIGN_KEY_PROPERTIES_TYPE_ID"

  # Add new elements to the elements and properties table
  ADD_FLOURINE_TO_ELEMENTS_TABLE=$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(9, 'F', 'Fluorine')")
  ADD_NEON_TO_ELEMENTS_TABLE=$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(10, 'Ne', 'Neon')")
  ADD_FLOURINE_TO_PROPERTIES_TABLE=$($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(9, 18.998, -220, -188.1, 2)")
  ADD_NEON_TO_PROPERTIES_TABLE=$($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(10, 20.18, -248.6, -246.1, 2)")
  echo -e "ADD_FLOURINE_TO_ELEMENTS_TABLE : $ADD_FLOURINE_TO_ELEMENTS_TABLE"
  echo -e "ADD_NEON_TO_ELEMENTS_TABLE : $ADD_NEON_TO_ELEMENTS_TABLE"
  echo -e "ADD_FLOURINE_TO_PROPERTIES_TABLE : $ADD_FLOURINE_TO_PROPERTIES_TABLE"
  echo -e "ADD_NEON_TO_PROPERTIES_TABLE : $ADD_NEON_TO_PROPERTIES_TABLE"
}

START_PROGRAM() {
  CHECK=$($PSQL "SELECT COUNT(*) FROM elements WHERE atomic_number=1000")
  if [[ $CHECK -gt 0 ]]
  then 
    FIX_DATABASE
    clear
  fi
  MAIN_PROGRAM $1
}

START_PROGRAM $1


PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types ON properties.type_id=types.type_id WHERE atomic_number=$ATOMIC_NUMBER" | sed 's/ //g')

    # Print the element details
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
}

START_PROGRAM() {
  MAIN_PROGRAM $1
}

START_PROGRAM $1


