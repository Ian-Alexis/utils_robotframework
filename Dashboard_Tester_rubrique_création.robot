*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${url_anyway}    https://anyway.qal.covage.com/dashboard
${browser}    chrome

${delay}    0.2s
${second}    1s
${tampon}    3s

${abreviation_text}    Abréviation
${actions_text}    Actions
${ajouter_text}    Ajouter
${bonjour_text}    Bonjour
${carte_text}    Carte
${collecte_text}    Collecte
${constructeur_text}    Constructeur
${constructeurs_text}    Constructeurs
${equipement_text}    Equipement
${equipementier_text}    Equipementier
${license_text}    Licence
${modele_carte_text}    Modèle de carte
${modele_equipment_text}    Modèle d'équipement
${modele_license_text}    Modèles de licence 
${ne_text}    NE
${prefix_mac_text}    Préfixe MAC
${rack_text}    Rack
${reseau_text}    Réseau
${service_text}    Service
${site_text}    Site       
${template_text}    Template 
${transceivers_text}    Transceivers        

${accueil_xpath}    //a[@href="https://anyway.qal.covage.com/dashboard"]

${constructeurs_xpath}    //*[@id="sidebarNav"]/li[2]/a
${constructeur_plus_xpath}    //a[@href="https://anyway.qal.covage.com/constructors/create"]

${modele_xpath}    //*[@id="sidebarNav"]/li[3]/a
${modele_equipments_xpath}    //*[@id="wrapper-0"]/ul/li[1]/a
${modele_equipment_plus_xpath}    //a[@href="https://anyway.qal.covage.com/equipment_models/create"]
${modele_cartes_xpath}    //*[@id="wrapper-0"]/ul/li[2]/a
${modele_cartes_plus_xpath}    //a[@href="https://anyway.qal.covage.com/card_models/create"]
${modele_transceivers_xpath}    //*[@id="wrapper-0"]/ul/li[3]/a
${modele_transceivers_plus_xpath}    //a[@href="https://anyway.qal.covage.com/transceivers/create"]
${modele_licenses_xpath}    //*[@id="wrapper-0"]/ul/li[4]/a    
${modele_licenses_plus_xpath}    //a[@href="https://anyway.qal.covage.com/licence_models/create"]
${modele_templates_xpath}    //*[@id="wrapper-0"]/ul/li[5]/a
${modele_templates_plus_xpath}    //a[@href="https://anyway.qal.covage.com/templates/create"]

${inventaire_xpath}    //*[@id="sidebarNav"]/li[4]/a
${inventaire_site_xpath}    //*[@id="wrapper-1"]/ul/li[2]/a
${inventaire_site_plus_xpath}    //a[@href="https://anyway.qal.covage.com/sites/create"]
${inventaire_racks_xpath}    //*[@id="wrapper-1"]/ul/li[3]/a
${inventaire_racks_plus_xpath}    //a[@href="https://anyway.qal.covage.com/racks/create"]
${inventaire_ne_xpath}    //*[@id="wrapper-1"]/ul/li[5]/a
${inventaire_equipements_xpath}    //*[@id="wrapper-1"]/ul/li[6]/a
${inventaire_equipement_plus_xpath}    //a[@href="https://anyway.qal.covage.com/equipments/create"]
${inventaire_cartes_xpath}    //*[@id="wrapper-1"]/ul/li[7]/a
${inventaire_cartes_plus_xpath}    //a[@href="https://anyway.qal.covage.com/cards/create"]
${invenaire_licenses_xpath}    //*[@id="wrapper-1"]/ul/li[8]/a
${inventaire_licences_plus_xpath}    //a[@href="https://anyway.qal.covage.com/licences/create"]
${inventaire_service_xpath}    //*[@id="wrapper-1"]/ul/li[10]/a
${inventaire_service_plus_xpath}    //a[@href="https://anyway.qal.covage.com/services/create"]
${inventaire_collecte_xpath}    //*[@id="wrapper-1"]/ul/li[11]/a
${inventaire_collecte_plus_xpath}    //a[@href="https://anyway.qal.covage.com/collects/create"]



*** Keywords ***
Open Anyway
    Open Browser    ${url_anyway}    ${browser}
    Maximize Browser Window    

Check Accueil
    Page Should Contain    ${bonjour_text}

Click Accueil
    Click Element    ${accueil_xpath}
    

Click And Check Constructeur
    Click Element    ${constructeurs_xpath}
    Page Should Contain    ${constructeurs_text} 

Click And Check Contructeur Plus
    Click Element    ${constructeur_plus_xpath}
    Page Should Contain    ${constructeur_text}
    Page Should Contain    ${prefix_mac_text}

Click Modèle
    Click Element    ${modele_xpath}
    Sleep    ${delay}

Click And Check Modèle Equipments
    Click Modèle
    Click Element    ${modele_equipments_xpath}
    Page Should Contain    ${modele__equipment_text}
    Page Should Contain    ${equipementier_text}
    Page Should Contain    ${abreviation_text}

Click And Check Modèle Equipment Plus
    Click Element    ${modele_equipment_plus_xpath}
    Page Should Contain    ${modele_equipment_text}
    Page Should Contain    ${ajouter_text}

Click And Check Modèle Cartes
    Click Modèle
    Click Element    ${modele_cartes_xpath}
    Page Should Contain    ${modele_carte_text}
    Page Should Contain    Equipemetier    #    A rempalcer par ${equipementier_text} lorsque le site sera réparé !!

Click And Check Modèle Cartes Plus
    Click Element    ${modele_cartes_plus_xpath}
    Page Should Contain    ${modele_carte_text}
    Page Should Contain    ${ajouter_text}

CLick And Check Modèle Transceivers
    Click Modèle
    Click Element    ${modele_transceivers_xpath}
    Page Should Contain    ${transceivers_text}
    Page Should Contain    ${actions_text}

Click And Check Modèle Transceivers Plus
    Click Element    ${modele_transceivers_plus_xpath}
    Page Should Contain    ${transceivers_text}
    Page Should Contain    ${ajouter_text}
    
Click And Check Modèle Licenses
    Click Modèle
    Click Element    ${modele_licenses_xpath}
    Page Should Contain    ${Modele_license_text}
    Page Should Contain    ${equipementier_text}

Click And Check Modèle Licenses Plus
    Click Element    ${modele_licenses_plus_xpath}
    Page Should Contain    ${Modele_license_text}
    Page Should Contain    ${ajouter_text}

CLick And Check Modèle Templates 
    Click Modèle   
    Click Element    ${modele_templates_xpath}
    Page Should Contain    ${template_text}
    Page Should Contain    ${actions_text}

Click And Check Modèle Templates Plus
    Click Element    ${modele_templates_plus_xpath}
    Page Should Contain    ${template_text}
    Page Should Contain    ${ajouter_text}

Click Inventaire
    Click Element    ${inventaire_xpath}
    Sleep    ${delay}

Click And Check Inventaire Sites
    Click Inventaire
    Click Element    ${inventaire_site_xpath}
    Page Should Contain    ${site_text}
    Page Should Contain    ${actions_text}

Click And Check Inventaire Sites Plus 
    Click Element    ${inventaire_site_plus_xpath}
    Page Should Contain    ${site_text}
    Page Should Contain   ${ajouter_text}

Click And Check Inventaire Racks
    Click Inventaire   
    Click Element    ${inventaire_racks_xpath}
    Page Should Contain    ${rack_text}
    Page Should Contain    ${actions_text}

Click And Check Inventaire Racks Plus
    Click Element    ${inventaire_racks_plus_xpath}
    Page Should Contain    ${rack_text}
    Page Should Contain    ${ajouter_text}

Click And Check Inventaire NE
    Click Inventaire
    Click Element    ${inventaire_ne_xpath}
    Page Should Contain    ${ne_text}
    Page Should Contain    ${actions_text}

CLick And Check Inventaire Equipement
    Click Inventaire
    Click Element    ${inventaire_equipements_xpath}
    Page Should Contain    ${equipement_text}
    Page Should Contain    ${reseau_text}

Click And Check Inventaire Equipment Plus
    Click Element    ${inventaire_equipement_plus_xpath}
    Page Should Contain    ${equipement_text}
    Page Should Contain    ${ajouter_text}

Click And Check Inventaire Cartes 
    Click Inventaire
    Click Element    ${inventaire_cartes_xpath}
    Page Should Contain    ${carte_text}
    Page Should Contain    ${reseau_text}

Click And Check Inventaire Cartes Plus
    Click Element    ${inventaire_cartes_plus_xpath}
    Page Should Contain    ${carte_text}
    Page Should Contain    ${ajouter_text}

Click And Check Inventaire Licenses
    Click Inventaire   
    Click Element    ${invenaire_licenses_xpath}
    Page Should Contain    ${license_text}
    Page Should Contain    ${reseau_text}

Click And Check Inventaire Licenses Plus 
    Click Element    ${inventaire_licences_plus_xpath}
    Page Should Contain    ${license_text}
    Page Should Contain    ${ajouter_text}

Click And Check Inventaire Services 
    Click Inventaire
    Click Element    ${inventaire_service_xpath}
    Page Should Contain    ${service_text}
    Page Should Contain    ${actions_text}

Click And Check Inventaire Services Plus
    Click Element    ${inventaire_service_plus_xpath}
    Page Should Contain    ${service_text}
    Page Should Contain   ${ajouter_text}

Click And Check Inventaire Collecte
    Click Inventaire
    Click Element    ${inventaire_collecte_xpath}
    Page Should Contain    ${collecte_text}
    Page Should Contain    ${actions_text}

Click And Check Inventaire Collecte Plus 
    Click Element    ${inventaire_collecte_plus_xpath}
    Page Should Contain    ${service_text}
    Page Should Contain    ${ajouter_text}


# *** Test Cases ***
# Anyway Test 
#     Open Anyway
#     Check Accueil
#     Click And Check Constructeur
#     Click And Check Contructeur Plus
#     Click And Check Modèle Equipments
#     Click And Check Modèle Equipment Plus
#     Click And Check Modèle Cartes
#     Click And Check Modèle Cartes Plus
#     CLick And Check Modèle Transceivers
#     Click And Check Modèle Transceivers Plus
#     Click And Check Modèle Licenses
#     Click And Check Modèle Licenses Plus
#     CLick And Check Modèle Templates
#     Click And Check Modèle Templates Plus
#     Click And Check Inventaire Sites
#     Click And Check Inventaire Sites Plus
#     Click And Check Inventaire Racks
#     Click And Check Inventaire Racks Plus
#     Click And Check Inventaire NE
#     Click Modèle
#     Sleep    ${delay}
#     Click And Check Inventaire Equipement 
#     Click And Check Inventaire Equipment Plus
#     Click And Check Inventaire Cartes
#     Click And Check Inventaire Cartes Plus
#     Click And Check Inventaire Licenses
#     Click And Check Inventaire Licenses Plus
#     Click And Check Inventaire Services
#     Click And Check Inventaire Services Plus
#     Sleep    ${delay}
#     Click And Check Inventaire Collecte
#     Click And Check Inventaire Collecte Plus
#     Sleep    ${tampon}   