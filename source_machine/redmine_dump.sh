#!/bin/bash

# Script to run on old machine to create sql and SVN repository dumps

# Database credentials and redmine backup options
user=""
password=""
db_name=""
backup_path="/path/to/backups"

# Create directory for backups if it doesn't exist
mkdir -p $backup_path

# Dump the redmine sql database.  "-t --insert-ignore --skip-opt" should create a dump with no DROP TABLE or CREATE TABLE and all INSERT changed to INSERT-IGNORE.  This should allow it to be merged with tictac's sql database.
mysqldump -t --insert-ignore --skip-opt --user=$user --password=$password $db_name > $backup_path/$db_name-backup.sql

# SVN backup options
svnBackup_path="/path/to/backups/svn_backup"
REPO_BASE="/path/to/repos"

# Create directory for SVN repository backups if it doesn't exist (and ignore errors if it does)
mkdir -p $svnBackup_path

# Dump all SVN repositories
cd "$REPO_BASE"
for f in *; do
    test -d "$f" && svnadmin dump "$f" > "$svnBackup_path/$f.dump"
done

# SCP options - change username as needed
scpUSER=""
remoteSERVER=""

# Copy backups to tictac - will require user password input - could(should) probably be done with keys instead?
scp -r $backup_path $scpUSER@$remoteSERVER:/destination/path
