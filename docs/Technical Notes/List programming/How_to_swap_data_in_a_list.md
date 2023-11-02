### How to swap data in a list

The new JS Chart component in Omnis Studio 11 is great for displaying tabular data in a graphical layout. Sometimes, you may need to swap the data in your list around, that is, you may want to swap the data in the columns and rows in your list. In most cases, it would be best to load the data already swapped, but not all databases have a swap (or transpose) function, so it would be good if you could write some Omnis code to do this for you. 

However, if your list variable has hundreds or thousands of lines, you may not want to transfer all these lines to columns. A list or row variable can have 32,000 columns, but do you really want to scroll across that far? So in practice, you may only want to transfer the first 10 or 20 lines into that number of columns, and this will be easier or quicker to process the data during the swapping procedure. 

To swap data in a list, I made an Omnis object class that contains only one method to swap the data in a list, that is, the lines in your source list become columns and all columns become lines. So check out the method below. It has one parameter of type list (pList) which takes the list data to be swapped. 

#### The `$getSwappedList` method

The name of the first column does not need to be swapped, so you can add the name of the first column from the source list (pList) to the destination list (lReturnList):

```omnis
# The $getSwappedList method
# Parameter: pList (list)
Do lReturnList.$cols.$add(pList.$cols.$first().$name,kCharacter,kSimplechar,255) 
```

Now you need to use the content of the first column of the source list and create columns in the destination list for each line of the source list:

```omnis
For pList.$line from 1 to pList.$linecount
    Do lReturnList.$cols.$add(pList.c1,kCharacter,kSimplechar,255)
End For
```

Finally you need to transfer the data in the source list into the return list starting with the second column, as the first has already been used in the column definition: 

```omnis
Do pList.$cols.$first() Returns lColRef
While lColRef
    Do pList.$cols.$next(lColRef) Returns lColRef
    If lColRef
        Do lString.$assign(#NULL) ## make sure lString is cleared as it will be used in the following $sendall loop to concatinate a comma separated list for the $add command 
        Do pList.$sendall(lString.$assign(con(lString,iSep,kSq,pList.[pList.$line].[lColRef.
$name],kSq)))
        # calculate a row variable to add a line using the name of the column followed by the comma separated string calculated in the $sendall above
        Calculate lString as con('row(',kSq,lColRef.$name,kSq,lString,')') 
        # transfer the string into a row variable
 
        Calculate lRow as evalf(lString)
        # add a line to the return list using the data of the row variable 
        Do lReturnList.$add().$assignrow(lRow)
    End If
End While
Quit method lReturnList
```

Note: iSep is a variable that has been assigned in the definition of the variable to the separator used for the language setting: iSep=mid($prefs.$separators(),3)

So in English it would be a comma, while in other languages it might be a semicolon.

See the example [library](/assets/swaplistdata/swapdata.zip) accompanying this tech note (compatible with Omnis Studio 11 revision 35659 or above), which has an object class containing the `$getSwappedList` method, and a window containing a data grid to display the data.

Author: Andreas Pfeiffer, Senior Consultant, Omnis Germany.
