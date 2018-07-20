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
getMessages connection boxName = do
  conn <- connect connection
  select conn boxName
  uids <- search conn [ALLs]
  logout conn
  pure uids

listBoxes :: Connection -> IO [MailboxName]
listBoxes connection = do
  conn      <- connect connection
  mailboxes <- list conn
  logout conn
  pure $ map snd mailboxes

connect :: Connection -> IO IMAPConnection
connect connection = do
  conn <- connectIMAPSSL $ server connection
  login conn (username connection) (password connection)
  pure conn
