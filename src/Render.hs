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

background :: Color
background = white

drawRectangle :: Float -> Float ->Picture
drawRectangle = rectangleWire

drawCircle :: Float -> Color -> Picture
drawCircle size c =  color c $ circleSolid size

counterToCircles :: Board -> Int -> Int -> Picture -> Picture
counterToCircles b r c p = case getCounter b r c of
    Nothing -> p
    Just Red -> p <> drawCircle 30 azure
    Just Yellow -> p <> drawCircle 30 violet

render :: Board -> Picture
render b = pictures [translate (fromIntegral x * 69) (fromIntegral y * 69) (counterToCircles b y x (drawRectangle 69 69)) |x <- [0 .. numCols b-1], y <- [0 .. numRows b -1]]

-- Q7 (Game loop)
-- Example of how to use displayIO (similar to interactIO)
testPicture :: IO ()
testPicture =
    displayIO
        (InWindow "Connect 4" (floor windowWidth, floor windowHeight) (0, 0))
        white
        (return (color red (rectangleSolid 50 50)))
        (const $ return ())

-- Fill in gameLoop using interactIO to handle user input and display the game board.
gameLoop :: Int -> Int -> IO ()
gameLoop rows cols =  displayIO
        (InWindow "Connect 4" (floor windowWidth, floor windowHeight) (0, 0))
        white
        (return (render $ b)) -- i care avout this
        (const $ return ())

        where 
            b = MkBoard { board =  [[Red], [Red, Yellow], [Red, Yellow, Red], [Red, Yellow, Yellow, Yellow], []], numRows = 5, numCols = 5 }
