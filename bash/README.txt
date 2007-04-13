This directory contains a bunch of files related to the GNU bash shell.

profile.bash and rc.bash are meant to be "global" profiles that apply equally
    to all machines.
They add common-denominator aliases, functions, and make sure that ~/sw/bin
    can be located in the PATH. They also provide for easy machine-
    specific customizations. Such customizations should go in the local
    subdirectory, under these filenames:

            ~/sw/local/paths.bash
            ~/sw/local/profile.bash
            ~/sw/local/rc.bash

The bash_completion files are responsible for setting up smart programmable
    completion for versions of bash later than 2.05b. The bash_completion.d
    directory holds customized completion scripts.
