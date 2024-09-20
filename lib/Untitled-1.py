import random

def guess_the_number():
    print("Välkommen till Gissa Numret!")
    print("Jag tänker på ett tal mellan 1 och 100.")
    secret_number = random.randint(1, 100)
    attempts = 0

    while True:
        guess = input("Gissa ett tal: ")

        # Kontrollera om inmatningen är ett nummer
        if not guess.isdigit():
            print("Vänligen ange ett giltigt tal.")
            continue

        guess = int(guess)
        attempts += 1

        if guess < secret_number:
            print("För lågt! Försök igen.")
        elif guess > secret_number:
            print("För högt! Försök igen.")
        else:
            print(f"Grattis! Du gissade rätt på {attempts} försök!")
            break

guess_the_number()
