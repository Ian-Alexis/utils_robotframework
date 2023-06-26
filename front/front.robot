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

*** Keywords ***
Connect To Anyway
    Open Browser    ${url_anyway}    ${browser}
    Maximize Browser Window
    Sleep    3s

Verify Dashboard Menu
    Wait Until Page Contains Element    ${bonjour_message}
    ${bonjour_text}=    Get Text    ${bonjour_message}
    LOG CHECK GOOD    ${bonjour_text}