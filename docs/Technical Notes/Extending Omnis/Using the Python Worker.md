# Using the Python Worker

---

Interoperability has improved massively in Omnis Studio 11 with the addition of a Python Worker, a Process Worker and simplified JavaScript Worker.

In this Tech Note, we are going to explore the features of the Python Worker and how to set it up.

## What is the Python Worker?

---

The Python Worker is an object grouped under the [OW3 Worker Objects](https://omnis.net/developers/resources/onlinedocs/ExtendingOmnis/07webcomms.html#ow3-worker-objects) that can be used to interopreate with a Python script. Below we discuss more about Python, setting up the Python worker up and using it.

### Python

[Python](https://www.python.org/) is a powerful, fast, open-source, interpreated programming language that can run everywhere. With its rich ecosystem of packages, it can be the perfect completion to your Omnis application.

The Python Worker enables the integration of new and existing Python scripts into Omnis Studio and therefore expands the capabilities of your application.

Python is **not** packaged with Omnis Studio, therefore you will need to install it separately.

### pip

[Pip](https://pypi.org/project/pip/) is the package manager and installer for Python. With pip, you can install packages for Python which can be subsequently called from Omnis Studio.

At the time of writing, pip is **not** packaged with Omnis Studio, meaning you will need to install it manually (usually comes with the Python installer).

## Installing Python and pip

---

At the time of writing, the OW3 Python Worker uses Python version 3, which can be downloaded from [Python's download page](https://www.python.org/downloads/). Since Python is interpreted, any version of Python 3 should be supported, unless a breaking change is introduced over time.

Download an install the appropriate package for your operative system and that should make Python and pip available on your system. Please note, on the Windows installer, you might have to manually tick to install pip during the installation process.

## Installing required packages

---

Once Python is installed, you need to install some packages in order to facilitate the communication between Python and Omnis Studio.

Navigate to the writable directory of your Omnis Studio installation, typically located inside the **AppData** folder on Windows or the **Application Support** folder on macOS. On Linux, the writable and read-only directories are the same.

Inside the writable directory, locate the **pyworker** folder, inside of which you will find a **requirements.txt** file containing all the packages Python requires to communicate with Omnis Studio. Using a terminal inside the **pyworker** folder, execute `path/to/python3 -m pip install -r requirements.txt` to install all the packages listed in the requirements file.

Please note we use the absolute path to the Python executable when installing these packages as you can have multiple installations of Python and inadvertently add the packages to the wrong installation, leading to the Python Worker not starting.

## Setting up Python module

---

### Locate pyworker folder

Navigate to the writable directory of your Omnis Studio installation, typically located inside the **AppData** folder on Windows or the **Application Support** folder on macOS. On Linux, the writable and read-only directories are the same.

Look for a folder named **pyworker**. This is where all the modules that can be used with the Python Worker will be installed.

### Create module folder

Create a new folder inside **pyworker** and name it after your module. The folder's name will be used to identify your module when calling its methods through the Python Worker from Omnis Studio.

For example, if your module is named **test_module**, create a folder named **test_module** inside the **pyworker** directory.

### Create entrypoint file

Inside your module's folder, we need to set up a **main.py** file which will be loaded by the Python Worker. The **main.py** file is where you can define your functions and import other packages - the Python Worker will automatically load this file and you can call the methods within from Omnis Studio.

For example, we can create a `test` function in our **main.py** in the following way:

```py
from omnis_calls import sendResponse, sendError

def test(param):
    return sendResponse({'unicode': 'Fingerspitzengef\xFChl is a German term.\nIt\u2019s pronounced as follows: [\u02C8f\u026A\u014B\u0250\u02CC\u0283p\u026Ats\u0259n\u0261\u0259\u02CCfy\u02D0l]'})

```

## Calling Python methods

---

### Create Python Worker object

Create a new object variable and inherit from the Python Worker, grouped under the OW3 Worker Objects. For more control, you might prefer to create a new object class in your library and inherit from the Python worker through the `$superclass` property.

### Initialise and start the worker

Once you have an object or an object reference to the Python Worker, you need initialise and then start the worker:

```js
pyWorker.$init(,'/path/to/python3')
pyWorker.$start() Return #F
```

A new thread will be launched upon calling `$start` where the Python process will wait until we give it methods to execute. Furthermore, you only need to call `$start` as you can make multiple method calls to the same worker.

The first parameter to `$init` takes overrides the search path, which is usually best to leave to default. The second parameter however is very useful: you can use it to specify the exact Python executable you wish to use. Please note whichever Python executable you try to use, it will need to have the packages from the requirements file installed, otherwise it will fail to start.

If the second parameter to `$init` is omitted, we default to `/usr/bin/python3` on Linux and macOS. On Windows, we attempt to load the `python3.dll` which works if it's available in the **PATH**, then try loading the **python3.exe** in the same directory as the **python3.dll**.

To avoid failures when starting the Python Worker, we advise you point the Worker to your **python3** executable through the second parameter to `$init`.

### Call a method

If your Python worker has started successfully, we can use `$callmethod(cModule, cMethod)` where **cModule** is the name of the module we wish to use and **cMethod** is the name of the method inside our module we want to execute:

```js
Do pyWorker.$callmethod('omnis_test', 'test') Return #F
```

### Passing parameters

Parameters passed to the Python worker are in the form of a [list](https://omnis.net/developers/resources/onlinedocs/Programming/02libsandclasses.html#list) or [row](https://omnis.net/developers/resources/onlinedocs/Programming/02libsandclasses.html#row).

You can pass the list or row in the `$callmethod`:

```js
Do lRow.$cols.$add('message',kCharacter,kSimplechar)
Do lRow.$assigncols('hello world')
Do lPyWorker.$callmethod("omnis_test","test",lRow) Returns #F
```

In order to access parameters on the Python module side, use the `param` parameter of your method:

```py
from omnis_calls import sendResponse, sendError

def test(param):
    return sendResponse(param['value'])
```

Please note Omnis rows will create a Python dictionary `param` and Omnis lists will create a Python list `param`.

### Method results

When the Python Worker returns, the `$methodreturn` callback is called with a [row](https://omnis.net/developers/resources/onlinedocs/Programming/02libsandclasses.html#row) parameter.

Inside the row parameter, you can find the returned data from your method as well as any tags supplied to `$callmethod`.

For example, calling the **test** method in the **omnis_test** module will result in Unicode characters to be returned inside the **unicode** column in the first row parameter of `$methodreturn`.

### Cancel call

If you have called a Python method but wish to cancel it, use the `$cancel` method on the Python worker:

```js
Do pyWorker.$cancel()
```

Cancelling a call might be useful if you think it has been running for too long and wish to stop it.

### Waiting on a call

The `$callmethod` is asynchronous by default, but there might be times where you wish to block the main thread until the Python Worker finishes its job, in which case you can pass `kTrue` to the **bWait** parameter of `$callmethod` (4th parameter):

```js
Do pyWorker.$callmethod('omnis_test','test',,kTrue) Returns #F
```

When **bWait** is true, the Python Worker will block the main thread until it returns.

### Tagging method calls

The same Python Worker instance can be used for multiple method calls since Python methods can be made asynchronous, as such it may come in useful the ability of tagging each call with an identifiable number.

The 6th parameter of `$callmethod` can accept a tag which will be returned in the `$methodreturn`:

```js
Do pyWorker.$callmethod('omnis_test','test',,,,lTagID) Returns #F
```

A **\_\_tag** column is added to the row parameter of `$methodreturn` if a tag was given to `$callmethod`, allowing you to identify the results.

## Error handling

---

### Method errors

If your Python method contains throws errors when executing, the `$methoderror` callback is called with a [row](https://omnis.net/developers/resources/onlinedocs/Programming/02libsandclasses.html#row) parameter which contains two columns:

**errorCode** column contains the error code of the error.

**errorInfo** column contains information about the error.

You can use the **errorCode** and **errorInfo** columns to debug your Python method.

### Worker errors

If the Python Worker has failed to start, the `$workererror` callback is called with a [row](https://omnis.net/developers/resources/onlinedocs/Programming/02libsandclasses.html#row) parameter which contains two columns:

**errorCode** column contains the error code of the error.

**errorInfo** column contains information about the error.

These errors are unlikely to be caused by the method called, but more likely issues with Python itself e.g. quitting due to missing packages.

## Registering callbacks

If you inherited your Python Worker, you can simply override callbacks in your new object.

Otherwise, if you created a new variable with the object type of OW3 Python Worker, you will need to register the instance that will receive the callbacks such as `$methoderror`, `$workererror` and `$methodreturn`.

You can do so by assigning the instance to the `$callbackinst` property, for example:

```js
Do pyWorker.$callbackinst.$assign($cinst)
```

Will assign the callback instance to `$cinst` (current instance). If `$cinst` is a window, then that window class must implement the methods `$methoderror`, `$workererror` and `$methodreturn`.

## Methods and properties

To view all methods and properties of the OW3 Python Worker, please consult the online documentation available [here](https://omnis.net/developers/resources/onlinedocs/ExtendingOmnis/07webcomms.html#python-worker-object).
