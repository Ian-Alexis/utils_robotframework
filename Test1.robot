*** Settings ***
Resource    front/constructeur.robot
Resource    Dashboard_Tester_rubrique_création.robot
Suite Setup    Connect To Anyway

*** Variables ***

*** Keywords ***
    
*** Test Cases ***
Test 
    Click And Check Modèle Equipments
    Click And Check Modèle Equipment Plus
    Select In Scrolling Menu    Constructeur    Nokia
    Click And Check Modèle Transceivers 
    Click And Check Modèle Transceivers Plus
    Select In Scrolling Menu    Constructeur    Nokia
    Select In Scrolling Menu    Technique    Unidirectionnel
    Select In Scrolling Menu    Type    SFP
    Select In Scrolling Menu    Débit    1G
    Click And Check Inventaire Licenses
    Click And Check Inventaire Licenses Plus
    Select In Scrolling Menu    Modèle de licence     Modèle licence 1
    Click And Check Inventaire Services
    Click And Check Inventaire Services Plus
    Select In Scrolling Menu    Réseau    CZT - COVAGE - ZONE TRES DENSE
    Sleep    5s