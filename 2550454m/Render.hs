module Render(module Render) where
import Game
import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Display
import Graphics.Gloss.Interface.IO.Interact

{- Viewport dimensions -}
windowWidth :: Float
windowWidth = 1024.0

windowHeight :: Float
windowHeight = 768.0

-- Q6 (Rendering the board)



window :: Display
window = InWindow "Nice Window" (200, 200) (10, 10)

-- sizes for drawing the board
squareSize :: Float
squareSize = 55
circleSize :: Float
circleSize =  (squareSize / 2) - 4

background :: Color
background = white

drawRectangle :: Float -> Float ->Picture
drawRectangle = rectangleWire

drawCircle :: Float -> Color -> Picture
drawCircle size c =  color c $ circleSolid size

counterToCircles :: Board -> Int -> Int -> Picture -> Picture
counterToCircles b r c p = case getCounter b r c of
    Nothing -> p
    Just Red -> p <> drawCircle circleSize azure
    Just Yellow -> p <> drawCircle circleSize violet

scaleText :: Float -> String ->Picture
scaleText scaleFactor phrase = scale scaleFactor scaleFactor (text phrase)

render :: Board -> Picture
render b = pictures [translate (fromIntegral x * squareSize) (fromIntegral y * squareSize) (counterToCircles b y x (drawRectangle squareSize squareSize)) |x <- [0 .. numCols b-1], y <- [0 .. numRows b -1]]

-- Q7 (Game loop)
-- Example of how to use displayIO (similar to interactIO)
testPicture :: IO ()
testPicture =
    displayIO
        (InWindow "Connect 4" (floor windowWidth, floor windowHeight) (0, 0))
        white
        (return (color red (rectangleSolid 50 50)))
        (const $ return ())

-- State of the Connect4 Game
data Connect4State = Connect4State {boardState :: Board, playerState :: Player, winner :: Maybe Player}

updateState :: Connect4State -> IO Picture
updateState state =  return (render (boardState state) <>
    (case winner state of
        Nothing -> Blank
        Just Red -> translate (-200) (-150) (scaleText 0.6 "Winner: BLUE!")
        Just Yellow -> translate (-200) (-150) (scaleText 0.6 "Winner: PURPLE!")))

eventHandler :: Event -> Connect4State -> IO Connect4State
eventHandler (EventKey (MouseButton LeftButton) Down _ (x,y)) state
    | x <= fromIntegral (numCols (boardState state)) * squareSize
    && y>= -10 && y <= fromIntegral (numRows (boardState state)) * squareSize
    && winner state == Nothing =
        let updateGameBoard = dropCounter (boardState state) (floor ((x+20)/squareSize)) (playerState state)
        in case updateGameBoard of
            Nothing -> return state 
            Just b -> let newConnect4State = Connect4State 
                            {boardState = b, playerState = togglePlayer (playerState state), winner = checkWin b}
                in if winner newConnect4State == Nothing then return newConnect4State
                    else return newConnect4State 
                                    {boardState = b, playerState = togglePlayer (playerState state), winner = winner newConnect4State}
eventHandler _ state = return state


-- Fill in gameLoop using interactIO to handle user input and display the game board.
gameLoop :: Int -> Int -> IO ()
gameLoop rows cols =  interactIO
        (InWindow "Connect 4" (floor windowWidth, floor windowHeight) (0, 0))
        white
        (Connect4State {boardState = emptyBoard rows cols, playerState = Red, winner = Nothing})
        updateState
        eventHandler
        (const $ return ())

