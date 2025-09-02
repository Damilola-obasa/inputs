# Buildkite Pipeline with Slack Notifications for Input Steps

This pipeline demonstrates how to send Slack notifications when a step is in an input step (manual approval required) and when deployment completes.

## Pipeline Overview

The pipeline consists of the following steps:

1. **🚀 Build and Test** - Simulates building and testing the application
2. **🔄 Manual Approval Required** - Input step requiring manual approval with form fields
3. **📱 Send Slack Notification - Input Step** - Sends notification when input step is reached
4. **🚀 Deploy to Staging/Production** - Conditional deployment based on user input
5. **📱 Send Slack Notification - Deployment Complete** - Sends completion notification
6. **🧹 Cleanup** - Final cleanup tasks

## Setup Instructions

### 1. Configure Slack Webhook

To enable Slack notifications, you need to set up a Slack webhook URL in your Buildkite pipeline settings:

1. Go to your Slack workspace and create a new app
2. Enable "Incoming Webhooks" feature
3. Create a webhook for your desired channel
4. Copy the webhook URL

### 2. Set Environment Variable in Buildkite

In your Buildkite pipeline settings, add the following environment variable:

```
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```

### 3. Pipeline Features

#### Input Step with Form Fields
The input step includes:
- **Deployment Reason** (required text field)
- **Environment** (required dropdown: staging/production)

#### Slack Notifications
Two types of notifications are sent:

1. **Input Step Notification** - Sent when the pipeline reaches the manual approval step
   - Includes pipeline details, build info, and a "View Build" button
   - Notifies team members that approval is needed

2. **Deployment Complete Notification** - Sent after deployment finishes
   - Includes deployment details and environment information
   - Confirms successful completion

#### Conditional Deployment
- Deployment steps only run for the selected environment
- Uses `build.env("environment")` to conditionally execute steps

## Customization

### Modify Slack Message Format
Edit the `SLACK_MESSAGE` variable in the notification steps to customize:
- Message text and formatting
- Fields displayed
- Button actions
- Channel mentions (@channel, @here)

### Add More Input Fields
Extend the input step by adding more fields:

```yaml
- input: "Custom Input Step"
  prompt: "Please provide additional information"
  fields:
    - text: "Custom Field"
      key: "custom_key"
      hint: "Helpful hint text"
      required: false
    - select: "Priority"
      key: "priority"
      options:
        - label: "Low"
          value: "low"
        - label: "High"
          value: "high"
      default: "low"
```

### Add More Notification Points
You can add Slack notifications at any step by copying the notification pattern and modifying the message content.

## Troubleshooting

### Slack Notifications Not Working
1. Verify `SLACK_WEBHOOK_URL` is set correctly
2. Check that the webhook URL is valid and active
3. Ensure your Slack app has the necessary permissions
4. Check Buildkite logs for any curl errors

### Input Step Not Appearing
1. Verify the input step syntax is correct
2. Check that the step is not being skipped by conditional logic
3. Ensure you have the necessary permissions to approve steps

## Example Usage

1. Pipeline starts and runs the build step
2. Pipeline pauses at the input step, waiting for manual approval
3. Team receives Slack notification about pending approval
4. User fills out the form and approves the step
5. Pipeline continues with deployment
6. Team receives Slack notification about successful deployment
7. Pipeline completes with cleanup

## Security Notes

- Never commit Slack webhook URLs to version control
- Use Buildkite's environment variable management for sensitive data
- Consider using Slack app tokens for more secure integrations
- Review and restrict webhook permissions in your Slack workspace
