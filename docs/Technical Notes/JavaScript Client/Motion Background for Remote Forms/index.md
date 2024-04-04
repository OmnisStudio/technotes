# Motion Background for Remote Forms

for Omnis Studio 10 or above

By Andreas Pfeiffer, Senior Omnis Consultant

---

Imagine a movie playing on the background of your remote form: this is called '**Motion Background**'. This tech note describes how you can implement this in your Omnis web or mobile application.

The image below shows a "jsLogin" Remote Form, but in general this is also possible with any JavaScript Remote Form. License-free background videos are available on this website: [www.motionbolt.com](https://www.motionbolt.com). For the example I used this video: [www.motionbolt.com/race-day/](https://www.motionbolt.com/race-day/) (note other video resources are available and we urge you to check and comply with any license requirements with regards to using video).

![Motion Background For Remote Forms Image](/assets/motion_background_for_remote_forms/remote-form-motion-background.jpg)

## Setting up the "video" folder

To make this work in your development environment, it's best to add a "video" folder below your HTML folder of your Omnis installation in \AppData\local under Windows or /Application Support on macOS. In this folder copy the video you want to use. Note that if the video is too large, it will cause delays on slow connections. I renamed the video to "movie.mp4".

## Displaying the video with the HTML Control

Now drag an HTML object onto your remote form and type the following into the `$html` property of the control:


```html
<div>
<video autoplay muted loop>
<source src="video/movie.mp4" type="video/mp4">
Your browser does not support the video tag. </video>
</div>
```

Note: if you copy the code from this web page, ensure it does not contain any erroneous characters or spaces that may cause the HTML to fail when the browser tries to display it: for example, copy and paste the code into a text editor to convert it to raw text and then copy that into the `$html` property of the HTML object.
{: .description}

The "**autoplay**" entry in the `<video>` tag makes the video start immediately, while "**loop**" makes the video automatically start from the beginning when it reaches the end. The "**source**" entry then specifies the video itself relative to the HTML folder. If the browser can't play a mp4 file, an error text is displayed.

It is best to set the `$edgefloat` property of the HTML object to **kEFPosnClient** (for all layout breakpoints) and then set the `$designactive` property to **kFalse** so that the object does not interfere with the design of the other objects. If you want to turn this on again, use the Field List to select the HTML object and change its properties.

## Using a Paged Pane as a container over the video

You can achieve a good effect by using a Paged Pane control that has its `$alpha` value set to **220**. This way the video is still visible through the Paged Pane but the text input and fields are clearly visible.

If you set the `$edgefloat` property for the Paged Pane to **kEFCenterAll**, it will always be in the center of the web browser and if you turn on `$hasshadow` it will appear to float above the video. Note you can only set round corners with `$borderradius` if `$effect` is set to **kJSBorderPlain**. If you want to make the border line invisible, set the `$bordercolor` to **kJSThemeColorBackground**.

Please note that the Video Resource must be copied to your web server for production. To do this, set up the subfolder "video" there and copy the video into it.

You can download a library [motionbackground.zip](/assets/motion_background_for_remote_forms/motionbackground.zip){:download="motionbackground.zip"}  (compatible with Studio 10.2 or above) containing the remote form described above: note the zip does not include a movie which you will have to source yourself, and depending on the name of the movie you use, you will need to rename the movie or amend the movie name in the code for the HTML object `$html` property.