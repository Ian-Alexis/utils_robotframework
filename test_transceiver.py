from playwright.sync_api import sync_playwright
import os
import time
import json
import logging 
from logging import getLogger

import front.anyway_playwright as util
# playwright codegen

url = "https://anyway.qal.covage.com/"
constructeur_text_1 = "Constucteur test playwright 1"
constructeur_text_2 = "Constucteur test playwright 2"
commande = "playwright show-trace out/trace.zip"


def test():
    if util.Filter_try():
        os.system(commande)
        assert True
    else:
        assert False

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
        util.Erase_if_exist(page, constructeur_text_1)
        util.Erase_if_exist(page, constructeur_text_2)
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

def run():
    try:
        with open("data/Dashboard_transceiver_dictionary.json", "r", encoding='utf-8') as file:
            data = json.load(file)
    except Exception as e:
        print("J'ai pas réussi à lire de JSON :(", e)


    with sync_playwright() as PS:
        # setup test
        browser = PS.chromium.launch(headless=False)
        context = browser.new_context()
        context.tracing.start(screenshots=True, snapshots=True, sources=True)
        page = context.new_page()
        # go to anyway
        page.goto("https://anyway.qal.covage.com/dashboard")

        page.get_by_role("link", name=" Modèle").click()
        page.get_by_role("link", name="Transceivers").click()
        util.Erase_if_exist(page, "Transceiver numéro 1")

        page.get_by_role("link", name="").click()
        page.get_by_role("combobox", name="Sélectionner un constructeur").click()
        page.get_by_text(data["Dashboard_transceiver_1"]["Constructeur"]).nth(2).click()
        # select_scrolling_menu(page, "Sélectionner un constructeur", data["Dashboard_transceiver_1"]["Constructeur"])

        page.get_by_label("Nom du modèle *").click()

        try:
            page.get_by_label("Nom du modèle *").fill(data["Dashboard_transceiver_1"]["Nom"])
        except:
            print("J'ai raté :(")
            page.get_by_label("Nom du modèle *").fill("Transceiver numéro 1")

        page.get_by_label("Référence *").click()
        page.get_by_label("Référence *").fill(data["Dashboard_transceiver_1"]["Référence"])

        try:
            util.select_scrolling_menu(page, "Sélectionner une technique",data["Dashboard_transceiver_1"]["Technique"])
        except:
            print("J'ai pas réussi à utiliser select_scrolling_menu :(")
            page.get_by_role("combobox", name="Sélectionner une technique").click()
            page.get_by_text("Unidirectionnel").nth(1).click()

        util.select_scrolling_menu(page, "Sélectionner un type", data["Dashboard_transceiver_1"]["Type"])
        util.select_scrolling_menu(page, "Sélectionner un débit", data["Dashboard_transceiver_1"]["Débit"])

        page.get_by_label("Distance (Km) *").click()
        page.get_by_label("Distance (Km) *").fill(data["Dashboard_transceiver_1"]["Distance (Km)"])
        page.get_by_label("Budget optique (dBm) *").click()
        page.get_by_label("Budget optique (dBm) *").fill(data["Dashboard_transceiver_1"]["Budget optique (dBm)"])
        page.get_by_label("Tx *").click()
        page.get_by_label("Tx *").fill(data["Dashboard_transceiver_1"]["Tx"])
        page.get_by_label("Rx *").click()
        page.get_by_label("Rx *").fill(data["Dashboard_transceiver_1"]["Rx"])
        page.get_by_label("Description *").click()
        page.get_by_label("Description *").fill(data["Dashboard_transceiver_1"]["Description"])
        page.get_by_role("button", name="Ajouter").nth(1).click()
        page.get_by_role("button", name="OK").click()
        page.get_by_role("link", name="Transceivers").click()

        page.get_by_role("columnheader", name="Nom").get_by_role("img").click()

        page.get_by_role("columnheader", name="Type").get_by_role("img").click()
        util.get_column_content(page,"Type")

        util.filter_search_test(page, "data/tabs")

        page.locator("#table-filter-name").click()
        page.locator("#table-filter-name").fill("Transceiver numéro 1")

        page.get_by_role("combobox", name="Tous").first.click()
        page.locator("#bs-select-2-13").click()

        page.locator("#table-filter-name").click()
        page.locator("#table-filter-name").press("Control+a")
        page.locator("#table-filter-name").press("Delete")

        page.locator("#table-filter-reference").click()
        page.locator("#table-filter-reference").fill("Transceiver")

        page.get_by_role("cell", name="Transceiver_numéro-1").click()
        page.get_by_role("button", name="").click()
        page.get_by_role("button", name="Confirmer").click()
        page.get_by_role("button", name="OK").click()

        context.tracing.stop(path="out/trace.zip")

        # ---------------------
        context.close()
        browser.close()
    return True

test()