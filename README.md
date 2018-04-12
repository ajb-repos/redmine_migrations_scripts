This is an early attempt at automating the migration of older redmine databases and SVN repositories to a new server and more recent version

The source_machine code (redmine_dump.sh) should be run on the old machine and the target_machine code (redmine_load.sh) should be run on the new machine.  Make sure to set the backup folders on your target machine to be writeable if you want to use scp to move everything over.

redmine_load.sh should run successfully on a pre-existing redmine install, but gets around overwriting subversion repositories by removing and loading them in from scratch.  This may take significant time on larger repos.
