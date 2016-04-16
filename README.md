# On the Map
<img src="http://i.imgur.com/mNhsqOQ.jpg" width="263" height="500"> <img src="http://i.imgur.com/ZMJSEz6.jpg" width="263" height="500"> <img src="http://i.imgur.com/t490Qul.jpg" width="263" height="500">

The On The Map app allows users to share their location and a URL with their fellow students. To visualize this data, On The Map uses a map with pins for location and pin annotations for student names and URLs, allowing students to place themselves “on the map,” so to speak. 
First, the user logs in to the app using their Udacity username and password. After login, the app downloads locations and links previously posted by other students. These links can point to any URL that a student chooses. We encourage students to share something about their work or interests.
After viewing the information posted by other students, a user can post their own location and link. The locations are specified with a string and forward geocoded. They can be as specific as a full street address or as generic as “Costa Rica” or “Seattle, WA.”

The app has three view controller scenes:
* Login View: Allows the user to log in using their Udacity credentials or using their Facebook account
* Map and Table Tabbed View: Allows users to see the locations of other students in two formats.  
* Information Posting View: Allows the users specify their own locations and links.
* These three scenes are described in detail below.

## Login View
The login view accepts the email address and password that students use to login to the Udacity site.
When the user taps the Login button, the app will attempt to authenticate with Udacity’s servers.

## Map And Table Tabbed View
This view has two tabs at the bottom: one specifying a map, and the other a table.
When the map tab is selected, the view displays a map with pins specifying the last 100 locations posted by students.
The user is able to zoom and scroll the map to any location using standard pinch and drag gestures.
When the user taps a pin, it displays the pin annotation popup, with the student’s name (pulled from their Udacity profile) and the link associated with the student’s pin.
Tapping anywhere within the annotation will launch Safari and direct it to the link associated with the pin.
Tapping outside of the annotation will dismiss/hide it.
When the table tab is selected, the most recent 100 locations posted by students are displayed in a table. Each row displays the name from the student’s Udacity profile. Tapping on the row launches Safari and opens the link associated with the student.
Both the map tab and the table tab share the same top navigation bar.
The rightmost bar button will be a refresh button. Clicking on the button will refresh the entire data set by downloading and displaying the most recent 100 posts made by students.
The bar button directly to its left will be a pin button. Clicking on the pin button will modally present the Information Posting View.

## Information Posting View
The Information Posting View allows users to input data in two steps: first adding their location string, then their link.

## Techonologies Used
* RESTful API - Retreiving, Pushing, Updating data from Parse/Udacity using JSON
* MapKit - Display coordinates in form of annotations from the Parse API
* FBSDK Integration - Login with Facebook account 
