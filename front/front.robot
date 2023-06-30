*** Settings ***
Resource    ../utils/utils.robot

*** Variables ***
${url_anyway}    https://anyway.qal.covage.com/dashboard
${browser}    chrome
${bonjour_message}    //h2[contains(text(), "Bonjour")]

${ajouter_button}    //button[span[contains(text(), "Ajouter")]]
${validation_button}    //button[@class="btn btn-success"]
${ariane_fil_object}    //li[@class="breadcrumb-item active"]

${trash_logo}    //i[@class="bi bi-trash3-fill"]
${no_result_search}    //div[contains(text(), "Aucun élément trouvé.")]


${popup_validation}   //div[@id="swal2-html-container"]
${ok_popup_button}    //button[contains(text(), "OK")]
${confirmer_button}    //button[contains(text(), "Confirmer")]

*** Keywords ***
Connect To Anyway
    Open Browser    ${url_anyway}    ${browser}
    Maximize Browser Window

Verify Dashboard Menu
    Wait Until Page Contains Element    ${bonjour_message}
    ${bonjour_text}=    Get Text    ${bonjour_message}
    LOG CHECK GOOD    ${bonjour_text}

Find Field Xpath From Name
# Voir si on le met dans utils
    [Arguments]    ${field_name}   

    ${input_xpath}    Set Variable    //label[contains(text(), '${field_name}')]/following-sibling::input[1]
    ${textarea_xpath}    Set Variable    //label[contains(text(), '${field_name}')]/following-sibling::textarea[1]
    ${is_visible_input}    Run Keyword And Return Status    Element Should Be Visible    ${input_xpath}
    ${is_visible_textarea}    Run Keyword And Return Status    Element Should Be Visible    ${textarea_xpath}

    IF    ${is_visible_input}  
        Log To Console    ${field_name} input does exist
        ${xpath}    Set Variable      ${input_xpath}  
    ELSE IF    ${is_visible_textarea}
        Log To Console    ${field name} textarea exits
        ${xpath}    Set Variable      ${textarea_xpath} 
    ELSE
        LOG CHECK WARNING    ${field_name} field or textarea xpath doesn't exist
    END

    [Return]    ${xpath}    

Validate Popup Ok
    Wait Until Page Contains Element    ${popup_validation}
    ${popup_validation_text}    Get Text    ${popup_validation}
    LOG CHECK GOOD    ${popup_validation_text}
    Wait Until Page Contains Element   ${ok_popup_button}
    Click Button    ${ok_popup_button}
    
Validate Popup Confirmer  
    Wait Until Page Contains Element    ${confirmer_button} 
    ${popup_validation_text}=    Get Text    ${popup_validation}
    LOG CHECK GOOD    ${popup_validation_text}
    Click Button    ${confirmer_button}
    Sleep    1s
    Validate Popup Ok

Get Column Index From Name
    [Arguments]    ${name_column}

    ${return}    Set Variable    False
    Wait Until Page Contains Element    //thead[tr]
    ${elements}    Get WebElements    //thead[tr]

    @{names}    Create List
    FOR    ${element}    IN    @{elements}
        ${name}    Get Text    ${element}
        Append To List    ${names}    ${name}
    END 
    @{names}    Split String    ${name}    \n

    FOR    ${index}    ${name}    IN ENUMERATE    @{names}
        ${test}    Run Keyword And Return Status    Should Be Equal    ${name_column}    ${name}
        IF    ${test}
            ${return}    Set Variable    ${index}
            ${return}    Evaluate    ${return} + 2
        END
    END

    IF    '${return}'=='False'
        Log    ${name_column} not found
        Fail
    END    

    [Return]   ${return}
            

Test Filter
    [Arguments]    ${filter_name}

    Wait Until Page Contains Element    //thead
    ${index}    Get Column Index From Name    ${filter_name}
    ${trier_button}    Set Variable    //thead/tr/th[position()=${index}]/div[@style="cursor:pointer;"]
    ${column_xpath}    Set Variable    //tbody/tr/td[position()=${index}]
    @{elements}    Get WebElements    ${column_xpath}

    @{noms}    Create List
    FOR    ${element}    IN    @{elements}
        ${nom}    Get Text    ${element}
        Append To List    ${noms}    ${nom}
    END
    Remove From List   ${noms}    0
    Sort List   ${noms}

    Click Element    ${trier_button}
    Sleep    1s
    @{elements_sort}    Get WebElements    ${column_xpath}
    @{noms_sorted}    Create List
    FOR    ${element}    IN    @{elements_sort}
        ${nom}    Get Text    ${element}
        Append To List    ${noms_sorted}    ${nom}
    END
    Remove From List   ${noms_sorted}    0

    ${sort_test}=    Run Keyword And Return Status    Should Be True    ${noms} == ${noms_sorted}
    IF  ${sort_test}
        LOG CHECK GOOD    The list of constructeur is sorted by NOM
    ELSE
        LOG CHECK WARNING    The list of constructeur is not sorted by NOM
    END

Test Search Filter
    [Arguments]    ${filter_name}    ${input}    ${find}

    ${index}    Get Column Index From Name    ${filter_name}
    ${search_xpath}    Set Variable    //tbody/tr[1]/td[position()=${index}]/div/input
    Wait Until Page Contains Element    ${search_xpath}
    Input Text    ${search_xpath}    ${input}
    ${result_search}    Set Variable    //td[contains(text(), "${input}")]
    ${test}    Run Keyword And Return Status    Wait Until Page Contains Element    ${result_search}     1s
    IF   '${test}'=='${find}'
        IF  ${test}
            LOG CHECK GOOD    ${input} found !
        ELSE
            LOG CHECK GOOD    ${input} not found !       
        END     
    ELSE
        IF    ${test}
            LOG CHECK WARNING    ${input} found !
        ELSE 
            LOG CHECK WARNING    ${input} not found !
        END
    END

    [Return]     ${result_search}


Check And Delete Existing Elements 
    [Arguments]    ${filter_name}    &{nom_dict}    

    ${index}    Get Column Index From Name    ${filter_name}
    ${search_xpath}    Set Variable    //tbody/tr[1]/td[position()=${index}]/div/input

    # Sort List    ${all_noms}
    # Reverse List    ${all_noms} 
       
    @{all_noms}    Create List

    FOR    ${nom}    ${value}    IN    &{nom_dict}
        Append To List    ${all_noms}    ${nom}
    END
    Sort List    ${all_noms}
    Reverse List    ${all_noms}
    Log    ${all_noms}
    ${var}    Set Variable    ${nom_dict["Dashboard_constructeur_2"]}
    Log    ${var["Nom"]}

    FOR    ${test}    IN    @{all_noms}
        Wait Until Page Contains Element    ${search_xpath}
        ${dict_test}    Set Variable    ${nom_dict["${test}"]}
        Input Text    ${search_xpath}    ${dict_test["Nom"]} 
        ${test}    Run Keyword And Return Status    Wait Until Page Contains Element    //tr[td[normalize-space()='${dict_test["Nom"]}']]    1s
        IF    ${test}
            Click Element    //tr[td[normalize-space()='${dict_test["Nom"]}']]
            Erase Element
        END
    END

Erase Element
    [Arguments]    ${xpath}=${False}

    IF    '${xpath}'!='False'
        Wait Until Page Contains Element    ${xpath}
        Click Element    ${xpath}
    END

    Wait Until Page Contains Element    ${trash_logo}
    Click Element    ${trash_logo}
    Validate Popup Confirmer
    Validate Popup Ok