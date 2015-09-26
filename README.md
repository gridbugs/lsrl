LiveScript Roguelike Engine
===========================

A roguelike engine written in [LiveScript](http://livescript.net/).
It can be run in a terminal using nodejs and the blessed library,
or in a browser using html canvas.

## Dependencies

- python (required by npm. If the default python on your system is not python 2, run `npm install --python=/path/to/python2`.)

## Usage

```
npm install         # install dependencies

# terminal frontend
./game-console.sh    # run game in terminal

# web frontend
make webapp         # compile javascript for web frontend
./webserver.sh      # start server
```
