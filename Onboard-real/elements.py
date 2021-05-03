from pathlib import Path
from selenium import webdriver
from selenium.webdriver.common.by import By


class ChromeConfig:

    chromeOptions = webdriver.ChromeOptions()
    prefs = {'safebrowsing.enabled': 'false'}
    chromeOptions.add_experimental_option("prefs", prefs)
    chromeOptions.add_experimental_option('excludeSwitches', ['enable-logging'])


class Locator_convertion:
    locator = {
        "XPATH": By.XPATH,
        "CLASS_NAME": By.CLASS_NAME,
        "ID": By.ID,
        "LINK_TEXT": By.LINK_TEXT,
        "PARTIAL_LINK_TEXT": By.PARTIAL_LINK_TEXT,
        "NAME": By.NAME,
        "TAG_NAME": By.TAG_NAME,
        "CSS_SELECTOR": By.CSS_SELECTOR
    }


class OS_Paths:
    DOWNLOADS_DIRECTORY = str(Path.home() / "Downloads")


class Utils:
    installation_paths = []
    not_downloaded = []
    installation_errors = []
