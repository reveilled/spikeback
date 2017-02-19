#! /usr/bin/python
import code
from wikido import *
import sys

text = '\n\n' + ' '.join(sys.argv[3:]) + '\n\n'
url = sys.argv[2]
title= sys.argv[1]
site = GetSiteFromConfig()
GrabFileFromWeb(site, url, title, text)
