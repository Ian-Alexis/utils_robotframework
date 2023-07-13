from playwright.sync_api import sync_playwright
import os
import time
import json
from class_elements import constructeurClass, modeleTransceiverClass
from utils import connect_to_anyway, exctract_from_json
# python.exe -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org pip install

url = "https://anyway.qal.covage.com/"
constructeur_text_1 = "Constucteur test playwright 1"
constructeur_text_2 = "Constucteur test playwright 2"
commande = "playwright show-trace out/trace.zip"
# /html/body/main/div[2]/div/div/div/div[2]/div/div[4]/table/tbody/tr[1]/td[4]/div/div/button/div/div/div

"""
def First_try():
    with sync_playwright() as PS:
        # setup test
        browser = PS.chromium.launch(headless=False)
        context = browser.new_context()
        context.tracing.start(screenshots=True, snapshots=True, sources=True)
        page = context.new_page()
        # go to anyway
        page.goto(url)
        page.get_by_role("link", name=" Constructeurs").click()
        # test if constructor exist
        Erase_if_exist(page, constructeur_text_1)
        Erase_if_exist(page, constructeur_text_2)
        # create constructor 1
        page.get_by_role("link", name="").click()
        page.get_by_label("Nom *").click()
        page.get_by_label("Nom *").fill(constructeur_text_1)
        page.get_by_role("button", name="Ajouter").nth(0).click()
        page.get_by_role("button", name="OK").click()
        # return on list ok constructeur
        page.get_by_role("link", name="Constructeurs", exact=True).click()
        # create constructeur 1 again
        page.get_by_role("link", name="").click()
        page.get_by_label("Nom *").click()
        page.get_by_label("Nom *").fill(constructeur_text_1)
        page.get_by_role("button", name="Ajouter").nth(1).click()
        # verify text error
        text = page.wait_for_selector(".form-text.text-danger").text_content()
        # save recording in a zip file
        context.tracing.stop(path="out/trace.zip")
        # to close browser
        context.close()
        browser.close()
    return True

    def erase_if_exist(constructeur_text):
        page.get_by_placeholder("Rechercher...").click()
        page.get_by_placeholder("Rechercher...").fill(constructeur_text)
        try:
            page.get_by_role("cell", name=constructeur_text).click(timeout=1000)
            page.get_by_role("button", name="").click()
            page.get_by_role("button", name="Confirmer").click()
            page.get_by_role("button", name="OK").click()
        except:
            print("Don't find")
"""


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
    with open("tabs.json", "r", encoding="utf-8") as file_tabs:
        data_tabs = json.load(file_tabs)
    for tabs in data_tabs:
        page.goto(data_tabs[tabs][2])
        filter_search_test(page, tabs)


def filter_search_test(page, tab, test=None):
    # extract json file
    with open("{}.json".format(tab), "r", encoding="utf-8") as file:
        data_tab = json.load(file)
    # extract name of column
    page.wait_for_selector('//thead[@class="table-dark"]')
    headers = page.query_selector_all('th')
    # find all span
    headers_data = []
    for header in headers:
        headers_data.append(header.text_content().strip())
    headers_data.pop(0)
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


def second_try():
    with sync_playwright() as PS:
        page = connect_to_anyway(PS)
        # create constructor 2
        page.get_by_role("link", name=" Constructeurs").click()
        data = exctract_from_json("constructeurs")
        constructeur_2 = constructeurClass(data["Constructeur numéro 2"])
        constructeur_2.erase(page)
        page.get_by_role("link", name="").click()
        constructeur_2.create()
        page.get_by_role("button", name="Ajouter").nth(0).click()
        page.get_by_role("button", name="OK").click()
        # create transceiver 1
        page.get_by_role("link", name=" Modèle").click()
        page.get_by_role("link", name="Transceivers").click()
        data = exctract_from_json("modèle_transceivers")
        transceiver_1 = modeleTransceiverClass(data["Transceiver numéro 1"])
        transceiver_1.erase(page)
        page.get_by_role("link", name="").click()
        transceiver_1.create()
        page.get_by_role("button", name="Ajouter").nth(0).click()
        page.get_by_role("button", name="OK").click()


def test_myscript():
    # if First_try() is True:
    #     os.system(commande)
    #     assert True
    if second_try():
        os.system(commande)
        assert True
    else:
        assert False


second_try()
# Filter_try()
