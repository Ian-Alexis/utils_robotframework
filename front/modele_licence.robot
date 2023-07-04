*** Settings ***
Resource    ../utils/utils.robot
Resource    front.robot

*** Variables ***
# ${modele_menu}    //li[a[contains(text(), "Modèle")]]
${modele_menu}    //*[@id="sidebarNav"]/li[@class="nav-item accordion-item"]/a
${modele_licence_menu}    //li/a[@href="https://anyway.qal.covage.com/licence_models"]
# ${modele_licence_menu}     //*[@id="wrapper-0"]/ul/li[4]/a

${modele_licence_creation}    //a[@href="https://anyway.qal.covage.com/licence_models/create"]
${breadcrumb_modele_licence}    //a[@href="https://anyway.qal.covage.com/licence_models"][@class="text-decoration-none"]

${modele_licence_text}    //div/h1[contains(text(),"Modèle de licence")]

${nom_du_modèle_field} 
${constructeur_field}
${reference_field}

*** Keywords ***
Go To Modele Licence Menu
    Wait Until Page Contains Element    ${modele_menu}
    Click Element    ${modele_menu}
    Wait Until Page Contains Element    ${modele_licence_menu}
    Sleep     1s
    Click Element    ${modele_licence_menu}
    Wait Until Page Contains Element    ${modele_licence_creation}
    LOG CHECK GOOD    Go to modele licence menu

Go To Modele Licence Menu Breadcrumb
    Wait Until Page Contains Element    ${breadcrumb_modele_licence}
    Click Element    ${breadcrumb_modele_licence}
    Wait Until Page Contains Element    ${modele_licence_creation}
    LOG CHECK GOOD    Go to modele licence menu

Check Information In Modele Licence
    [Arguments]    ${data}
    Wait Until Page Contains Element    ${validation_button}
    Wait Until Page Contains Element    ${modele_licence_text}
    # CHECK SCROLLING MENU TEXT FIELD    Constructeur    ${constructeur_field}    ${data["Constructeur"]}
    CHECK SCROLLING MENU TEXT FIELD    Préfixe MAC    ${constructeur_field}    ${data["Constructeur"]}    True
    CHECK INPUT TEXT FIELD LOG      Nom du modèle    ${nom_du_modèle_field}    ${data["Nom"]}    True
    CHECK INPUT TEXT FIELD LOG      Référence    ${reference_field}    ${data["Référence"]}    True

Go To Modele Licence Creation
    Click Element    ${modele_licence_creation}
    Wait Until Page Contains Element    ${ajouter_button}
    Wait Until Page Contains Element    ${modele_licence_text}
    LOG CHECK GOOD    Go to modele licence creation

Check Error Field Modele Licence
    Click Button    ${ajouter_button} 
    Find Error Message    Nom du modèle
    Find Error Message    Constructeur 


Put All Field Xpath Modele Licence In Global 
    ${nom_du_modèle_field}    Find Field Xpath From Name    Nom du modèle 
    ${constructeur_field}    Find Field Xpath From Name    Constructeur
    ${reference_field}    Find Field Xpath From Name    Référence
    
  
    Set Global Variable    ${nom_du_modèle_field}
    Set Global Variable    ${constructeur_field}
    Set Global Variable    ${reference_field}

Fill Data In Modele Licence Creation   
    [Arguments]    ${data}    
    Put All Field Xpath Modele Licence In Global 

    Wait Until Element Is Visible        ${modele_licence_text}
    Select In Scrolling Menu    Constructeur    ${data["Constructeur"]}
    Write In Input    Nom du modèle    ${data["Nom"]}
    Write In Input    Référence    ${data["Référence"]}

    CHECK SCROLLING MENU TEXT FIELD    Préfixe MAC    ${constructeur_field}    ${data["Constructeur"]}    False
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_du_modèle_field}    ${data["Nom"]}    False
    CHECK INPUT TEXT FIELD LOG    Réréfence    ${reference_field}    ${data["Référence"]}    False
    Click Button    ${ajouter_button}

Test Fill Data In Modele Licence Creation 
    [Arguments]    ${data} 
    ${test_fill_constructeur}    Run Keyword And Return Status    Fill Data In Modele Licence Creation    ${data}
    Run Keyword If    ${test_fill_constructeur} == False    RETRY TEST
    Run Keyword If    ${test_fill_constructeur} == False    Fail

Fill Data In Constructeur
    [Arguments]    ${data}    
    Put All Field Xpath Modele Licence In Global

    Wait Until Element Is Visible        ${modele_licence_text}
    Select In Scrolling Menu    Constructeur    ${data["Constructeur"]}
    Write In Input    Nom du modèle    ${data["Nom"]}
    Write In Input    Référence    ${data["Référence"]}

    CHECK SCROLLING MENU TEXT FIELD    Préfixe MAC    ${constructeur_field}    ${data["Constructeur"]}    False
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_du_modèle_field}    ${data["Nom"]}    False
    CHECK INPUT TEXT FIELD LOG    Préfixe MAC    ${reference_field}    ${data["Référence"]}    False

    Click Button    ${validation_button}

Test Fill Data In Modele Licence
    [Arguments]    ${data} 

    ${test_fill_constructeur}    Run Keyword And Return Status    Fill Data In Constructeur    ${data}
    Run Keyword If    ${test_fill_constructeur} == False    RETRY TEST
    Run Keyword If    ${test_fill_constructeur} == False    Fail


