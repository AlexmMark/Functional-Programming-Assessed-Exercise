{- Game logic / win checking -}
module Game(module Game) where
import GHC.ForeignPtr (ForeignPtrContents(PlainForeignPtr))
import Data.Data (repConstr)
import Data.Maybe (listToMaybe, maybeToList, catMaybes)
-- import Graphics.Gloss (color)
-- import Options.Applicative.Help (column, rangle)

{- Board and counters definition -}
{- In our case, we represent a board as a function from column IDs to lists of tokens.
 - These are sparse and grow upwards. -}
{- Row indices again begin at the bottom left and grow upwards -}
type RowID = Int
type ColumnID = Int
type RowCount = Int
type ColCount = Int
data Player = Red | Yellow
    deriving (Eq)

type Row = [Maybe Player]
type PaddedColumn = [Maybe Player]
type Column = [Player]
type Diagonal = [Maybe Player]

data Board = MkBoard { board :: [[Player]], numRows :: Int, numCols :: Int }

{- Toggles the current player -}
togglePlayer :: Player -> Player
togglePlayer Red = Yellow
togglePlayer Yellow = Red

{- Board accessors / manipulation function -}

{- Q1(a): emptyBoard -}
emptyBoard :: RowCount -> ColCount -> Board
emptyBoard rows cols
    | rows < 4 || cols < 4 = error "Invalid size of rows and columns!" -- make exception? Shpuld it be greater than 4?
    | otherwise = MkBoard { board = replicate cols [], numRows = rows, numCols = cols}

{- Q1(b): getCounter
 - Gets the counter at the given co-ordinates (or Nothing if there is no counter there).
 - Raises an error if co-ordinates are out-of-bounds. -}

getCounter :: Board -> RowID -> ColumnID -> Maybe Player
getCounter b r c
    | r < 0 || r > (numRows b-1) || c < 0 || c > (numCols b-1) = error "Coordinates out of bounds!" --Accessor methods?
    | otherwise = toMaybeListElement (reverse (board b !! c)) r


{- Q1(c): getRow
 - Retrieves the list of counters on the given row -}
getRow :: Board -> RowID -> [Maybe Player]
getRow b r
    | r < 0 || r > (numRows b-1) = error "Coordinates out of bounds!"
    | otherwise = map (getCounter b r) [0 .. numCols b-1]

{- Q1(d): getColumn
 - Retrieves the list of counters in the given column, from top-to-bottom -}
getColumn :: Board -> ColumnID -> PaddedColumn
getColumn b c
    | c < 0 || c > (numCols b-1) = error "Coordinates out of bounds!"
    | otherwise = [getCounter b r c |r <- [0 .. numRows b -1]]

-- Helper

getBoard :: Board -> [[Player]]
getBoard = board

getRowNum :: Board -> Int
getRowNum = numRows

getColNum :: Board -> Int
getColNum = numCols

toMaybeListElement :: [a] -> Int -> Maybe a
toMaybeListElement l element
    | element >= length l = Nothing
    | otherwise = Just (l !! element)

{- Q2: Show instance -}
{- Show instance for players -}
instance Show Player where
    show p = playerColor
        where
            playerColor = case p of
                Red -> "R"
                Yellow -> "Y"


{- Instance -}
instance Show Board where
     show b = unlines (map showRows [(numRows b) - 1, (numRows b) - 2 .. 0])
        where
            showRows x = concatMap (maybe "0" show) (getRow b x)

{- Q3: Board update -}

{- Drops a counter into the given column. If the move is legal, returns an updated
 - board. Otherwise returns Nothing. -}
dropCounter :: Board -> ColumnID -> Player -> Maybe Board
dropCounter b c p
    |c < 0 || c > numCols b = Nothing -- columnID out of bounds
    | length (board b !! c) > numRows b = Nothing -- Check if the column is already full
    | otherwise = Just (updateBoard b c p)

-- Helpers
updateBoard :: Board -> ColumnID -> Player -> Board
updateBoard b c p =
    let newColumn = (board b !! c)
        newRow = [p] ++ newColumn
        newBoard =  take c (board b) ++ [newRow] ++ drop (c + 1) (board b)
    in MkBoard { board = newBoard, numRows = numRows b, numCols = numCols b }

{- Q4: Diagonals -}
getTLBRDiagonals :: Board -> [[Maybe Player]] -- Top Left Bottom Right
getTLBRDiagonals b = [getDiagonals b numOfDiagonals | numOfDiagonals <- [0.. numRows b + numCols b - 2]]

getBLTRDiagonals :: Board -> [[Maybe Player]]
getBLTRDiagonals b =
    let newBoard = MkBoard { board = reverse (board b), numRows = numRows b, numCols = numCols b}
    in reverse ( getTLBRDiagonals newBoard)

-- Helper

getDiagonals :: Board -> Int -> [Maybe Player]
getDiagonals b max
    | max >= 0 = [getCounter b (max - column) column | column <- [0 .. numRows b - 1], max-column >= 0, max-column <= numRows b - 1]
    | otherwise = error "invalid"

{- Q5: Win checking -}
{- Checks if the given list has a subsequence of length 4, returning Just Player
 - if so, Nothing otherwise -}
hasFourInRow :: [Maybe Player] -> Maybe Player
hasFourInRow [] = Nothing
hasFourInRow (a:b:c:d:rest)
    | a == Nothing = hasFourInRow (b:c:d:rest)
    |equalCounters [a, b, c, d] = a
    |otherwise = hasFourInRow (b:c:d:rest)
hasFourInRow _ = Nothing


{- Checks all rows, columns, and diagonals for any subsequences of length 4 -}
checkWin :: Board -> Maybe Player
checkWin b =
    let allPatterns = getBLTRDiagonals b ++ getTLBRDiagonals b ++ map (getRow b) [0..numRows b -1] ++ map (getColumn b) [0..numCols b -1]
    in findWinner allPatterns
-- Helper

equalCounters :: Eq a => [a] -> Bool
equalCounters [] = False
equalCounters (x : xs) = all (== x) xs

findWinner :: [[Maybe Player]] -> Maybe Player
findWinner patterns = listToMaybe (catMaybes (map hasFourInRow patterns))


 {-    | board b == [] = Nothing
    | otherwise = 
        let allPatterns = (getBLTRDiagonals b) ++ (getTLBRDiagonals b) ++ (map getRow b [0..numRows b -1]) ++ (map getColumn b [0..numCols b -1])
            match = False
        in-}