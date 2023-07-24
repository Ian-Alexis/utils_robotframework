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

    transceiver_1 = CL.modeleTransceiverClass(AW, "Transceiver numéro 1")
    transceiver_1_bis = CL.modeleTransceiverClass(AW, "Transceiver numéro 1 Bis")
    transceiver_2 = CL.modeleTransceiverClass(AW, "Transceiver numéro 2")
    transceiver_1.goto()

    transceiver_1.erase()
    transceiver_1_bis.erase()
    transceiver_2.erase()

    transceiver_1.goto_create()
    # Il faudra encore implémenter les fonctions pour obtenir le contenu des menus déroulants. 
    transceiver_1.create()
    transceiver_1.click_ok()
    transceiver_1.goto_breadcrumb()

    # Nous pourrons enlever les sleeps
    transceiver_1.goto_create()
    transceiver_1.reference = "Transceiver numéro 1"
    transceiver_1.create()
    CL.time.sleep(1)
    transceiver_1_bis.create()
    transceiver_1_bis.click_ok()
    CL.time.sleep(1)
    transceiver_2.create()
    transceiver_2.click_ok()
    CL.time.sleep(1)
    transceiver_1.create()
    transceiver_2.goto_breadcrumb()

    transceiver_1.test_search()
    transceiver_1.erase()
    transceiver_1.test_search

    AW.context.tracing.stop(path="out/trace.zip")
    return True


test_constructeur()