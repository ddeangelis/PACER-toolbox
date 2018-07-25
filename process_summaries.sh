#!/bin/bash
#title          :process_summaries.sh
#description    :Simple bash script to extract data from multiple PACER search html files.
#author         :Tyche Analytics. Co.

for f in $(find /PACER_summaries/html_files/ -name '*.html')
do
    python PACER_search_extract.py $f
done
