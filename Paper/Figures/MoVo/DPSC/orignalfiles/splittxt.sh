#!/bin/bash

# Configuration stuff

fspec=$1
echo -e $fspec
num_files=$2
echo -e $num_files

# Work out lines per file.

total_lines=$(wc -l <${fspec})
((lines_per_file = (total_lines + num_files - 1) / num_files))

# Split the actual file, maintaining lines.

split -l $lines_per_file $fspec $fspec.

# Debug information

echo "Total lines     = ${total_lines}"
echo "Lines  per file = ${lines_per_file}"    
wc -l $fspec.*


