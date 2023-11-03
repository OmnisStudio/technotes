# Linux system requirements


## What is Linux?
Linux is a open-source, Unix-like operating system based on the Linux kernel.

Although it does offer Desktop environments that make great client machines, it's the server side where Linux shines the most.

Either on a VM or in a Docker container, you can run Omnis Studio 11's headless Web Server for Linux (**x86-64**/**amd64**).

Because Linux [distros](https://en.wikipedia.org/wiki/Linux_distribution) can come with a variation of system libraries and kernel versions, you might have to install certain dependencies yourself, if the system you choose doesn't come with it out of the box.

This is not hard to do, since your system is likely to have a package manager such as `apt` or `yum`, for example executing `apt-get install cups` in the terminal will install the **cups** library with the `apt-get` package manager, usually found on distros such as **Debian**.