LiveScript Roguelike Engine
===========================

A roguelike engine written in [LiveScript](http://livescript.net/).
Currently supports an ncurses frontend and a web frontend so it can be
run in a terminal or a browser.

## Dependencies

- zeromq (required to compile ncurses)

## Usage

Tested with nodejs 0.10.25, npm 1.3.24


```
npm install         # install dependencies

# ncurses frontend
./run-ncurses.sh    # run game in terminal using ncurses

# web frontend
make webapp         # compile javascript for web frontend
make watch          # update webapp as livescript files are changed
./webserver.sh      # start server
```

## Compiling ncurses

If the ncurses compilation (during `npm install`) is failing with errors,
make sure the package "zeromq" is installed. This has only been tested using
nodejs 0.10.25, npm 1.3.24.
