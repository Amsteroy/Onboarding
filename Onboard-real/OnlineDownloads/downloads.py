import json
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from OnlineDownloads.functions import *
from elements import ChromeConfig, Locator_convertion, Utils
from Installations.install import install

driver = webdriver.Chrome(chrome_options=ChromeConfig.chromeOptions)


# Returns a specific dictionary - contains only the programs and data adjusted for the employee
def programs(employee_division):
    employee_programs = []

    with open('configuration.json') as download_configuration:
        data = json.load(download_configuration)
        for program in data['programs']:
            adapted_program = filter_for_employee(employee_division, program)
            employee_programs.append(adapted_program)

    return employee_programs


def download(adjusted_programs):
    print("Starting Download...")

    for program in adjusted_programs:
        driver.get(program['Url'])
        if 'Attribute' in program:
            try:
                locator = Locator_convertion.locator[program['Attribute']]
                element = EC.presence_of_element_located((locator, program['Attribute_Value']))
                WebDriverWait(driver, 15).until(element).click()

            except Exception as e:
                print("%s:    " % program['Name'] + str(e))

        downloaded = check_all_download_process(program['Name'])
        if downloaded:
            program['Install_Path'] = Utils.installation_paths[-1]

    Watcher.done = True
    driver.quit()
    return adjusted_programs
