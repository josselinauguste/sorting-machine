module Main where

import           Data.List                      ( intercalate )
import           Lib
import           System.Environment

main :: IO ()
main = do
  myConnection <- connection
  boxes        <- listBoxes myConnection
  putStr $ intercalate "\n" boxes
  msgs <- getMessages myConnection "[Gmail]/All Mail"
  print $ length msgs

connection :: IO Connection
connection = do
  myServer   <- getEnv "IMAP_SERVER"
  myUsername <- getEnv "IMAP_USER"
  myPassword <- getEnv "IMAP_PASS"
  pure Connection
    { server   = myServer
    , username = myUsername
    , password = myPassword
    }
