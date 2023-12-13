# frozen_string_literal: true
# In Ruby, certain comments known as "magic comments," have a special meaning.
# They are preceded with # and affect how the code is interpreted and executed.
# The first line above is a magic comment that ensures string literals are immutable (unchangeable) in the file.

# name: discourse-custom-automations
# about: Sends an email when a new post is created.
# Version 1.0.1
# authors: Backroads4me
# url: https://github.com/Backroads4Me/discourse-custom-automations


# This creates a setting in the Discourse admin panel to enable or disable this plugin.
enabled_site_setting :discourse_custom_automations_enabled

# This ensures that this code runs after the Discourse application has been fully initialized.
after_initialize do

# Allows the code to be reloaded without restarting the entire server.
reloadable_patch do

# Check if the DiscourseAutomation plugin is available, if not, end.
if defined?(DiscourseAutomation)

# Skip this automation trigger if the post is a PM.
#  (not currently using)
#next if post.topic.private_message?
  
# Define the script name that is used in the DiscourseAutoamtion plugin.
DiscourseAutomation::Scriptable::SEND_EMAIL_ON_NEW_POST = "send_email_on_new_post"

# Add a this automation script as an option in the DiscourseAutomation plugin.
DiscourseAutomation::Scriptable.add(DiscourseAutomation::Scriptable::SEND_EMAIL_ON_NEW_POST) do

  # Define the event that triggers this script.
  # 'post_created_edited'  is one of the built in trigger options.  You can also create your own.
  triggerables %i[post_created_edited]
  
  # This block defines what happens when the trigger event occurs.
  script do |context|

    # Retrieve the attributes of the object from the context provided by the trigger.
    # (not currently using)
    #post = context["post"]

    # Access the settings defined in 'settings.yml'.
    # Must be defined in settings.yml
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
