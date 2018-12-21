#!/bin/bash

sox $1 "${1%.*}_part_.mp3" silence 1 0.5 0.1% 1 0.5 0.1% : newfile : restart
