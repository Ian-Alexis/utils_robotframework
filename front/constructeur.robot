*** Settings ***
Resource    ../utils/utils.robot
Resource    front.robot

*** Variables ***
${contructeur_menu}    //a[@href="https://anyway.qal.covage.com/constructors" and @class="nav-link"]
# ${nom_filter}    //div[span[contains(text(), "NOM")]]
${nom_filter}    xpath:/html/body/main/div[2]/div/div/div/div[2]/div/div[4]/table/thead/tr/th[2]/div

${constructeur_creation}    //a[@href="https://anyway.qal.covage.com/constructors/create"]
${ariane_fil_constructor}    //a[@href="https://anyway.qal.covage.com/constructors"][@class="text-decoration-none"]

*** Keywords ***
Go To Constructeur Menu
    Wait Until Page Contains Element    ${contructeur_menu}
    Click Element    ${contructeur_menu}
    Wait Until Page Contains Element    ${constructeur_creation}
    LOG CHECK GOOD    Go to contructeurs menu

Go To Constructeur Creation
    Click Element    ${constructeur_creation}
    Wait Until Page Contains Element    ${ajouter_button}
    LOG CHECK GOOD    Go to contructeurs creation