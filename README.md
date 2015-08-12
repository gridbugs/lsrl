LiveScript Roguelike Engine
===========================

A roguelike engine written in [LiveScript](http://livescript.net/).
Currently supports an ncurses frontend and a web frontend so it can be
run in a terminal or a browser.

## Usage

Tested with nodejs 0.10.25


```
npm install         # install dependencies

# ncurses frontend
./run-ncurses.sh    # run game in terminal using ncurses

# web frontend
make webapp         # compile javascript for web frontend
make watch          # update webapp as livescript files are changed
./webserver.sh      # start server
```
