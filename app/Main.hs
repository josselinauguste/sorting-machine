module Main where

import           Configuration
import           Data.List                      ( intercalate )
import           MailServer

main :: IO ()
main = do
  connections <- loadConnections
  sequence_ $ printConnection <$> connections

printConnection :: Connection -> IO ()
printConnection connection = do
  boxes <- listBoxes connection
  putStr $ intercalate "\n" boxes
  putStrLn ""
  msgs <- getMessages connection
  print $ length msgs
