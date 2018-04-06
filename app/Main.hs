module Main where

import Cli

main :: IO ()
main = do
  cmd <- customIdidParser
  putStrLn $ show cmd

