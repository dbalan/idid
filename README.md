# idid what?

[![CircleCI](https://circleci.com/gh/dbalan/idid/tree/master.svg?style=svg)](https://circleci.com/gh/dbalan/idid/tree/master)

Simple CLI to keep track of what I did. Data is stored in a text file, and the format is quite simple. <date-time> <msg>

## API
idid new : create a new idid entry
idid what <period>: displayes what you did last period `lastday|lastweek|lastmonth`

## Todo
- [x] Make storage file configurable
- [ ] Optional date argument for new
- [ ] Pretty printing
  - [ ] Group by date
  - [ ] Colored output

## Building
0. [stack]() needs to be install.
```
git clone git@github.com:dbalan/idid.git
cd idid/
stack setup
stack build
stack install
```

## Usage
```
I did what?

Usage: idid [--filepath FILEPATH] COMMAND
  I did what is a simple CLI to track things that you do, the program has
  command, one to record a small msg what you did and one to list all the things
  you did for given last period

Available options:
  -h,--help                Show this help text
  --filepath FILEPATH      file to store data (default: "~/.ididwhat.txt")

Available commands:
  new                      new idid entry
  what                     list what I did
```

1. Example session

```
$ idid new 
what did you do? some stuff
$ idid what lastweek
2018-04-08
========
1. fixed idid codebase to accept file as an argument

2018-04-10
========
1. some stuff
```
## Hacking!
Pull requests welcome!


