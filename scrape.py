# 710
# Web-Scraping Fuel Cost Averages
# Taylor Meyer 2/22/2020

# Libraries
import requests
from urllib.request import Request, urlopen
import time
from bs4 import BeautifulSoup as soup

# AAA website to be scraped
url = "https://gasprices.aaa.com/?state=CA"

# Request page
req = Request(url , headers={'User-Agent': 'Mozilla/5.0'})

# Open it
webpage = urlopen(req).read()

# Parse it
page_soup = soup(webpage, "html.parser")

# Put every line of html that contains an <h3> tag
# into a list
head3 = page_soup.findAll("h3")

# Element 5 is "Los Angeles-Long Beach"
print(head3[5])