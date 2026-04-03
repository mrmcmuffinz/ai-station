import unittest

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

class TestTicTacToe(unittest.TestCase):
    def test_check_winner_row(self):
        board = [
            ['X', 'X', 'X'],
            [' ', ' ', ' '],
            [' ', ' ', ' ']
        ]
        self.assertTrue(check_winner(board, 'X'))

    def test_check_winner_column(self):
        board = [
            ['X', ' ', ' '],
            ['X', ' ', ' '],
            ['X', ' ', ' ']
        ]
        self.assertTrue(check_winner(board, 'X'))

    def test_check_winner_diagonal(self):
        board = [
            ['X', ' ', ' '],
            [' ', 'X', ' '],
            [' ', ' ', 'X']
        ]
        self.assertTrue(check_winner(board, 'X'))

    def test_check_winner_reverse_diagonal(self):
        board = [
            [' ', ' ', 'X'],
            [' ', 'X', ' '],
            ['X', ' ', ' ']
        ]
        self.assertTrue(check_winner(board, 'X'))

    def test_check_winner_no_winner(self):
        board = [
            ['X', 'O', 'X'],
            ['O', 'X', 'O'],
            ['O', 'X', 'O']
        ]
        self.assertFalse(check_winner(board, 'X'))

if __name__ == '__main__':
    unittest.main()
