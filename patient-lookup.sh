#!/bin/bash
# Usage: Bash Shell Script used to open downloaded patient records from defunct Eye Care Connect system
# Author: David Lu
# -------------------------------------------------

# Define the HTML file path
input_html_file=""C:/Users/daves/Downloads/arch_3222/index_3222.html"" # Replace 'your_file.html' with the actual path to your HTML file
output_html_file="C:/Users/daves/Downloads/arch_3222/filtered_records.html" # Output file path

# Create the initial structure of the new HTML file
echo "<html><head><title>Filtered Records</title></head><body>" > "$output_html_file"
echo "<h1>Filtered Records</h1>" >> "$output_html_file"
echo "<table border=1>" >> "$output_html_file"
echo "<tr><th>Record ID</th><th>Last Name</th><th>First Name</th><th>Middle Initial</th><th>Date of Birth</th><th>Gender</th></tr>" >> "$output_html_file"

while true; do
    # Prompt the user to enter a last name (or partial)
    read -p "Please enter the patient's last name (or type 'exit' to quit): " last_name_input

    # Exit condition
    if [[ "$last_name_input" == "exit" ]]; then
        echo "Exiting the script."
        break
    fi

    # Construct the grep pattern for partial matching on the last name
    pattern="<tr><td><a href=\".*</a></td><td>$last_name_input.*</td><td>"

    # Search for matching records in the input HTML file
    records=$(grep -i "$pattern" "$input_html_file")

    if [[ -z "$records" ]]; then
        echo "No records found for the given last name. Please try again."
    else
        # Add the matching records to the output HTML file
        echo "$records" >> "$output_html_file"
        echo "Filtered records have been saved to $output_html_file."

        # Close the table and HTML tags
        echo "</table></body></html>" >> "$output_html_file"

        # Open the filtered records in the default browser
        start "" "$output_html_file"

        # Break the loop after finding a valid match
        break
    fi
done
