
all:
	scons --max-drift=1 --implicit-deps-unchanged BUILD=$(DEBUG)

clean:
	scons -c
