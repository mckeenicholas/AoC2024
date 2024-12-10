options(scipen = 999)

line <- as.integer(unlist(strsplit(readLines("input.txt"), "")))

disk <- list()

for (i in seq(1, length(line), by = 2)) {
  disk <- c(disk, rep(i %/% 2, line[i]))
  if (i + 1 <= length(line)) {
    disk <- c(disk, rep(NA, line[i + 1]))
  }
}

idx <- 1

while (idx <= length(disk)) {
  while (idx <= length(disk) && !is.na(disk[idx])) {
    idx <- idx + 1
  }
  
  if (idx <= length(disk)) {
    x <- tail(disk, n = 1)
    disk <- disk[-length(disk)]
    disk[idx] <- x
  }
}

t <- 0

for (i in seq_along(disk)) {
  if (!is.na(disk[i])) {
    t <- t + (i - 1) * disk[[i]]
  }
}

print(t)
