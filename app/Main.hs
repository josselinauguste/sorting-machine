module Main where

import           Data.List                      ( intercalate )
import           Lib
import           System.Environment

main :: IO ()
main = do
  myServer   <- imapServer
  myUsername <- username
  myPassword <- password
  boxes      <- listBoxes myServer myUsername myPassword
  putStr $ intercalate "\n" boxes
  msgs <- getMessages myServer myUsername myPassword "[Gmail]/All Mail"
  print $ length msgs

imapServer :: IO Server
imapServer = getEnv "IMAP_SERVER"

username :: IO UserName
username = getEnv "IMAP_USER"

password :: IO Password
password = getEnv "IMAP_PASS"
