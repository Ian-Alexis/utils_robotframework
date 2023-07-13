from utils import fill_data, erase_el, filter_search


class constructeurClass():
    def __init__(self, data) -> None:
        self.nom = data["Nom"]
        self.préfixe_mac = data["Préfixe MAC"]

    def create(self):
        fill_data("Nom", "input", self.nom)
        fill_data("Préfixe MAC", "textarea", self.préfixe_mac)

    def erase(self, page):
        # # extract name of column
        # page.wait_for_selector('//thead[@class="table-dark"]')
        # headers = page.query_selector_all('th')
        # # input data in filter search
        # filter_search(self.__dict__, headers, page)
        # # erase if element is find
        erase_el(self.nom, page)


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
        fill_data("Constructeur", "scrolling menu", self.constructeur)
        fill_data("Nom du modèle", "input", self.nom)
        fill_data("Référence", "input", self.reference)
        fill_data("Technique", "scrolling menu", self.technique)
        fill_data("Type", "scrolling menu", self.type)
        fill_data("Débit", "scrolling menu", self.debit)
        fill_data("Distance (Km)", "input", self.distance)
        fill_data("Budget optique (dBm)", "input", self.budget)
        fill_data("Tx", "input", self.tx)
        fill_data("Rx", "input", self.rx)
        fill_data("Description", "textarea", self.description)

    def erase(self, page):
        # # extract name of column
        # page.wait_for_selector('//thead[@class="table-dark"]')
        # headers = page.query_selector_all('th')
        # # input data in filter search
        # filter_search(self.__dict__, headers, page)
        # # erase if element is find
        erase_el(self.nom, page)
