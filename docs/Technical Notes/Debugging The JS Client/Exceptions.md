### Client-Side Exceptions

When some invalid code is executed on the client side of the JS Client, an *exception* will be thrown, and you will likely see an error message like this:

![JS Error Message](/assets/debugging_jsc_images/jsError.png){: .image-medium .centered}

 - The first line gives a broad indication of the **context** in which the error occurred.
     - *Calling a client method*
{: .description}
 - The second line gives a **description** of the error.
     - *$add is being called on something which is null*
{: .description}
 - The third line gives a clue as to the related **Form** and/or **Control** on which the error occurred.
     - *The "bAdd" button on the form "jsForm1"*
{: .description}


These errors could be caused by an issue in your own client-executed methods, or by an underlying issue in the JS Client itself.



### Stack Traces

Whenever such an exception occurs, a stack trace, showing the route the code took to hit the exception, will be printed to the web browser's **Console**.

The Google Chrome web browser has a very good set of development tools, so we would advise using this when tracking down issues, where possible. 
{: .description}

To access the console, open your web browser's 'Developer Tools' (or equivalent). Usually accessed by **F12** or **Cmd + Option + I** or **Ctrl + Shift + I**. 
There should then be a "**Console**" tab in this interface, in which you should find the stack trace:

![Console Stack Trace](/assets/debugging_jsc_images/console_trace.png)

This shows (in red) the stack frames leading up to the exception, with the most recent at the top.

You can click the link to the source file related to each stack frame (**not** *the link on the right-most side*) to jump to the precise line of code. 
Here you may be able to determine the cause of the problem.


### Sending To Support

If the error is occurring not in your own client-executed methods, but in the JS Client's source code, please consider sending the stack trace to Omnis Support, along with a description of the context this is happening in, so that it can be fixed generally:

 - Copy the text of the stack trace from the console, including the top-level "**Error: ...** section and all stack frames, and paste into your email.
 - Click the source link next to the top-most stack frame, and include the problematic line from this file, and as much surrounding code as you think may be relevant.
     - If this error is occurring in the JS Client source code, this will be minified and all on a single line. Use the browser's "**Pretty Print**" button (it usually looks like "**{ }**") to make the code more readable before copying it.
{: .description}

