# import libraries
from bs4 import BeautifulSoup
import requests
import time
import datetime
import csv
import smtplib
import pandas as pd



# Connect to Website and pull in data
URL = 'https://www.amazon.com/gp/product/B07FNW9FGJ/ref=twister_dp_update?ie=UTF8&customId=B07537P4T9&psc=1&redirect=true'
headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101 Firefox/98.0",
            "Accept-Encoding": "gzip, deflate, br",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
            "Dnt": "1",
            "Connection":"close",
            "Upgrade-Insecure-Requests": "1"
}

# Get title and price from webpage
page = requests.get(URL, headers=headers)
soup1 = BeautifulSoup(page.content, "html.parser")
# print(soup1)
soup2 = BeautifulSoup(soup1.prettify(), "html.parser")
# print(soup2)
title = soup2.find(id='productTitle').get_text()
price = soup2.find(id='corePriceDisplay_desktop_feature_div').get_text()
#print(title)
#print(price)

# Clean up the data a little
price = price.strip()[1:]
title = title.strip()
print(title)
print(price[0:5])

today = datetime.date.today()
print(today)

# Create CSV and write headers and data into the file
header = ['Title', 'Price', 'Date']
data = [title, price, today]

with open('AmazonWebScraperDataset.csv', 'w', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)

    #df = pd.read_csv(r'C:\Users\ejore\PycharmProjects\AmazonWebScraper\AmazonWebScraperDataset.csv')
    #print(df)

# Now we are appending data to the csv
    with open('AmazonWebScraperDataset.csv', 'a+', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)

def check_price():
    URL = 'https://www.amazon.com/gp/product/B07FNW9FGJ/ref=twister_dp_update?ie=UTF8&customId=B07537P4T9&psc=1&redirect=true'
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101 Firefox/98.0",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
        "Dnt": "1",
        "Connection": "close",
        "Upgrade-Insecure-Requests": "1"
    }

    page = requests.get(URL, headers=headers)
    soup1 = BeautifulSoup(page.content, "html.parser")
    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")
    title = soup2.find(id='productTitle').get_text()
    price = soup2.find(id='corePriceDisplay_desktop_feature_div').get_text()
    price = price.strip()[1:]
    title = title.strip()
    today = datetime.date.today()

    header = ['Title', 'Price', 'Date']
    data = [title, price, today]

    with open('AmazonWebScraperDataset.csv', 'a+', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)

#while(True):
    check_price()
    time.sleep(86400)
    send_mail()

# Send email when a price drop hits
def send_mail():
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    server.login('email@gmail.com', '7e73hdT6r')

    subject = "Price drop for your item"
    body = "Your item has dropped in price. Link here: https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_3?dchild=1&keywords=data+analyst+tshirt&qid=1626655184&sr=8-3"

    msg = f"Subject: {subject}\n\n{body}"

    server.sendmail(
        'email@gmail.com',
        msg
    )
