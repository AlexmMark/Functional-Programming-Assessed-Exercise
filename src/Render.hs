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
render :: Board -> Picture
render b = undefined

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
gameLoop rows cols = undefined
