This is an early attempt at automating the migration of older redmine databases and SVN repositories to a new server and more recent version

The source_machine code (redmine_dump.sh) should be run on the old machine and the target_machine code (redmine_load.sh) should be run on the new machine.

redmine_load.sh is untested, use at your own risk - if you are trying to migrate into existing databases and repositories, this may break things.  Make sure you have a complete backup before attempting to run.
