package main

import (
	"fmt"
	"os"
	"strings"
)

func P1() {
	data, _ := os.ReadFile("./input.txt")

	parts := strings.Split(string(data), "\n\n")
	boardStr, moveLines := parts[0], parts[1]

	moves := strings.ReplaceAll(moveLines, "\n", "")

	var board [][]rune
	for _, line := range strings.Split(boardStr, "\n") {
		board = append(board, []rune(strings.TrimSpace(line)))
	}
	var x, y int
	found := false
	for rowIdx, row := range board {
		for colIdx, cell := range row {
			if cell == '@' {
				x, y = colIdx, rowIdx
				found = true
				break
			}
		}
		if found {
			break
		}
	}

	directions := map[rune][2]int{
		'^': {-1, 0},
		'>': {0, 1},
		'v': {1, 0},
		'<': {0, -1},
	}

	for _, char := range moves {
		dx, dy := directions[char][0], directions[char][1]
		newX, newY := x+dx, y+dy
		cell := board[newX][newY]

		if cell == '.' {
			board[newX][newY] = '@'
			board[x][y] = '.'
			x, y = newX, newY
		} else if cell == 'O' {
			if pushBox(x, y, dx, dy, board) {
				board[newX][newY] = '@'
				board[x][y] = '.'
				x, y = newX, newY
			}
		}
	}

	fmt.Println("Final Board:")
	PrintBoard(board)

	score := 0

	for rowIdx, row := range board {
		for colIdx, cell := range row {
			if cell == 'O' {
				score += (rowIdx*100 + colIdx)
			}
		}
	}

	fmt.Println(score)
}

func pushBox(x int, y int, dx int, dy int, board [][]rune) bool {
	newX, newY := x+dx, y+dy
	cell := board[newX][newY]

	if cell == '.' {
		board[newX][newY] = 'O'
		board[x][y] = '.'
		return true
	} else if cell == 'O' {
		if pushBox(newX, newY, dx, dy, board) {
			board[newX][newY] = 'O'
			board[x][y] = '.'
			return true
		}
	}
	return false
}

func PrintBoard(board [][]rune) {
	for _, row := range board {
		fmt.Println(string(row))
	}
}

func main() {
	P1()
	P2()
}
