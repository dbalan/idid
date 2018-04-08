module Cli
  ( customIdidParser
  , periodToNominalDiffTime
  , Command(..)
  , Period(..)
  ) where

import Options.Applicative
import Control.Applicative
import Data.Monoid
import Data.Time

-- definitions for commands
data Command = CommandNew
             | CommandWhat {
                 period :: Period
                 }
               deriving (Show)

data Period = Day
  | Week
  | Month
  deriving (Show, Eq)

-- description
hdr :: String
hdr = "I did what?"

desc :: String
desc = "I did what is a simple CLI to track things that you do, \
       \ the program has command, one to record a small msg what you did \
       \ and one to list all the things you did for given last period"

customIdidParser :: IO Command
customIdidParser = customExecParser (prefs showHelpOnError) $ (info (helper <*> parseCommand)
                                                              (fullDesc <> progDesc desc <> header hdr))

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
parseWhatCommand = CommandWhat <$> periodParser

periodParser :: Parser Period
periodParser = subparser $
  (command
  "lastday"
  (info (helper <*> pure (Day))
        (fullDesc <> progDesc "last day"))
  ) <>
  (command
  "lastweek"
  (info (helper <*> pure (Week))
        (fullDesc <> progDesc "last week"))
  ) <>
  (command
  "lastmonth"
  (info (helper <*> pure (Month))
        (fullDesc <> progDesc "last month"))
  )

-- data conversion
periodToNominalDiffTime :: Period -> NominalDiffTime
periodToNominalDiffTime p
  | p == Day = 24*60*60
  | p == Week = 7 * periodToNominalDiffTime Day
  | p == Month = 4 * periodToNominalDiffTime Week

