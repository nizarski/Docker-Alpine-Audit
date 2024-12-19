apk add curl audit

mkdir /etc/audit/rules.d/

# Define the URL of the audit rules file
AUDIT_RULES_URL="https://raw.githubusercontent.com/nizarski/Docker-Alpine-Audit/refs/heads/main/audit.rules"

# Define the local path where the audit rules will be stored
LOCAL_AUDIT_RULES_PATH="/etc/audit/rules.d/audit.rules"

# Define the audit log file location
AUDIT_LOG_FILE="/var/log/audit/audit.log"

# Download the audit rules file
echo "Downloading audit rules from ${AUDIT_RULES_URL}..."
curl -o ${LOCAL_AUDIT_RULES_PATH} ${AUDIT_RULES_URL}

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download the audit rules file."
  exit 1
fi

# Set the appropriate permissions for the audit rules file
chmod 640 ${LOCAL_AUDIT_RULES_PATH}
chown root:root ${LOCAL_AUDIT_RULES_PATH}

# Restart the auditd service to apply the new rules
echo "Restarting auditd service..."
service auditd restart

# Check if the auditd service restarted successfully
if [ $? -ne 0 ]; then
  echo "Failed to restart the auditd service."
  exit 1
fi

# Verify that auditd is running
echo "Verifying auditd service status..."
service auditd status

# Check if the audit log file exists
if [ ! -f ${AUDIT_LOG_FILE} ]; then
  echo "Audit log file not found. Creating the audit log file..."
  touch ${AUDIT_LOG_FILE}
  chmod 640 ${AUDIT_LOG_FILE}
  chown root:root ${AUDIT_LOG_FILE}
fi

