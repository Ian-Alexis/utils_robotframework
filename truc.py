from playwright.sync_api import sync_playwright
import os
# import time
# playwright codegen

url = "https://anyway.qal.covage.com/"
constructeur_text_1 = "Constucteur test playwright 1"
constructeur_text_2 = "Constucteur test playwright 2"
commande = "playwright show-trace out/trace.zip"

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
        page.get_by_role("button", name="Ajouter").nth(1).click()
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
        print(text)
        # save recording in a zip file
        context.tracing.stop(path="out/trace.zip")
        # to close browser
        context.close()
        browser.close()
    return True


def Erase_if_exist(page, constructeur_text):
    page.get_by_placeholder("Rechercher...").click()
    page.get_by_placeholder("Rechercher...").fill(constructeur_text)
    try:
        page.get_by_role("cell", name=constructeur_text).click(timeout=3000)
        page.get_by_role("button", name="").click()
        page.get_by_role("button", name="Confirmer").click()
        page.get_by_role("button", name="OK").click()
    except:
        print("Don't find")


def test_myscript():
    if First_try() is True:
        os.system(commande)
        assert True
    else:
        assert False

test_myscript()