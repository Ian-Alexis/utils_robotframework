*** Settings ***
Library    String
Library    SeleniumLibrary
Library    DateTime
Library    Collections
Library    JSONLibrary
Library    utils.py

# pip install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org bs4

*** Keywords ***
CHECK INPUT TEXT FIELD LOG
    [Documentation]
    ...    La fonction CHECK INPUT TEXT FIELD LOG vérifie la valeur d'un champ de texte spécifique et 
    ...    enregistre le résultat dans le journal de test. Cette fonction est utile pour valider 
    ...    que les champs de texte ont été correctement remplis lors d'un test automatisé.
    ...    
    ...    Arguments:
    ...    ${name_of_field} : Le nom du champ de texte à vérifier. Ce nom est utilisé uniquement à des fins de journalisation.
    ...    ${xpath_of_field} : Le chemin d'accès XPath du champ de texte à vérifier.
    ...    ${text_of_field} : Le texte attendu dans le champ de texte.
    ...    ${log} : Un booléen pour contrôler si le résultat doit être enregistré dans le journal de test.
    ...    
    ...    Comportement :
    ...    1. Extrayez la valeur actuelle du champ de texte spécifié par ${xpath_of_field}.
    ...    2. Vérifiez si la valeur extraite contient ${text_of_field}.
    ...    3. Si la valeur contient ${text_of_field} et si ${log} est vrai, enregistrez un message de succès dans le journal.
    ...    4. Si la valeur ne contient pas ${text_of_field}, enregistrez un message d'erreur dans le journal.
    ...    
    ...    Exemple d'utilisation :
    ...    CHECK INPUT TEXT FIELD LOG    Nom de l'utilisateur    //input[@name='username']    "Utilisateur Test"    ${TRUE}

    [Arguments]    ${name_of_field}    ${xpath_of_field}    ${text_of_field}    ${log}
    ${Extract_field}=    Get Value    ${xpath_of_field}
    ${test_field}=    Run Keyword And Return Status    Should Contain    ${Extract_field}  ${text_of_field} 
    IF    ${test_field} and ${log}
        LOG CHECK GOOD    There is written ${text_of_field} in the ${name_of_field} field
    ELSE IF    "${test_field}" == "False"
        LOG CHECK WARNING    There is not written ${text_of_field} in the ${name_of_field} field
    END

CHECK SCROLLING MENU TEXT FIELD
    [Documentation]
    ...    La fonction CHECK SCROLLING MENU TEXT FIELD vérifie le texte d'un champ spécifique 
    ...    dans un menu déroulant et enregistre le résultat dans le journal de test. 
    ...    Cette fonction est utile pour valider que les menus déroulants ont été correctement 
    ...    remplis ou sélectionnés lors d'un test automatisé.
    ...    
    ...    Arguments:
    ...    ${name_of_field} : Le nom du champ du menu déroulant à vérifier. Ce nom est utilisé uniquement à des fins de journalisation.
    ...    ${xpath_of_field} : Le chemin d'accès XPath du champ du menu déroulant à vérifier.
    ...    ${text_of_field} : Le texte attendu dans le champ du menu déroulant.
    ...    ${log} : Un booléen pour contrôler si le résultat doit être enregistré dans le journal de test.
    ...    
    ...    Comportement :
    ...    1. Extrayez le texte actuel du champ du menu déroulant spécifié par ${xpath_of_field}.
    ...    2. Vérifiez si le texte extrait contient ${text_of_field}.
    ...    3. Si le texte contient ${text_of_field} et si ${log} est vrai, enregistrez un message de succès dans le journal.
    ...    4. Si le texte ne contient pas ${text_of_field}, enregistrez un message d'erreur dans le journal.
    ...    
    ...    Exemple d'utilisation :
    ...    CHECK SCROLLING MENU TEXT FIELD    Nom du menu    //select[@name='dropdown']    "Option sélectionnée"    ${TRUE}

    [Arguments]    ${name_of_field}    ${xpath_of_field}    ${text_of_field}    ${log}
    ${Extract_field}=    Get Text    ${xpath_of_field}
    ${test_field}=    Run Keyword And Return Status    Should Contain    ${Extract_field}  ${text_of_field} 
    IF  ${test_field} and ${log}
        LOG CHECK GOOD    There is writed ${text_of_field} in the ${name_of_field} scrolling menu
    ELSE IF    "${test_field}" == "False"
        LOG CHECK WARNING    There is not writed ${text_of_field} in the ${name_of_field} scrolling menu
    END

PRESS MULTIPLE TIME KEYS
    [Documentation]
    ...    La fonction PRESS MULTIPLE TIME KEYS simule l'appui d'une séquence de touches 
    ...    sur le clavier un certain nombre de fois. 
    ...    Cette fonction est utile pour les tests qui nécessitent des interactions avec le clavier,
    ...    comme la saisie de texte ou la navigation à l'aide des touches du clavier.
    ...    
    ...    Arguments:
    ...    ${number} : Le nombre de fois que la séquence de touches doit être simulée.
    ...    ${keys} : La séquence de touches à simuler.
    ...    
    ...    Comportement :
    ...    1. Pour chaque itération jusqu'à ${number}, simulez l'appui de la séquence de touches ${keys}.
    ...    2. Attendez 0,1 seconde entre chaque simulation pour garantir que chaque touche est correctement détectée.
    ...    
    ...    Exemple d'utilisation :
    ...    PRESS MULTIPLE TIME KEYS    10    TAB

    [Arguments]    ${number}    ${keys}
    FOR    ${counter}    IN RANGE    0    ${number}
        Press Keys    None    ${keys}
        Sleep    0.1s
    END

LOG CHECK GOOD
    [Documentation]
    ...    La fonction LOG CHECK GOOD enregistre un message de niveau WARN dans les journaux de test,
    ...    avec une mise en forme HTML pour afficher le texte en vert.
    ...    Cette fonction est généralement utilisée pour indiquer qu'une certaine étape du test s'est déroulée correctement.
    ...    
    ...    Arguments:
    ...    ${message} : Le message à enregistrer dans le journal de test.
    ...    
    ...    Exemple d'utilisation:
    ...    LOG CHECK GOOD    L'étape de validation s'est déroulée correctement.

    [Arguments]    ${message}
    Log    <h3 style="color: green;">${message}</h3>   level=WARN  html=True

LOG CHECK WARNING
    [Documentation]
    ...    La fonction LOG CHECK WARNING enregistre un message de niveau ERROR dans les journaux de test,
    ...    avec une mise en forme HTML pour afficher le texte en rouge.
    ...    Cette fonction est généralement utilisée pour indiquer une erreur ou un échec lors d'une certaine étape du test.
    ...    
    ...    Arguments:
    ...    ${message} : Le message à enregistrer dans le journal de test.
    ...    
    ...    Exemple d'utilisation:
    ...    LOG CHECK WARNING    L'étape de validation a échoué.

    [Arguments]    ${message}
    Log    <h3 style="color: red;">${message}</h3>    level=ERROR     html=True

LOG CHECK INFORMATION
    [Documentation]
    ...    La fonction LOG CHECK INFORMATION enregistre un message de niveau ERROR dans les journaux de test,
    ...    avec une mise en forme HTML pour afficher le texte en orange.
    ...    Cette fonction est utilisée pour enregistrer des informations supplémentaires qui pourraient être utiles 
    ...    pour comprendre le déroulement du test, sans pour autant indiquer un échec.
    ...    
    ...    Arguments:
    ...    ${message} : Le message à enregistrer dans le journal de test.
    ...    
    ...    Exemple d'utilisation:
    ...    LOG CHECK INFORMATION    L'étape de validation a été exécutée mais la réponse n'était pas celle attendue. 

    [Arguments]    ${message}
    Log    <h3 style="color: orange;">${message}</h3>    level=ERROR     html=True

GET CSS PROPERTY VALUE
    [Documentation]
    ...    Get the CSS property value of an Element.
    ...    
    ...    This keyword retrieves the CSS property value of an element. The element
    ...    is retrieved using the locator.
    ...    
    ...    Arguments:
    ...    - locator           (string)    any Selenium Library supported locator xpath/css/id etc.
    ...    - property_name     (string)    the name of the css property for which the value is returned.
    ...    
    ...    Returns             (string)    returns the string value of the given css attribute or fails.
    ...        
    [Arguments]    ${locator}    ${attribute name}
    ${css}=         Get WebElement    ${locator}
    ${prop_val}=    Call Method       ${css}    value_of_css_property    ${attribute name}
    [Return]     ${prop_val}

RETRY TEST
    [Documentation]
    ...    La fonction RETRY TEST recharge la page en cours et enregistre l'information 
    ...    dans le journal de test. Cette fonction est utile lorsque le test échoue en raison 
    ...    d'une condition temporaire qui peut être résolue en rechargeant la page.
    ...    
    ...    Comportement :
    ...    1. Enregistrez le message "Reload test" dans le journal de test.
    ...    2. Rechargez la page en cours.
    ...    
    ...    Exemple d'utilisation :
    ...    RETRY TEST

    LOG CHECK INFORMATION    Reload test
    Reload Page

EXTRACT JSON TO DICTIONNARY
# Possibilité de retourner sous différents formats
    [Documentation]
    ...    La fonction EXTRACT JSON TO DICTIONARY lit un fichier JSON à partir d'un chemin d'accès spécifié, 
    ...    convertit les données JSON en un dictionnaire Python et enregistre les données dans le journal de test.
    ...    Cette fonction est utile pour lire des fichiers JSON qui contiennent des données de test ou des 
    ...    configurations de test.
    ...    
    ...    Arguments:
    ...    ${path_json} : Le chemin d'accès du fichier JSON à lire.
    ...    
    ...    Comportement :
    ...    1. Utilisez la fonction utils.get_value_from_json pour lire le fichier JSON à partir de ${path_json} 
    ...    et convertir les données JSON en un dictionnaire Python.
    ...    2. Enregistrez le dictionnaire dans le journal de test.
    ...    3. Retournez le dictionnaire.
    ...    
    ...    Exemple d'utilisation :
    ...    ${data} = EXTRACT JSON TO DICTIONARY    /path/to/data.json

    [Arguments]    ${path_json}

    ${data}    utils.get_value_from_json    ${path_json}
    Log    ${data}

    [Return]    ${data}

GET INDEX OF ELEMENT
    [Documentation]
    ...    La fonction GET INDEX OF ELEMENT trouve l'index d'un élément spécifique dans une liste. 
    ...    Si l'élément n'est pas trouvé dans la liste, la fonction échoue avec un message d'erreur.
    ...    Cette fonction est utile lorsque vous devez trouver la position d'un élément spécifique dans une liste.
    ...    
    ...    Arguments:
    ...    @{list} : La liste dans laquelle chercher.
    ...    ${element} : L'élément à chercher dans la liste.
    ...    
    ...    Comportement :
    ...    1. Initialise une variable de retour à vide.
    ...    2. Parcourez chaque élément de la liste avec son index.
    ...    3. Comparez chaque élément de la liste avec ${element}.
    ...    4. Si un élément de la liste est égal à ${element}, définissez la variable de retour à l'index de cet élément 
    ...    et retournez cet index.
    ...    5. Si aucun élément de la liste n'est égal à ${element}, échouez avec le message "L'élément n'est pas dans la liste."
    ...    
    ...    Exemple d'utilisation :
    ...    ${index} = GET INDEX OF ELEMENT    ${list}    "element"

    [Arguments]    @{list}    ${element}

    ${return}    Set Variable    ${EMPTY}

    FOR    ${index}    ${value}    IN ENUMERATE    @{list}

        ${test}    Run Keyword And Return Status    Should Be Equal    ${element}    ${value}

        IF    ${test}
        
            ${return}    Set Variable    ${index}  
            Return From Keyword  ${index}

        Fail  L'élément n'est pas dans la liste.FOR
        END
    END