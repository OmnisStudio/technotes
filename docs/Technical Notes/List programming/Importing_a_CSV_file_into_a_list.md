### Importing a CSV file into a list

Omnis has some powerful commands that allow you to import structural data, such as a CSV file. So it would be useful to create an object class that would allow you to import CSV data into an Omnis list. Usually, a data file has column headers in the first line of the data, so this should be taken into consideration when importing the data.

When importing data into an Omnis list, you must define the columns (column name and type) in the list before using the Import Data command (or doing anything with list data for that matter). In this case, you need to look at the first line of your data file to see how many columns are required in the list and what the column names should be.

![Import CSV window](/assets/importcsv/importcsv.png){: .image-medium .centered}

The following is a method that you can use to import a tab delimited CSV file into an Omnis list, while maintaining the column headings:

#### The \$importCSV method

```omnis
# create parameter: pPath (Character)
Set import file name [pPath]
Prepare for import from file Delimited (tabs)
```

The parameter `pPath` contains the path to the CSV file to be imported. The next command prepares the file to be imported with tab as a column delimiter.

So now before you can import all of the data, you need to use a command to import the first line which you can assume has the names of the column headings:

```omnis
Import field from file into lHeaderString ## import header End import
```

Note that you need to include the command *End import* because you will use another command to import the rest of the data into the list. Before you can do this, you need to define the list columns using the column names that are now in lHeaderString. However, they are currently delimited by a tab. That is why you need to use a loop and the *strtok()* function to loop through the `lHeaderString`:

```omnis
While len(lHeaderString)>0
    Calculate lColumnName as strtok('lHeaderString',kTab) ## cut each column name out of the string divided by tab
    Do lImportList.$cols.$add(lColumnName,kCharacter,kSimplechar,100000000) ## add the column to the list
End While
```

Now that you have defined the list, you need to import the rest of the data. Again, you can use the *Prepare for import* command, and then the *Import data* command to import all the data from line number two until the last record:

```omnis
Prepare for import from file Delimited (tabs)
Import data lImportList ## this will import only the data, not the header anymore End import
```

Finally you need to close the import file:

```omnis
Close import file
```

See the [sample library](/assets/importcsv/import_csv.zip){:download="import_csv.zip"} that demonstrates how you can use this method with diﬀerent column separators. There are also two lines in the \$construct method of the object class that sets the import encoding to unicode and the user import separator to semicolon:

```omnis
Do $prefs.$importencoding.$assign(kUniTypeUTF8) Do $clib.$prefs.$userexportdelimiter.$assign(';')
```

Note: some CSV files might have diﬀerent line breaks (LF or CR or both). If the line breaks are LF only there might be a problem to import those files; to fix this, you can add a new item to the config.json file. To do this, select the **Edit configuration** option from the Options button in the bottom-left corner of the Omnis Studio Browser underneath the tree. Then go to the "default" section and press the plus (+) button in the header which allows you to add a new variable. Enter the following:

`LFonlyLineTermination = kTrue`

Once this is set, the code will be able to handle both versions of line break (Windows and macOS).

Author: Andreas Pfeiffer, Senior Consultant, Omnis Germany.
