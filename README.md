# Discourse Custom Automations

## Overview

DiscourseCustomAutomations is a plugin for Discourse forums that triggers an email notification when a new post is created.
This plugin uses the DiscourseAutomation framework and can be easily configured through the Discourse admin panel.

## Features
- **Integration with DiscourseAutomation**: Integrates with the existing DiscourseAutomation plugin.
- **Automatic Email Notifications**: Sends an email to a specified recipient whenever a new post is created on the forum.
- **Customizable Email Content**: Allows setting the recipient, subject, and body of the email through the Site Settings.

## Installation

To install Discourse Custom Automations, follow these steps:

1. Add the DiscourseAutomation plugin's repository URL to your Discourse's `containers/app.yml` file under the `hooks` section.
2. Add this plugin's repository URL to your Discourse's `containers/app.yml` file under the `hooks` section.
   ```yaml
   hooks:
     after_code:
       - exec:
           cd: $home/plugins
           cmd:
             - git clone https://github.com/discourse/discourse-automation.git
             - git clone https://github.com/[your-username]/discourse-custom-automations.git
