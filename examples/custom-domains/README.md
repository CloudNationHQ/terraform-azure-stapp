This example demonstrates how to configure multiple custom domains for a static web app using DNS TXT token validation.

## Notes

This example uses `dns-txt-token` validation which allows testing without actual DNS records. Azure will provide validation tokens that can be used to verify domain ownership via TXT records when ready for production use.

For production deployments with actual domains:

Deploy this configuration to get the validation tokens

Create TXT records in your DNS with the tokens provided by Azure

Azure will automatically validate and enable the custom domains

Alternative validation method `cname-delegation` requires actual CNAME records pointing to the static web app's default hostname before deployment.
