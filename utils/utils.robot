
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
    [Arguments]    ${name_of_field}    ${xpath_of_field}    ${text_of_field}    ${log}
    ${Extract_field}=    Get Value    ${xpath_of_field}
    ${test_field}=    Run Keyword And Return Status    Should Contain    ${Extract_field}  ${text_of_field} 
    IF    ${test_field} and ${log}
        LOG CHECK GOOD    There is written ${text_of_field} in the ${name_of_field} field
    ELSE IF    "${test_field}" == "False"
        LOG CHECK WARNING    There is not written ${text_of_field} in the ${name_of_field} field
    END

CHECK SCROLLING MENU TEXT FIELD
    [Arguments]    ${name_of_field}    ${xpath_of_field}    ${text_of_field}
    ${Extract_field}=    Get Text    ${xpath_of_field}
    ${test_field}=    Run Keyword And Return Status    Should Contain    ${Extract_field}  ${text_of_field} 
    IF  ${test_field}
        LOG CHECK GOOD    There is writed ${text_of_field} in the ${name_of_field} scrolling menu
    ELSE
        LOG CHECK WARNING    There is not writed ${text_of_field} in the ${name_of_field} scrolling menu
    END

PRESS MULTIPLE TIME KEYS
    [Arguments]    ${number}    ${keys}
    FOR    ${counter}    IN RANGE    0    ${number}
        Press Keys    None    ${keys}
        Sleep    0.1s
    END

LOG CHECK GOOD
    [Arguments]    ${message}
    Log    <h3 style="color: green;">${message}</h3>   level=WARN  html=True

LOG CHECK WARNING
    [Arguments]    ${message}
    Log    <h3 style="color: red;">${message}</h3>    level=ERROR     html=True

LOG CHECK INFORMATION
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
    LOG CHECK INFORMATION    Reload test
    Reload Page

EXTRACT JSON TO DICTIONNARY
# Possibilité de retourner sous différents formats
    [Arguments]    ${path_json}

    ${data}    utils.get_value_from_json    ${path_json}
    Log    ${data}

    [Return]    ${data}

GET INDEX OF ELEMENT
    [Arguments]    @{list}    ${element}

    ${return}    Set Variable    ${EMPTY}

    FOR    ${index}    ${value}    IN ENUMERATE    @{list}

        ${test}    Run Keyword And Return Status    Should Be Equal    '${element}' == '${value}'

        IF    ${test}
        
            ${return}    Set Variable    ${index}  
            Return From Keyword  ${index}

        Fail  L'élément n'est pas dans la liste.FOR

    END