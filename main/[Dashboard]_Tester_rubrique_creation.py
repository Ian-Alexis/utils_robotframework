import class_librairy as CL
import os 

commande = "playwright show-trace out/trace.zip"

url = "https://anyway.qal.covage.com"

def test_rubrique():
    if test():
        os.system(commande)
        assert True
    else:
        assert False

def test():
    AW = CL.connectAnyway()
    AW.connect(url)
    AW.debug()

    AW.page.get_by_role("link", name=" Constructeurs").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Modèle").click()
    AW.page.get_by_role("link", name="Equipements").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Modèle").click()
    AW.page.get_by_role("link", name="Cartes").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Modèle").click()
    AW.page.get_by_role("link", name="Transceivers").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Modèle").click()
    AW.page.get_by_role("link", name="Licences").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Modèle").click()
    AW.page.get_by_role("link", name="Templates").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Inventaire").click()
    AW.page.get_by_role("link", name="Sites").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Inventaire").click()
    AW.page.get_by_role("link", name="Racks").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Inventaire").click()
    AW.page.get_by_role("link", name="NE").click()
    AW.page.get_by_role("link", name="Equipements").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Inventaire").click()
    AW.page.get_by_role("link", name="Cartes").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Inventaire").click()
    AW.page.get_by_role("link", name="Licences").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Inventaire").click()
    AW.page.get_by_role("link", name="Services").click()
    AW.page.get_by_role("link", name="").click()
    AW.page.get_by_role("link", name=" Inventaire").click()
    AW.page.get_by_role("link", name="Collectes").click()
    AW.page.get_by_role("link", name="").click()

    AW.context.tracing.stop(path="out/trace.zip")
    return True

test_rubrique()