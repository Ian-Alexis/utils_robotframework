*** Settings ***
Resource    ../Dashboard_Tester_rubrique_création.robot
Resource    front.robot

*** Variables ***    
${breadcrumb_transceiver}    //a[@href="https://anyway.qal.covage.com/transceivers"][@class="text-decoration-none"]

${constructeur_xpath}
${nom_xpath}
${reference_xpath}
${technique_xpath}
${type_xpath}
${debit_xpath}
${distance_xpath}
${distance_xpath}
${budget_xpath}
${tx_xpath}
${rx_xpath}
${description_xpath}

*** Keywords ***    
Check Error Field Transceiver
    [Arguments]    ${error_1}    ${error_2}
    Click Element    ${ajouter_button}
    Find Error Message    ${error_1}
    Find Error Message    ${error_2}
    
Check Scrolling Menu Option 
    [Arguments]    ${data}    ${scrolling_menu_name}

    ${scrolling_menu_xpath}    Find Field Xpath From Name    ${scrolling_menu_name}
    @{elements}    Get WebElements    ${scrolling_menu_xpath}/select

    @{type_list}    Create List
    FOR     ${element}     IN      @{elements}
        ${type}    Get Text    ${element}
        Append To List    ${type_list}    ${type}
    END
    @{type_list}    Split String    ${type}    \n

    ${sort_test}    Run Keyword And Return Status    Should Be True    ${type_list} == ${data}
    IF  ${sort_test}
        LOG CHECK GOOD    La liste des ${scrolling_menu_name}s est complète
    ELSE
        LOG CHECK WARNING    La liste des ${scrolling_menu_name}s est incomplète
    END
    
Fill Data In Transceiver Creation   
    [Arguments]    ${data}    
    
    Select In Scrolling Menu    Constructeur    ${data["Constructeur"]}
    Write In Input    Nom du modèle    ${data["Nom"]}
    Write In Input    Référence    ${data["Référence"]}
    Select In Scrolling Menu    Technique    ${data["Technique"]}
    Select In Scrolling Menu    Type    ${data["Type"]}
    Select In Scrolling Menu    Débit    ${data["Débit"]}
    Write In Input    Distance (Km)    ${data["Distance (Km)"]}
    Write In Input    Budget optique (dBm)    ${data["Budget optique (dBm)"]}
    Write In Input    Tx    ${data["Tx"]}
    Write In Input    Rx    ${data["Rx"]}
    Write In Input    Description    ${data["Description"]}
    Click Element    ${ajouter_button}

Check Data In Transceiver Creation
    [Arguments]    ${data}
    
    Put All Field Xpath Transceiver In Global

    CHECK SCROLLING MENU TEXT FIELD    Constructeur    ${constructeur_xpath}    ${data["Constructeur"]}    False
    CHECK INPUT TEXT FIELD LOG    Nom du modèle    ${nom_xpath}    ${data["Nom"]}    False
    CHECK INPUT TEXT FIELD LOG    Référence    ${reference_xpath}    ${data["Référence"]}    False
    CHECK SCROLLING MENU TEXT FIELD    Technique    ${technique_xpath}    ${data["Technique"]}    False
    CHECK SCROLLING MENU TEXT FIELD    Type    ${type_xpath}    ${data["Type"]}    False
    CHECK SCROLLING MENU TEXT FIELD    Débit    ${debit_xpath}    ${data["Débit"]}    False
    CHECK INPUT TEXT FIELD LOG    Distance (Km)    ${distance_xpath}    ${data["Distance (Km)"]}    False
    CHECK INPUT TEXT FIELD LOG    Budget optique (dBm)    ${budget_xpath}    ${data["Budget optique (dBm)"]}    False
    CHECK INPUT TEXT FIELD LOG    Tx    ${tx_xpath}    ${data["Tx"]}    False
    CHECK INPUT TEXT FIELD LOG    Rx    ${rx_xpath}    ${data["Rx"]}    False
    CHECK INPUT TEXT FIELD LOG    Description    ${description_xpath}    ${data["Description"]}    False

Go To Transceiver Menu Breadcrumb
    Wait Until Page Contains Element    ${breadcrumb_transceiver}
    Click Element    ${breadcrumb_transceiver}
    Wait Until Page Contains    Transceivers
    LOG CHECK GOOD    Go to contructeurs menu

Put All Field Xpath Transceiver In Global

    ${constructeur_xpath}    Find Field Xpath From Name    Constructeur
    ${nom_xpath}    Find Field Xpath From Name    Nom du modèle
    ${reference_xpath}    Find Field Xpath From Name    Référence
    ${technique_xpath}    Find Field Xpath From Name    Technique
    ${type_xpath}    Find Field Xpath From Name    Type
    ${debit_xpath}    Find Field Xpath From Name    Débit
    ${distance_xpath}    Find Field Xpath From Name    Distance (Km)
    ${budget_xpath}    Find Field Xpath From Name    Budget optique (dBm)
    ${tx_xpath}    Find Field Xpath From Name    Tx
    ${rx_xpath}    Find Field Xpath From Name    Rx
    ${description_xpath}    Find Field Xpath From Name    Description

    Set Global Variable    ${constructeur_xpath}
    Set Global Variable    ${nom_xpath}
    Set Global Variable    ${reference_xpath}
    Set Global Variable    ${technique_xpath}
    Set Global Variable    ${type_xpath}
    Set Global Variable    ${debit_xpath}
    Set Global Variable    ${distance_xpath}
    Set Global Variable    ${distance_xpath}
    Set Global Variable    ${budget_xpath}
    Set Global Variable    ${tx_xpath}
    Set Global Variable    ${rx_xpath}
    Set Global Variable    ${description_xpath}

Click On Arrows
    [Arguments]    ${filter_name}

    ${element_xpath}    Set Variable    //div/span[contains(text(),'${filter_name}')]
    Click Element    ${element_xpath}
    Click Element    ${element_xpath}
    Sleep    1s

Check Rechercher Scrolling Menu
    [Arguments]    ${field_name}    ${option_text}

        ${index}    Get Column Index From Name    ${field_name}
        ${research_xpath}    Set Variable    //tbody/tr/td[position()=${index}]/div/div
        Click Element    ${research_xpath}
        ${option_xpath}    Set Variable    //li/a/span[normalize-space()='${option_text}']
        Wait Until Page Contains Element    ${option_xpath}
        Click Element    ${option_xpath}
        Click Element    ${research_xpath}

Transceiver Filter Test
# Trouver une meilleure solution que les sleeps

    Test Search Filter    NOM    Transceiver numéro 1    True
    Clear Rechercher Input    NOM
    Sleep    0.5s
    Test Search Filter    RÉFÉRENCE    Transceiver_numéro-1    True
    Clear Rechercher Input    RÉFÉRENCE
    Sleep    0.5s
    Test Search Filter Scrolling menu    TYPE    RJ45    True
    Test Search Filter Scrolling menu    TYPE    RJ45    True
    Sleep    0.5s
    Test Search Filter Scrolling menu    DÉBIT    100M    True
    Test Search Filter Scrolling menu    DÉBIT    100M    True
    Sleep    0.5
    Test Search Filter    BUDGET OPTIQUE (DBM)    5    True
    Clear Rechercher Input    BUDGET OPTIQUE (DBM)
    Sleep    0.5s
    Test Search Filter Scrolling menu    TECHNIQUE    Unidirectionnel    True
    Test Search Filter Scrolling menu    TECHNIQUE    Tous    False

Transceiver 1 Research
    Test Search Filter    NOM    Transceiver numéro 1    True
    Test Search Filter    RÉFÉRENCE    Transceiver_numéro-1    True
    Test Search Filter Scrolling menu    TYPE    RJ45    True
    Test Search Filter Scrolling menu    DÉBIT    100M    True
    Test Search Filter    BUDGET OPTIQUE (DBM)    5    True
    Test Search Filter Scrolling menu    TECHNIQUE    Unidirectionnel    True

Go To Transceiver 1 Details
    ${xpath}    Set Variable    //td[contains(text(),'Transceiver numéro 1')]
    
    Wait Until Element Is Visible    ${xpath}
    Click Element    ${xpath}