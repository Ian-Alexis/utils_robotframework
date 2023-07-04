*** Settings ***
Resource    front/modele_licence.robot
Suite Setup    Connect To Anyway

*** Variables ***


*** Keywords ***
    

*** Test Cases ***
Dashboard Modele Licence
    &{data_dicts}    EXTRACT JSON TO DICTIONNARY    data\\Dashboard_Modele_Licence.json

    Verify Dashboard Menu
    Go To Modele Licence Menu
    Check And Delete Existing Elements    NOM    &{data_dicts}
    Go To Modele Licence Creation
    Check Error Field Modele Licence
    Wait Until Keyword Succeeds    5x    1s    Test Fill Data In Modele Licence Creation     ${data_dicts["Dashboard_modèle_licence_1"]}
    Validate Popup Ok
    Check Information In Modele Licence    ${data_dicts["Dashboard_modèle_licence_1"]}
    Go To Modele Licence Menu Breadcrumb
    Go To Modele Licence Creation
    Wait Until Keyword Succeeds    5x    1s    Test Fill Data In Modele Licence Creation     ${data_dicts["Dashboard_modèle_licence_1"]}
    Check Error Field Modele Licence
    Wait Until Keyword Succeeds    5x    1s    Test Fill Data In Modele Licence Creation     ${data_dicts["Dashboard_modèle_licence_1Bis"]}
    Validate Popup Ok
    Check Information In Modele Licence    ${data_dicts["Dashboard_modèle_licence_1Bis"]}
    Wait Until Keyword Succeeds    5x    1s    Test Fill Data In Modele Licence     ${data_dicts["Dashboard_modèle_licence_2"]}
    Validate Popup Ok
    Check Information In Modele Licence    ${data_dicts["Dashboard_modèle_licence_2"]}
    Go To Modele Licence Menu Breadcrumb
    Test Filter    NOM
    Test Filter    EQUIPEMENTIER
    Test Filter    RÉFÉRENCE