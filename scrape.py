# 710
# Web-Scraping Fuel Cost Averages
# Taylor Meyer 2/22/2020

# Libraries
import requests
from urllib.request import Request, urlopen
from bs4 import BeautifulSoup as soup
import json

# AAA website to be scraped
url = "https://gasprices.aaa.com/?state=CA"

# Request page
req = Request(url , headers={'User-Agent': 'Mozilla/5.0'})

# Open it
webpage = urlopen(req).read()

# Parse it
page_soup = soup(webpage, 'html.parser')

# Put every line of html that contains an <h3> tag
# into a list
h3 = page_soup.findAll('h3')

# Element 5 is "Los Angeles-Long Beach"
#print(head3)

# For JSON
data = {}
data['fuelCost'] = []

# For every tag
for i in h3:
    # Get location
    loc = i.text
    # Get fuel cost
    cost = i.attrs.get('data-cost')
    #print(loc, cost, sep=' ')

    # Append to the JSON
    data['fuelCost'].append({
        'location': loc,
        'cost': cost
    })

# Write JSON to .txt file
with open('data.json', 'w') as outfile:
    json.dump(data, outfile)