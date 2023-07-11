from playwright.sync_api import sync_playwright
import os
import time
import json
import logging 
from logging import getLogger

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
    rows.pop(0) # On enblève le header 
    column_content = []
    for row in rows:
        # print(rows[0].text_content().strip())
        cells = row.query_selector_all('td')
        column_content.append(cells[column_index].text_content().strip())

    column_content_clean = [element.replace('\n','') for element in column_content]
    column_content_clean.pop(0) # On enlève l'élément provenant du bandeau rechercher

    print("\n",column_content_clean)

    return column_content_clean

def select_scrolling_menu(page, menu_name, option_text):
    # Click on the combobox to open the dropdown menu
    page.get_by_role("combobox", name=menu_name).click()
    
    # Click on the option with the given text
    page.get_by_text(option_text).nth(1).click()