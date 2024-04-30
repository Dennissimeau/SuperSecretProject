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

I started with a basic structure of the how I wanted to view to look like:
*A basic sigle view app within a NavigationStack View with a title and a toolbar item.*
The toolbar item is a button that opens a sheet with a medium detent where the user can pick another location. 

The first commit contains some hard coded code in one single file: 
- The Location object, with sample data to fill the List;
- The Main view as described above;
- The LocationPicker View, empty at this stage.

Next, I started... UNDER CONSTRUCTION