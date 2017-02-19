#! /usr/bin/python
import code
from wikido import *
import sys

fpath= sys.argv[2]
title= sys.argv[1]
site = GetSiteFromConfig()
DownloadFile(site, title, fpath)
