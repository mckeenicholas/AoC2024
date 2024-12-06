import System.IO (readFile)
import Data.List (isPrefixOf)

splitOn :: String -> String -> [String]
splitOn delim str
  | delim `isPrefixOf` str = "" : splitOn delim (drop (length delim) str)
  | null str = [""]
  | otherwise =
      let (x:xs) = splitOn delim (tail str)
      in (head str : x) : xs

parsePair :: [String] -> [(Int, Int)]
parsePair = map (\line -> let [a, b] = map read (splitOn "|" line) in (a, b))

parseList :: [String] -> [[Int]]
parseList = map (map read . splitOn ",")

parseFile :: FilePath -> IO ([(Int, Int)], [[Int]])
parseFile fileName = do
    content <- readFile fileName
    let sections = splitOn "\n\n" content
    case sections of
        [firstSection, secondSection] ->
            let pairs = parsePair (lines firstSection)
                lists = parseList (lines secondSection)
            in return (pairs, lists)

isCorrect :: [(Int, Int)] -> [Int] -> Bool
isCorrect _ [] = True
isCorrect pairs (x:xs) = 
  let filteredPairs = filter (\(_, b) -> b == x) pairs
      firstValues = map fst filteredPairs
  in if any (`elem` xs) firstValues
     then False
     else isCorrect pairs xs

middleItem :: [a] -> a
middleItem xs = 
    let idx = length xs `div` 2
    in xs !! idx

dependencyGraph :: [(Int, Int)] -> [Int] -> [(Int, [Int])]
dependencyGraph pairs xs = foldr addEdge [] pairs
  where
    addEdge (x, y) graph
      | x `elem` xs && y `elem` xs =
          case lookup x graph of
            Just neighbors -> (x, y:neighbors) : filter ((/= x) . fst) graph
            Nothing -> (x, [y]) : graph
      | otherwise = graph

kahnSort :: [(Int, Int)] -> [Int] -> [Int]
kahnSort pairs xs = 
  let graph = dependencyGraph pairs xs
  in go (filter (noIncoming graph) xs) [] graph
  where
    noIncoming g x = not $ any (elem x . snd) g
    go [] result _ = reverse result
    go (x:xs) result g = 
        let deps = case lookup x g of
                    Nothing -> []
                    Just ds -> ds
            g' = filter ((/= x) . fst) g
            newNodes = filter (noIncoming g') deps
        in go (xs ++ newNodes) (x:result) g'

main :: IO ()
main = do
    (pairs, lists) <- parseFile "input.txt"
    let incorrect = filter (not . isCorrect pairs) lists
    let fixed = map (kahnSort pairs) incorrect
    let ans = foldl (+) 0 (map middleItem fixed)
    print ans
