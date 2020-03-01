# 710
# Web-Scraping Fuel Cost Averages
# Taylor Meyer 2/29/2020

# Libraries
import requests
from urllib.request import Request, urlopen
from bs4 import BeautifulSoup as soup
import json
import firebase_admin
import google.cloud
from firebase_admin import credentials, firestore
from pprint import pprint

def getStateNames(page_soup):

    # Get all href tag
    lines = page_soup.findAll('a', href=True)

    # Delete the ones that are not what we want
    del lines[0:44]
    del lines[51:53]

    # Append names with stripped whitespace to list
    list = []
    for line in lines:
        list.append(line.text.strip())
    
    # Return list
    return list

# URL
url = "https://gasprices.aaa.com/state-gas-price-averages/"

# Request page
req = Request(url, headers={'User-Agent': 'Mozilla/5.0'})

# Open it
webpage = urlopen(req).read()

# Parse it
page_soup = soup(webpage, 'html.parser')

# Get state names
names = getStateNames(page_soup)

prices = page_soup.findAll('td')
count = 0
for i in prices:
    print(count,":",i,sep="")
    count = count + 1