import class_librairy as CL
import os 
import random
import matplotlib.pyplot as plt 

commande = "playwright show-trace out/trace.zip"

url = "https://anyway.qal.covage.com"


def test_myscript():
    if test():
        os.system(commande)
        assert True
    else:
        assert False


def test(): 
    AW = CL.connectAnyway()
    AW.connect(url)
    AW.debug()


    # const_num_1_bis = CL.constructeurClass(AW, "Constructeur numéro 1 Bis")
    # const_num_1_bis.goto()
    # const_num_1_bis.goto_details()
    # const_num_1_bis.goto_breadcrumb()
    # const_num_1_bis.test_filter()
    # const_num_1_bis.test_search()
    # const_num_1_bis.erase()
    # const_num_1_bis.create()


    transceiver_2 = CL.modeleTransceiverClass(AW, "Transceiver numéro 2")
    transceiver_2.goto()
    times = []
    for i in range(50):
        start_time = CL.time.time()
        transceiver_2.goto_create()
        transceiver_2.create()
        transceiver_2.goto_breadcrumb()
        transceiver_2.erase()
        end_time = CL.time.time()
        execution_time = end_time - start_time
        times.append(execution_time)

    AW.context.tracing.stop(path="out/trace.zip")

    plt.plot(times)
    plt.show()

    return True

test_myscript()
