Omnis Studio has a built in server for testing your remote forms and apps. However, this is only served on the local network over http. 

If your remote form contains a feature that requires a [secure context](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts), such as accessing the user's camera device in the camera control, then this will fail to work when testing on a device other than the localhost. For example, if you use a mobile device on the same network to preview the app, *pError* in the relative event will be populated with an error code and description similar to:

![Not Secure Context Error](/assets/testing_https_images/pErrorCamera.png){: .image-medium .centered}

Or perhaps you just want to temporarily share your progress and give someone outside your local network access to your app, either way, this short tech note is for you.

### ngrok

ngrok (available at [https://ngrok.com/](https://ngrok.com/)) is a small utility that can be used to provide a solution to the above use cases. The capabilities of ngrok far exceed this, but we are covering just its basic usage here to meet most Omnis developers basic needs for testing.

- Download ngrok from [https://ngrok.com/download](https://ngrok.com/download) for your platform (or follow the instructions to install via a package manager such as brew or chocolatey)
- Sign up for a free ngrok account at [https://dashboard.ngrok.com/signup](https://dashboard.ngrok.com/signup)
- Once you are logged in, copy your auth token, open a terminal and run the following command:
```bash
ngrok config add-authtoken <your-token-here>
```
- You should then be able to create a tunnel with the following command (where port is your *$serverport* value):
```bash
ngrok http <port>
```

ngrok should now be running in your terminal like in the image below:

![ngrok tunnel app](/assets/testing_https_images/ngrok.png){: .image-large .centered}

The **Forwarding** line shows you the live address which is now pointing at your localhost:port

Copy this address and append the path to your html file, like `/jschtml/jsCamera.htm`, and share where you need to. You'll now be able to properly test features that require **secure context** on other devices and share your work with others.

Remember: The address is only temporary and will change next time you run ngrok.
{: .description}