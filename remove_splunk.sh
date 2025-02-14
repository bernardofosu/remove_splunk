#!/bin/bash

# Stop Splunk Service
echo "Stopping Splunk service..."
if [ -f "/opt/splunk/bin/splunk" ]; then
    sudo /opt/splunk/bin/splunk stop --answer-yes --accept-license
else
    echo "Splunk service not found or already removed."
fi

# Remove Splunk Installation
echo "Removing Splunk installation..."
sudo rm -rf /opt/splunk

# Stop All Running Processes for Splunk User
echo "Stopping all processes for Splunk user..."
if id "splunk" &>/dev/null; then
    sudo pkill -u splunk || echo "No running processes for Splunk user."
else
    echo "Splunk user does not exist."
fi

# Manually Remove Home Directory if Still Exists
echo "Checking for remaining Splunk home directory..."
if [ -d "/home/splunk" ]; then
    echo "Removing /home/splunk manually..."
    sudo rm -rf /home/splunk
else
    echo "Splunk home directory already removed."
fi

# Remove Splunk group if it exists
echo "Removing Splunk group if it exists..."
if getent group splunk > /dev/null; then
    sudo groupdel splunk
    echo "Splunk group removed."
else
    echo "Splunk group does not exist."
fi

# Clean up /etc/passwd and /etc/group if entries remain
echo "Cleaning up user entries in /etc/passwd and /etc/group..."
sudo sed -i '/^splunk:/d' /etc/passwd
sudo sed -i '/^splunk:/d' /etc/group

# Clean Any Remaining Splunk Files (Restrict Scope)
echo "Cleaning any remaining Splunk files..."
sudo find /var/log -name "*splunk*" -exec rm -rf {} \;
sudo find /etc -name "*splunk*" -exec rm -rf {} \;
sudo find /opt -name "*splunk*" -exec rm -rf {} \;

# Verify Removal
echo "Verifying Splunk removal..."
if id "splunk" &>/dev/null; then
    echo "Failed to remove Splunk user. Please check manually."
else
    echo "Splunk user removed successfully."
fi

if [ -d "/opt/splunk" ]; then
    echo "Failed to remove Splunk installation. Please check manually."
else
    echo "Splunk installation removed successfully."
fi

if [ -d "/home/splunk" ]; then
    echo "Failed to remove Splunk home directory. Please check manually."
else
    echo "Splunk home directory removed successfully."
fi

echo "Cleanup completed. Ready for reinstallation."