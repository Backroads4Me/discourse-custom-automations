# frozen_string_literal: true

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

      # Define the script name that is used in the DiscourseAutomation plugin.
      DiscourseAutomation::Scriptable::SEND_EMAIL_ON_NEW_POST = "send_email_on_new_post"

      # Add this automation script as an option in the DiscourseAutomation plugin.
      DiscourseAutomation::Scriptable.add(DiscourseAutomation::Scriptable::SEND_EMAIL_ON_NEW_POST) do
        # Define the event that triggers this script.
        triggerables %i[post_created_edited]

        # This block defines what happens when the trigger event occurs.
        script do |context|
          # Access the settings defined in 'settings.yml'.
          recipient = SiteSetting.send_email_on_new_post_email_recipient
          subject = SiteSetting.send_email_on_new_post_email_subject
          body = SiteSetting.send_email_on_new_post_email_body

          # Do not attempt to send the email if an address has not been configured.
          if recipient.present?
            # Send the private messsage.  In this case, I am actually using it to send an email.
            post = PostCreator.create!(Discourse.system_user, {
                      target_emails: recipient,
                      archetype: Archetype.private_message,
                      subtype: TopicSubtype.system_message,
                      title: subject,
                      raw: body,
                      skip_validations: true
                    })
          end # if recipient.present?
        end # script do |context|
      end # DiscourseAutomation::Scriptable.add
    end # if defined?(DiscourseAutomation)
  end # reloadable_patch do
end # after_initialize do
