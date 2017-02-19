#! /usr/bin/python
import code
from wikido import *
import sys

text = '\n\n' + ' '.join(sys.argv[2:]) + '\n\n'
title= sys.argv[1]
site = GetSiteFromConfig()
AppendTextToPage(site,title,text)

#code.interact(local=locals())
