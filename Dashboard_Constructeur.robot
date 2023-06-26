*** Settings ***
Resource    front/constructeur.robot

*** Variables ***






${nom_field}    //label[contains(text(), 'Nom')]/following-sibling::input[1]
${error_nom_field}    //label[contains(text(), 'Nom')]/following-sibling::div[@class="form-text text-danger"]
${prefixe_mac_field}    //label[contains(text(), 'Préfixe MAC')]/following-sibling::textarea[1]

${popup_validation}   //div[@id="swal2-html-container"]
${ok_popup_button}    //button[contains(text(), "OK")]
${confirmer_button}    //button[contains(text(), "Confirmer")]






${name_filter_search}    //*[@id="table-filter-name"]
${result_search}    //td[contains(text(), "Constructeur numéro 1")]


*** Keywords ***









Fill Data In Constructeur Creation 1
    Wait Until Element Is Visible    ${nom_field}
    Input Text    ${nom_field}    Constructeur numéro 1
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_field}    Constructeur numéro 1    False
    Click Button    ${ajouter_button}
    Wait Until Page Contains Element    ${popup_validation}
    ${popup_validation_text}=    Get Text    ${popup_validation}
    LOG CHECK GOOD    ${popup_validation_text}
    Wait Until Page Contains Element   ${ok_popup_button}
    Click Button    ${ok_popup_button}

Check Information In Constructor 1
    Wait Until Page Contains Element    ${validation_button}
    Wait Until Page Contains Element    ${nom_field}
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_field}    Constructeur numéro 1    True

Go To Constructeur Menu Bis
    Wait Until Page Contains Element    ${ariane_fil_constructor}
    Click Element    ${ariane_fil_constructor}
    Wait Until Page Contains Element    ${constructeur_creation}
    LOG CHECK GOOD    Go to contructeurs menu

Fill Data In Constructeur Creation Wrong
    Wait Until Element Is Visible   ${nom_field}
    Input Text    ${nom_field}    Constructeur numéro 1
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_field}    Constructeur numéro 1    False
    Wait Until Element Is Visible    ${prefixe_mac_field}
    Input Text    ${prefixe_mac_field}    00:20:d3
    CHECK INPUT TEXT FIELD LOG    Préfix Mac    ${prefixe_mac_field}    00:20:d3    False
    Click Button    ${ajouter_button}

    Wait Until Page Contains Element    ${error_nom_field}
    ${error_non_field_text}=    Get Text    ${error_nom_field}
    LOG CHECK GOOD    There is write : ${error_non_field_text} for Constructeur numéro 1
    Input Text    ${nom_field}    Constructeur numéro 1 Bis
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_field}    Constructeur numéro 1 Bis    False
    Click Button    ${ajouter_button}

    Wait Until Page Contains Element    ${popup_validation}
    ${popup_validation_text}=    Get Text    ${popup_validation}
    LOG CHECK GOOD    ${popup_validation_text}
    Wait Until Page Contains Element   ${ok_popup_button}
    Click Button    ${ok_popup_button}

Check Information In Constructor 2
    Wait Until Page Contains Element    ${validation_button}
    Wait Until Page Contains Element    ${nom_field}
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_field}    Constructeur numéro 1 Bis    True
    Wait Until Page Contains Element    ${prefixe_mac_field}
    CHECK INPUT TEXT FIELD LOG    Préfixe MAC    ${prefixe_mac_field}    00:20:d3    True
    Input Text    ${nom_field}    Constructeur numéro 1
    Click Button    ${validation_button}

    Wait Until Page Contains Element    ${error_nom_field}
    ${error_non_field_text}=    Get Text    ${error_nom_field}
    LOG CHECK GOOD    There is write : ${error_non_field_text} for Constructeur numéro 1
    Input Text    ${nom_field}    Constructeur numéro 2
    Click Button    ${validation_button}
    Wait Until Page Contains Element    ${popup_validation}
    ${popup_validation_text}=    Get Text    ${popup_validation}
    LOG CHECK GOOD    ${popup_validation_text}
    CHECK INPUT TEXT FIELD LOG    Nom    ${nom_field}    Constructeur numéro 2    True
    CHECK INPUT TEXT FIELD LOG    Préfixe MAC    ${prefixe_mac_field}    00:20:d3    True
    Wait Until Page Contains Element   ${ok_popup_button}
    Click Button    ${ok_popup_button}

    Reload Page
    ${ariane_fil_object_text}=    Get Text    ${ariane_fil_object}
    ${test_ariane_fil}=    Run Keyword And Return Status    Should Be Equal    ${ariane_fil_object_text}    Constructeur numéro 2
    IF  ${test_ariane_fil}
        LOG CHECK GOOD    The breadcrumb contains ${ariane_fil_object_text}
    ELSE
        LOG CHECK WARNIG    The breadcrumb doesn't contain ${ariane_fil_object_text}
    END

Test Filter
    Wait Until Page Contains Element    ${nom_filter}

    @{elements}    Get WebElements    //tbody/tr/td[position()=2]
    @{noms}    Create List
    FOR    ${element}    IN    @{elements}
        ${nom}    Get Text    ${element}
        Append To List    ${noms}    ${nom}
    END
    Sort List   ${noms}

    Click Element    ${nom_filter}
    Sleep    2s
    @{elements_sort}    Get WebElements    //tbody/tr/td[position()=2]
    @{noms_sorted}    Create List
    FOR    ${element}    IN    @{elements_sort}
        ${nom}    Get Text    ${element}
        Append To List    ${noms_sorted}    ${nom}
    END

    ${sort_test}=    Run Keyword And Return Status    Should Be True    ${noms} == ${noms_sorted}
    IF  ${${sort_test}}
        LOG CHECK GOOD    The list of constructeur is sorted by NOM
    ELSE
        LOG CHECK WARNIG    The list of constructeur is not sorted by NOM
    END

Test Search Filter 1
    Wait Until Page Contains Element    ${name_filter_search}
    Input Text    ${name_filter_search}    Constructeur numéro 1
    Wait Until Page Contains Element    ${result_search} 
    LOG CHECK GOOD    Constructeur numéro 1 find !
    Click Element    ${result_search} 

Erase A Constructor
    Wait Until Page Contains Element    ${trash_logo}
    Click Element    ${trash_logo}
    Wait Until Page Contains Element    ${popup_validation}
    ${popup_validation_text}=    Get Text    ${popup_validation}
    LOG CHECK GOOD    ${popup_validation_text}
    Wait Until Page Contains Element    ${confirmer_button} 
    Click Button    ${confirmer_button}
    Sleep    1s
    Wait Until Page Contains Element    ${popup_validation}
    ${popup_validation_text}=    Get Text    ${popup_validation}
    LOG CHECK GOOD    ${popup_validation_text}
    Wait Until Page Contains Element   ${ok_popup_button}
    Click Button    ${ok_popup_button}

Test Search Filter 2
    Wait Until Page Contains Element    ${name_filter_search}
    Input Text    ${name_filter_search}    Constructeur numéro 1
    Wait Until Page Contains Element    ${no_result_search} 
    LOG CHECK GOOD    Constructeur numéro 1 not find !

*** Test Cases ***
Dashboard Constructeur
    Connect To Anyway
    Verify Dashboard Menu
    Go To Constructeur Menu
    Go To Constructeur Creation
    Fill Data In Constructeur Creation 1
    Check Information In Constructor 1
    Go To Constructeur Menu Bis
    Go To Constructeur Creation
    Fill Data In Constructeur Creation Wrong
    Check Information In Constructor 2
    Go To Constructeur Menu Bis
    Test Filter
    Test Search Filter 1
    Erase A Constructor
    Test Search Filter 2
    Sleep    1s
