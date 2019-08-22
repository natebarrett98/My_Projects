
##Calculates OHLC at the specific minute


import pandas as pd
import requests
import numpy as np
from datetime import datetime

def current_candlestick_data(symbol):
    
    dt = datetime.now()


    
    symbol = str(symbol)
    url = "https://api.binance.com/api/v1/klines?"+"symbol="+symbol+"&interval=1m"
    resp= requests.get(url)
    rawd = resp.json()
    rawd1 = np.array(rawd[0],dtype=np.float64)
    rawd2 = rawd1[[0,1,2,3,4,5,8]]
    a = dt.strftime('%Y-%m-%d %H:%M')
    b = pd.Series([a,rawd2[1],rawd2[2],rawd2[3],rawd2[4],rawd2[5],rawd2[6]],index=["Time","Open","High","Low","Close","Volume","Num Trades"])
    
    return b

current_candlestick_data("BTCUSDT")
current_candlestick_data("ETHUSDT")