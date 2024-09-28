#!/bin/bash
# Usage: Bash Shell Script used to open downloaded patient records from defunct Eye Care Connect system
# Author: David Lu
# -------------------------------------------------

# Define the HTML file path
input_html_file=""C:/Users/daves/Downloads/arch_3222/index_3222.html"" # Replace 'your_file.html' with the actual path to your HTML file
output_html_file="C:/Users/daves/Downloads/arch_3222/filtered_records.html" # Output file path

# Create a new HTML file with filtered records
echo "<html><head><title>Filtered Records</title></head><body>" > "$output_html_file"
echo "<h1>Filtered Records</h1>" >> "$output_html_file"
echo "<table border=1>" >> "$output_html_file"
echo "<tr><th>Record ID</th><th>Last Name</th><th>First Name</th><th>Middle Initial</th><th>Date of Birth</th><th>Gender</th></tr>" >> "$output_html_file"

while true; do
    # Prompt the user for search type
    read -p "Do you want to search by (L) Last Name or (F) First Name? (Enter L or F): " search_type

    # Validate input
    if [[ "$search_type" != "L" && "$search_type" != "F" ]]; then
        echo "Invalid input. Please enter L or F."
        continue
    fi

    # Prompt for the name based on search type
    if [[ "$search_type" == "L" ]]; then
        read -p "Please enter the patient's last name (or type 'exit' to quit): " name_input
    else
        read -p "Please enter the patient's first name (or type 'exit' to quit): " name_input
    fi

    # Exit condition
    if [[ "$name_input" == "exit" ]]; then
        echo "Exiting the script."
        break
    fi

    # Construct grep pattern based on search type
    if [[ "$search_type" == "L" ]]; then
        pattern="<tr><td><a href=\".*</a></td><td>$name_input.*</td><td>"
    else
        pattern="<tr><td><a href=\".*</a></td><td>.*</td><td>$name_input.*</td><td>"
    fi

    # Search for the records with the matching name
    records=$(grep -i "$pattern" "$input_html_file")

    if [[ -z "$records" ]]; then
        echo "No records found for the given name. Please try again."
    else
        # Add matching records to the output HTML file
        echo "$records" >> "$output_html_file"
        echo "Filtered records have been saved to $output_html_file."
        
        # Close the table and HTML tags
        echo "</table></body></html>" >> "$output_html_file"
        
        # Open the filtered records in the default browser
        start "" "$output_html_file"
        
        # Break after processing a valid search
        break
    fi
done