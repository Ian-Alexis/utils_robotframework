*** Settings ***
Resource    ../utils/utils.robot

*** Variables ***
${url_anyway}    https://anyway.qal.covage.com/dashboard
${browser}    chrome
${bonjour_message}    //h2[contains(text(), "Bonjour")]

${ajouter_button}    //button[span[contains(text(), "Ajouter")]]
${validation_button}    //button[@class="btn btn-success"]
${valider_button}    //button[span[i[@class='bi bi-check']]]
${ariane_fil_object}    //li[@class="breadcrumb-item active"]

${trash_logo}    //i[@class="bi bi-trash3-fill"]
${no_result_search}    //div[contains(text(), "Aucun élément trouvé.")]


${popup_validation}   //div[@id="swal2-html-container"]
${ok_popup_button}    //button[contains(text(),"OK")]
${confirmer_button}    //button[contains(text(), "Confirmer")]
${scrolling_menu_loading}    //div[@class="select-loader"]

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
    ${scrolling_menu_xpath}    Set Variable    //label[contains(text(), '${field_name}')]/following-sibling::div


    ${is_visible_input}    Run Keyword And Return Status    Element Should Be Visible    ${input_xpath}
    ${is_visible_textarea}    Run Keyword And Return Status    Element Should Be Visible    ${textarea_xpath}
    ${is_visible_scrolling_menu}    Run Keyword And Return Status    Element Should Be Visible    ${scrolling_menu_xpath}

    IF    ${is_visible_input}  
        Log To Console    ${field_name} input does exist
        ${xpath}    Set Variable      ${input_xpath}  
    ELSE IF    ${is_visible_textarea}
        Log To Console    ${field name} textarea does exist
        ${xpath}    Set Variable      ${textarea_xpath} 
    ELSE IF    ${is_visible_scrolling_menu}
        Log To Console    ${field_name} scrolling menu does exist
        ${xpath}    Set Variable    ${scrolling_menu_xpath}
    ELSE
        LOG CHECK WARNING    ${field_name} field textarea or scrolling menu xpath doesn't exist
    END

    [Return]    ${xpath}    

Validate Popup Ok
    ${test_popup_ok}    Run Keyword And Return Status   Wait Until Page Contains Element  ${ok_popup_button}
    Wait Until Page Contains Element    ${popup_validation}
    ${popup_validation_text}    Get Text    ${popup_validation}
    LOG CHECK GOOD    ${popup_validation_text}
    Click Button    ${ok_popup_button}
    
Validate Popup Confirmer  
    Wait Until Page Contains Element    ${confirmer_button} 
    ${popup_validation_text}=    Get Text    ${popup_validation}
    LOG CHECK GOOD    ${popup_validation_text}
    Click Button    ${confirmer_button}
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
        ${nom_minuscule}    Convert To Lower Case    ${nom}
        Append To List    ${noms}    ${nom_minuscule}
    END
    Remove From List   ${noms}    0
    Sort List   ${noms}

    Click Element    ${trier_button}
    Sleep    1s
    @{elements_sort}    Get WebElements    ${column_xpath}
    @{noms_sorted}    Create List
    FOR    ${element}    IN    @{elements_sort}
        ${nom}    Get Text    ${element}
        ${nom_minuscule}    Convert To Lower Case    ${nom}
        Append To List    ${noms_sorted}    ${nom_minuscule}
    END
    Remove From List   ${noms_sorted}    0

    ${sort_test}=    Run Keyword And Return Status    Should Be True    ${noms} == ${noms_sorted}
    IF  ${sort_test}
        LOG CHECK GOOD    The list of constructeur is sorted by ${filter_name}
    ELSE
        LOG CHECK WARNING    The list of constructeur is not sorted by ${filter_name}
    END

Test Search Filter
    [Arguments]    ${filter_name}    ${input}    ${find}

    ${index}    Get Column Index From Name    ${filter_name}
    ${search_xpath}    Set Variable    //tbody/tr[1]/td[position()=${index}]/div/input
    Wait Until Page Contains Element    ${search_xpath}
    Input Text    ${search_xpath}    ${input}
    ${result_search}    Set Variable    //td[contains(text(), "${input}")]
    ${existing_test}    Run Keyword And Return Status    Wait Until Page Contains Element    ${result_search}     1s
    IF   '${existing_test}'=='${find}'
        IF  ${existing_test}
            LOG CHECK GOOD    ${input} found !
        ELSE
            LOG CHECK GOOD    ${input} not found !       
        END     
    ELSE
        IF    ${existing_test}
            LOG CHECK WARNING    ${input} found !
        ELSE 
            LOG CHECK WARNING    ${input} not found !
        END
    END

    [Return]     ${result_search}

Test Search Filter Scrolling Menu 
    [Arguments]    ${filter_name}    ${option_text}    ${find}

    ${index}    Get Column Index From Name    ${filter_name}
    ${search_xpath}    Set Variable    //tbody/tr[1]/td[position()=${index}]/div/div
    Wait Until Page Contains Element    ${search_xpath}

    Click Element    ${search_xpath}
    ${option_xpath}    Set Variable    //li/a/span[normalize-space()='${option_text}']
    Wait Until Page Contains Element    ${option_xpath}
    Click Element    ${option_xpath}
    Reload Page

    ${result_search}    Set Variable    //td[contains(text(), "${option_text}")]
    ${existing_test}    Run Keyword And Return Status    Wait Until Page Contains Element    ${result_search}     1s
    IF   '${existing_test}'=='${find}'
        IF  ${existing_test}
            LOG CHECK GOOD    ${option_text} found !
        ELSE
            LOG CHECK GOOD    ${option_text} not found !       
        END     
    ELSE
        IF    ${existing_test}
            LOG CHECK WARNING    ${option_text} found !
        ELSE 
            LOG CHECK WARNING    ${option_text} not found !
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

    FOR    ${test}    IN    @{all_noms}
        Wait Until Page Contains Element    ${search_xpath}
        ${dict_test}    Set Variable    ${nom_dict["${test}"]}
        Input Text    ${search_xpath}    ${dict_test["Nom"]} 
        ${xpath}    Set Variable    //tr[td[normalize-space()='${dict_test["Nom"]}']]
        ${test}    Run Keyword And Return Status    Wait Until Page Contains Element    ${xpath}    1s
        IF    ${test}
            Click Element    ${xpath}
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

Write In Input
    [Arguments]    ${input_name}    ${text}

    ${input_xpath}    Find Field Xpath From Name    ${input_name}
    Input Text    ${input_xpath}    ${text}
    CHECK INPUT TEXT FIELD LOG    ${input_name}   ${input_xpath}    ${text}    False

Select In Scrolling Menu
# Mettre un Log
    [Arguments]    ${menu_name}    ${option_text}

    Wait Until Element Is Not Visible    ${scrolling_menu_loading}    20s

    ${menu_xpath}    Find Field Xpath From Name    ${menu_name}
    Wait Until Page Contains Element    ${menu_xpath}
    Click Element    ${menu_xpath}
    ${option_xpath}    Set Variable    //li/a/span[normalize-space()='${option_text}']
    Wait Until Page Contains Element    ${option_xpath}
    Click Element    ${option_xpath}

Clear Rechercher Input
    [Arguments]    ${input_name}

    ${index}    Get Column Index From Name    ${input_name}
    ${search_xpath}    Set Variable    //tbody/tr[1]/td[position()=${index}]/div/input
    Wait Until Page Contains Element    ${search_xpath}
    Press Keys    ${search_xpath}    \CTRL+a+DELETE
