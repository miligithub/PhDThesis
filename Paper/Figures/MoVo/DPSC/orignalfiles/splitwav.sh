#!/bin/bash
ffmpeg -i $1 -f segment -segment_time 3 -c copy $1%03d.wav