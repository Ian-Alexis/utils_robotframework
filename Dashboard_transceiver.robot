*** Settings ***  
Resource    front/Transceiver.robot
# test
*** Variables *** 

*** Keywords ***
 
*** Test Cases ***
Dashboard Transceiver
    &{data_lists}    EXTRACT JSON TO DICTIONNARY    data\\Dashboard_transceiver_list.json
    &{data_dicts}    EXTRACT JSON TO DICTIONNARY    data\\Dashboard_transceiver_dictionary.json

    Connect To Anyway
    Verify Dashboard Menu
    Click And Check Modèle Transceivers
    Check And Delete Existing Elements    NOM    &{data_dicts}
    Click And Check Modèle Transceivers Plus
    Check Error Field Transceiver    Constructeur    Nom du modèle
    Check Scrolling Menu Option    ${data_lists["Type_List"]}    Type    
    Check Scrolling Menu Option    ${data_lists["Technique_List"]}    Technique
    Check Scrolling Menu Option    ${data_lists["Debit_List"]}    Débit
    Fill Data In Transceiver Creation    ${data_dicts["Dashboard_transceiver_1"]}
    Validate Popup Ok
    Check Data In Transceiver Creation    ${data_dicts["Dashboard_transceiver_1"]}
    Go To Transceiver Menu Breadcrumb
    Click And Check Modèle Transceivers Plus
    Fill Data In Transceiver Creation    ${data_dicts["Dashboard_transceiver_1_existing"]}   
    Find Error Message    Nom du modèle
    Write In Input    Nom du modèle    ${data_dicts["Dashboard_transceiver_1bis"]["Nom"]}
    Write In Input    Référence    ${data_dicts["Dashboard_transceiver_1bis"]["Référence"]}
    Click Element    ${ajouter_button}
    Validate Popup Ok
    Check Data In Transceiver Creation    ${data_dicts["Dashboard_transceiver_1bis"]}
    Write In Input    Nom du modèle    ${data_dicts["Dashboard_transceiver_2"]["Nom"]}
    Click Element    ${valider_button}
    Validate Popup Ok
    Reload Page
    Page Should Contain Element    //li[@class='breadcrumb-item active'][contains(text(),'Transceiver numéro 2')]
    Go To Transceiver Menu Breadcrumb
    Click On Arrows    Nom
    Test Filter    NOM
    Transceiver Filter Test
    Transceiver 1 Research
    Go To Transceiver 1 Details
    Click Element    ${trash_logo}
    Validate Popup Confirmer
    Test Search Filter    NOM    Transceiver numéro 1    False

    Sleep    5s