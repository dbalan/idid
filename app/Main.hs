module Main where

import Options.Applicative
import Data.Monoid
import Control.Applicative

-- definitions for commands
data Command = CommandNew
             | CommandLast {
                 period :: Period
                 }
               deriving (Show)

data Period = Day
  | Week
  | Month
  deriving (Show)

-- parsers for command
parseCommand :: Parser Command
parseCommand = subparser $
  (command
   "new"
    (info (helper <*> parseNewCommand)
     (fullDesc <> progDesc "new idid entry"))
  ) <>

  (command
   "last"
   (info (helper <*> parseWhatCommand)
    (fullDesc <> progDesc "list what I did"))
  )

parseNewCommand :: Parser Command
parseNewCommand = pure (CommandNew)

parseWhatCommand :: Parser Command
parseWhatCommand = CommandLast <$> periodParser

periodParser :: Parser Period
periodParser = subparser $
  (command
  "day"
  (info (helper <*> pure (Day))
        (fullDesc <> progDesc "last day"))
  ) <>
  (command
  "week"
  (info (helper <*> pure (Week))
        (fullDesc <> progDesc "last day"))
  ) <>
  (command
  "month"
  (info (helper <*> pure (Month))
        (fullDesc <> progDesc "last day"))
  )


showHelpOnErrorExecParser :: ParserInfo a -> IO a
showHelpOnErrorExecParser = customExecParser (prefs showHelpOnError)

main :: IO ()
main = do
  cmd <- showHelpOnErrorExecParser (info (helper <*> parseCommand)
                                    (fullDesc <> progDesc "description" <> header "header"))
  putStrLn $ show cmd

