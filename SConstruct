import os
import sys
import rtconfig


if os.getenv('RTT_ROOT'):
    RTT_ROOT = os.getenv('RTT_ROOT')
else:
    #RTT_ROOT = os.path.normpath(os.getcwd() + '/../..')
    RTT_ROOT = rtconfig.DEFAULT_RTT_ROOT
    print 'set default RTT_ROOT is ' + rtconfig.DEFAULT_RTT_ROOT

sys.path = sys.path + [os.path.join(RTT_ROOT, 'tools')]
from building import *

TARGET = rtconfig.TARGET_NAME+ '.' + rtconfig.TARGET_EXT


BUILD=ARGUMENTS.get('BUILD','debug')

if os.getenv('BUILD'):
	rtconfig.BUILD = os.getenv('BUILD')

else:
	if BUILD == '':
		rtconfig.BUILD = 'debug'
	else:
		rtconfig.BUILD = BUILD

if rtconfig.PLATFORM == 'gcc':
    if rtconfig.BUILD == 'debug':
        rtconfig.CFLAGS += ' -O0 -gdwarf-2'
        rtconfig.AFLAGS += ' -gdwarf-2'
    else:
        rtconfig.CFLAGS += ' -O2'

elif rtconfig.PLATFORM == 'armcc':
    if rtconfig.BUILD == 'debug':
        rtconfig.CFLAGS += ' -g -O0'
        rtconfig.AFLAGS += ' -g'
    else:
        rtconfig.CFLAGS += ' -O2'



env = Environment(tools = ['mingw'],
	AS = rtconfig.AS, ASFLAGS = rtconfig.AFLAGS,
	CC = rtconfig.CC, CCFLAGS = rtconfig.CFLAGS,
	AR = rtconfig.AR, ARFLAGS = '-rc',
	LINK = rtconfig.LINK, LINKFLAGS = rtconfig.LFLAGS)
env.PrependENVPath('PATH', rtconfig.EXEC_PATH)

if rtconfig.PLATFORM == 'iar':
	env.Replace(CCCOM = ['$CC $CCFLAGS $CPPFLAGS $_CPPDEFFLAGS $_CPPINCFLAGS -o $TARGET $SOURCES'])
	env.Replace(ARFLAGS = [''])
	env.Replace(LINKCOM = ['$LINK $SOURCES $LINKFLAGS -o $TARGET --map project.map'])

Export('RTT_ROOT')
Export('rtconfig')

# prepare building environment
objs = PrepareBuilding(env, RTT_ROOT)

# STM32 firemare library building script
objs = objs + SConscript( GetCurrentDir() + '/Libraries/SConscript', variant_dir='build/bsp/Libraries', duplicate=0)

if GetDepend('RT_USING_RTGUI'):
    objs = objs + SConscript(RTT_ROOT + '/examples/gui/SConscript', variant_dir='build/examples/gui', duplicate=0)

# build program
env.Program(TARGET, objs)

# end building
EndBuilding(TARGET)
