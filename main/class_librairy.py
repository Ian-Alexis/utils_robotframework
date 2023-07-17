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

    def send_page(self):
        return self.page

    def debug(self):
        self.context.tracing.start(screenshots=True, snapshots=True, sources=True)

    time.sleep(3)


class constructeurClass(connectAnyway):
    def __init__(self, AW, test) -> None:
        self.page = AW.page
        data = utils.extract_from_json("constructeurs")
        self.nom = data[test]["Nom"]
        self.prefixe_mac = data[test]["Préfixe MAC"]

    def goto(self):
        self.page.get_by_role("link", name=" Constructeurs").click()

    # def goto_details(self):


    def create(self):
        self.page.get_by_role("link", name="").click()
        utils.fill_data("Nom", "input", self.nom, self.page)
        utils.fill_data("Préfixe MAC", "textarea", self.prefixe_mac, self.page)
        self.page.get_by_role("button", name="Ajouter").nth(1).click()
        self.page.get_by_role("button", name="OK").click()

    def erase(self):
        utils.erase_el(self.nom, self.page)

class modeleTransceiverClass():
    def __init__(self, AW, test) -> None:
        self.page = AW.page
        data = utils.extract_from_json("modèle_transceivers")
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
        self.header = []

    def goto(self):
        self.page.get_by_role("link", name=" Modèle").click()
        self.page.get_by_role("link", name="Transceivers").click()
        self.header = utils.get_header(self.page)
    
    def goto_add(self):
        self.page.get_by_role("link", name="").click()

    def create(self):
        utils.fill_data("Constructeur", "scrolling menu", self.constructeur, self.page)
        utils.fill_data("Nom du modèle", "input", self.nom, self.page)
        utils.fill_data("Référence", "input", self.reference, self.page)
        utils.fill_data("Technique", "scrolling menu", self.technique, self.page)
        utils.fill_data("Type", "scrolling menu", self.type, self.page)
        utils.fill_data("Débit", "scrolling menu", self.debit, self.page)
        utils.fill_data("Distance (Km)", "input", self.distance, self.page)
        utils.fill_data("Budget optique (dBm)", "input", self.budget_optique, self.page)
        utils.fill_data("Tx", "input", self.tx, self.page)
        utils.fill_data("Rx", "input", self.rx, self.page)
        utils.fill_data("Description", "textarea", self.description, self.page)
        self.page.get_by_role("button", name="Ajouter").nth(1).click()
        self.page.get_by_role("button", name="OK").click()

    def erase(self):
        # # extract name of column
        # page.wait_for_selector('//thead[@class="table-dark"]')
        # headers = page.query_selector_all('th')
        # # input data in filter search
        # filter_search(self.__dict__, headers, page)
        # # erase if element is find
        utils.erase_el(self.nom, self.page)

    def test_filter(self):
        utils.test_whole_tab(self.page,"transceivers")
