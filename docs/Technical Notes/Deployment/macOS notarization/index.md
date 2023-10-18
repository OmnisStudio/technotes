# macOS notarization

---

macOS offers the Gatekeeper technology and runtime protection to help ensure that only trusted software runs on a user’s Mac. Furthermore, notarization give users even more confidence in your macOS software by submitting it to Apple for scanning for malicious content.

## Gatekeeper

>[Source](https://support.apple.com/en-gb/guide/security/sec5599b66df/web)

macOS includes a security technology called Gatekeeper, which is designed to help ensure that only trusted software runs on a user’s Mac.

When a user downloads and opens an app, a plug-in or an installer package from outside the App Store, Gatekeeper verifies that the software is from an identified developer, is notarised by Apple to be free of known malicious content and hasn’t been altered.

Gatekeeper also requests user approval before opening downloaded software for the first time to make sure the user hasn’t been tricked into running executable code they believed to simply be a data file.

## Notarization

>[Source](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)

Notarization gives users more confidence that the Developer ID-signed software you distribute has been checked by Apple for malicious components.

**Notarization is not App Review.**

The Apple notary service is an automated system that scans your software for malicious content, checks for code-signing issues, and returns the results to you quickly.

If there are no issues, the notary service generates a ticket for you to staple to your software; the notary service also publishes that ticket online where Gatekeeper can find it.

When the user first installs or runs your software, the presence of a ticket (either online or attached to the executable) tells Gatekeeper that Apple notarized the software.