#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUMBER=$(( RANDOM % 999 + 1))
NUMBER_OF_GUESSES=0

echo "Enter your username:"
read USERNAME

CHECK_USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")
if [[ -z $CHECK_USERNAME ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(username) FROM users WHERE username = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM users WHERE username = '$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  (( GAMES_PLAYED++ ))
fi

echo "Guess the secret number between 1 and 1000:"

while [[ $SECRET_NUMBER != $GUESS ]]
do
  (( NUMBER_OF_GUESSES++ ))
  read GUESS

  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $SECRET_NUMBER == $GUESS ]]
    then
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      RECORD_GAME=$($PSQL "INSERT INTO users(username, number_of_guesses) VALUES('$USERNAME', $NUMBER_OF_GUESSES)")
    else
      if [[ $SECRET_NUMBER < $GUESS ]]
      then
        echo "It's lower than that, guess again:"
        else
          if [[ $SECRET_NUMBER > $GUESS ]]
          then
            echo "It's higher than that, guess again:"
          fi
        fi
    fi
  fi
done
