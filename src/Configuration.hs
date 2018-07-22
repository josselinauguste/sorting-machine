{-# LANGUAGE OverloadedStrings #-}

module Configuration
  ( loadConnections
  )
where

import           Data.Either                    ( rights )
import           Data.Ini
import           Data.Text                      ( Text
                                                , unpack
                                                )
import           MailServer                     ( Connection(..) )

type Section = Text

loadConnections :: IO [Connection]
loadConnections = getValidConnections <$> readIniFile "sorting-machine.ini"

getValidConnections :: Either String Ini -> [Connection]
getValidConnections (Right ini) = rights $ getConnection ini <$> sections ini
getValidConnections (Left  _  ) = []

getConnection :: Ini -> Section -> Either String Connection
getConnection ini section = do
  myServer   <- lookupValue section "server" ini
  myUsername <- lookupValue section "user" ini
  myPassword <- lookupValue section "password" ini
  myBoxName  <- lookupValue section "box" ini
  pure $ Connection
    { server   = unpack myServer
    , username = unpack myUsername
    , password = unpack myPassword
    , boxName  = unpack myBoxName
    }
