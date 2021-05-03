import sys
from threading import Thread
from OnlineDownloads.downloads import *

if __name__ == '__main__':

    try:
        # Receives it from the powershell
        employee_division = str(sys.argv[1])
    except:
        employee_division = input("Please enter the employee's Department ")

    employee_programs = programs(employee_division)
    # Only checks if downloaded completely
    thr = Thread(target=checkdownloaded, daemon=True)
    thr.start()
    employee_programs = download(employee_programs)
    thr.join()
    install(employee_programs)
    overall()
