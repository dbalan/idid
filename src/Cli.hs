module Cli
  ( customIdidParser
  , periodToDiff
  , Args(..)
  , CommonOpts(..)
  , Command(..)
  , Period(..)
  ) where

import Options.Applicative
import Data.Monoid
import Data.Time

-- definitions for command
data Args = Args CommonOpts Command
  deriving Show

data Command = CommandNew { message :: [String] }
             | CommandWhat { period :: Period }
               deriving (Show)

data CommonOpts = CommonOpts { filePath :: String }
  deriving (Show, Eq)

data Period = Day
  | Week
  | Month
  | Year
  | Period { date :: String }
  deriving (Show, Eq)

-- description
hdr :: String
hdr = "I did what?"

desc :: String
desc = "I did what is a simple CLI to track things that you do, \
       \ the program has command, one to record a small msg what you did \
       \ and one to list all the things you did for given last period"

customIdidParser :: IO Args
customIdidParser = customExecParser (prefs showHelpOnError) $ (info (helper <*> parse)
                                                              (fullDesc <> progDesc desc <> header hdr))

-- parsers for command
parse :: Parser Args
parse = (liftA2 Args parseOpts parseCommand)

parseCommand :: Parser Command
parseCommand = subparser $
  (command
   "new"
    (info (helper <*> parseNewCommand)
     (fullDesc <> progDesc "new idid entry"))
  ) <>

  (command
   "what"
   (info (helper <*> parseWhatCommand)
    (fullDesc <> progDesc "list what I did"))
  )

parseOpts :: Parser CommonOpts
parseOpts = CommonOpts
  <$> strOption (long "filepath"
                <> metavar "FILEPATH"
                <> showDefault
                <> value "~/.ididwhat.txt"
                <> help "file to store data")

parseNewCommand :: Parser Command
parseNewCommand = CommandNew <$> (many $ argument str (metavar "MSG.."))

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
  ) <>
  (command
  "lastyear"
  (info (helper <*> pure (Year))
        (fullDesc <> progDesc "last year"))
  ) <>
  (command
  "since"
  (info (helper <*> parseSince)
        (fullDesc <> progDesc "since date (format: YYYY-mm-dd)"))
  )

periodToDiff :: UTCTime -> Period -> UTCTime
periodToDiff cur pd@(Period {}) = addUTCTime (-1 * sincePeriodToNominalDiffTime cur pd) cur
periodToDiff cur pd = addUTCTime (-1 * periodToNominalDiffTime pd) cur

-- data conversion
periodToNominalDiffTime :: Period -> NominalDiffTime
periodToNominalDiffTime p
  | p == Day = 24*60*60
  | p == Week = 7 * periodToNominalDiffTime Day
  | p == Month = 4 * periodToNominalDiffTime Week
  | p == Year = 12 * periodToNominalDiffTime Month

sincePeriodToNominalDiffTime :: UTCTime -> Period -> NominalDiffTime
sincePeriodToNominalDiffTime cur Period { date = s } =
  case (parseTimeM True defaultTimeLocale "%Y-%m-%d" s) :: Maybe UTCTime of
    Just t -> diffUTCTime cur t
    Nothing -> 0

parseSince :: Parser Period
parseSince = parseDate <$>
  (argument str (metavar "date"))

parseDate :: String -> Period
parseDate dateStr = Period { date = dateStr }
