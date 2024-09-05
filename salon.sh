#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c" 

MAIN_MENU() {

  echo -e "\n1) Haircut\n2) Manicure\n3) Massage\n"
  echo "How may I help you?"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SERVICE="Haircut"; APPOINTMENT 1 ;;
    2) SERVICE="Manicure"; APPOINTMENT 2 ;;
    3) SERVICE="Massage"; APPOINTMENT 3 ;;
    *) MAIN_MENU "Please pick a valid option." ;;
  esac
}

APPOINTMENT() {
  
  echo "What is your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "select customer_ID from customers where phone = '$CUSTOMER_PHONE';")
  
  if [[ -z $CUSTOMER_ID ]]
  then 
    echo "What is your name?"
    read CUSTOMER_NAME
   $PSQL "insert into customers (phone, name) values ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');"
   CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE';")
  else   
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID;")
  fi

  echo "What time would you like your appointment?"
  read SERVICE_TIME

  $PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"

  echo "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU

