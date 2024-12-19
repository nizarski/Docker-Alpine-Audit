#!/bin/bash

#SYSMON
sudo wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

# Update package lists
sudo apt update && sudo apt install -y curl auditd sysmonforlinux rsyslog net-tools p7zip-full iptables iptables-persistent

# Create directory for audit rules if it does not exist
sudo mkdir -p /etc/audit/rules.d/


# Define the URL of the audit rules file
AUDIT_RULES_URL="https://raw.githubusercontent.com/nizarski/Docker-Audit-automation/refs/heads/main/audit.rules"

# Define the local path where the audit rules will be stored
LOCAL_AUDIT_RULES_PATH="/etc/audit/rules.d/audit.rules"

# Define the audit log file location
AUDIT_LOG_FILE="/var/log/audit/audit.log"

# Download the audit rules file
echo "Downloading audit rules from ${AUDIT_RULES_URL}..."
sudo curl -o ${LOCAL_AUDIT_RULES_PATH} ${AUDIT_RULES_URL}

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download the audit rules file."
  exit 1
fi

# Set the appropriate permissions for the audit rules file
sudo chmod 640 ${LOCAL_AUDIT_RULES_PATH}
sudo chown root:root ${LOCAL_AUDIT_RULES_PATH}

# Restart the auditd service to apply the new rules
echo "Restarting auditd service..."
sudo systemctl restart auditd

# Check if the auditd service restarted successfully
if [ $? -ne 0 ]; then
  echo "Failed to restart the auditd service."
  exit 1
fi

# Verify that auditd is running
echo "Verifying auditd service status..."
sudo systemctl status auditd

# Check if the audit log file exists
if [ ! -f ${AUDIT_LOG_FILE} ]; then
  echo "Audit log file not found. Creating the audit log file..."
  sudo touch ${AUDIT_LOG_FILE}
  sudo chmod 640 ${AUDIT_LOG_FILE}
  sudo chown root:root ${AUDIT_LOG_FILE}
fi


sudo systemctl restart rsyslog


# network activities save
sudo iptables -N LOGGING
sudo iptables -A INPUT -j LOGGING
sudo iptables -A OUTPUT -j LOGGING
sudo iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "Network Activity : " --log-level 4
sudo iptables -A LOGGING -j RETURN 


sudo systemctl restart auditd

#SYSLOG
sudo systemctl enable rsyslog
sudo systemctl start rsyslog

#SYSMON
sudo sysmon -i


