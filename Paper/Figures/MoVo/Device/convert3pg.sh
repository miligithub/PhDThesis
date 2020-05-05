#!/bin/sh
if [ $# -eq 0 ];then
    folder=MoVoApp
else
    folder=MoVoApp$1
fi
echo Processing $folder... 
folderlen=${#folder}
echo $folderlen
for file in $folder/*.3gp; do    
    echo $file
    filelen=${#file}
    echo $filelen
    start=$((folderlen+1))
    continue=$((filelen-folderlen-5))
    filename=${file:$start:$continue} 
    echo $filename.wav
    if [ ! -f $folder/$filename.wav ]; then
        ffmpeg -i $file $folder/$filename.wav
    fi    
done