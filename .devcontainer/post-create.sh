# Update the package list
sudo apk update

# Install unzip and curl
sudo apk add unzip curl

# Set the version of Terraform you want to install
TERRAFORM_VERSION="1.6.6"

# Download Terraform
sudo curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Unzip the downloaded file
sudo unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Move the Terraform binary to a directory in your PATH
sudo mv terraform /usr/local/bin/

# Clean up the directory
sudo rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Verify that the installation worked by opening a new terminal session and listing Terraform's available subcommands
terraform --version

# Add the community repository
sudo echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install Node.js and npm
sudo apk add nodejs npm