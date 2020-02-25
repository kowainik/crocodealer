module Crocodealer.ColorTerminal
       ( Color (..)
       , reset
       , setColor
       , successMessage
       , warningMessage
       , errorMessage
       , infoMessage
       , skipMessage
       ) where

import System.Console.ANSI (Color (..), ColorIntensity (Vivid), ConsoleLayer (Foreground), SGR (..),
                            setSGR)
import System.IO (hFlush)

setColor :: Color -> IO ()
setColor color = setSGR [SetColor Foreground Vivid color]

-- | Starts bold printing.
-- | Resets all previous settings.
reset :: IO ()
reset = do
    setSGR [Reset]
    hFlush stdout

colorMessage :: Color -> Text -> IO ()
colorMessage color message = do
    setColor color
    putTextLn $ "  " <> message
    reset

errorMessage, warningMessage, successMessage, infoMessage, skipMessage :: Text -> IO ()
errorMessage   = colorMessage Red
warningMessage = colorMessage Yellow
successMessage = colorMessage Green
infoMessage    = colorMessage Blue
skipMessage    = colorMessage Cyan
