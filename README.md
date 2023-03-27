![Tagsafe](readme.png)

<div align="center"><strong>Tagsafe</strong></div>
<div align="center">Self-Host Your 3rd Party Javascript</div>
<br />
<div align="center">
<a href="https://tagsafe.io">Website</a>
<span> · </span>
<a href="https://github.com/swishjam/tagsafe">GitHub</a>
</div

-----
## Our goal
We want everyone to build awesome web experiences. We see Tagsafe as a great tool to improve the experience you have with the third party code on your frontend.
  
## Why should I self-host my 3P JS?
- **Control** - with each third party tag added to your site, you are effectively giving control to someone else to push changes to your site whenever they'd like without your knowledge. Tagsafe puts you back in control of when your 3P JS changes.
- **Page Performance** - each new domain a browser has to download content on requires a series of steps to verify the origin (DNS lookup, TCP connection, TLS connection). By consolidating all of your 3P JS to a single CDN, you automatically get improved page performance.
- **Best Practices** - are your third party tags minified? Cached efficiently? Using a global CDN? Using Tagsafe puts you in control of all these things so you no longer have to assume your 3P tags are using best practices.
  - Tagsafe runs an extra layer of minification on your 3P JS before hosting it, often times reducing it's file size.
  - Your hosted 3P JS is cached for 1 year with Tagsafe. We are able to do this because the fact we capture each change to the JS and host it as a new file.
  - We use [Cloudfront|https://aws.amazon.com/cloudfront] as our CDN provider, with over 450 points of presence.
  
## How it works
1. You tell Tagsafe which tags you'd like to self-host by inputting the URL of the JS
2. Tagsafe captures the JS content, hosts it behind our CDN, and then monitors the origin for changes
3. You place a small, in-lined piece of JS at the top of your pages which intercepts 3P tags added to your page, and re-points them to the Tagsafe-hosted version
4. When Tagsafe detects your tag provider has made a change, we capture a new version of the tag and host that as a new endpoint, and update your configuration so that your site is now pointing to the latest version.

## Other Projects
<a href="https://swishjam.com">Swishjam - Open-source tool to monitor frontend performance</a>

## Instructions
- more installation and setup instructions coming!
