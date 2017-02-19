from wikitools import wiki, api, wikifile, page
import ConfigParser
import os

def GetToken(site, title, action):
    token_params = {'action':'query','prop':'info','intoken':action,'titles':title}
    token_request = api.APIRequest(site,token_params)
    token_request.query()
    result = token_request.query()
    #print result
    page_rev = result['query']['pages'].keys()[0]
    token = result['query']['pages'][page_rev][action+'token']
    return token
    

def AppendTextToPage(site, title, append_text, summary=None):
    page = Page(site,title)
    page.edit(appendtext=append_text)
    if result['edit']['result'] != 'Success':
        print "Unsuccessful result ",result
        return False
    return True


def EditPage(site,title, new_text, summary=None):
    page = Page(site,title)
    page.edit(text=append_text)

    if result['edit']['result'] != 'Success':
        print "Unsuccessful result ",result
        return False
    return True

def GrabFileFromWeb(site, source_url, title=None, comment=''):
    if title == None:
        #make title from url and pray the source isn't an asshole
        title = source_url.split('/')[-1].split('?')[0]
    wfile = wikifile.File(site,title)
    wfile.upload(comment=comment, url=source_url)

def UploadFile(site, filepath, title=None, comment=''):
    if title == None:
        #make title from filepath
        title = filepath.split(os.sep)[-1]
    #wikifile
    wfile = wikifile.File(site, title)
    #local file
    lfile = open(filepath,'r')
    wfile.upload(lfile, comment)


def DownloadFile(site, title, outpath):
    wfile = wikifile.File(site, title)
    wfile.download(location=outpath)

def GetSiteAuthenticated(base_url, user, passwd):
    site = wiki.Wiki(base_url+'/api.php')
    site.login(user,passwd)
    return site

def GetSiteFromConfig(cfile = os.path.expanduser('~/.wikido'), target='default'):

    config = ConfigParser.ConfigParser()
    config.read(cfile)

    base_url = config.get(target, 'url')
    user = config.get(target, 'user')
    passwd = config.get(target,'password')
    return GetSiteAuthenticated(base_url, user, passwd)

#site = GetSiteAuthenticated('http://spikeback-sdr/wiki','greg','hexi32')


