using DataStructures

function mark_coordinate(grid, coord)
    x, y = coord
    grid[y + 1, x + 1] = false
end

function bfs(grid, start, goal)
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    
    queue = Deque{Tuple{Int,Int,Int}}()
    push!(queue, (start[1], start[2], 0))
    
    visited = Set()
    push!(visited, start)
    
    while !isempty(queue)
        x, y, steps = popfirst!(queue)
        
        if (x, y) == goal
            return steps
        end
        
        for (dx, dy) in directions
            nx, ny = x + dx, y + dy
            
            if nx > 0 && nx <= size(grid, 2) && ny > 0 && ny <= size(grid, 1) && grid[ny, nx] == true && !((nx, ny) in visited)
                push!(visited, (nx, ny))
                push!(queue, (nx, ny, steps + 1))
            end
        end
    end
    
    return -1
end

function read_coordinates(filename)
    coordinates = []
    open(filename, "r") do file
        for line in eachline(file)
            push!(coordinates, tuple(parse(Int, split(line, ",")[1]), parse(Int, split(line, ",")[2])))
        end
    end
    return coordinates
end

function find_blocking_coordinate(grid, coordinates)
    grid_copy = copy(grid)
    start = (1, 1)
    goal = (71, 71)
    
    for (i, coord) in enumerate(coordinates)
        mark_coordinate(grid_copy, coord)
        steps = bfs(grid_copy, start, goal)
        
        if steps == -1
            return i, coord 
        end
    end
    return nothing
end

function main()
    grid = fill(true, 71, 71)
    coordinates = read_coordinates("input.txt")
    
    result = find_blocking_coordinate(grid, coordinates)
    
    if result !== nothing
        index, blocking_coord = result
        println("$(blocking_coord[1]),$(blocking_coord[2])")
    end
end

main()