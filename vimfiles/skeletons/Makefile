default: build

CMAKE_DIR = _obj
ifdef WINDIR
	# Running on Windows...
	CMAKE_NAME = "MSYS Makefiles"
else
	# Linux or OS X, presumably
	CMAKE_NAME = "Unix Makefiles"
endif

${CMAKE_DIR}:
	mkdir ${CMAKE_DIR} 

${CMAKE_DIR}/Makefile: ${CMAKE_DIR}
	cd ${CMAKE_DIR} ; cmake .. -G ${CMAKE_NAME}

build: ${CMAKE_DIR}/Makefile
	cd ${CMAKE_DIR} ; make

clean:
	rm *~
