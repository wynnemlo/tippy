# Pre-work - Tippy

Tippy is a tip calculator application for iOS.

Submitted by: Wynne Lo

Time spent: 15 hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [ ] Using locale-specific currency and currency thousands separators.
* [ ] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] The keyboard is visible upon loading but the bill amount is not the first responder due to UI design.
- [x] User can input the number of people the bill is the split among.
- [x] User can add extra amounts (that are not subjected to tax) to be split - for example, if they are attending a birthday dinner and they pitch in for the birthday cake money
- [x] User can choose a plain or color theme (gradient background)
- [x] Currency amounts are indicated with the "$" sign for improved readability - invalid inputs will be checked and disabled.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/O0HoQYa.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I wanted to implement a full light/dark theme for the app, but found out that it's very challenging to do so. I didn't want to have a bunch of spaghetti code setting up the colors of each component, but that also meant I may have to incorporate certain other frameworks? I couldn't figure out an elegant solution so I decided to simplify the feature and go with a plain / colored background.

I've decided, that instead of implementing a pushed view controller for the Settings page, to use a slide out view controller that's contained in a parent controller. This is so that users that easily see the theme changes, instead of having to go back and forth between the main and settings VC.

I've incorporated a few Cocoapods mainly for UI design, but one of the libraries did not exactly do what I needed it to do, so I had to fork the original and modify it.

## Project Analysis

As part of your pre-work submission, please reflect on the app and answer the following questions below:

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:** I love developing onthe iOS app platform (especially compared to Android), because of how elegant it is with the autolayout. It is a lot simpler than web development because of how you don't have to use CSS which is oftentimes unreliable and inconsistent between different browsers.
I would tell the developer that interfaces (views) are designed / coded in a storyboard file, which is separate from the view controller files (controller). It is similar to web dev's MVC concept, where the views are the HTML files, but in here it's an XML file. An outlet is basically a variable for an item in the VIEW file, that is accessible in your CONTROLLER file. An action is basically a function defined in your CONTROLLER file to control the behavior of a particular item in the VIEW. Basically, outlets and actions are just ways to link the view and controller.

Question 2: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:** All the declarations (with the '=' sign) are implicitly assumed to be strong references in Swift. A strong reference cycle is when two instances have a strong reference to each other, then the two instances will never be deinitialized and cause a memory leak.
This can happen as well for closures, when an instance references a closure and the closure references the instance ('self'). E.g. a person has a weight and height variable, and then his BMI is declared as a closure with a reference to the person's own weight and height. Then even when we declare the person to be nil, the person will not deinitialize because there's a strong reference cycle. To resolve these issues, we can use the 'weak' or 'unowned' prefix to change the nature of the reference (so that it's not both strong references to each other).


## License

    Copyright [2017] [Wynne Lo]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.