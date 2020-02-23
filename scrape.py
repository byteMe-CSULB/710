'''
Let's learn how to web scrape!
'''

# Libraries
import requests
from urllib.request import Request, urlopen
import time
from bs4 import BeautifulSoup

print("Hello World!")

url = "https://gasprices.aaa.com/?state=CA"

req = Request(url, headers={'User-Agent': 'Mozilla/5.0'})

webpage = urlopen(req).read()

#response = requests.get(url)
#soup = BeautifulSoup(response.text, "html.parser")
print(webpage)
