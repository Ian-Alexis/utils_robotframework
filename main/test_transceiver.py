import class_librairy as CL
import os 

commande = "playwright show-trace out/trace.zip"

url = "https://anyway.qal.covage.com"

def test_Transceiver():
    if test():
        os.system(commande)
        assert True
    else:
        assert False

def test():
    AW = CL.connectAnyway()
    AW.connect(url)
    AW.debug()

    Transceiver_1 = CL.modeleTransceiverClass(AW, "Transceiver numéro 1")
    Transceiver_1_bis = CL.modeleTransceiverClass(AW, "Transceiver numéro 1 Bis")
    Transceiver_2 = CL.modeleTransceiverClass(AW, "Transceiver numéro 2")

    Transceiver_1.goto()
    Transceiver_1.erase()
    Transceiver_1_bis.erase()
    Transceiver_2.erase()

    Transceiver_1.goto_create()
    Transceiver_1.create()
    Transceiver_1.click_ok()
    Transceiver_1.goto_breadcrumb()
    Transceiver_1.goto_create()
    Transceiver_1.create()
    Transceiver_1_bis.create()
    Transceiver_1_bis.click_ok()
    Transceiver_1_bis.goto_breadcrumb()

    Transceiver_1_bis.goto_details()
    Transceiver_2.fill_detail("Transceiver numéro 2")
    Transceiver_2.click_ok()
    Transceiver_1.fill_detail("Transceiver numéro 1")
    Transceiver_1.goto_breadcrumb()

    Transceiver_1.test_filter()
    Transceiver_1.test_search()
    Transceiver_1.erase()
    Transceiver_1.test_search()

    CL.time.sleep(3)
    
    AW.context.tracing.stop(path="out/trace.zip")
    return True

test_Transceiver()