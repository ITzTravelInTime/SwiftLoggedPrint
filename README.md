# SwiftLoggedPrint

Swift Library for better prints and to log prints.

# Usage

The source code is well documented, for some help here is some example usage:

```swift

import SwiftLoggedPrint

//The usage of a subclass is recommended sice it allows for a shorter name in the code and to customize the prefix
class Log: LoggedPrinter{
    override class var prefix: String{
        return "[My App]"
    }
    
    override class var debugPrefix: String{
        return "[Debug]"
    }
}

Log.debug("This should print and be visible in the log")
Log.print("Hello this is my app!") //this will print and show up in the log

Log.enabled = false

Log.debug("This should not print and be visible in the log")
Log.print("Hello this is my app!") //This will not print but will be visible in the log

Log.allowsLogging = false

Log.debug("This should not print and not be visible in the log")
Log.print("Hello this is my app!") //This will not print and not show up in the log

Log.enabled = true

Log.print("This should print and not be visible in the log")

Log.readLoggedDebugLines = false

Log.print("Here is the log so far: \n\n\(Log.readAllLog())") //The "Hello this is my app!" messange should be printed twice now and you should not see all the lines marked as debug

```

# Who should use this Library?

This library should be used by Swift apps/programs that needs better printing management compared to what Swift's Foundation library provvides and that needs some logs to provvide.

# Requirements

This code should work for almost any platform/target that has the Swift Foundation library or any equivalent one that's named the same, and that provvides the same basic types and functionalities.

# About the project

This code was created as part of my TINU project (https://github.com/ITzTravelInTime/TINU) and has been separated and made into it's own library to make the main project's source less complex and more focused on it's aim. 

Also having this as it's own library allows for code to be updated separately and so various versions of the main TINU app will be able to be compiled all with the latest version of this library.

# Credits

 - ITzTravelInTime (Pietro Caruso) - Project creator

# Contacts

 - ITzTravelInTime (Pietro Caruso): piecaruso97@gmail.com

# Copyright

Copyright (C) 2021 Pietro Caruso

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA



