# This Bash script completely removes Splunk from a system, including its installation, user account, and all related files.

## 🛠 Installation Instructions:
**1️⃣** Open the remove_splunk.sh script file using any text editor.

**2️⃣** Copy all the script content.

**3️⃣** On your server, use a text editor (nano or vi) and paste the script.

**4️⃣** Save the file and exit the editor.

## 🔐 Grant Execution Permissions:
After creating the script, run the following command to make it executable:
```sh
sudo chmod +x remove_splunk.sh
```

### 🚀 Run the Uninstall script
```sh
sudo ./remove_splunk.sh
```
##### 📌 Note:
_**./** means you are running the script from the current directory. If you are not in the current directory, use the full path to the script instead_

_🔑 Using sudo ensures proper permissions for installation!_

_👤 If you're not using the root user, you'll need sudo to perform administrative actions during installation_


## 📜 What’s Inside the Installation Script?
🔹 Step-by-Step Breakdown

### 1️⃣ Stop the Splunk Service
```bash
if [ -f "/opt/splunk/bin/splunk" ]; then
    sudo /opt/splunk/bin/splunk stop --answer-yes --accept-license
```
✔️ If the Splunk binary exists at /opt/splunk/bin/splunk, it stops the Splunk service.

✔️ --answer-yes --accept-license prevents interactive prompts.

✔️ If Splunk isn’t found, it prints "Splunk service not found or already removed."

### 2️⃣ Remove Splunk Installation Directory
```bash
sudo rm -rf /opt/splunk
```
✔️ Deletes the entire Splunk installation directory (/opt/splunk)

✔️ rm -rf ensures forced deletion without confirmation.

### 3️⃣ Stop All Running Processes for the Splunk User
```bash
if id "splunk" &>/dev/null; then
    sudo pkill -u splunk || echo "No running processes for Splunk user."
```
✔️ Checks if the splunk user exists using id "splunk".

✔️ If found, kills all processes owned by splunk using pkill -u splunk.

✔️ If no processes exist, it prints "No running processes for Splunk user."

### 4️⃣ Remove Splunk User’s Home Directory
```bash
if [ -d "/home/splunk" ]; then
    sudo rm -rf /home/splunk
```
✔️ If /home/splunk exists, it gets deleted.

✔️ If already removed, it prints "Splunk home directory already removed."

### 5️⃣ Remove Splunk Group
```bash
if getent group splunk > /dev/null; then
    sudo groupdel splunk
```
✔️ Checks if the splunk group exists.

✔️ If found, deletes it using groupdel splunk.

**&>/dev/null:**

Redirects both stdout (standard output) and stderr (error output) to /dev/null, which hides any output.
This prevents unnecessary messages from being displayed on the terminal.

### 6️⃣ Remove Splunk User from System Files
```bash
sudo sed -i '/^splunk:/d' /etc/passwd
sudo sed -i '/^splunk:/d' /etc/group
```
✔️ Uses sed to remove any Splunk-related entries from:
- /etc/passwd (user accounts)
- /etc/group (groups)

####  Breakdown:
##### 1️⃣ sed (Stream Editor)
sed is used to edit text files by searching, modifying, and deleting lines.

##### 2️⃣ -i (In-Place Editing)
This flag modifies the file directly instead of outputting the changes to the terminal.

##### 3️⃣ '/^splunk:/d' (Delete Matching Lines)
/^splunk:/ → Matches any line that starts with "splunk:" (^ means start of line).
"d" → Deletes the matched line.

##### 4️⃣ /etc/passwd
The system file where user account information is stored.

###### Example:
Before (/etc/passwd contains "splunk"):
```bash
splunk:x:1001:1001::/home/splunk:/bin/bash
```

### 7️⃣ Clean Up Any Remaining Splunk Files
```bash
sudo find /var/log -name "*splunk*" -exec rm -rf {} \;
sudo find /etc -name "*splunk*" -exec rm -rf {} \;
sudo find /opt -name "*splunk*" -exec rm -rf {} \;
```
✔️ Searches and deletes any leftover Splunk-related files in:
- /var/log (log files)
- /etc (configuration files)
- /opt (other system directories)

#### 🔹 Explanation of the find Commands
These commands search for and delete all Splunk-related files in the specified directories (/var/log, /etc, /opt).

##### Breakdown:
###### 1️⃣ find /var/log -name "*splunk*"
- find /var/log → Search inside /var/log.
- -name "*splunk*" → Match files/folders containing "splunk" in their names.
- -exec rm -rf {} \; → Delete each found file/folder recursively.

The **\;** is used to terminate the -exec command in a find command.

###### 2️⃣ find /etc -name "*splunk*"
- Looks for Splunk-related config files in /etc (where system settings are stored).
- Deletes them permanently.

###### 3️⃣ find /opt -name "*splunk*"
- Searches for Splunk installation files in /opt (common for third-party apps).
- Deletes all Splunk-related files and directories.

###### 🔹 How It Works:
The -exec option in the find command allows you to execute a command on each file or directory that matches the search criteria.
- find ... -exec rm -rf {} \;
- -exec → Runs a command on each found file/folder.
- rm -rf {} → Deletes (rm) the found item:
- -r → Recursively (for directories).
- -f → Force delete (without confirmation).
- {} → Represents each found file/folder.
- \; → Ends the -exec command.

#### 8️⃣ Verify and Confirm Removal
```bash
if id "splunk" &>/dev/null; then
    echo "Failed to remove Splunk user. Please check manually."
else
    echo "Splunk user removed successfully."
fi
```
✔️ Checks if the splunk user still exists.

✔️ If deleted, it prints "Splunk user removed successfully."

✔️ Similar checks are done for /opt/splunk and /home/splunk to confirm complete removal.

#### ✅ Final Outcome
✔️ Splunk is completely uninstalled from the system.

✔️ No traces of Splunk remain, including logs, users, and configuration files.

✔️ System is ready for a fresh Splunk installation if needed.


## 🚀 Simplifying Splunk Unstallation for the Architect Class
Since we are installing multiple Splunk instances for the architect class, I have designed a Bash script to streamline the process and speed up our work.  

If you encounter any issues while using it, please let me know. I'm happy to help! 😊  

#### 💬 **Share Your Views!**  
Join the discussion on the repository to share feedback and suggestions for improvement.  

#### 🔧 **Want to Contribute?**  
You can **fork** the repository, modify the script, and send a **pull request** to enhance it! 🚀  

Thank you for your support! 🙌  

