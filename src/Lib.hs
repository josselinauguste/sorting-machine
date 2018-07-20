module Lib
  ( getMessages
  , listBoxes
  , Server
  , UserName
  , Password
  , Connection(..)
  )
where

import           Network.HaskellNet.IMAP
import           Network.HaskellNet.IMAP.Connection
import           Network.HaskellNet.IMAP.SSL
import           Network.HaskellNet.IMAP.Types

type MessageUid = UID
type Server = String
type UserName = String
type Password = String
type BoxName = String

data Connection = Connection {server :: Server, username :: UserName, password :: Password}

getMessages :: Connection -> BoxName -> IO [MessageUid]
getMessages connection boxName = withConnection
  connection
  (\conn -> do
    select conn boxName
    search conn [ALLs]
  )

listBoxes :: Connection -> IO [MailboxName]
listBoxes connection = map snd <$> withConnection connection list

withConnection :: Connection -> (IMAPConnection -> IO a) -> IO a
withConnection connection io = do
  conn <- connectIMAPSSL $ server connection
  login conn (username connection) (password connection)
  result <- io conn
  logout conn
  pure result
