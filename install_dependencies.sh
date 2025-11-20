#!/bin/bash
set -e

# Install Amazon SSM Agent
sudo snap install amazon-ssm-agent --classic
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# For ubuntu
# sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
# sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service