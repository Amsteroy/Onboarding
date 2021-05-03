import subprocess
from elements import Utils


def filter_rearrange(programs):
    manual_installation = []
    for program in programs:
        if 'Install_Path' in program:
            if program['Command_For_Installation'] == '{}':
                manual_installation.append(program)
                programs.remove(program)
        else:
            programs.remove(program)

    return programs + manual_installation


def install(programs):
    programs = filter_rearrange(programs)
    for program in programs:
        subprocess.call(program['Command_For_Installation']
                        .format(program['Install_Path']), shell=True)
        print(program['Name'] + ' Is installed!')
