*** Settings ***
Resource    front/constructeur.robot
Suite Setup    Connect To Anyway

*** Variables ***


*** Keywords ***
    

*** Test Cases ***
Dashboard Constructeur
# Faire une fonction qui extrait tous les json correspondant au nom du test
    &{data}    EXTRACT JSON TO DICTIONNARY    data\\Dashboard_Constructeur.json
    
    Verify Dashboard Menu
    Go To Constructeur Menu
    Check And Delete Existing Elements    NOM    &{data}      
    Go To Constructeur Creation
    Check Error Field Constructeur
    Fill Data In Constructeur Creation    ${data["Dashboard_constructeur_1"]}
    Validate Popup Ok
    Check Information In Constructeur    ${data["Dashboard_constructeur_1"]}
    Go To Constructeur Menu Breadcrumb
    Go To Constructeur Creation
    Fill Data In Constructeur Creation    ${data["Dashboard_constructeur_1"]}
    Check Error Field Constructeur
    Fill Data In Constructeur Creation    ${data["Dashboard_constructeur_1Bis"]}
    Validate Popup Ok
    Check Information In Constructeur    ${data["Dashboard_constructeur_1Bis"]}
    Fill Data In Constructeur    ${data["Dashboard_constructeur_2"]}
    Validate Popup Ok
    Check Information In Constructeur    ${data["Dashboard_constructeur_2"]}
    Go To Constructeur Menu Breadcrumb
    Test Filter    NOM
    ${element_xpath}    Test Search Filter    NOM    ${data["Dashboard_constructeur_1"]["Nom"]}    True
    Erase Element    ${element_xpath}
    Test Search Filter    NOM    ${data["Dashboard_constructeur_1"]["Nom"]}    False
    # test