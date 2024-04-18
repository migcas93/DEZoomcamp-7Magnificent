import io
import pandas as pd
import requests
from pandas import DataFrame
import yfinance as yf
from datetime import datetime, timedelta

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(**kwargs) -> DataFrame:
    """
    Template for loading data from API
    """
    
    start_date = ( datetime.now() - timedelta(days=365) ).strftime("%Y-%m-%d")

    tickers = ["AAPL", "GOOGL", "MSFT", "AMZN", "META", "TSLA", "NVDA"] # Magnificent 7 of NASDAQ

    data = []

    for i in tickers:
        a = yf.download(i, start=start_date ,interval="1h")
        a['Ticker'] = i
        data.append(a)

    df = pd.concat(data)


    return df


@test
def test_output(df) -> None:
    """
    Template code for testing the output of the block.
    """
    assert df is not None, 'The output is undefined'
