{- Game logic / win checking -}
module Game(module Game) where

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
emptyBoard rs cs = MkBoard Player rs cs

{- Q1(b): getCounter
 - Gets the counter at the given co-ordinates (or Nothing if there is no counter there).
 - Raises an error if co-ordinates are out-of-bounds. -}
getCounter :: Board -> RowID -> ColumnID -> Maybe Player
getCounter b r c = undefined

{- Q1(c): getRow
 - Retrieves the list of counters on the given row -}
getRow :: Board -> RowID -> [Maybe Player]
getRow b r = undefined

{- Q1(d): getColumn
 - Retrieves the list of counters in the given column, from top-to-bottom -}
getColumn :: Board -> ColumnID -> PaddedColumn
getColumn b c = undefined

{- Q2: Show instance -}
{- Show instance for players -}
instance Show Player where
    show p = undefined

{- Instance -}
instance Show Board where
    show b = undefined

{- Q3: Board update -}

{- Drops a counter into the given column. If the move is legal, returns an updated
 - board. Otherwise returns Nothing. -}
dropCounter :: Board -> ColumnID -> Player -> Maybe Board
dropCounter b c p = undefined

{- Q4: Diagonals -}
getTLBRDiagonals :: Board -> [[Maybe Player]]
getTLBRDiagonals b = undefined

getBLTRDiagonals :: Board -> [Diagonal]
getBLTRDiagonals b = undefined

{- Q5: Win checking -}
{- Checks if the given list has a subsequence of length 4, returning Just Player
 - if so, Nothing otherwise -}
hasFourInRow :: [Maybe Player] -> Maybe Player
hasFourInRow = undefined

{- Checks all rows, columns, and diagonals for any subsequences of length 4 -}
checkWin :: Board -> Maybe Player
checkWin b = undefined
