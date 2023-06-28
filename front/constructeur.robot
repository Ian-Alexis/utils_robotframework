*** Settings ***
Resource    ../utils/utils.robot
Resource    front.robot

*** Variables ***
${contructeur_menu}    //a[@href="https://anyway.qal.covage.com/constructors" and @class="nav-link"]
# ${nom_filter}    //div[span[contains(text(), "NOM")]]
${nom_filter}    xpath:/html/body/main/div[2]/div/div/div/div[2]/div/div[4]/table/thead/tr/th[2]/div

${constructeur_creation}    //a[@href="https://anyway.qal.covage.com/constructors/create"]
${breadcrumb_constructeur}    //a[@href="https://anyway.qal.covage.com/constructors"][@class="text-decoration-none"]

${constructeur_text}    //h1[contains(text(),"Constructeur")]

${name_filter_search}    //*[@id="table-filter-name"]

${nom_field}    
${prefixe_mac_field}

*** Keywords ***
Go To Constructeur Menu
    Wait Until Page Contains Element    ${contructeur_menu}
    Click Element    ${contructeur_menu}
    Wait Until Page Contains Element    ${constructeur_creation}
    Wait Until Page Contains Element    ${constructeur_text}
    LOG CHECK GOOD    Go to contructeurs menu

Go To Constructeur Menu Breadcrumb
    Wait Until Page Contains Element    ${breadcrumb_constructeur}
    Click Element    ${breadcrumb_constructeur}
    Wait Until Page Contains Element    ${constructeur_creation}
    LOG CHECK GOOD    Go to contructeurs menu

Go To Constructeur Creation
    Click Element    ${constructeur_creation}
    Wait Until Page Contains Element    ${ajouter_button}
    Wait Until Page Contains Element    ${constructeur_text}
    LOG CHECK GOOD    Go to contructeurs creation

Put All Field Xpath Constructeur In Global 
    ${nom_field}    Find Field Xpath From Name    Nom 
    ${prefixe_mac_field}    Find Field Xpath From Name    Préfixe MAC 
  
    Set Global Variable    ${nom_field}
    Set Global Variable    ${prefixe_mac_field}    

Fill Data In Constructeur Creation 1
    Put All Field Xpath Constructeur In Global

    Wait Until Element Is Visible        ${nom_field}
    Input Text    ${nom_field}    Constructeur numéro 1
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_field}    Constructeur numéro 1    False
    Click Button    ${ajouter_button}
   
Check Information In Constructeur
    [Arguments]    ${data}
    Wait Until Page Contains Element    ${validation_button}
    Wait Until Page Contains Element    ${nom_field}
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_field}    ${data["Nom"]}    True
    CHECK INPUT TEXT FIELD LOG    Préfixe MAC    ${prefixe_mac_field}    ${data["Préfixe MAC"]}    True

Check Error Field Constructeur
    Click Button    ${ajouter_button} 
    Find Error Message    Nom   

Find Error Message
    [Arguments]    ${error_template_text}

    ${error_xpath}    Set Variable    //label[contains(text(), '${error_template_text}')]/following-sibling::div[@class="form-text text-danger"]    
    ${test}    Run Keyword And Return Status    Wait Until Page Contains Element    ${error_xpath}
    IF   ${test}    
        ${error_text}    Get Text    ${error_xpath}    
        LOG CHECK GOOD    The message of ${error_template_text} field is : ${error_text}
    ELSE   
        LOG CHECK WARNING    There is no error message in ${error_template_text} field
    END

Fill Data In Constructeur Creation   
    [Arguments]    ${data}    
    Put All Field Xpath Constructeur In Global

    Wait Until Element Is Visible        ${nom_field}
    Input Text    ${nom_field}    ${data["Nom"]}
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_field}    ${data["Nom"]}    False
    Input Text    ${prefixe_mac_field}    ${data["Préfixe MAC"]}
    CHECK INPUT TEXT FIELD LOG    Préfixe MAC    ${prefixe_mac_field}    ${data["Préfixe MAC"]}    False
    Click Button    ${ajouter_button}
    
# Check And Delete Existing Constructeurs
#     ${test_1}    Run Keyword And Return Status    Wait Until Page Contains    Constructeur numéro 1
#     ${test_2}    Run Keyword And Return Status    Wait Until Page Contains    Constructeur numéro 2
#     ${test_1bis}    Run Keyword And Return Status    Wait Until Page Contains    Constructeur numéro 1 Bis
#     IF    ${test_1}
#         Click Element    //td[contains(text(), 'Constructeur numéro 1')]
#         Click Element    //*[@class="bi bi-trash3-fill"]
#         Validate Popup Confirmer
#         Validate Popup Ok
#     END
#     IF    ${test_1bis}
#         Click Element    //td[contains(text(), 'Constructeur numéro 1 Bis')]
#         Click Element    //*[@class="bi bi-trash3-fill"]
#         Validate Popup Confirmer
#         Validate Popup Ok
#     END
#     IF    ${test_2}
#         Click Element    //td[contains(text(), 'Constructeur numéro 2')]
#         Click Element    //*[@class="bi bi-trash3-fill"]
#         Validate Popup Confirmer
#         Validate Popup Ok
#     END

Check And Delete Existing Constructeurs
    [Arguments]    @{all_noms}
    
    Sort List    ${all_noms}
    Reverse List    ${all_noms}    

    FOR    ${nom}    IN    @{all_noms}
        Wait Until Page Contains Element    ${name_filter_search}
        Input Text    ${name_filter_search}    ${nom} 
        ${test}    Run Keyword And Return Status    Wait Until Page Contains Element    //tr[td[contains(text(),'${nom}')]]    2s
        IF    ${test}
            Click Element    //tr[td[contains(text(),'${nom}')]]
            Wait Until Page Contains Element    ${trash_logo}
            Click Element    ${trash_logo}
            Validate Popup Confirmer
            Validate Popup Ok
        END
    END

Test
    Click And Check Modèle Equipments    
    Wait Until Page Contains Element    xpath:/html/body/main/div[2]/div/div/div/div[2]/div/div[4]/table/thead/tr

    ${elements}    Get WebElements    xpath:/html/body/main/div[2]/div/div/div/div[2]/div/div[4]/table/thead/tr
    Log    ${elements}

    @{noms}    Create List
    FOR    ${element}    IN    @{elements}
        ${nom}    Get Text    ${element}
        Append To List    ${noms}    ${nom}
    END

Click Modèle
    Click Element    //*[@id="sidebarNav"]/li[3]/a
    Sleep    0.2

Click And Check Modèle Equipments
    Click Modèle
    Click Element    //*[@id="wrapper-0"]/ul/li[1]/a