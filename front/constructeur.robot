*** Settings ***
Resource    ../utils/utils.robot
Resource    front.robot

*** Variables ***
${contructeur_menu}    //a[@href="https://anyway.qal.covage.com/constructors" and @class="nav-link"]

${constructeur_creation}    //a[@href="https://anyway.qal.covage.com/constructors/create"]
${breadcrumb_constructeur}    //a[@href="https://anyway.qal.covage.com/constructors"][@class="text-decoration-none"]

${constructeur_text}    //h1[contains(text(),"Constructeur")]

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

Fill Data In Constructeur
    [Arguments]    ${data}    
    Put All Field Xpath Constructeur In Global

    Wait Until Element Is Visible        ${nom_field}
    Input Text    ${nom_field}    ${data["Nom"]}
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_field}    ${data["Nom"]}    False
    Input Text    ${prefixe_mac_field}    ${data["Préfixe MAC"]}
    CHECK INPUT TEXT FIELD LOG    Préfixe MAC    ${prefixe_mac_field}    ${data["Préfixe MAC"]}    False
    Click Button    ${validation_button}