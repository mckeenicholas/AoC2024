options(scipen = 999)

line <- as.integer(unlist(strsplit(readLines("input.txt"), "")))

files <- list()
free <- list()

idx <- 0

for (i in seq(1, length(line), by = 2)) {
  files <- append(files, list(c(idx, line[i], (i - 1) %/% 2)))
  idx <- idx + line[i]
  if (i + 1 <= length(line)) {
    free <- append(free, list(c(idx, line[i + 1])))
    idx <- idx + line[i + 1]
  }
}

for (i in rev(seq_along(files))) {
  pos <- files[[i]][1]
  size <- files[[i]][2]
  id <- files[[i]][3]
  
  for (j in seq_along(free)) {
    fpos <- free[[j]][1]
    fsize <- free[[j]][2]
    
    if (fpos <= pos && fsize >= size) {
      free[[j]] <- c(fpos + size, fsize - size)
      files[[i]] <- c(fpos, size, id)
      break
    }
  }
}

t <- 0

for (file in files) {
  pos <- file[1]
  l <- file[2]
  id <- file[3]
  
  for (i in seq_len(l)) {
    t <- t + (pos + i - 1) * id
  }
}

print(t)
