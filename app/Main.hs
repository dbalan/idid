-- Copyright Dhananjay Balan (c) 2018

module Main where

import Cli
import Data as D
import System.IO

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
  putStrLn $ show entry

readMsg :: IO String
readMsg = do
  hSetBuffering stdout NoBuffering
  putStr "what did you do? "
  getLine

-- periodToDate :: DateTime -> Period -> DateTime
-- periodToDate now period = undefined
whatCmd :: Period -> IO ()
whatCmd = undefined
