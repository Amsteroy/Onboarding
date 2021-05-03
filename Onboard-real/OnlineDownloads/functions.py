import os
import os.path
import platform
import time

from elements import OS_Paths, Utils
from OnlineDownloads.directorylistener import Watcher, Handler


def bit_os():
    # Returns the system type - x-bit os
    return 'x' + platform.machine()[-2:]


def downloads_files():
    # Number of files in Downloads Directory
    return os.listdir(OS_Paths.DOWNLOADS_DIRECTORY)


def checkdownloadstart(name):
    counter = 0
    # Checks if the download of the program has begun - waits 20 seconds
    while not Handler.created:
        time.sleep(1)
        counter += 1
        if counter > 20:
            Utils.not_downloaded.append(name)
            return False
    Handler.created = False
    return True


def checkdownloadfinished(name):
    counter = 0
    # Checks if the download of the program has begun - waits 15 minutes
    while not Handler.downloaded:
        time.sleep(1)
        counter += 1
        if counter > 900:
            Utils.not_downloaded.append(name)
            return False
    Handler.downloaded = False
    return True


def check_all_download_process(name):
    created = checkdownloadstart(name)

    if created:
        downloaded = checkdownloadfinished(name)

    if created and downloaded:
        return True


def checkdownloaded():
    listener = Watcher(OS_Paths.DOWNLOADS_DIRECTORY)
    listener.run()


def overall():
    if len(Utils.not_downloaded) == 0 and len(Utils.installation_errors) == 0:
        print('Success! All Programs fully installed')

    else:
        print('Program finished with these errors:')
        for program in Utils.not_downloaded:
            print(program + ' Not Downloaded')
        for program in Utils.installation_errors:
            print(program + ' Not Installed')


# Filters the data needed for each employee & computer
def filter_for_employee(employee_division, program):
    # System type
    bit = bit_os()

    adapted_program = {}
    if employee_division in program['Division'] or program[
        'Division'] == 'Everyone':  # If program can be used for more then 1 division
        adapted_program['Name'] = program['Name']
        if 'Attribute' in program:
            adapted_program['Attribute'] = program['Attribute']
            if ('Attribute_Value' + bit) in program:
                adapted_program['Attribute_Value'] = program['Attribute_Value' + bit]
            else:
                adapted_program['Attribute_Value'] = program['Attribute_Value']
        if ('Url' + bit) in program:
            adapted_program['Url'] = program['Url' + bit]
        else:
            adapted_program['Url'] = program['Url']
        adapted_program['Division'] = program['Division']
        adapted_program['Command_For_Installation'] = program['Command_For_Installation']

        return adapted_program
