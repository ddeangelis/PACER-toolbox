'''
    File name: PACER_search_extract.py
    Author: Tyche Analytics Co.
'''

from bs4 import BeautifulSoup
import datetime
import sys

filename = sys.argv[1]
infile = open(filename, 'r')
soup = BeautifulSoup(infile)
infile.close()

outfile = open('/PACER_summaries/output.csv', 'a')

# Gets first case (row 2) case title (parties)
# soup('table')[3]('tr')[2]('td')[1].string

# Court
# soup('table')[3]('tr')[2]('td')[3].string

# Case ID
# soup('table')[3]('tr')[2]('td')[4].string

# NOS code
# soup('table')[3]('tr')[2]('td')[5].string

# Date Filed
# soup('table')[3]('tr')[2]('td')[6].string

# Date Closed
# soup('table')[3]('tr')[2]('td')[7].string

# Remove first garbage rows 
soup('table')[3]('tr')[0].extract()
soup('table')[3]('tr')[0].extract()

for case in soup('table')[3]('tr'):

    if not case('td')[1].string:
        plaintiff = ''
        defendant = ''
    else:
        if ' v. ' not in case('td')[1].string:
            plaintiff = case('td')[1].string
            defendant = ''
        else:
            plaintiff, defendant = case('td')[1].string.split(' v. ')

    court = case('td')[3].string
    case_ID = case('td')[4].string
    NOS = case('td')[5].string
    month, day, year = case('td')[6].string.split('/')
    date_filed = datetime.date(int(year), int(month), int(day))

    if not case('td')[7].string:
        date_closed = ''   
    else:
        month, day, year = case('td')[7].string.split('/')
        date_closed = datetime.date(int(year), int(month), int(day))
        date_closed = date_closed.isoformat()       

    outstring = case_ID + '^' + plaintiff + '^' + defendant + '^' + court + '^' + NOS + '^' + date_filed.isoformat() + '^' + date_closed + '\n'

    print outstring
    outfile.write(outstring)

outfile.close()
