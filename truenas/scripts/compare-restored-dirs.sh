#!/bin/bash

rsync -rcnv /mnt/thedatapool/restored/* /mnt/backupspool/restored-from-qnap/

#-r will recurse into the directories
#-c will compare based on file checksum
#-n will run it as a "dry run" and make no changes, but just print out the files 
#   that would be updated
#-v will print the output to stdout verbosely

