import utils as utils
from playwright.sync_api import sync_playwright
import time

url = "https://anyway.qal.covage.com"

class connectAnyway():
    def __init__(self) -> None:
        self.playwright = sync_playwright().start()
        self.browser = self.playwright.chromium.launch(headless=False)
        self.context = self.browser.new_context()
        self.page = self.context.new_page()

    def connect(self):
        self.page.goto(url)

    @property
    def send_page(self):
        return self.page
        
    def debug(self):
        self.context.tracing.start(screenshots=True, snapshots=True, sources=True)

    time.sleep(3)

class constructeurClass(connectAnyway):
    def __init__(self, test) -> None:
        # super().__init__()
        # superClass = super().__dict__()
        print(connectAnyway())
        data = utils.extract_from_json("constructeurs")
        self.test = data[test]
        self.nom = data[test]["Nom"]
        self.prefixe_mac = data[test]["Préfixe MAC"]

    def goto(self):
        self.page.get_by_role("link", name=" Constructeurs").click()

    def create(self):
        utils.utils.fill_data("Nom", "input", self.nom)
        utils.utils.fill_data("Préfixe MAC", "textarea", self.prefixe_mac)

    def erase(self, page):
        # # extract name of column
        # page.wait_for_selector('//thead[@class="table-dark"]')
        # headers = page.query_selector_all('th')
        # # input data in filter search
        # filter_search(self.__dict__, headers, page)
        # # erase if element is find
        utils.erase_el(self.nom, page)


class modeleTransceiverClass():
    def __init__(self, data) -> None:
        self.constructeur = data["Constructeur"]
        self.nom = data["Nom"]
        self.reference = data["Référence"]
        self.technique = data["Technique"]
        self.type = data["Type"]
        self.debit = data["Débit"]
        self.distance = data["Distance (Km)"]
        self.budget = data["Budget optique (dBm)"]
        self.tx = data["Tx"]
        self.rx = data["Rx"]
        self.description = data["Description"]

    def create(self):
        utils.fill_data("Constructeur", "scrolling menu", self.constructeur)
        utils.fill_data("Nom du modèle", "input", self.nom)
        utils.fill_data("Référence", "input", self.reference)
        utils.fill_data("Technique", "scrolling menu", self.technique)
        utils.fill_data("Type", "scrolling menu", self.type)
        utils.fill_data("Débit", "scrolling menu", self.debit)
        utils.fill_data("Distance (Km)", "input", self.distance)
        utils.fill_data("Budget optique (dBm)", "input", self.budget)
        utils.fill_data("Tx", "input", self.tx)
        utils.fill_data("Rx", "input", self.rx)
        utils.fill_data("Description", "textarea", self.description)

    def erase(self, page):
        # # extract name of column
        # page.wait_for_selector('//thead[@class="table-dark"]')
        # headers = page.query_selector_all('th')
        # # input data in filter search
        # filter_search(self.__dict__, headers, page)
        # # erase if element is find
        utils.erase_el(self.nom, page)
