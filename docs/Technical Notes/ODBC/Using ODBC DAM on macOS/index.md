---
title: Using the ODBC DAM on macOS
---

# WORK IN PROGRESS, WILL GET UPDATED SOON

Microsoft SQL Server is relational database system developed by Microsoft.

You can communicate with SQL Server through Omnis Studio's ODBC DAM, which uses ODBC: a standard application programming interface for accessing database management systems.

## Requirements 

#### [Microsoft ODBC Driver](https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-2017)

Microsoft advises using [Homebrew](https://brew.sh/) to install their Microsoft ODBC Driver (version 18 at time of writing) by executing the following in the terminal:

```bash
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
HOMEBREW_ACCEPT_EULA=Y brew install msodbcsql18 mssql-tools18
```

Note the command above installs the Microsoft ODBC Driver 18, please double check if newer versions are available.
{:.description}

For further details on where things are installed, please consult Microsoft's [documentation](https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-ver16#driver-files).

## Setting up the odbc.ini

Open (or create) **/Library/ODBC/odbc.ini** and add your connection details, for example:

```text title="odbc.ini"
[ODBC Data Sources]
ntms2018 = ODBC Driver 18 for SQL Server

[ntms2017]
Driver = /usr/local/lib/libmsodbcsql.18.dylib
Description = SQL Server 18 on SERVER-PC
UID = henry
PWD = password
Database = test
Server = 192.168.100.15
```

Note that if you are running on a M1, the installed path might be **/opt/homebrew/lib** instead of **/usr/local/lib**.
{:.description}

## Setting up the ODBC DAM

In order for Omnis Studio's ODBC DAM to look for the **libodbc.dylib**, we need to set the DAM's sessin object $mode to **kODBCModeUnix**:

```omnis
Do sessionObj.$mode.$assign(kODBCModeUnix)
Do sessionObj.$database.$assign('test')
Do sessionObj.$logon('ntms2018','henry','password','session1') Returns #F
```