# Sudoku
Small iPhone application that generates and solves sudoku

## Features
### Solving
* Logic for solving Easy puzzles without guessing
* Logic for solving Medium puzzles without guessing
* Logic for solving Hard or "Samurai" level puzzles with bruteforcing guesses

### Generating
* Application can generate easy,medium, and hard/samurai puzzles
(There is still no difference in hard and samurai level in the generation)

### Play
* Sudoku is playable and validates as the last number is filled succefully

### Load sudokus from file
* Files in the Data folder, with the extension ".sudoku" is listed and can be loaded as sudokus


## TODO:
* **Add tests for basic algorithms and creation of sudoku**
* Inplement x-wing algorithm for solving Hard puzzles without bruteforcing
* Implement Hidden subset algorithm for solving Hard puzzles without bruteforcing
* *Add feedback for when user tapps the hidden solving buttons in the main view* or remove buttons
* Remove potential issues with background task touching the same datastructure as the user and therefor creating threading issues for data




