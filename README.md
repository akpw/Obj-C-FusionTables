Obj-C-FusionTables
==================

![obj-c](http://goo.gl/S71pRK)

[Google Fusion Tables](http://www.google.com/drive/apps.html#fusiontables) is a powerful combination of a big web store and variety of ways to access and visualise the data. While marked as 'experimental', it has reached its maturity with [Fusion Tables API v1.0](https://developers.google.com/fusiontables/) and now offers developers some clean & easy ways to enrich their apps across variety of development platforms. 

One potential obstacle for Fusion Tables in iOS apps is that there is no official, dedicated Google API Objective-C API. While the existing libraries such as [gtm-oauth2](https://code.google.com/p/gtm-oauth2/) and [gtm-http-fetcher](https://code.google.com/p/gtm-http-fetcher/) are well-written and provide all that is needed to work with Fusion Tables, being general and a bit lower-level they can also put a lot of extra weight on developers's shoulders.

Obj-C-FusionTables is a light-weight soluition for integrating Fusion Tables into iOS apps, built entirely on top of the gtm-oauth2 and gtm-http-fetcher libraries. 

# Sample Project
The main purpose of the sample project was to show typical usage of ````Obj-C-FusionTables```` for common Fusion Tables operations such as listing tables, creating a table, setting Map styles, adding InfoWindow templates, SQL rows operations, etc. For data safety, only Fusion Tables created within the sample app can be modified.
To run the sample project, you will need to set your own Google API key in ````GoogleAPIKeys.plist````. You can get the API key [here](https://developers.google.com/fusiontables/docs/v1/using#APIKey)

# Installation
Drag & drop the ''''Obj-C-Fusion Tables Base'''' folder from sample app into your XCode project. The ````Google Toolbox```` subfolder contains gtm-oauth2 and gtm-http-fetcher classes, if you're already using these libraries in your project feel free to delete it. If not, you'll need to set the -fno-objc-arc compiler flag for the gtm-oauth2 /  gtm-http-fetcheras classes as described [here](https://code.google.com/p/gtm-http-fetcher/wiki/GTMHTTPFetcherIntroduction#Adding_the_Fetcher_to_Your_Project).
And that's pretty much it!

# Usage
* Start with setting your own Google API Key in ````GoogleAPIKeys.plist````. You can get the API key [here](https://developers.google.com/fusiontables/docs/v1/using#APIKey)
* 



# Compatibility
GroupedUITableViews requires ARC and was optimised for iOS6 and above.
