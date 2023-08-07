# Using the JavaScript Worker

---

Interoperability has improved massively in Omnis Studio 11 with the addition of a Python Worker, a Process Worker and simplified JavaScript Worker.

In this Tech Note, we are going to explore the features that simplify the JavaScript Worker and how to use it.

## What is the JavaScript Worker?

---

The JavaScript Worker is an object grouped under the [OW3 Worker Objects](https://omnis.net/developers/resources/onlinedocs/ExtendingOmnis/07webcomms.html#ow3-worker-objects) that can be used to interoperate with Node.js. Below we discuss more about Node.js and npm, the package manager.

### Node.js

[Node.js](https://nodejs.org) is an open-source, cross-platform, asynchronous, event-driven server environment powered by Google's V8 JavaScript enginem, making it a seamless fit for Omnis Studio.

The JavaScript Worker enables the integration of pre-existing Node.js applications into Omnis Studio and empowers the expansion of Omnis Studio's capabilities by incorporating Node.js-based modules.

Node.js is packaged with Omnis Studio and you can find out the version by executing `path/to/node --version` from the terminal (or command prompt on Windows).

### npm

[npm](https://www.npmjs.com/) is a JavaScript package manager and it is the world’s largest software registry at the time of writing. With npm, you can install packages for Node.js which can be subsequently called from Omnis Studio.

At the time of writing, npm is **not** packaged with Omnis Studio, meaning you will need to install it manually and it must match with the version of Node.js, otherwise some packages may not run or load correctly.

If you install the same version of Node.js Omnis Studio packages on your system, npm will be installed alongisde it.

## Setting up Node.js module

---

### Locate jsworker folder

Navigate to the writable directory of your Omnis Studio installation, typically located inside the **AppData** folder on Windows or the **Application Support** folder on macOS. On Linux, the writable and read-only directories are the same.

Look for a folder named **jsworker**. This is where all the modules that can be used with the JavaScript Worker will be installed.

### Create module folder

Create a new folder inside **jsworker** and name it after your module. The folder's name will be used to identify your module when calling its methods through the JavaScript Worker from Omnis Studio.

For example, if your module is named **test_module**, create a folder named **test_module** inside the **jsworker** directory.

### Create package.json

Inside your module's folder, we need to set up a **package.json** file describing the module's version, name, dependencies and most importantly, the entrypoint.

The easiest way is to use `npm init` from a terminal or command prompt which will ask you a bunch of questions, and then write a **package.json** for you. Alterntively, you can create the file manually with the following contents:

```js title="package.json"
{
  "name": "your_module_name",
  "version": "1.0.0",
  "main": "test.js"
}
```

`"name"` is used by the package manager to identify modules. Omnis Studio uses the names of the folders inside jsworker to identify modules, but it must be defined for a valid package.json.

`"version"` is used by the package manager to identify your module's version. Omnis Studio does not currently use the version of a module, but it also must be defined for a valid package.json.

`"main"` is of most importance to Omnis Studio as it defines the entrypoint of your module. For example, if your package.json defines `"main": "test.js"`, Omnis Studio will look for a `test.js` file inside your module's folder (at the same level as your package.json) when calling a method through the JavaScript Worker.

Feel free to modify any of the options above to suit your needs.

### Create entrypoint file

Inside your module's folder, create a new file and use the value from `"main"` from your package.json as its name.

For example, if your package.json defines `"main": "test.js"`, your file must be named **test.js**.

The entrypoint file is responsible for exposing your module's methods to Omnis Studio's JavaScript Worker through a `call` function.

Here is an example of a simple entrypoint file. It contains a method map with one method and exports a `call` function, which enables the invocation of any function within the method map.

```js
const omnis_calls = require("omnis_calls");
const { errorCodes, newErrorWithCode } = require("../errors.js");

const methodMap = {
  test: function (param) {
    return {
      hello: "world",
    };
  },
};

module.exports = {
  call: function (method, param, response) {
    if (methodMap[method]) {
      const outcome = methodMap[method](param, response);
      omnis_calls.sendResponse(outcome, response);
      return true;
    } else {
      throw newErrorWithCode(errorCodes.METHOD_NOT_FOUND, "");
    }
  },
};
```

## Calling Node.js methods

---

### Create JavaScript Worker object

Create a new object variable and inherit from the JavaScript Worker, grouped under the OW3 Worker Objects. For more control, you might prefer to create a new object class in your library and inherit from the JavaScript worker through the `$superclass` property.

### Initialise and start the worker

Once you have an object or an object reference to the JavaScript Worker, you need initialise and then start the worker:

```js
jsWorker.$init()
jsWorker.$start() Return #F
```

A new thread will be launched upon calling `$start` where the Node.js process will wait until we give it methods to execute. Furthermore, you only need to call `$start` as you can make multiple method calls to the same worker.

### Call a method

If your JavaScript worker has started successfully, we can use `$callmethod(cModule, cMethod)` where **cModule** is the name of the module we wish to use and **cMethod** is the name of the method inside our module we want to execute:

```js
Do jsWorker.$callmethod('omnis_test', 'test') Return #F
```

### Passing parameters

Parameters passed to the JavaScript worker are in the form of a [list](https://omnis.net/developers/resources/onlinedocs/Programming/02libsandclasses.html#list) or [row](https://omnis.net/developers/resources/onlinedocs/Programming/02libsandclasses.html#row).

You can pass the list or row in the `$callmethod`:

```js
Do lRow.$cols.$add('message',kCharacter,kSimplechar)
Do lRow.$assigncols('hello world')
Do lJSWorker.$callmethod("omnis_test","test",lRow) Returns #F
```

In order to access parameters on the JavaScript module side, use the `param` parameter of your method:

```js
const methodMap = {
  test: function (param) {
    console.log(`Message is ${param.message}`);
    // ...
  },
};
```

### Method results

When the JavaScript worker returns, the `$methodreturn` callback is called with a [row](https://omnis.net/developers/resources/onlinedocs/Programming/02libsandclasses.html#row) parameter.

Inside the row parameter, you can find the returned data from your method as well as any tags supplied to `$callmethod`.

For example, calling the **test** method in the **omnis_test** module will result in Unicode characters to be returned inside the **unicode** column in the first row parameter of `$methodreturn`.

### Cancel call

If you have called a Node.js method but wish to cancel it, use the `$cancel` method on the JavaScript worker:

```js
Do jsWorker.$cancel()
```

Cancelling a call might be useful if you think it has been running for too long and wish to stop it.

### Waiting on a call

The `$callmethod` is asynchronous by default, but there might be times where you wish to block the main thread until the JavaScript worker finishes its job, in which case you can pass `kTrue` to the **bWait** parameter of `$callmethod` (4th parameter):

```js
Do jsWorker.$callmethod('omnis_test','test',,kTrue) Returns #F
```

When **bWait** is true, the JavaScript worker will block the main thread until it returns.

### Tagging method calls

The same JavaScript worker instance can be used for multiple method calls, as such it may come in useful the ability of tagging each call with an identifiable number.

The 6th parameter of `$callmethod` can accept a tag which will be returned in the `$methodreturn`:

```js
Do jsWorker.$callmethod('omnis_test','test',,,,lTagID) Returns #F
```

A **\_\_tag** column is added to the row parameter of `$methodreturn` if a tag was given to `$callmethod`, allowing you to identify the results.

## Error handling

---

### Method errors

If your JavaScript method contains throws errors when executing, the `$methoderror` callback is called with a [row](https://omnis.net/developers/resources/onlinedocs/Programming/02libsandclasses.html#row) parameter which contains two columns:

**errorCode** column contains the error code of the error.

**errorInfo** column contains information about the error.

You can use the **errorCode** and **errorInfo** columns to debug your JavaScript method.

### Worker errors

If the JavaScript worker has failed to start, the `$workererror` callback is called with a [row](https://omnis.net/developers/resources/onlinedocs/Programming/02libsandclasses.html#row) parameter which contains two columns:

**errorCode** column contains the error code of the error.

**errorInfo** column contains information about the error.

These errors are unlikely to be caused by the method called, but more likely issues with Node.js itself e.g. a crash.

## Registering callbacks

If you inherited your JavaScript worker, you can simply override callbacks in your new object.

Otherwise, if you created a new variable with the object type of OW3 JavaScript worker, you will need to register the instance that will receive the callbacks such as `$methoderror`, `$workererror` and `$methodreturn`.

You can do so by assigning the instance to the `$callbackinst` property, for example:

```js
Do jsWorker.$callbackinst.$assign($cinst)
```

Will assign the callback instance to `$cinst` (current instance). If `$cinst` is a window, then that window class must implement the methods `$methoderror`, `$workererror` and `$methodreturn`.

## Methods and properties

To view all methods and properties of the OW3 JavaScript Worker, please consult the online documentation available [here](https://omnis.net/developers/resources/onlinedocs/ExtendingOmnis/07webcomms.html#javascript-worker-object).
