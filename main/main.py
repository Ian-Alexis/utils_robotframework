import class_librairy as CL
from playwright.sync_api import sync_playwright

def test_myscript():
    if test():
        # os.system(commande)
        assert True
    else:
        assert False

def test(): 
    AW = CL.connectAnyway()
    AW.connect()
    print(AW)
    const_num_1_bis = CL.constructeurClass(AW)
    const_num_1_bis.goto()
    return True

test()