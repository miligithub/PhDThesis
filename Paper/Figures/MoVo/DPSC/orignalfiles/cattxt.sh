#!/bin/bash
rm all.txt
touch all.txt
cat $1 >> all.txt
cat $2 >> all.txt