-- Copyright Dhananjay Balan (c) 2018
module Data
  ( Entry
  , entryNow
  , toFile
  , readFromFile
  , isAfter
  , prettyPrint
  ) where

import Data.Time
import Data.List

data Entry = Entry UTCTime String
  deriving (Show, Read, Eq, Ord)

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

prettyGroup :: [Entry] -> [(Day, [String])]
prettyGroup entry = foldl (\a b -> a ++ [(b, lookup b)]) [] days
  where
    se = sort entry
    dse = map dateEntry se
    days = sort $ nub $ map fst dse
    lookup b = map snd $ filter (\x -> fst x == b) dse

dateEntry :: Entry -> (Day, String)
dateEntry (Entry tm msg) = ((utctDay tm), msg)

groupPrint :: (Day, [String]) -> String
groupPrint (d, msgs) = show d ++ "\n========\n" ++ concatMap (\a -> a ++ "\n") nmsgs
  where
    nmsgs = map (\a -> (show $ fst a) ++ ". " ++ snd a) $ zip [1..] msgs

prettyPrint :: [Entry] -> String
prettyPrint es = concatMap (\e -> groupPrint e ++ "\n") $ prettyGroup es
