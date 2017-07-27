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