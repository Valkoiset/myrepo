

# install.packages("rchess")
# Or if you want to be risky you can install the latest development version from github with:
# devtools::install_github("jbkunst/rchess")

library(rchess)
library(dplyr)
  
  # FIDE World Cups data
  data(chesswc)
  count(chesswc, event)   # counts number of events in each World Cup
  
# Basic Usage
chss <- Chess$new()

# Check the legal next moves:
chss$moves()

# A tibble: 20 x 6 
# (moves available in this position with description of pieces and squares)
chss$moves(verbose = TRUE)

# Make a move:
chss$move("a3")

# We can concate some moves (and a captures)
chss$move("e5")$move("f4")$move("Qe7")$move("fxe5")
plot(chss)

# Or a ggplot2 version (I know, I need to change the chess pieces symbols in unicode; maybe use a chess typeface)
# plot(chss, type = "ggplot")

# There are function to get information of actual position:
chss$turn()   # whose turn is it now
chss$square_color("h1")
chss$get("e5")   # get color of square and piece which stands there
chss$history(verbose = TRUE)   # A tibble: 5 x 8
chss$history()
  chss$undo()   # back to 1 turn before
chss$history()

chss$fen()   # Forsyth–Edwards Notation (FEN) is a standard notation for 
             # describing a particular board position of a chess game. 
             # The purpose of FEN is to provide all the necessary information to 
             # restart a game from a particular position.

# You can edit the header
chss$header("White", "You")
chss$header("WhiteElo", 1800)
chss$header("Black", "Me")
chss$header("Date", Sys.Date())
chss$header("Site", "This R session")

# Get the header
chss$get_header()

# And get the pgn
cat(chss$pgn())

# Or plot the board in ascii format:
chss$ascii()

# Load PGN and FEN
# FEN
chssfen <- Chess$new()

fen <- "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2"

chssfen$load(fen)
plot(chssfen)

# PGN
pgn <- system.file("extdata/pgn/kasparov_vs_topalov.pgn", package = "rchess")
pgn <- readLines(pgn, warn = FALSE)
pgn <- paste(pgn, collapse = "\n")
cat(pgn)

chsspgn <- Chess$new()

chsspgn$load_pgn(pgn)
chsspgn$history()
chsspgn$history(verbose = TRUE)   # A tibble: 87 x 8
plot(chsspgn)

# Validation Functions
# State validation
chss2 <- Chess$new("rnb1kbnr/pppp1ppp/8/4p3/5PPq/8/PPPPP2P/RNBQKBNR w KQkq - 1 3")
plot(chss2)
chss2$in_check()
chss2$in_checkmate()

# Slatemate validation
chss3 <- Chess$new("4k3/4P3/4K3/8/8/8/8/8 b - - 0 78")
plot(chss3)
chss3$in_stalemate()

# Three fold repetition
chss4 <- Chess$new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")

chss4$in_threefold_repetition()   # FALSE
chss4$move('Nf3')$move('Nf6')$move('Ng1')$move('Ng8')
chss4$in_threefold_repetition()   # FALSE
chss4$move('Nf3')$move('Nf6')$move('Ng1')$move('Ng8')
chss4$in_threefold_repetition()   # TRUE
chss4$history()

# Insufficient material
chss5 <- Chess$new("k7/8/n7/8/8/8/8/7K b - - 0 1")
plot(chss5)
chss5$insufficient_material()

# Helpers Functions
# There some helper function to get more information
# History Detail
# This functions is a detailed version from the history(verbose = TRUE).
chsspgn$history_detail()

# Plot a boad via ggplot
# You can plot a specific fen vía ggplot:
# ggchessboard(chsspgn$fen())

# Auxiliar Data
# There function to retrieve some data which is easier to plot:
  
# Pieces
rchess:::.chesspiecedata()

# Board
rchess:::.chessboarddata()

# Data
# The package have two data sets:
  
# FIDE World cups
data("chesswc")
str(chesswc)
head(chesswc)

# More Details
# Under the hood
# This package is mainly a wrapper of chessjs by jhlywa.
# 
# The main parts in this package are:
#   
#   V8 package and chessjs javascript library.
#   R6 package for the OO system.
#   htmlwidget package and chessboardjs javascript library.
#
# Thanks to the creators and maintainers of these packages and libraries.
# 
# Session Info
print(sessionInfo())



