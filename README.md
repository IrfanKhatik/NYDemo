# NYTimes

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

NYTimes simple app to hit the NY Times Most Popular Articles API and show a list of articles.
We'll be using the most viewed section of this [API].

# Features!

- List Articles (with refresh loader)
- Implemented network call
- Followed MVC pattern
- Filter Search

- Implemented roman convertor (1 to 3000)
- Added unit test cases

## How to run tests
- 1] Open Sample App in Xcode
- 2] Select Simulator at device to build
- 3] Select Project from Project hierarchy 
- 4] Open Dropdown at NYTimesTests folder
- 5] Select NYTimesTests.swift XCTests class
- 6] There are three ways to run the test class:
   - a] Product\Test or Command-U. This actually runs all test classes.
   - b] Click the arrow button in the test navigator.
   - c] Click the diamond button in the gutter.
    
> Also enabled code coverage in current scheme.

### Tech

NYTimes uses a number of open source projects to work properly:

* [Swift] - Swift programming language!
* [Xcode Editor] - Awesome Apple IDE

License
----

MIT


**Free Software!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

[API]: <http://api.nytimes.com/svc/mostpopular/v2/mostviewed/{section}/{period}.json?apikey=sample-key>
[Swift]: <https://developer.apple.com/swift/>
[Xcode Editor]: <https://developer.apple.com/xcode/ide/>
