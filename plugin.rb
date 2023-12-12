# frozen_string_literal: true

# In Ruby, certain comments known as "magic comments," have a special meaning.
# They are preceded with # and affect how the code is interpreted and executed.
# This line is a magic comment that ensures string literals are immutable (unchangeable) in the file.
# This comment sets all string literals (i.e., text enclosed in quotes) in the file to be immutable (frozen).
# In Ruby, strings are mutable by default, which means they can be altered after they are created. 
# It's a best practice for Ruby code to avoid unexpected modifications to strings.


# name: automation-script-email
# about: Send an email when a new post is created.
# version: 1
# authors: Backroads4me

# This line creates a setting in the Discourse admin panel to enable or disable this plugin.
#enabled_site_setting :send_email_on_new_post_enabled

# 'after_initialize' block: This code runs after the Discourse application has been fully initialized.
# It ensures that all features and plugins of Discourse are loaded and available.
#after_initialize do

  # 'reloadable_patch' block: Allows parts of the code to be reloaded without restarting the entire server.
  # Useful for development and testing, making it easier to apply and test changes.
  #reloadable_patch do

    # Check if the DiscourseAutomation plugin is defined and available.
    # If it's not, the following code won't run.
    #if defined?(DiscourseAutomation)

      # Event listener for the 'post_created' event.
      # When a new post is created, the enclosed block is executed.
      #on(:post_created) do |post|

        # Fetch all automation instances that are enabled and set to trigger on 'post_created'.
        #DiscourseAutomation::Automation
         # .where(enabled: true, trigger: "post_created")
          #.find_each do |automation|

            # Trigger the automation with the specified kind and post data.
            # This line essentially activates the automation logic for each matching automation instance.
           # automation.trigger!(
            #  "kind" => "post_created",
              #"post" => post,
            #)
          #end
      #end
    #end
  #end
#end


# Define a constant for the script name. This is used to reference the script within the plugin.
DiscourseAutomation::Scriptable::SEND_EMAIL_ON_NEW_POST = "send_email_on_new_post"

# Add a new automation script to DiscourseAutomation.
# This part of the script defines what the automation does.
#add_automation_scriptable(DiscourseAutomation::Scriptable::SEND_EMAIL_ON_NEW_POST) do
DiscourseAutomation::Scriptable.add(DiscourseAutomation::Scriptable::SEND_EMAIL_ON_NEW_POST) do
version 1

  # Define the event that triggers this script.
  # 'post_created' means the script runs when a new post is made in the forum.
  triggerables [:post_created]
  
  # Define the logic of the script in a 'script' block.
  # This block describes what happens when the trigger event occurs.
  script do |context|

    # Retrieve the post object from the context provided by the trigger.
    post = context["post"]

    # Access the settings defined in 'settings.yml' to get email details.
    #recipient_email = SiteSetting.send_email_on_new_post_recipient_email
    #subject = SiteSetting.send_email_on_new_post_email_subject
    #body_template = SiteSetting.send_email_on_new_post_email_body_template

    # Replace the '%{post_title}' placeholder in the body template with the actual post title.
    #body = body_template.gsub('%{post_title}', post.title)

    # Enqueue a job to send the email.
    # 'critical_user_email' is a job type in Discourse for sending important emails.
    # The job is added to a queue and will be processed by the system.
    #Jobs.enqueue(:critical_user_email,
     #            to_address: recipient_email,
      #           subject: subject,
       #          body: body)
    Jobs.enqueue(:critical_user_email,
             to_address: "ghhght@ymail.com",
             subject: "test subject",
             body: "test body")
  end
#end
