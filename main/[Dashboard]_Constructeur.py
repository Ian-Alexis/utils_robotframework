import class_librairy as CL
import os 

commande = "playwright show-trace out/trace.zip"

url = "https://anyway.qal.covage.com"

def test_constructeur():
    if test():
        os.system(commande)
        assert True
    else:
        assert False

def test():
    AW = CL.connectAnyway()
    AW.connect(url)
    AW.debug()

    constructeur_1 = CL.constructeurClass(AW, "Constructeur numéro 1.0")
    constructeur_1_bis = CL.constructeurClass(AW, "Constructeur numéro 1 Bis")
    constructeur_2 = CL.constructeurClass(AW, "Constructeur numéro 2")

    constructeur_1.goto()
    constructeur_1.erase()
    constructeur_1_bis.erase()
    constructeur_2.erase()

    constructeur_1.goto_create()
    constructeur_1.create()
    constructeur_1.click_ok()
    constructeur_1.goto_breadcrumb()
    constructeur_1.goto_create()
    constructeur_1.prefixe_mac = "00:20:d3"
    constructeur_1.create()
    constructeur_1_bis.create()
    constructeur_1_bis.click_ok()
    constructeur_1_bis.goto_breadcrumb()

    constructeur_1_bis.goto_details()
    constructeur_2.fill_detail("Constructeur numéro 2")
    constructeur_2.click_ok()
    constructeur_1.fill_detail("Constructeur numéro 1.0")
    constructeur_1.goto_breadcrumb()

    constructeur_1.test_filter()
    constructeur_1.test_search()
    constructeur_1.erase()
    constructeur_1.test_search()

    CL.time.sleep(3)
    
    AW.context.tracing.stop(path="out/trace.zip")
    return True

test_constructeur()