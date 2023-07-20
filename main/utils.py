import json
import time

def connect_to_anyway(PS):
    # playwright=sync_playwright().start()
    url = "https://anyway.qal.covage.com/"
    # setup test
    browser = PS.chromium.launch(headless=False)
    context = browser.new_context()
    context.tracing.start(screenshots=True, snapshots=True, sources=True)
    global page
    page = context.new_page()
    # go to anyway
    page.goto(url)
    return page


def fill_data(name, element_type, data, page, check=False):
    base_xpath = "//label[contains(text(), '{}')]".format(name)
    if element_type == "scrolling menu":
        full_xpath = "/following-sibling::div"
        option = "//li/a/span[contains(text(), '{}')]".format(data)
        page.wait_for_selector(base_xpath + full_xpath).click()
        page.wait_for_selector(option).click()
    else:
        if element_type == 'input':
            full_xpath = "/following-sibling::input[1]"
        elif element_type == 'textarea':
            full_xpath = "/following-sibling::textarea[1]"
        page.wait_for_selector(base_xpath + full_xpath).fill(data)
    if check:
        check_data(name, base_xpath + full_xpath, element_type, data, page)
    return True

def check_data(name, xpath, element_type, data, page):
    print("\n\n")
    if element_type != "scrolling menu":
        content_text = str(page.query_selector(xpath).get_property('value'))
    else : 
        xpath_adding = "/button"
        content_text = str(page.query_selector(xpath+xpath_adding).get_attribute('title'))
        print(xpath+xpath_adding)
        print(content_text)
    if data == content_text:
        print("The {} {} is well filled".format(element_type, name))
    else : 
        print("The {} {} is not well filled".format(element_type, name))

def erase_el(name, page):
    page.locator("#table-filter-name").click()
    page.locator("#table-filter-name").fill(name)
    time.sleep(1)
    success = False
    results_data = get_column_content(page, "Nom")
    print(results_data)
    for result in results_data:
        if result == name:
            success = True
    if success:
        page.get_by_role("cell", name=name, exact=True).click()
        page.get_by_role("button", name="").click()
        page.get_by_role("button", name="Confirmer").click()
        page.get_by_role("button", name="OK").click()
        print("Element {} found in order to erase".format(name))
    else: 
        print("Element {} not found in order to erase".format(name))

def filter_search(page, data):
    # extract name of column
    page.wait_for_selector('//thead[@class="table-dark"]')
    headers = page.query_selector_all('th')
    headers_data = []
    for header in headers:
        headers_data.append(header.text_content().strip())
    headers_data.pop(0)
    # search in data the value correspond to name of column
    for header in headers_data:
        search = data[header]
        index = find_index(headers_data, header) + 2
        xpath = '//tbody/tr/td[position()={}]/div'.format(index)
        element = page.wait_for_selector(xpath)
        page.click(xpath)
        try:
            if "input-group" in element.get_attribute("class"):
                el = "/input"
                xpath_input = '//tbody/tr/td[position()={}]/div{}'.format(index, el)
                element_input = page.wait_for_selector(xpath_input)
                element_input.fill(search)
        except:
            option = '//li/a/span[contains(text(),"{}")]'.format(search)
            page.click(option)


def extract_from_json(name):
    # extract tabs json file
    with open("{}.json".format(name), "r", encoding="utf-8") as file:
        data = json.load(file)
    return data


def find_index(liste, el):
    index = 0
    for i, element in enumerate(liste):
        if element == el:
            index = i
    return index

def get_column_index(page, column_name):
    time.sleep(0.5)
    headers = get_header(page)
    # Find the column index by its name
    for i, header in enumerate(headers):
        if header == column_name:
            return i+1
    return False

def get_column_content(page, column_name, lower=False):
    column_index = get_column_index(page, column_name)
    if not column_index:
        print("L'indice n'a pas été trouvé")
        return []
    # Get the column content
    rows = page.query_selector_all('tr')
    rows.pop(0) # On enlève le header 
    column_content = []
    for row in rows:
        cells = row.query_selector_all('td')
        if len(cells) > 1:
            if lower:
                column_content.append(cells[column_index].text_content().strip().lower())
            else: 
                column_content.append(cells[column_index].text_content().strip())
    column_content_clean = [element.replace('\n','') for element in column_content]
    column_content_clean.pop(0) # On enlève l'élément provenant du bandeau rechercher
    return column_content_clean

def test_filter(page, data, test=None):
    # extract name of column
    headers = get_header(page)
    for header in headers:
        unfiltered = get_column_content(page,header, lower=True)
        if header == "Débit":
            unfiltered = custom_sort_key(unfiltered)
        else :
            unfiltered.sort()
        # print(unfiltered)
        page.get_by_role("columnheader", name=header).get_by_role("img").click()
        filtered = get_column_content(page,header, lower=True)
        # print(filtered)
        if filtered == unfiltered:
            print("{} filter works correctly".format(header))
        else:
            print("{} filter doesn't work".format(header)) 
        # print("\n\n")  

def test_search(page, data, test=None): 
    headers = get_header(page)
    for header in headers:
        search = data[header]
        index = find_index(headers, header) + 2
        # index  = get_column_index(page, header)
        xpath = '//tbody/tr/td[position()={}]/div'.format(index)
        element = page.wait_for_selector(xpath)
        page.click(xpath)
        var = element.query_selector('*')
        # print('Le nom de la colonne {} est associé à :\n{}'.format(header, var.text_content()))
        if var.text_content() == '':
            # if input : 
            if "input-group" in element.get_attribute("class"):
                el = "/input"
                xpath_input = '//tbody/tr/td[position()={}]/div{}'.format(index, el)
                element_input = page.wait_for_selector(xpath_input)
                element_input.fill(search)
        else:
            # print(element.query_selector('*').get_attribute('class'))
            # if scrolling menu multiple choice :
            if 'show-tick' in element.query_selector('*').get_attribute('class'):
                option = '//li/a/span[contains(text(),"{}")]'.format(search)
                page.click(option)
            # if single choice : 
            else :
                option = '//li/a/span[contains(text(),"{}")]'.format(search)
                page.click(option)

def get_header(page):
    page.wait_for_selector('//thead[@class="table-dark"]')
    headers = page.query_selector_all('th')
    headers_data = []
    for header in headers:
        headers_data.append(header.text_content().strip())
    headers_data.pop(0)
    return headers_data

def custom_sort_key(list):
    sorted = []
    sorted_ = []
    sorted_m = []
    sorted_g = []
    for debit in list:
        digits = ''.join(filter(str.isdigit, debit))
        letters = ''.join(filter(str.isalpha, debit))
        if debit == "":
            sorted_.append(debit)
        elif letters == "m":
            sorted_m.append(debit)
        else: 
            sorted_g.append(debit)
    sorted_g.sort()
    sorted_g.reverse()
    sorted_m.sort()
    sorted_m.reverse()
    sorted = sorted_+sorted_m+sorted_g
    
    return sorted

def extract_checked_element(page, checkboxes):
    checked_checkboxes = []
    for checkbox in checkboxes:
        if checkbox.is_checked():
            checked_checkboxes.append(checkbox.evaluate_handle('el => el.nextElementSibling').inner_text())
            # print("J'ai trouvé une checkbox cochée")
            # print(checkbox.evaluate_handle('el => el.nextElementSibling').inner_text())
        # else : 
            # print("J'ai trouvé une checkbox pas cochée")
    return checked_checkboxes

def test_header_filter(page, elements):
    page.wait_for_selector('//*[@id="columnSelect-table"]').click()
    checkboxes = page.query_selector_all('//div[@class="form-check ms-2"]/input[@type="checkbox"]')
    checked_checkboxes_before = extract_checked_element(page, checkboxes)
    headers_before = get_header(page)    
    check_checkboxes(page, elements)
    checked_checkboxes_after = extract_checked_element(page, checkboxes)
    headers_after = get_header(page)
    check_header_filter(elements, checked_checkboxes_before, checked_checkboxes_after, headers_before, headers_after)
    check_checkboxes(page, elements, visible=True)
    headers_after = get_header(page)
    if headers_after == checked_checkboxes_before :
        print("Checkboxes rechecked")
    else : 
        print("Checkboxes still unchecked")
    page.wait_for_selector('//*[@id="columnSelect-table"]').click()

def check_checkboxes(page, elements, visible=False):
    for element in elements :
        xpath_option = "//label[contains(text(), '{}')]/preceding-sibling::input".format(element)
        page.wait_for_selector(xpath_option).click()
        xpath_column_name = '//th/div/span[contains(text(),"{}")]'.format(element)
        page.wait_for_selector(xpath_column_name)
        element = page.query_selector(xpath_column_name)
        if visible :
            element.wait_for_element_state('visible')
        else : 
            element.wait_for_element_state('hidden')
    

def check_header_filter(elements, checked_checkboxes_before, checked_checkboxes_after, headers_before, headers_after):
    test_size = len(checked_checkboxes_before) - len(checked_checkboxes_after) == len(elements)
    if test_size : 
        test_elements = True 
        for element in elements :
            for checkbox in checked_checkboxes_after :
                if not test_elements :
                    print("{} element is still checked".format(element))
                    break
                elif element == checkbox :
                    test_elements = False
        if headers_before == checked_checkboxes_before :
            print("All filtered elements are present in the header before filtering")
        else :
            print("Missing filterd element in the header before filtering")
        if headers_after == checked_checkboxes_after :
            print("All filtered elements are present in the header after filtering")
        else : 
            print("Missing filterd element in the header after filtering")

def search_element_in_header(headers, element):
    test = False
    for header in headers:
        if header == element:
            test = True
    return test

def test_displayed_filter(page, number):
    xpath_num_page = '//*[@id="perPage"]/following-sibling::button'
    page.wait_for_selector(xpath_num_page).click()
    xpath_list_page = '{}/following-sibling::div/div[@role="listbox"]'.format(xpath_num_page)
    page.wait_for_selector(xpath_list_page)
    option = "//li/a/span[contains(text(), '{}')]".format(number)
    page.wait_for_selector(option).click()
    page.wait_for_selector('//nav/ul[@class="pagination"]')
    # time.sleep(5)
    get_rows_number(page)

def get_rows_number(page):
    all_rows = page.wait_for_selector('//tbody')
    rows = all_rows.query_selector_all('tr')
    print(len(rows)-1)