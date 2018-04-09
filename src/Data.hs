-- Copyright Dhananjay Balan (c) 2018
module Data
  ( Entry
  , entryNow
  , toFile
  , readFromFile
  , isAfter
  , pretty
  ) where

import Data.Time

data Entry = Entry UTCTime String
  deriving (Show, Read)

entryNow :: String -> IO Entry
entryNow msg = do
  curTime <- getCurrentTime
  return $ Entry curTime msg

toFile :: Entry -> String
toFile = (\x -> show x ++ "\n")

readFromFile :: String -> [Entry]
readFromFile txt = map read $ lines txt

isAfter :: UTCTime -> Entry -> Bool
isAfter etm (Entry tm _) = etm < tm

pretty :: Entry -> String
pretty (Entry tm msg) = show tm ++ "  " ++ msg
