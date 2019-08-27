#!/bin/bash

# set audio output to "auto"
#amixer cset numid=3 0
# force audio output to headphone jack
#amixer cset numid=3 1
# force audio output to hdmi
amixer cset numid=3 2

play -n synth .1 sin 1880
play -n synth 1.5 sin 880
play -n synth .5 sin 1280

