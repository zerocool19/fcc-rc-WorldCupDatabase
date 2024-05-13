#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNCATE_DB=$($PSQL "TRUNCATE TABLE games, teams")
if [[ $TRUNCATE_DB == "TRUNCATE TABLE" ]]
then
  echo -e "\nDatabase cleared."
fi

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
    
    # ------------------------------------------------   TEAMS ADDER   ------------------------------------------------ 
    # If to add winning team if not already added
    CHECK_TEAM_WINNER_ADDED=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    if [[ $CHECK_TEAM_WINNER_ADDED == '' ]]
    then
      INSERT_TEAM_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi

    # If to add opponent team if not already added
    CHECK_TEAM_OPPONENT_ADDED=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
    if [[ $CHECK_TEAM_OPPONENT_ADDED == '' ]]
    then
      INSERT_TEAM_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi


    # ------------------------------------------------   GAMES ADDER   ------------------------------------------------ 
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

    
  fi
done
