# A completely random project in my repository

> As I am publishing this publicly on my own GitHub repository, I figured the title could be somewhat of a joke to not attract too much attention 😁.

In this README, I will explain the steps that I took performing the assignment.

# 1. Modifying the Wikipedia app

After pulling the source code, and clicking through the app a little, I started looking for how the app implemented deeplinking and which schemes the app does support.

Using, among others, the `wikipedia://` scheme you are able to open the app, and subsequently `wikipedia://places` opens the places tab from the link. The URL to open the places tab with some coordinates would then look like this: `wikipedia://places?lat=48.858844&lon=2.294351` (which is the Eiffel Tower)

I then went looking for the code inside the app that is responsible for the deeplinking in the app to the places tab. This code seemed to be written in Objective-C. To add the possibilty to add the latitude and longitude to the `NSUserActivity` object, I added code to the `+ (instancetype)wmf_placesActivityWithURL:(NSURL *)activityURL` function to extract those and add them to the `userInfo` property of the user activity.

Lastly, I added code to the function that is responsible for opening the Places view that constructs a `CLLocation` object and passes it to the `PlacesViewController` where my `showLocationOnMap(location:)` functions actually opens the particular place.

You can find the Wikipedia-iOS Fork here: [Link](https://github.com/Dennissimeau/wikipedia-ios)

# 2. Creating the test app

I find it a bit difficult on what I need to discuss here, as the assignment leaves room for interpretation about what to describe in this README. 

I want to discuss a few things: 

## The UI
I wanted to show my possibilities with SwiftUI, both technically and visually. In the technical sense I wanted to show a diverse usage of SwiftUI's components and modifiers. A few examples are A responsive grid view, next to the basic List view; Usage of TipKit to explain the additions I added to the offered data; A different approach of letting a user select a location, by showing a nice reactive sheet.

I tried to show some finishing touches by adding animations, a shadow behind the map to give some visual depth and using different fonts to have visual hierarchy in text.

At last, I think keeping the user informed about (in this case) some things that are going wrong, via errorhandling and showing that in SwiftUI's native `ContentUnavailableView()` or showing a simple alert when the Wikipedia app is not installed, are things that are needed to keep a happy user.

Also, not completely related to the UI but to SwiftUI, I decided that MVVM would be the right approach here. SwiftUI in my opinion really wants you to do MVVM and secondly it is what most project I have been working on so far have been using.

## Reversed search
The provided data is structured in a simple way, but the last item lacks the name of the city. I felt invited to use `CoreLocation`'s `reverseGeocodeLocation()` to find the corresponding city name. That is also why I add the ✨-emoji to the name to show items that have been reverse searched by the coordinates.

## Swift Concurrency
Swift concurrency is a super nice and very readable framework, and regardless of the bonus point (which I'm still happy to receive, of course ;-) ) I would have chosen to use it anyway. It looks much nicer then using callbacks, it keeps the code simple, and it plays nice with SwiftUI. There is still a lot to play with (like AsyncStream, for adapting to older callback functionalities or delegation functionalities), but for the scope of this project I think the basics are shown.

## SwiftUI choices
One main thing I want to mention is the way I structured code. For small bits like a button with image or a picker, I decided to extract them into computed properties:

```Swift
   private var locationsPicker: some View {
        Picker("", selection: $selectedPickerIndex) {
            Image(systemName: "list.bullet").tag(0)
            Image(systemName: "rectangle.grid.2x2").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
```
In my personal view of writing SwiftUI these bits are too small to justify their own complete view struct. For bigger pieces of funcionality, like `ItemGridView` I did extract them to simplify structure in the bigger context.

## Testability
At last I want to touch on the unit tests. The app is of course quite simple, but I touch upon the functionality the viewmodel offers. The mock I made and injected is fairly simple but shows of the basic functionality works. That is also why I used protocols to base my networking functionality around.

