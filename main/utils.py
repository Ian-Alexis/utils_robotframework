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


def fill_data(name, type, data, page):
    base_xpath = "//label[contains(text(), '{}')]".format(name)
    if type == "scrolling menu":
        full_xpath = "/following-sibling::div"
        option = "//li/a/span[contains(text(), '{}')]".format(data)
        page.wait_for_selector(base_xpath + full_xpath).click()
        page.wait_for_selector(option).click()
    else:
        if type == 'input':
            full_xpath = "/following-sibling::input[1]"
        elif type == 'textarea':
            full_xpath = "/following-sibling::textarea[1]"
        page.wait_for_selector(base_xpath + full_xpath).fill(data)
    return True


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
        page.get_by_role("cell", name=name, exact=True).click(timeout=1000)
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
    print(headers)
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

def test_whole_tab(page, tab, test=None):
    # extract json file
    with open("data/{}.json".format(tab), "r", encoding="utf-8") as file:
        data_tab = json.load(file)
    # extract name of column
    page.wait_for_selector('//thead[@class="table-dark"]')
    headers = page.query_selector_all('th')
    # find all span
    headers_data = []
    for header in headers:
        headers_data.append(header.text_content().strip())
    headers_data.pop(0)
    print(headers_data)
    for header in headers_data:
        unfiltered = get_column_content(page,header)
        unfiltered.sort()
        print("\n",unfiltered)
        page.get_by_role("columnheader", name=header).get_by_role("img").click()
        filtered = get_column_content(page,header)
        print(filtered,"\n")
        if filtered == unfiltered:
            print(header,"filter works correctly")
        else:
            print(header,"filter doesn't work")    
    for header in headers_data:
        search = data_tab[header]
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

def get_header(page):
    page.wait_for_selector('//thead[@class="table-dark"]')
    headers = page.query_selector_all('th')
    headers_data = []
    for header in headers:
        headers_data.append(header.text_content().strip())
    headers_data.pop(0)
    return headers_data