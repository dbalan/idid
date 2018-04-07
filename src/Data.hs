-- Copyright Dhananjay Balan (c) 2018
module Data
  ( Entry
  , entryNow
  ) where

import Data.Time

data Entry = Entry UTCTime String
  deriving (Show, Read)

entryNow :: String -> IO Entry
entryNow msg = do
  curTime <- getCurrentTime
  return $ Entry curTime msg
