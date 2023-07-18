import class_librairy as CL

url = "https://anyway.qal.covage.com"


def test_myscript():
    if test():
        # os.system(commande)
        assert True
    else:
        assert False


def test(): 
    AW = CL.connectAnyway()
    AW.connect(url)
    const_num_1_bis = CL.constructeurClass(AW, "Constructeur numéro 1 Bis")
    const_num_1_bis.goto()
    const_num_1_bis.erase()
    const_num_1_bis.create()
    transceiver = CL.modeleTransceiverClass(AW, "Transceiver numéro 2")
    transceiver.goto()
    transceiver.erase()
    transceiver.goto_add()
    transceiver.create()
    CL.time.sleep(3)
    return True

test()
