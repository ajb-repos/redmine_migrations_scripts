#!/bin/bash

# Script to run on new machine to load sql database and SVN repositories

# Use the redmine bash - comment this out if not using the Bitnami Redmine stack
/srv/use_redmine.sh

# Database credentials and options
user=""
password=""
db_name=""
backup_path=""
backup_name=""

# Import the redmine database backup
mysql --user=$user --password=$password $db_name < $backup_path/$backup_name.sql

# Migrate database
redmine_path=""
cd $redmine_path
bundle exec ruby bin/rake db:migrate RAILS_ENV=production

# Migrate plugins
bundle exec rake redmine:plugins:migrate RAILS_ENV=production

# SVN variables
svnBackup_path="$backup_path/svn_repos"
svnDump=$svnBackup_path/*.dump

# Load SVN repos
cd "$svnBackup_path"
for svnDump in *; do
    svnDump_name=${svnDump##/*/}
    repo_name=$(echo $svnDump_name | cut -f 1 -d '.')
    rm -r "/path/to/repos/$repo_name"
    svnadmin create "path/to/repos/$repo_name"
    svnadmin load "$repo_name" < "$backup_path/$svnDump_name"
done

# Restart the bitnami stack
/srv/ctlscript.sh restart

# Exit the redmine bash
exit
