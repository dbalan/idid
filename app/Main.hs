-- Copyright Dhananjay Balan (c) 2018

module Main where

import Cli
import Data as D
import System.IO
import Data.Time

-- FIXME: expose this
filePath :: String
filePath = "/home/dj/.ididwhat?"

main :: IO ()
main = do
  cmd <- customIdidParser
  run cmd

-- actions, might need to move to a seperate new.
-- FIXME: IO Maybe Error?
run :: Command -> IO ()
run CommandNew = newCmd
run (CommandWhat prd) = whatCmd prd

newCmd = do
  msg <- readMsg
  entry <- D.entryNow msg
  appendFile filePath $ D.toFile entry

readMsg :: IO String
readMsg = do
  hSetBuffering stdout NoBuffering
  putStr "what did you do? "
  getLine

periodToDiff :: UTCTime -> Period -> UTCTime
periodToDiff cur pd = addUTCTime (-1 * periodToNominalDiffTime pd) cur

-- periodToDate now period = undefined
whatCmd :: Period -> IO ()
whatCmd pd = do
  store <- readFile filePath
  current <- getCurrentTime
  mapM_ putStrLn $ map D.pretty $
    filter (\x -> D.isAfter (periodToDiff current pd) x) $ D.readFromFile store
