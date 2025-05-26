#!/bin/bash

# Prompt user for the domain name
echo -n "Enter the domain (e.g., example.com): "
read domain

# Validate user input
if [[ -z "$domain" ]]; then
    echo "Error: Domain cannot be empty. Exiting."
    exit 1
fi

# Define final output file based on the domain
final_output_file="${domain}_filtered.txt"
temp_file="/tmp/${domain}_temp.txt"
confidential_output_file="${domain}_confidential.txt"

# Function to handle SIGINT (Ctrl+C)
function handle_sigint() {
    if [[ -f "$temp_file" ]]; then
        echo "\nProcessing collected data..."
        pkill -P $$  # Kill background processes started by the script
        cat "$temp_file" | uro | grep -E "\\.xls|\\.xml|\\.xlsx|\\.json|\\.pdf|\\.sql|\\.doc|\\.docx|\\.pptx|\\.txt|\\.zip|\\.tar\\.gz|\\.tgz|\\.bak|\\.7z|\\.rar|\\.log|\\.cache|\\.secret|\\.db|\\.backup|\\.yml|\\.gz|\\.config|\\.csv|\\.yaml|\\.md|\\.md5|\\.exe|\\.dll|\\.bin|\\.ini|\\.bat|\\.sh|\\.tar|\\.deb|\\.rpm|\\.iso|\\.img|\\.apk|\\.msi|\\.dmg|\\.tmp|\\.crt|\\.pem|\\.key|\\.pub|\\.asc|\\.js" > "$final_output_file"
        echo "Filtered results saved in $final_output_file"
        rm -f "$temp_file"
        
        echo "\nChecking for confidential data..."
        found_confidential=false
        cat "$final_output_file" | grep -Ea '\\.pdf' | while read -r url; do
            if curl -s "$url" | pdftotext - - | grep -Eai '(internal use only|confidential|strictly private|personal & confidential|private|restricted|internal|not for distribution|do not share|proprietary|trade secret|classified|sensitive|bank statement|invoice|salary|contract|agreement|non disclosure|passport|social security|ssn|date of birth|credit card|identity|id number|company confidential|staff only|management only|internal only)'; then
                echo "$url" >> "$confidential_output_file"
                found_confidential=true
            fi
        done
        
        if [[ "$found_confidential" == false ]]; then
            echo "No confidential data found."
        else
            echo "Confidential data URLs saved in $confidential_output_file"
        fi
        exit 0
    else
        echo "\nDownload stopped. Exiting..."
        pkill -P $$  # Kill background processes started by the script
        exit 1
    fi
}

# Trap Ctrl+C to execute handle_sigint
trap handle_sigint SIGINT

# Start fetching data in the foreground so it can be stopped by Ctrl+C
curl -G "https://web.archive.org/cdx/search/cdx" \
     --data-urlencode "url=*.$domain/*" \
     --data-urlencode "collapse=urlkey" \
     --data-urlencode "output=text" \
     --data-urlencode "fl=original" -o "$temp_file" &

# Store process ID of curl
curl_pid=$!

# Wait for the process to complete
wait $curl_pid
