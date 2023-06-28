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