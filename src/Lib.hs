module Lib
  ( getMessages
  , listBoxes
  , Server
  , UserName
  , Password
  )
where

import           Network.HaskellNet.IMAP
import           Network.HaskellNet.IMAP.SSL
import           Network.HaskellNet.IMAP.Types

type MessageUid = UID
type Server = String
type UserName = String
type Password = String
type BoxName = String

getMessages :: Server -> UserName -> Password -> BoxName -> IO [MessageUid]
getMessages server userName password boxName = do
  conn <- connectIMAPSSL server
  login conn userName password
  select conn boxName
  uids <- search conn [ALLs]
  logout conn
  pure uids

listBoxes :: Server -> UserName -> Password -> IO [MailboxName]
listBoxes server userName password = do
  conn <- connectIMAPSSL server
  login conn userName password
  mailboxes <- list conn
  logout conn
  pure $ map snd mailboxes
