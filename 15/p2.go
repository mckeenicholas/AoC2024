package main

import (
	"fmt"
	"os"
	"strings"
)

func P2() {
	data, _ := os.ReadFile("./input.txt")

	parts := strings.Split(string(data), "\n\n")
	boardStr, moveLines := parts[0], parts[1]

	moves := strings.ReplaceAll(moveLines, "\n", "")

	var initBoard [][]rune
	for _, line := range strings.Split(boardStr, "\n") {
		initBoard = append(initBoard, []rune(strings.TrimSpace(line)))
	}

	var board [][]rune
	for _, row := range initBoard {
		var newRow []rune
		for _, char := range row {
			switch char {
			case '#':
				newRow = append(newRow, '#', '#')
			case 'O':
				newRow = append(newRow, '[', ']')
			case '.':
				newRow = append(newRow, '.', '.')
			case '@':
				newRow = append(newRow, '@', '.')
			}
		}
		board = append(board, newRow)
	}

	var robotX, robotY int
	for y, row := range board {
		for x, cell := range row {
			if cell == '@' {
				robotX, robotY = x, y
				break
			}
		}
	}

	directions := map[rune][2]int{
		'^': {0, -1},
		'>': {1, 0},
		'v': {0, 1},
		'<': {-1, 0},
	}

	for _, move := range moves {
		dx, dy := directions[move][0], directions[move][1]
		newX, newY := robotX+dx, robotY+dy

		if newY < 0 || newY >= len(board) || newX < 0 || newX >= len(board[newY]) {
			continue
		}

		cell := board[newY][newX]

		if cell == '.' {
			board[robotY][robotX] = '.'
			board[newY][newX] = '@'
			robotX, robotY = newX, newY
		} else if cell == '[' || cell == ']' {
			if move == '^' || move == 'v' {
				sucess, moves := tryPushBoxVertical(board, newX, newY, dy)
				if sucess {
					board[robotY][robotX] = '.'
					board[newY][newX] = '@'

					for _, move := range moves {
						board[move.y][move.x] = move.newchar
					}

					robotX, robotY = newX, newY
				}
			} else {
				if tryPushBoxHorizontal(board, newX, newY, dx) {
					board[robotY][robotX] = '.'
					board[newY][newX] = '@'
					robotX, robotY = newX, newY
				}
			}
		}

		fmt.Println("Move: ", string(move))
		PrintBoard(board)

	}

	fmt.Println("Final Board:")
	PrintBoard(board)
}

type moveinstr struct {
	x       int
	y       int
	newchar rune
}

func tryPushBoxVertical(board [][]rune, x, y, dy int) (bool, []moveinstr) {
	var moves []moveinstr

	var leftX, rightX int
	if board[y][x] == '[' {
		leftX, rightX = x, x+1
	} else {
		leftX, rightX = x-1, x
	}

	newY := y + dy
	if newY < 0 || newY >= len(board) {
		return false, nil
	}

	leftDest := board[newY][leftX]
	rightDest := board[newY][rightX]

	if leftDest == '.' && rightDest == '.' {
		moves = append(moves, moveinstr{leftX, newY, '['}, moveinstr{rightX, newY, ']'}, moveinstr{leftX, y, '.'}, moveinstr{rightX, y, '.'})
		return true, moves
	} else if leftDest == '#' || rightDest == '#' {
		return false, nil
	} else if leftDest == '.' || rightDest == '.' {
		if success, subMoves := tryPushBoxVertical(board, leftX, newY, dy); success {
			moves = append(moves, subMoves...)
			moves = append(moves, moveinstr{leftX, newY, '['}, moveinstr{rightX, newY, ']'}, moveinstr{leftX, y, '.'}, moveinstr{rightX, y, '.'})
			return true, moves
		}
	} else {
		if success1, subMoves1 := tryPushBoxVertical(board, leftX, newY, dy); success1 {
			if success2, subMoves2 := tryPushBoxVertical(board, rightX, newY, dy); success2 {
				moves = append(moves, subMoves1...)
				moves = append(moves, subMoves2...)
				moves = append(moves, moveinstr{leftX, newY, '['}, moveinstr{rightX, newY, ']'}, moveinstr{leftX, y, '.'}, moveinstr{rightX, y, '.'})
				return true, moves
			}
		}
	}

	return false, nil
}

func tryPushBoxHorizontal(board [][]rune, x, y, dx int) bool {
	var leftX, rightX int
	if board[y][x] == '[' {
		leftX, rightX = x, x+1
	} else {
		leftX, rightX = x-1, x
	}

	checkX := rightX + dx
	if dx < 0 {
		checkX = leftX + dx
	}

	if checkX < 0 || checkX >= len(board[y]) {
		return false
	}

	destCell := board[y][checkX]

	if destCell == '.' {
		if dx < 0 {
			board[y][checkX] = '['
			board[y][checkX+1] = ']'
			board[y][rightX] = '.'
		} else {
			board[y][checkX-1] = '['
			board[y][checkX] = ']'
			board[y][leftX] = '.'
		}
		return true
	} else if destCell == '[' || destCell == ']' {
		if tryPushBoxHorizontal(board, checkX, y, dx) {
			if dx < 0 {
				board[y][checkX] = '['
				board[y][checkX+1] = ']'
				board[y][rightX] = '.'
			} else {
				board[y][checkX-1] = '['
				board[y][checkX] = ']'
				board[y][leftX] = '.'
			}
			return true
		}
	}

	return false
}
