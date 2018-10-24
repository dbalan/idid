-- Copyright Dhananjay Balan (c) 2018

module Main where

import Cli
import Data as D

import Data.List
import Data.Time
import System.Directory

main :: IO ()
main = do
  cmd <- customIdidParser
  run cmd

-- actions, might need to move to a seperate new.
-- FIXME: IO Maybe Error?
run :: Args -> IO ()
run (Args (CommonOpts fp) cmd) = do
  expPt <- getExpandedPath fp
  runWithFp expPt cmd

runWithFp :: String -> Command -> IO ()
runWithFp fp (CommandNew msg) = newCmd (intercalate " " msg) fp
runWithFp fp (CommandWhat prd) = whatCmd prd fp

getExpandedPath :: FilePath -> IO FilePath
getExpandedPath ('~':'/':xs) = (++ "/" ++ xs) <$> getHomeDirectory
getExpandedPath x = return x

newCmd :: String -> FilePath -> IO ()
newCmd m fp = do
  entry <- D.entryNow m
  appendFile fp $ D.toFile entry

-- periodToDate now period = undefined
whatCmd :: Period -> String -> IO ()
whatCmd pd fp = do
  store <- readFile fp
  current <- getCurrentTime
  putStr $ D.prettyPrint $
    filter (\x -> D.isAfter (periodToDiff current pd) x) $ D.readFromFile store
