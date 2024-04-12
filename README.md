Cribbage Card Game
Welcome to the Cribbage card game project! This Prolog-based game is designed to help players select the best hand cards for the highest score in the game of Cribbage. Dive into the world of card combinations and strategic scoring to outwit your opponents!

Project Overview
Objective: The objective of this project is to calculate the score of the cards in the player's hand according to the rules of Cribbage.

Scoring Components: 
The scoring algorithm considers five key components:
Fifteens: Pairs of cards whose values sum up to 15.
Pairs: Sets of two or more cards with the same rank.
Runs: Sequences of three or more consecutive cards in rank.
Flushes: All cards in the hand having the same suit.
His Nobs: The presence of the jack of the same suit as the start card.

How to Use
Input Hand: Provide the cards in your hand as input to the Prolog program.
Calculate Score: Run the Prolog program to calculate the score based on the provided hand.
Analyze Results: Review the score breakdown to understand which combinations contributed to your total score.
Strategize: Use the scoring information to make strategic decisions in the game, maximizing your chances of victory.

Running the Program
Install Prolog: Make sure you have a Prolog interpreter installed on your system.
Load the Program: Load the Cribbage game program into your Prolog interpreter.
Input Hand: Provide the cards in your hand as input to the program.
Calculate Score: Execute the scoring algorithm to determine the total score for the hand.

Sample Input
Here's an example of how you can input your hand:

prolog
Copy code
?- select_hand([card(5, hearts), card(4, spades), card(5, spades), card(5, clubs), card(jack, diamonds), card(5, diamonds)], Hand, Cribbage).

Contributing
Contributions are welcome! If you have any suggestions for improvements, additional features, or bug fixes, feel free to submit a pull request.

License
This project is licensed under the MIT License.

Acknowledgements
Special thanks to the Cribbage community for their insights and expertise in the game's rules and scoring mechanics.
