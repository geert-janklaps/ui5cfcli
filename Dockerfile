FROM ubuntu:18.04
LABEL maintainer="Geert-Jan Klaps"
LABEL version="1.0"

# Install required packages for next installs
RUN apt-get update && apt-get install -y wget gnupg2 curl chromium-browser

# Set chrome environment variable for karma tests
ENV CHROME_BIN /usr/bin/chromium-browser

# Install Cloud Foundry CLI
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN apt-get update && apt-get install -y cf7-cli

# Setup alias for CF7 command
RUN echo "alias cf='cf7'" >> ~/.bashrc

# Install community repository and MTA plugin
RUN cf7 add-plugin-repo CF-Community https://plugins.cloudfoundry.org
RUN cf7 install-plugin multiapps -f

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Update npm to latest version
RUN npm install npm@latest -g

# Run cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Create user
RUN adduser -uid 0 -gid 0 cicduser
USER cicduser

# Run command line
CMD /bin/bash
