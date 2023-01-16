Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash

# Update, and install dependencies
yum update -y
yum install ruby -y
yum install curl -y

# Install nvm
NVM_VERSION="v0.39.3"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

CHECK_FILE="/home/ec2-user/.nvm_installed"
HOME_DIRECTORY="/home/ec2-user"
if [ -f "$CHECK_FILE" ]; then
    echo "$CHECK_FILE exists, skipping"
else
    echo "$CHECK_FILE does not exist, setting up nvm"
    echo -e "\n
    export NVM_DIR=\"/.nvm\"
    [ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"
    \n" >> "$HOME_DIRECTORY/.bashrc"
    touch $CHECK_FILE
fi

# Install Node.js v12
nvm install 12
nvm use 12
node -v
npm -v

ln -s /.nvm/versions/node/v12.22.12/bin/node /usr/bin/node

SERVICE_UNITFILE="/lib/systemd/system/test_md.service"
if [ -f "$SERVICE_UNITFILE" ]; then
    echo "$SERVICE_UNITFILE exists, skipping"
else
    echo "$SERVICE_UNITFILE does not exist, creating unitfile"
    touch $SERVICE_UNITFILE
    echo -e "[Unit]
Description=index.js - testing test test test
Documentation=https://example.com
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/test/dist
ExecStart=/usr/bin/node /home/ec2-user/test/dist/index.js
Restart=on-failure
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=test_md.service
Environment=NODE_PORT=3300

[Install]
WantedBy=multi-user.target" >> "$SERVICE_UNITFILE"

chmod 644 $SERVICE_UNITFILE
fi

cd $HOME_DIRECTORY

# Install CodeDeploy Agent
EC2_AZ="$(curl http://169.254.169.254/latest/meta-data/placement/region 2>/dev/null)"
CDAGENT_BUCKET_NAME=aws-codedeploy-$EC2_AZ
wget https://$CDAGENT_BUCKET_NAME.s3.$EC2_AZ.amazonaws.com/latest/install
chmod +x ./install
./install auto
rm ./install
service codedeploy-agent start
service codedeploy-agent status
--//--
