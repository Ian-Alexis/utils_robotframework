from playwright.sync_api import sync_playwright
import os
import time
import json
import logging 
from logging import getLogger

url = "https://anyway.qal.covage.com/dashboard"

def Erase_if_exist(page, constructeur_text):
    page.get_by_placeholder("Rechercher...").nth(0).click()
    page.get_by_placeholder("Rechercher...").nth(0).fill(constructeur_text)
    try:
        page.get_by_role("cell", name=constructeur_text).click(timeout=1000)
        page.get_by_role("button", name="").click()
        page.get_by_role("button", name="Confirmer").click()
        page.get_by_role("button", name="OK").click()
    except:
        print(constructeur_text, " Not found")
    
def get_column_content(page, column_name):
    time.sleep(0.5)
    # Find the column index by its name
    try:
        headers = page.query_selector_all('th')
        column_index = None
    except:
        print("Je n'ai pas trouvé le header :/")

    i = -1
    for header in headers:
        i += 1
        try:
            if header.text_content().strip() == column_name:
                column_index = i
                break
        except:
            print("Je n'ai pas exécuté la boucle :(")

    if column_index is None:
        print(f'Column "{column_name}" not found')
        return

    # Get the column content
    rows = page.query_selector_all('tr')
    rows.pop(0) # On enlève le header 
    column_content = []
    for row in rows:
        # print(rows[0].text_content().strip())
        cells = row.query_selector_all('td')
        column_content.append(cells[column_index].text_content().strip().lower())

    column_content_clean = [element.replace('\n','') for element in column_content]
    column_content_clean.pop(0) # On enlève l'élément provenant du bandeau rechercher

    # print("\n",column_content_clean)
    return column_content_clean

def select_scrolling_menu(page, menu_name, option_text):
    # Click on the combobox to open the dropdown menu
    page.get_by_role("combobox", name=menu_name).click()
    
    # Click on the option with the given text
    page.get_by_text(option_text).nth(1).click()

def Filter_try():
    with sync_playwright() as PS:
        # setup test
        browser = PS.chromium.launch(headless=False)
        context = browser.new_context()
        context.tracing.start(screenshots=True, snapshots=True, sources=True)
        page = context.new_page()
        # go to anyway
        page.goto(url)
        filter_all_search_test(page)
        # save recording in a zip file
        context.tracing.stop(path="out/trace.zip")
        # to close browser
        context.close()
        browser.close()
    return True


def filter_all_search_test(page,  menu=None, tab=None):
    # extract tabs json file
    with open("data/tabs.json", "r", encoding="utf-8") as file_tabs:
        data_tabs = json.load(file_tabs)
    for tabs in data_tabs:
        page.goto(data_tabs[tabs][2])
        # filter_search_test(page, tabs)
        test_whole_tab(page,tabs)


def filter_search_test(page, tab, test=None):
    # extract json file
    with open("data/{}.json".format(tab), "r", encoding="utf-8") as file:
        data_tab = json.load(file)
    # extract name of column
    page.wait_for_selector('//thead[@class="table-dark"]')
    headers = page.query_selector_all('th')
    # find all span
    headers_data = []
    for header in headers:
        headers_data.append(header.text_content().strip())
    headers_data.pop(0)
    print(headers_data)
    for header in headers_data:
        search = data_tab[header]
        index = find_index(headers_data, header) + 2
        xpath = '//tbody/tr/td[position()={}]/div'.format(index)
        element = page.wait_for_selector(xpath)
        page.click(xpath)
        try:
            if "input-group" in element.get_attribute("class"):
                el = "/input"
                xpath_input = '//tbody/tr/td[position()={}]/div{}'.format(index, el)
                element_input = page.wait_for_selector(xpath_input)
                element_input.fill(search)
        except:
            option = '//li/a/span[contains(text(),"{}")]'.format(search)
            page.click(option)

def find_index(liste, el):
    index = 0
    for i, element in enumerate(liste):
        if element == el:
            index = i
    return index

def test_whole_tab(page, tab, test=None):
    # extract json file
    with open("data/{}.json".format(tab), "r", encoding="utf-8") as file:
        data_tab = json.load(file)
    # extract name of column
    page.wait_for_selector('//thead[@class="table-dark"]')
    headers = page.query_selector_all('th')
    # find all span
    headers_data = []
    for header in headers:
        headers_data.append(header.text_content().strip())
    headers_data.pop(0)
    print(headers_data)
    for header in headers_data:
        unfiltered = get_column_content(page,header)
        unfiltered.sort()
        print("\n",unfiltered)
        page.get_by_role("columnheader", name=header).get_by_role("img").click()
        filtered = get_column_content(page,header)
        print(filtered,"\n")
        if filtered == unfiltered:
            print(header,"filter works correctly")
        else:
            print(header,"filter doesn't work")    
    for header in headers_data:
        search = data_tab[header]
        index = find_index(headers_data, header) + 2
        xpath = '//tbody/tr/td[position()={}]/div'.format(index)
        element = page.wait_for_selector(xpath)
        page.click(xpath)
        try:
            if "input-group" in element.get_attribute("class"):
                el = "/input"
                xpath_input = '//tbody/tr/td[position()={}]/div{}'.format(index, el)
                element_input = page.wait_for_selector(xpath_input)
                element_input.fill(search)
        except:
            option = '//li/a/span[contains(text(),"{}")]'.format(search)
            page.click(option)