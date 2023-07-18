import class_librairy as CL
import os 

commande = "playwright show-trace out/trace.zip"

def test_myscript():
    if test():
        os.system(commande)
        assert True
    else:
        assert False


def test(): 
    AW = CL.connectAnyway()
    AW.connect()
    AW.debug()
    # const_num_1_bis = CL.constructeurClass(AW, "Constructeur numéro 1")
    # const_num_1_bis.goto()
    # const_num_1_bis.goto_details()
    # const_num_1_bis.goto_breadcrumb()
    # const_num_1_bis.test_filter()
    # const_num_1_bis.test_search()
    # const_num_1_bis.erase()
    # const_num_1_bis.create()

    transceiver_2 = CL.modeleTransceiverClass(AW, "Transceiver numéro 2")
    transceiver_2.goto()
    transceiver_2.goto_create()
    transceiver_2.create()
    transceiver_2.goto_breadcrumb()
    transceiver_2.goto_details()
    transceiver_2.fill_detail("Transceiver numéro 1 Bis")
    # transceiver_2.test_filter()
    # transceiver_2.test_search()
    # transceiver_2.erase()
    # transceiver_2.goto_create()
    # transceiver.create()

    AW.context.tracing.stop(path="out/trace.zip")

    return True

test_myscript()
