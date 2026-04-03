import unittest
from tictactoe import check_winner

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

    def test_check_winner_no_winner(self):
        board = [
            ['X', 'O', 'X'],
            ['O', 'X', 'O'],
            ['O', ' ', 'X']
        ]
        self.assertFalse(check_winner(board, 'X'))

if __name__ == '__main__':
    unittest.main()
