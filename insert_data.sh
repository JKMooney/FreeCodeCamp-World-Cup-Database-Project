#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# echo $ROUND
# We need to insert two groups into teams, the winner and the opponent

# We need to get the team ID from the teams table

if [[ $WINNER != "winner" ]]
then
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # If the TEAM_ID variable is empty then we will want to insert the name and get the new team_id
  if [[ -z $TEAM_ID ]]
  then
  # Insert the name
    INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    # echo $WINNER
  # Get the new team_id
  NEW_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
fi

if [[ $OPPONENT != "opponent" ]]
then 
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $TEAM_ID ]]
  then
  INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  fi
  NEW_TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
  fi

# Need to insert data into the games table

if [[ $YEAR != year ]]
then

WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")
fi
done
