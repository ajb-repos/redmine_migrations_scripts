#!/bin/bash

# Script to run on new machine to load sql database and SVN repositories

# Use the redmine bash - comment this out if not using the Bitnami Redmine stack
./srv/use_redmine.sh

# Database credentials and options
user=""
password=""
db_name=""
name=""
backup_path=""
backup_name=""

# Import the redmine database backup
mysql --user=$user --password=$password $db_name < "$backup_path/$backup_name.sql"

# Migrate database
redmine_path=""
cd $redmine_path
ruby bin/rake db:migrate RAILS_ENV=production

# Migrate plugins
rake redmine:plugins:migrate RAILS_ENV=production

# Load SVN repos
cd "$backup_path"
for f in *; do
    test -d "$f" && svnadmin load "$f" > "$backup_path/$f"
done

# Restart the bitnami stack
./srv/ctlscript.sh restart

# Exit the redmine bash
exit
