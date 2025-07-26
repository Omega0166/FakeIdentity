Fake Identity Generator
Overview
The Fake Identity Generator is a Bash script designed to create, manage, and display fake identities for testing or research purposes. It generates random names, email addresses (via the mail.tm API), phone numbers (via receive-smss.com), and addresses (from a local addresses.txt file). Identities are stored in a CSV file and can be listed, modified, deleted, or selected for further operations, such as viewing emails or SMS messages.
Important: This tool is intended for legal and ethical use only, such as testing applications or conducting authorized research. Misuse, including generating identities for fraudulent or illegal purposes, may violate laws and terms of service of the APIs used. The author is not responsible for misuse.
Features

Create Identities: Generate new identities with random names, emails, phone numbers, and addresses.
List Identities: Display all stored identities in a formatted table.
Modify Identities: Update specific fields (name, email, phone, address) of an existing identity.
Delete Identities: Remove identities by ID.
Select Identities: View details, check email inbox (via mail.tm), or retrieve SMS messages (via receive-smss.com).
Dependency Management: Automatically checks and installs required dependencies (curl, jq) on Debian/Ubuntu systems.
User-Friendly Interface: Color-coded menus and prompts for easy navigation.

Prerequisites

Operating System: Linux (tested on Debian/Ubuntu; other distributions may require manual dependency installation).
Root Privileges: The script requires sudo to write to /etc/FakeIdentity/ and install dependencies.
Internet Connection: Needed for API calls and dependency installation.
Dependencies:
curl: For making HTTP requests to APIs.
jq: For parsing JSON responses.


Configuration File: A properly formatted addresses.txt file for address generation.

Installation

Clone or Download the Script:
git clone https://github.com/Omega0166/FakeIdentity.git
cd FakeIdentity


Make the Script Executable:
chmod +x FakeIdentity.sh

Run the Script:
sudo ./fake_identity.sh


The script requires sudo to create /etc/FakeIdentity/ and install dependencies.
It will automatically check and install curl and jq on Debian/Ubuntu systems if missing.



Usage
The script presents an interactive menu with the following commands:

h (Help): Display the command list.
c (Create): Generate and save a new identity.
Prompts for a phone number prefix (country selection).
Generates random name, email, phone number, and address.


l (List): Show all stored identities in a table (ID, Name, Email, Phone, Address).
m (Modify): Update an existing identity.
Prompt for ID and field to modify (Name, Email, Phone, Address).


d (Delete): Remove an identity by ID.
s (Select): Select an identity for detailed operations.
Sub-commands:
h: Show help menu.
ml: Display last 5 email messages (via mail.tm).
ms: Display last 5 SMS messages (via receive-smss.com).
i: Show identity details.
d: Delete the current identity.
ch: Change to a different identity.
cl: Clear the screen.
q: Return to the main menu.




cl (Clear): Clear the screen.
q (Quit): Exit the program.

Example Workflow

Start the script:sudo ./fake_identity.sh


Create a new identity:
Type c and press Enter.
Select a country prefix for the phone number (e.g., 1 for USA).
The script generates and saves the identity.


List identities:
Type l to view all identities.


Modify an identity:
Type m, enter an ID, and choose a field to update (e.g., 1 for Name).


Select an identity:
Type s, enter an ID, and use sub-commands (e.g., ml to check emails).


Exit:
Type q to quit.



Configuration

Storage Location: Identities are stored in /etc/FakeIdentity/identities.csv.
CSV Format: id,name,gmail,token,phone,addres
Note: Addresses with commas may cause parsing issues. Consider quoting fields if needed.


Addresses File: Ensure addresses.txt is correctly formatted and placed in the script's directory.
Temporary Files: Phone number data is temporarily stored in /tmp/numbers.txt.

Troubleshooting

Dependency Installation Fails:
Ensure internet connectivity.
Check /var/log/apt/ for errors.
Manually install dependencies:sudo apt update
sudo apt install curl jq




API Errors:
If randomuser.me, mail.tm, or receive-smss.com fail, check your internet connection or API availability.
APIs may have rate limits; retry after a delay.


Addresses Not Found:
Verify that addresses.txt exists and matches country names from receive-smss.com.


Permission Denied:
Run the script with sudo.


CSV Parsing Issues:
If addresses contain commas, modify the script to quote CSV fields (see Development Notes).



Development Notes

Dependencies: The script uses curl for HTTP requests and jq for JSON parsing.
API Usage:
Names: randomuser.me (Mexican nationality).
Emails: mail.tm.
Phone Numbers: receive-smss.com.


Limitations:
Only supports apt for automatic dependency installation (Debian/Ubuntu).
CSV fields are not quoted, which may break parsing for comma-containing addresses.
Recursive ch command in select menu may cause stack overflow with heavy use.


Improvements Needed:
Quote CSV fields to handle commas in addresses.
Add support for other package managers (dnf, yum, pacman).
Implement retry logic for API failures.
Verify sudo privileges before installation attempts.



Contributing
Contributions are welcome! Please submit pull requests or issues to the repository. Suggested improvements:

Enhance CSV parsing for complex addresses.
Add support for additional package managers.
Implement error handling for API rate limits.
Localize messages (e.g., Spanish option).

Legal and Ethical Notice
This tool is provided for educational and testing purposes only. Generating fake identities for illegal activities, fraud, or violating API terms of service is strictly prohibited. Users are responsible for ensuring compliance with local laws and regulations. The author disclaims liability for any misuse.
Credits

Author: RussianBoy
APIs Used: randomuser.me, mail.tm, receive-smss.com
License: MIT License (or specify your preferred license)
