from binance.client import Client
from datetime import datetime
from pandas import DataFrame as df
from dotenv import load_dotenv
import os


load_dotenv()
BINANCE_API_KEY = os.getenv('BINANCE_API_KEY')
BINANCE_SECRET_KEY = os.getenv('BINANCE_SECRET_KEY')
client = Client(api_key, api_secret)
