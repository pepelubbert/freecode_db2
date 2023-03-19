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
if [[ $YEAR != "year" ]]
then
# SEARCH IF WINNER IS ON teams and if not, add it to teams
TEAM_ID=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
# if not found
if [[ -z $TEAM_ID ]]
then
# insert team
INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams as winner, $WINNER
      fi
fi

TEAM_ID2=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
# if not found
if [[ -z $TEAM_ID2 ]]
then
# insert team
INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams as lohoseher, $OPPONENT
      fi
fi

#get id_winner and id_opponnent
WINNER_ID=$($PSQL"SELECT team_id FROM teams WHERE name ILIKE '$WINNER'")
OPPONENT_ID=$($PSQL"SELECT team_id FROM teams WHERE name ILIKE '$OPPONENT'")
GAME_ROW=$($PSQL"INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")


fi
done