# FastLED on PC

## What?

With this software you can run an Arduino Sketch on your PC.
In particular, you can run FastLED sketches with Adafruit-GFX.

It is made for Linux using SDL.


## Why?

It takes three weeks to ship a serial LED strip from China, but I want to start coding animations now!

# HowTo

If you are using [Arduino Make](https://github.com/sudar/Arduino-Makefile), it should be sufficient to
replace the `Arduino.mk` include with `makeNativeArduino.mk` in your Makefile.
Then simply run `make` as usual.

See the `example/` directory for an example.

# Installation

SDL is used to render a simulation of the LED-Strip Matrix.
To install the required dependencies, run

```
sudo apt install libsdl2-dev
```
