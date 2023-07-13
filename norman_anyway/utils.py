import json


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


def fill_data(name, type, data):
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
    # element = page.wait_for_selector("//tbody/tr[2]")
    # el = element.get_attribute("wire:key")
    # print(el)
    try:
        page.get_by_role("cell", name=name, exact=True).click(timeout=1000)
        page.get_by_role("button", name="").click()
        page.get_by_role("button", name="Confirmer").click()
        page.get_by_role("button", name="OK").click()
    except:
        print("Don't find")


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


def exctract_from_json(name):
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
