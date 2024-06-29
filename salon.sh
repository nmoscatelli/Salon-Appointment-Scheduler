#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~ My salon ~~"

# Main menu
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e $1
  else
    echo -e "\n Welcome. How can I help you?"
  fi
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do 
    echo -e "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
  1) SERVICE ;;
  2) SERVICE ;;
  3) SERVICE ;;
  *) MAIN_MENU "\nI could not find that service. How can I help you?";;
  esac
}

# Service
SERVICE() {
  echo -e "What's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi

  echo -e "\nWhat time would you like your service, $CUSTOMER_NAME?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

}

# "Main"
MAIN_MENU