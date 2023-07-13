import class_librairy as CL

def test_myscript():
    if test():
        # os.system(commande)
        assert True
    else:
        assert False


def test(): 
    AW = CL.connectAnyway()
    AW.connect()
    const_num_1_bis = CL.constructeurClass(AW, "Constructeur numéro 1")
    const_num_1_bis.goto()
    return True


test()
