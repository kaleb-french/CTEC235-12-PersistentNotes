# Journal
Write your Journal questions and notes here.

Phase 1-
The ?? operate allows you to specify a default fallback if null is returned, ie ?? false will make it false if null is returned. If omitted with produce a compile-time error due to the prefs.getBool('isDarkMode') returns a nullable bool? which means it needs some form of null safety to compile.

Phase 2-
It is helpful to test file writes with a console print to show they are actually writing and see their output in console. Seperating logic where possible into other files helps with readability, especially as the main file gets larger, having helper classes in their own files makes it easier to find them in the end.
