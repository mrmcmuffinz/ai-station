import os

def print_board(board):
    os.system('cls' if os.name == 'nt' else 'clear')
    board_length = len(board)
    print("Let's play Tic Tac Toe\n")
    for row in range(board_length):
        print(" | ".join(board[row]))
        if row < board_length - 1:
            print("-" * 9)
    print("")

def check_winner(board, player):
    # Check rows, columns, and diagonals for a win
    for row in board:
        if all([cell == player for cell in row]):
            return True
    for col in range(3):
        if all([board[row][col] == player for row in range(3)]):
            return True
    if all([board[i][i] == player for i in range(3)]) or all([board[i][2 - i] == player for i in range(3)]):
        return True
    return False

def is_board_full(board):
    return all([cell != ' ' for row in board for cell in row])

def main():
    board = [[' ' for _ in range(3)] for _ in range(3)]
    current_player = 'X'

    while True:
        print_board(board)
        print(f"Player {current_player}'s turn")

        while True:
            try:
                move = int(input("Enter a number 1-9: ")) - 1
                if move < 0 or move > 8:
                    print("Invalid input. Please enter a number 1-9.")
                    continue
                row, col = move // 3, move % 3
                if board[row][col] == ' ':
                    board[row][col] = current_player
                    break
                else:
                    print("That square is already occupied. Try again.")
            except (ValueError, IndexError):
                print("Invalid input used. Please enter a number 1-9.")

        if check_winner(board, current_player):
            print_board(board)
            print(f"Player {current_player} wins!")
            break
        elif is_board_full(board):
            print_board(board)
            print("It's a draw!")
            break

        current_player = 'O' if current_player == 'X' else 'X'

    play_again = input("Do you want to play again? (yes/no): ").strip().lower()
    if play_again == 'yes':
        main()

if __name__ == "__main__":
    main()
