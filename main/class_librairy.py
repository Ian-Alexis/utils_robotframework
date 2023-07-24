import utils as utils
from playwright.sync_api import sync_playwright
import time


class connectAnyway():
    def __init__(self) -> None:
        self.playwright = sync_playwright().start()
        self.browser = self.playwright.chromium.launch(headless=False,
                                                       channel="chrome",
                                                       args=["--start-maximized"])
        self.context = self.browser.new_context(no_viewport=True)
        self.page = self.context.new_page()

    def connect(self, url):
        self.page.goto(url)

    def send_page(self):
        return self.page

    def debug(self):
        self.context.tracing.start(screenshots=True,
                                   snapshots=True,
                                   sources=True)


class constructeurClass(connectAnyway):
    def __init__(self, AW, test) -> None:
        self.page = AW.page
        data = utils.extract_from_json("constructeurs")
        self.data = data[test]
        self.nom = data[test]["Nom"]
        self.prefixe_mac = data[test]["Préfixe MAC"]

    def goto(self):
        self.page.get_by_role("link", name=" Constructeurs").click()

    def goto_details(self):
        utils.test_search(self.page, self.data)
        self.page.get_by_role("cell", name=self.nom, exact=True).click()

    def goto_breadcrumb(self):
        self.page.get_by_role(
            "navigation", name="breadcrumb"
        ).get_by_role("link", name="Constructeurs").click()

    def goto_create(self):
        self.page.get_by_role("link", name="").click()

    def create(self):
        utils.fill_data("Nom", "input", self.nom, self.page)
        utils.fill_data("Préfixe MAC", "textarea", self.prefixe_mac, self.page)
        self.page.get_by_role("button", name="Ajouter").nth(1).click()

    def fill_detail(self, test):
        data = utils.extract_from_json("constructeurs")
        utils.fill_data("Nom", "input", data[test]["Nom"], self.page)
        utils.fill_data("Préfixe MAC", "textarea",
                        data[test]["Préfixe MAC"], self.page)
        self.page.get_by_role("button", name="").nth(1).click()

    def check_detail(self, test):
        data = utils.extract_from_json("constructeurs")
        utils.check_data("Nom", "input", data[test]["Nom"], self.page)
        utils.check_data("Préfixe MAC", "textarea",
                         data[test]["Préfixe MAC"], self.page)

    def click_ok(self):
        self.page.get_by_role("button", name="OK").click()

    def multiple_create(self, n):
        for i in range(n):
            self.goto_create()
            self.nom = "Constructeur multiple numéro {}".format(i+1)
            self.create()
            self.goto_breadcrumb()

    def erase(self):
        utils.erase_el(self.nom, self.page)

    def multiple_erase(self, n):
        for i in range(n):
            self.nom = "Constructeur multiple numéro {}".format(i+1)
            self.erase()

    def test_filter(self):
        utils.test_filter(self.page, self.data)

    def test_search(self):
        utils.test_search(self.page, self.data)

    def test_displayed_filter(self, number):
        utils.test_displayed_filter(self.page, number)


class modeleTransceiverClass():
    def __init__(self, AW, test) -> None:
        self.page = AW.page
        data = utils.extract_from_json("modèle_transceivers")
        self.data = data[test]
        self.constructeur = data[test]["Constructeur"]
        self.nom = data[test]["Nom"]
        self.reference = data[test]["Référence"]
        self.technique = data[test]["Technique"]
        self.type = data[test]["Type"]
        self.debit = data[test]["Débit"]
        self.distance = data[test]["Distance (Km)"]
        self.budget_optique = data[test]["Budget optique (dBm)"]
        self.tx = data[test]["Tx"]
        self.rx = data[test]["Rx"]
        self.description = data[test]["Description"]

    def goto(self):
        self.page.get_by_role("link", name=" Modèle").click()
        self.page.get_by_role("link", name="Transceivers").click()

    def goto_create(self):
        self.page.get_by_role("link", name="").click()

    def goto_details(self):
        utils.test_search(self.page, self.data)
        self.page.get_by_role("cell", name=self.nom, exact=True).click()

    def goto_breadcrumb(self):
        self.page.get_by_role(
            "navigation", name="breadcrumb"
        ).get_by_role("link", name="Transceivers").click()

    def create(self):
        utils.fill_data("Constructeur", "scrolling menu",
                        self.constructeur, self.page)
        utils.fill_data("Nom du modèle", "input",
                        self.nom, self.page)
        utils.fill_data("Référence", "input",
                        self.reference, self.page)
        utils.fill_data("Technique", "scrolling menu",
                        self.technique, self.page)
        utils.fill_data("Type", "scrolling menu",
                        self.type, self.page)
        utils.fill_data("Débit", "scrolling menu",
                        self.debit, self.page)
        utils.fill_data("Distance (Km)", "input",
                        self.distance, self.page)
        utils.fill_data("Budget optique (dBm)", "input",
                        self.budget_optique, self.page)
        utils.fill_data("Tx", "input",
                        self.tx, self.page)
        utils.fill_data("Rx", "input",
                        self.rx, self.page)
        utils.fill_data("Description", "textarea",
                        self.description, self.page)
        self.page.get_by_role("button", name="Ajouter").nth(1).click()

    def click_ok(self):
        self.page.get_by_role("button", name="OK").click()

    def fill_detail(self, test):
        data = utils.extract_from_json("modèle_transceivers")
        utils.fill_data("Constructeur", "scrolling menu",
                        data[test]["Constructeur"], self.page)
        utils.fill_data("Nom du modèle", "input", 
                        data[test]["Nom"], self.page)
        utils.fill_data("Référence", "input",
                        data[test]["Référence"], self.page)
        utils.fill_data("Technique", "scrolling menu",
                        data[test]["Technique"], self.page)
        utils.fill_data("Type", "scrolling menu", 
                        data[test]["Type"], self.page)
        utils.fill_data("Débit", "scrolling menu",
                        data[test]["Débit"], self.page)
        utils.fill_data("Distance (Km)", "input",
                        data[test]["Distance (Km)"], self.page)
        utils.fill_data("Budget optique (dBm)", "input",
                        data[test]["Budget optique (dBm)"], self.page)
        utils.fill_data("Tx", "input",
                        data[test]["Tx"], self.page)
        utils.fill_data("Rx", "input",
                        data[test]["Rx"], self.page)
        utils.fill_data("Description", "textarea",
                        data[test]["Description"], self.page)
        self.page.get_by_role("button", name="").nth(1).click()

    def check_detail(self, test):
        data = utils.extract_from_json("modèle_transceivers")
        utils.check_data("Constructeur", "scrolling menu",
                         data[test]["Constructeur"], self.page)
        utils.check_data("Nom du modèle", "input", 
                         data[test]["Nom"], self.page)
        utils.check_data("Référence", "input",
                         data[test]["Référence"], self.page)
        utils.check_data("Technique", "scrolling menu",
                         data[test]["Technique"], self.page)
        utils.check_data("Type", "scrolling menu", 
                         data[test]["Type"], self.page)
        utils.check_data("Débit", "scrolling menu",
                         data[test]["Débit"], self.page)
        utils.check_data("Distance (Km)", "input",
                         data[test]["Distance (Km)"], self.page)
        utils.check_data("Budget optique (dBm)", "input",
                         data[test]["Budget optique (dBm)"], self.page)
        utils.check_data("Tx", "input",
                         data[test]["Tx"], self.page)
        utils.check_data("Rx", "input",
                         data[test]["Rx"], self.page)
        utils.check_data("Description", "textarea",
                         data[test]["Description"], self.page)

    def test_header_filter(self, element):
        utils.test_header_filter(self.page, element)

    def erase(self):
        utils.erase_el(self.nom, self.page)

    def test_filter(self):
        utils.test_filter(self.page, self.data)

    def test_search(self):
        utils.test_search(self.page, self.data)
