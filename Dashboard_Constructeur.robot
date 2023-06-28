*** Settings ***
Resource    front/constructeur.robot
Suite Setup    Connect To Anyway

# Automatiser la suppression d'un constructeur qui existe déjà 
*** Variables ***


# ${nom_field}    //label[contains(text(), 'Nom')]/following-sibling::input[1]
${error_nom_field}    //label[contains(text(), 'Nom')]/following-sibling::div[@class="form-text text-danger"]
# ${prefixe_mac_field}    //label[contains(text(), 'Préfixe MAC')]/following-sibling::textarea[1]



${result_search}    //td[contains(text(), "Constructeur numéro 1")]


*** Keywords ***

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
        LOG CHECK WARNING    The breadcrumb doesn't contain ${ariane_fil_object_text}
    END

Test Filter
    Wait Until Page Contains Element    ${nom_filter}

    ${index}    Get Element Attribute    xpath://span[text()='Nom']/preceding::th    count


    @{elements}    Get WebElements    //tbody/tr/td[position()=${index}]

    @{noms}    Create List
    FOR    ${element}    IN    @{elements}
        ${nom}    Get Text    ${element}
        Append To List    ${noms}    ${nom}
    END
    Sort List   ${noms}

    Click Element    ${nom_filter}
    Sleep    2s
    # @{elements_sort}    Get WebElements    //tbody/tr/td[position()=2]
    @{elements_sort}    Get WebElements    //tbody/tr/td[contains(text(),"NOM")]
    @{noms_sorted}    Create List
    FOR    ${element}    IN    @{elements_sort}
        ${nom}    Get Text    ${element}
        Append To List    ${noms_sorted}    ${nom}
    END

    ${sort_test}=    Run Keyword And Return Status    Should Be True    ${noms} == ${noms_sorted}
    IF  ${${sort_test}}
        LOG CHECK GOOD    The list of constructeur is sorted by NOM
    ELSE
        LOG CHECK WARNING    The list of constructeur is not sorted by NOM
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
# Mettre la fonction Element Should Not Be Visible
    Wait Until Page Contains Element    ${name_filter_search}
    Input Text    ${name_filter_search}    Constructeur numéro 1
    Wait Until Page Contains Element    ${no_result_search} 
    LOG CHECK GOOD    Constructeur numéro 1 not found !


*** Test Cases ***
Dashboard Constructeur
# Faire une fonction qui extrait tous les json correspondant au nom du test
    
    &{data}    EXTRACT JSON TO DICTIONNARY    data\\Dashboard_Constructeur.json
    
    Verify Dashboard Menu

    Get Column Index From Name    NOM
    
    # Go To Constructeur Menu
    # Check And Delete Existing Constructeurs    &{data}  
    
    # Go To Constructeur Creation
    # Check Error Field Constructeur
    # Fill Data In Constructeur Creation    ${data["Dashboard_constructeur_1"]}
    # Validate Popup Ok
    # Check Information In Constructeur    ${data["Dashboard_constructeur_1"]}
    # Go To Constructeur Menu Breadcrumb
    # Go To Constructeur Creation
    # Fill Data In Constructeur Creation    ${data["Dashboard_constructeur_1"]}
    # Check Error Field Constructeur
    # Fill Data In Constructeur Creation    ${data["Dashboard_constructeur_1Bis"]}
    # Validate Popup Ok
    # Check Information In Constructeur    ${data["Dashboard_constructeur_1Bis"]}
    # Fill Data In Constructeur    ${data["Dashboard_constructeur_2"]}
    # Validate Popup Ok
    # Check Information In Constructeur    ${data["Dashboard_constructeur_2"]}
    # Go To Constructeur Menu Breadcrumb
    # Test Filter
    # Test Search Filter 1
    # Erase A Constructor
    # Test Search Filter 2
    Sleep    1s
