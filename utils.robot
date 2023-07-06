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
    ...    The CHECK INPUT TEXT FIELD LOG function verifies the value of a specific text field and
    ...    logs the result in the test log. This function is useful for validating
    ...    that text fields have been correctly filled in during an automated test.
    ...    
    ...    Arguments:
    ...    ${name_of_field} (string) : The name of the text field to check. This name is used only for logging purposes.
    ...    ${xpath_of_field} (string) : The XPath path of the text field to check.
    ...    ${text_of_field} (string) : The expected text in the text field.
    ...    ${log} (boolean) : A boolean to control whether the result should be logged in the test log.
    ...    
    ...    Behavior :
    ...    1. Extract the current value of the text field specified by ${xpath_of_field}.
    ...    2. Check if the extracted value contains ${text_of_field}.
    ...    3. If the value contains ${text_of_field} and if ${log} is true, log a success message in the log.
    ...    4. If the value does not contain ${text_of_field}, log an error message in the log.
    ...    
    ...    Usage example :
    ...    CHECK INPUT TEXT FIELD LOG    Username    //input[@name='username']    "Test User"    ${TRUE}

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
    ...    The CHECK SCROLLING MENU TEXT FIELD function verifies the text of a specific field
    ...    in a dropdown menu and logs the result in the test log.
    ...    This function is useful for validating that dropdown menus have been correctly
    ...    filled or selected during an automated test.
    ...    
    ...    Arguments:
    ...    ${name_of_field} (string) : The name of the dropdown menu field to check. This name is used only for logging purposes.
    ...    ${xpath_of_field} (string) : The XPath path of the dropdown menu field to check.
    ...    ${text_of_field} (string) : The expected text in the dropdown menu field.
    ...    ${log} (boolean) : A boolean to control whether the result should be logged in the test log.
    ...    
    ...    Behavior :
    ...    1. Extract the current text of the dropdown menu field specified by ${xpath_of_field}.
    ...    2. Check if the extracted text contains ${text_of_field}.
    ...    3. If the text contains ${text_of_field} and if ${log} is true, log a success message in the log.
    ...    4. If the text does not contain ${text_of_field}, log an error message in the log.
    ...    
    ...    Usage example :
    ...    CHECK SCROLLING MENU TEXT FIELD    Menu name    //select[@name='dropdown']    "Selected option"    ${TRUE}

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
    ...    The PRESS MULTIPLE TIME KEYS function simulates the pressing of a sequence of keys
    ...    on the keyboard a certain number of times.
    ...    This function is useful for tests that require keyboard interactions,
    ...    such as typing text or navigating using the keyboard keys.
    ...    
    ...    Arguments:
    ...    ${number} (integer) : The number of times the key sequence should be simulated.
    ...    ${keys} (string) : The sequence of keys to simulate.
    ...    
    ...    Behavior :
    ...    1. For each iteration up to ${number}, simulate the pressing of the key sequence ${keys}.
    ...    2. Wait 0.1 second between each simulation to ensure that each key press is correctly detected.
    ...    
    ...    Usage example :
    ...    PRESS MULTIPLE TIME KEYS    10    TAB

    [Arguments]    ${number}    ${keys}
    FOR    ${counter}    IN RANGE    0    ${number}
        Press Keys    None    ${keys}
        Sleep    0.1s
    END

LOG CHECK GOOD
    [Documentation]
    ...    The LOG CHECK GOOD function logs a message at the WARN level in the test logs,
    ...    with HTML formatting to display the text in green.
    ...    This function is typically used to indicate that a certain test step has proceeded correctly.
    ...    
    ...    Arguments:
    ...    ${message} (string) : The message to log in the test log.
    ...    
    ...    Usage example :
    ...    LOG CHECK GOOD    Validation step proceeded correctly.

    [Arguments]    ${message}
    Log    <h3 style="color: green;">${message}</h3>   level=WARN  html=True

LOG CHECK WARNING
    [Documentation]
    ...    The LOG CHECK WARNING function logs a message at the ERROR level in the test logs,
    ...    with HTML formatting to display the text in red.
    ...    This function is typically used to indicate an error or failure during a certain test step.
    ...    
    ...    Arguments:
    ...    ${message} (string) : The message to log in the test log.
    ...    
    ...    Usage example :
    ...    LOG CHECK WARNING    Validation step failed.

    [Arguments]    ${message}
    Log    <h3 style="color: red;">${message}</h3>    level=ERROR     html=True

LOG CHECK INFORMATION
    [Documentation]
    ...    The LOG CHECK INFORMATION function logs a message at the ERROR level in the test logs,
    ...    with HTML formatting to display the text in orange.
    ...    This function is used to record additional information that might be useful
    ...    for understanding the course of the test, without necessarily indicating a failure.
    ...    
    ...    Arguments:
    ...    ${message} (string) : The message to log in the test log.
    ...    
    ...    Usage example :
    ...    LOG CHECK INFORMATION    Validation step was executed but the response was not as expected.

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
    ...    The RETRY TEST function reloads the current page and logs the information
    ...    in the test log. This function is useful when the test fails due to a
    ...    temporary condition that can be resolved by reloading the page.
    ...    
    ...    Behavior:
    ...    1. Log the message "Reload test" in the test log.
    ...    2. Reload the current page.
    ...    
    ...    Usage example :
    ...    RETRY TEST

    LOG CHECK INFORMATION    Reload test
    Reload Page

EXTRACT JSON TO DICTIONNARY
# Possibilité de retourner sous différents formats
    [Documentation]
    ...    The EXTRACT JSON TO DICTIONARY function reads a JSON file from a specified path,
    ...    converts the JSON data into a Python dictionary and logs the data in the test log.
    ...    This function is useful for reading JSON files that contain test data or test
    ...    configurations.
    ...    
    ...    Arguments:
    ...    ${path_json} (str): The path of the JSON file to read.
    ...    
    ...    Behavior:
    ...    1. Use the utils.get_value_from_json function to read the JSON file from ${path_json} 
    ...    and convert the JSON data into a Python dictionary.
    ...    2. Log the dictionary in the test log.
    ...    3. Return the dictionary.
    ...    
    ...    Usage example :
    ...    ${data} = EXTRACT JSON TO DICTIONARY    /path/to/data.json

    [Arguments]    ${path_json}

    ${data}    utils.get_value_from_json    ${path_json}
    Log    ${data}

    [Return]    ${data}

GET INDEX OF ELEMENT
    [Documentation]
    ...    The GET INDEX OF ELEMENT function finds the index of a specific element in a list. 
    ...    If the element is not found in the list, the function fails with an error message.
    ...    This function is useful when you need to find the position of a specific element in a list.
    ...    
    ...    Arguments:
    ...    @{list} (list): The list to search in.
    ...    ${element} (various types): The element to search for in the list.
    ...    
    ...    Behavior:
    ...    1. Initialize a return variable to empty.
    ...    2. Iterate over each element in the list with its index.
    ...    3. Compare each element in the list with ${element}.
    ...    4. If a list element is equal to ${element}, set the return variable to the index of this element 
    ...    and return this index.
    ...    5. If no list element is equal to ${element}, fail with the message "The element is not in the list."
    ...    
    ...    Usage example :
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