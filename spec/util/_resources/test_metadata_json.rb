# frozen_string_literal: true

METADATA_JSON = '{
  "name": "puppetlabs-apache",
  "version": "5.4.0",
  "author": "puppetlabs",
  "summary": "Installs, configures, and manages Apache virtual hosts, web services, and modules.",
  "license": "Apache-2.0",
  "source": "https://github.com/puppetlabs/puppetlabs-apache",
  "project_page": "https://github.com/puppetlabs/puppetlabs-apache",
  "issues_url": "https://github.com/puppetlabs/puppetlabs-apache/issues",
  "dependencies": [
    {
      "name": "puppetlabs/stdlib",
      "version_requirement": ">= 4.13.1 < 7.0.0"
    },
    {
      "name": "puppetlabs/concat",
      "version_requirement": ">= 2.2.1 < 7.0.0"
    }
  ],
  "operatingsystem_support": [
    {
      "operatingsystem": "RedHat",
      "operatingsystemrelease": [
        "6",
        "7",
        "8"
      ]
    },
    {
      "operatingsystem": "CentOS",
      "operatingsystemrelease": [
        "6",
        "7",
        "8"
      ]
    },
    {
      "operatingsystem": "OracleLinux",
      "operatingsystemrelease": [
        "6",
        "7"
      ]
    },
    {
      "operatingsystem": "Scientific",
      "operatingsystemrelease": [
        "6",
        "7"
      ]
    },
    {
      "operatingsystem": "Debian",
      "operatingsystemrelease": [
        "8",
        "9",
        "10"
      ]
    },
    {
      "operatingsystem": "SLES",
      "operatingsystemrelease": [
        "11 SP1",
        "12",
        "15"
      ]
    },
    {
      "operatingsystem": "Ubuntu",
      "operatingsystemrelease": [
        "14.04",
        "16.04",
        "18.04"
      ]
    }
  ],
  "requirements": [
    {
      "name": "puppet",
      "version_requirement": ">= 5.5.10 < 7.0.0"
    }
  ],
  "description": "Module for Apache configuration",
  "pdk-version": "1.17.0",
  "template-url": "https://github.com/puppetlabs/pdk-templates#main",
  "template-ref": "heads/main-0-g095317c"
}'
