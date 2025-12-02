#!/bin/bash

###################################################################################################
# The purpose of this script is to announce when a new player joins the universe to discord.
#

export PGHOST="localhost"
export PGPORT="5432"
export PGDATABASE="app_database"
export PGUSER="db_user"
export PGPASSWORD="your_password"

# Set your Discord webhook URL here
WEBHOOK_URL="https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"

#Set Last Known User
last_user=""

# Loop through for new players:
while true; do
	# Collect the most recent user information
	id=$(psql -d app_database -U db_user -t -c "select id from users order by id desc limit 1;")
	name=$(psql -d app_database -U db_user -t -c "select name from users order by id desc limit 1;")
	
	# Determine if this is the most recent user
	if [[ $id > $last_user ]]; then
		 
		# Configure Discord Message
        	MESSAGE="A New Player Joined The Universe! Welcome:  $name"

        	# Build the JSON payload for the webhook request
        	PAYLOAD="{\"content\":\"$MESSAGE\"}"

		# Send the webhook request using cURL
        	curl -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL"
		
		# Update last known user ID
		last_user=$id
	fi

	sleep 5
done

