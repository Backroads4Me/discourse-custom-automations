# frozen_string_literal: true

# In Ruby, certain comments known as "magic comments," have a special meaning.
# They are preceded with # and affect how the code is interpreted and executed.
# This line is a magic comment that ensures string literals are immutable (unchangeable) in the file.
# This comment sets all string literals (i.e., text enclosed in quotes) in the file to be immutable (frozen).
# In Ruby, strings are mutable by default, which means they can be altered after they are created. 
# It's a best practice for Ruby code to avoid unexpected modifications to strings.


# name: discourse-custom-automations
# about: Send an email when a new post is created.
# version: 1.0.0
# author: Backroads4me

# This line creates a setting in the Discourse admin panel to enable or disable this plugin.
enabled_site_setting :discourse_custom_automations_enabled

# 'after_initialize' block: This code runs after the Discourse application has been fully initialized.
# It ensures that all features and plugins of Discourse are loaded and available.
after_initialize do

# 'reloadable_patch' block: Allows parts of the code to be reloaded without restarting the entire server.
# Useful for development and testing, making it easier to apply and test changes.
reloadable_patch do

# Check if the DiscourseAutomation plugin is defined and available.
# If it's not, the following code won't run.
if defined?(DiscourseAutomation)

# Check if the post is a private message.
# Skip the automation trigger if the post is a PM.
#next if post.topic.private_message?
  
# Define a constant for the script name. This is used to reference the script within the plugin.
DiscourseAutomation::Scriptable::SEND_EMAIL_ON_NEW_POST = "send_email_on_new_post"

# Add a new automation script to DiscourseAutomation.
# This part of the script defines what the automation does.
DiscourseAutomation::Scriptable.add(DiscourseAutomation::Scriptable::SEND_EMAIL_ON_NEW_POST) do

  # Define the event that triggers this script.
  # 'post_created' means the script runs when a new post is made in the forum.
  triggerables %i[post_created_edited]
  
  # Define the logic of the script in a 'script' block.
  # This block describes what happens when the trigger event occurs.
  script do |context|

    # Retrieve the post object from the context provided by the trigger.
    #post = context["post"]

    # Access the settings defined in 'settings.yml' to get email details.
    recipient = SiteSetting.send_email_on_new_post_email_recipient
    subject = SiteSetting.send_email_on_new_post_email_subject
    body = SiteSetting.send_email_on_new_post_email_body

      # Do not attempt to send the email if an address has not been configured.
      if recipient.present?
  
        # Send the PM from the system user
        PostCreator.create!(Discourse.system_user, {
                target_emails: recipient,
                archetype: Archetype.private_message,
                title: subject,
                raw: body
              })
      end
  end
end
end
end
end
