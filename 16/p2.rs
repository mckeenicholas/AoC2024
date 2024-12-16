use std::{
    collections::{HashMap, HashSet, VecDeque},
    fs::{self},
    i32,
};

pub enum MazeTile {
    Target,
    Wall,
    Open,
}

#[derive(Eq, Hash, PartialEq, Clone, Debug)]
pub enum Direction {
    North,
    East,
    South,
    West,
}

impl Direction {
    pub fn to_dir(&self) -> (i32, i32) {
        match self {
            Direction::North => (-1, 0),
            Direction::East => (0, 1),
            Direction::South => (1, 0),
            Direction::West => (0, -1),
        }
    }

    pub fn all() -> [Direction; 4] {
        [
            Direction::North,
            Direction::East,
            Direction::South,
            Direction::West,
        ]
    }
}

#[derive(Eq, Hash, PartialEq, Clone)]
pub struct Reindeer {
    r: i32,
    c: i32,
    dir: Direction,
}

fn main() {
    p1();
}

pub fn p1() {
    let input = fs::read_to_string("input.txt").unwrap();
    let lines = input.split("\n");

    let mut reindeer = Reindeer {
        r: 0,
        c: 0,
        dir: Direction::East,
    };
    let mut target_x = 0;
    let mut target_y = 0;

    let board: Vec<Vec<MazeTile>> = lines
        .enumerate() 
        .map(|(row_idx, line)| {
            line.chars()
                .enumerate()
                .map(|(col_idx, char)| match char {
                    '.' => MazeTile::Open,
                    '#' => MazeTile::Wall,
                    'E' => {
                        target_x = row_idx as i32;
                        target_y = col_idx as i32;
                        MazeTile::Target
                    }
                    'S' => {
                        reindeer.r = row_idx as i32;
                        reindeer.c = col_idx as i32;
                        MazeTile::Open
                    }
                    _ => panic!("Bad char: {}", char),
                })
                .collect::<Vec<MazeTile>>()
        })
        .collect();

    for row in &board {
        for tile in row {
            match tile {
                MazeTile::Open => print!("."),
                MazeTile::Target => print!("E"),
                MazeTile::Wall => print!("#"),
            }
        }
        println!();
    }

    let mut min_score = i32::MAX;
    let mut reindeer_end = Reindeer {r: 0, c: 0, dir: Direction::East};

    let mapping = bfs(&board, &reindeer);
    for dir in Direction::all() {
        if let Some(score) = mapping.get(&(target_x, target_y, dir.clone())) {            
            if *score < min_score {
                reindeer_end = Reindeer {
                    r: target_x,
                    c: target_y,
                    dir,
                };
                min_score = *score;
            }
        }
    }

    let len = backtrack(&board, mapping, &reindeer_end, min_score);

    println!("spots: {}", len);
}

fn backtrack(
    board: &Vec<Vec<MazeTile>>,
    visited: HashMap<(i32, i32, Direction), i32>,
    reindeer_end: &Reindeer,
    min_cost: i32
) -> i32 {
    let rows = board.len() as i32;
    let cols = board[0].len() as i32;

    let mut queue: VecDeque<(i32, i32, i32, Direction)> = VecDeque::new();
    let mut best_paths: HashSet<(i32, i32)> = HashSet::new();

    queue.push_back((reindeer_end.r, reindeer_end.c, min_cost, reindeer_end.dir.clone()));

    while let Some((r, c, score, dir)) = queue.pop_front() {
        for search_dir in Direction::all().iter() {
            let (dr, dc) = search_dir.to_dir();
            let back_r = r + dr;
            let back_c = c + dc;

            if back_r >= 0
                && back_r < rows
                && back_c >= 0
                && back_c < cols
                && matches!(board[back_r as usize][back_c as usize], MazeTile::Open)
            {
                for last_dir in Direction::all().iter() {
                    if let Some(last_score) = visited.get(&(back_r, back_c, last_dir.clone())) {
                        let cost = 1 + if dir != last_dir.clone() {
                            1000
                        } else {
                            0
                        };

                        if last_score + cost == score {
                            best_paths.insert((back_r, back_c));
                            queue.push_back((back_r, back_c, *last_score, last_dir.clone()));
                        }
                    }
                }
            }
        }
    }
    (best_paths.len() + 1) as i32
}

fn bfs(board: &Vec<Vec<MazeTile>>, reindeer: &Reindeer) -> HashMap<(i32, i32, Direction), i32> {
    let rows = board.len() as i32;
    let cols = board[0].len() as i32;

    let mut queue: VecDeque<(i32, i32, i32, Direction)> = VecDeque::new();
    let mut best_score: HashMap<(i32, i32, Direction), i32> = HashMap::new();

    queue.push_back((reindeer.r, reindeer.c, 0, reindeer.dir.clone()));
    best_score.insert((reindeer.r, reindeer.c, reindeer.dir.clone()), 0);

    while let Some((r, c, score, dir)) = queue.pop_front() {
        for new_dir in Direction::all().iter() {
            let (dr, dc) = new_dir.to_dir();
            let new_r = r + dr;
            let new_c = c + dc;

            if new_r >= 0
                && new_r < rows
                && new_c >= 0
                && new_c < cols
                && matches!(
                    board[new_r as usize][new_c as usize],
                    MazeTile::Open | MazeTile::Target
                )
            {
                let turn_cost = if *new_dir != dir { 1000 } else { 0 };
                let new_score = score + 1 + turn_cost;

                if best_score
                    .get(&(new_r, new_c, new_dir.clone()))
                    .map_or(true, |&current_score| new_score < current_score)
                {
                    best_score.insert((new_r, new_c, new_dir.clone()), new_score);
                    queue.push_back((new_r, new_c, new_score, new_dir.clone()));
                }
            }
        }
    }

    best_score
}
