![obj-c](https://lh3.googleusercontent.com/--n6ytfyWEo8/UgX1o20eHjI/AAAAAAAAEPw/EufyyeKjl9E/w856-h523-no/u3.png)


[Google Fusion Tables](http://www.google.com/drive/apps.html#fusiontables) is a powerful combination of a big web store and variety of ways to access and visualise the data. While marked as 'experimental', it has reached its maturity with [Fusion Tables API v1.0](https://developers.google.com/fusiontables/) and now offers developers some clean & easy ways to enrich their apps across variety of development platforms. 

One potential obstacle for Fusion Tables in iOS apps is that there is no official, dedicated Google API Objective-C API. While the existing libraries such as [gtm-oauth2](https://code.google.com/p/gtm-oauth2/) and [gtm-http-fetcher](https://code.google.com/p/gtm-http-fetcher/) are well-written and provide all that is needed to work with Fusion Tables, being general and a bit lower-level they can also put a lot of extra weight on developers's shoulders.

Obj-C-FusionTables is a light-weight soluition for integrating Fusion Tables into iOS apps, built entirely on top of the gtm-oauth2 and gtm-http-fetcher libraries. 

# Sample Project
The main purpose of the sample project was to show typical usage of ````Obj-C-FusionTables```` for common Fusion Tables operations such as listing tables, creating a table, setting Map styles, adding InfoWindow templates, SQL rows operations, etc. For your existing Fusion Tables data safety, only the tables created within the sample app can be modified.

To run the sample project, you will need to set <b>your own Google API</b> key in ````GoogleAPIKeys.plist````. You can get the API key [here](https://developers.google.com/fusiontables/docs/v1/using#APIKey).

# Installation
Drag & drop the ''''Obj-C-Fusion Tables Base'''' folder from sample app into your XCode project. The ````Google Toolbox```` subfolder contains gtm-oauth2 and gtm-http-fetcher classes, if you're already using these libraries in your project feel free to delete it. If not, you'll need to set the -fno-objc-arc compiler flag for the gtm-oauth2 /  gtm-http-fetcheras classes as described [here](https://code.google.com/p/gtm-http-fetcher/wiki/GTMHTTPFetcherIntroduction#Adding_the_Fetcher_to_Your_Project).
And that's pretty much it!

# Usage
* Start with setting <b>your own Google API Key</b> in ````GoogleAPIKeys.plist````. You can get the API key [here](https://developers.google.com/fusiontables/docs/v1/using#APIKey)
* Take a quick look at the Obj-C-FusionTables classes to famiiarize yourself with the concepts. If you already have some level of experience with [Google Fusion Tables API v1.0](https://developers.google.com/fusiontables/docs/v1/reference/), things should be mostly self-explanatory. E.g. the ````FTTable```` class is an Objective-C represeantation of the [Fusion Table resource](https://developers.google.com/fusiontables/docs/v1/reference/#Table), with corresponding methods such as ````list....````, ````insert....````, ````update....````, ````delete....````. Similarly, the same goes for other Fusion Tables resources such as Templates and Styles. 
The ````FTSQLQuery```` class represents the Fusion Table SQL query resource and has corresponding methods such as ````select...````, ````insert...````, ````update...````, ````delete...````. The ````FTSQLQueryBuilder```` class serves helps build SQL statements as shown below.
The ````GoogleAuthorizationController```` class conviniently wraps around Google Authentication library, providing simple ways to sign-in / sign-out and authenticating general requests to Google Services.

# A few quick code samples
* read a list of Fusion Tables

````
__block NSArray *ftTableObjects = nil;
[self.ftTable listFusionTablesWithCompletionHandler:^(NSData *data, NSError *error) {
	if (error) {
	    NSData *data = [[error userInfo] valueForKey:@"data"];
	    NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	    NSLog(@"Error Creating Fusion Table: %@", errorStr);
	} else {
	    NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data
	                                                          options:kNilOptions error:nil];
	    ftTableObjects = [NSMutableArray arrayWithArray:lines[@"items"]];
	}
}];

````

* insert a new Fusion Table

````
[self.ftTable insertFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
    if (error) {
        NSData *data = [[error userInfo] valueForKey:@"data"];
        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"Error Creating Fusion Table: %@", errorStr);
    } else {
        NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions error:nil];
		NSLog(@"Created a new Fusion Table: %@", contentDict);
    }
}];
````

* delete a Fusion Table

````
[self.ftTable deleteFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
    [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
    if (error) {
        NSData *data = [[error userInfo] valueForKey:@"data"];
        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Error Deleting Fusion Table: %@", errorStr);
    }
}];
````

Similar coding patterns work for Fusion Tables Templates, Styles, and SQL Queries.


# The Delegates
After a brief glance on the delete table code above, the first question is probably "where the heck is the table ID coming from? is it in some property, or what?" Well, as the ```FTTable``` class is a representation of a stateless web resource a more logical way of handling parametrization is via a delegate. The ```FTTable``` delegate is defined as follows:

````
@protocol FTDelegate <NSObject>
@optional
- (NSString *)ftTableID;
- (NSArray *)ftColumns;
- (NSString *)ftTitle;
- (NSString *)ftDescription;
- (BOOL)ftIsExportable;
@end
````

This way things are more flexible, letting you implement the delegate where it makes sense in your app rather than going into parametrising / subclassing the ```FTTable``` class. A similar approach is used for other Obj-C-FusionTables core classes such as ````FTStyle```` and ````FTTemplate````.

A simple way to learn about implementing specific delagates is to look at the sample project. While obviously it requires some level of the [Fusion Tables API](https://developers.google.com/fusiontables/docs/v1/reference/) knowledge itself, the Objective-C part of it as quite straightforward. A quick code sample:

````
// Sample Fusion Table Title
- (NSString *)ftTitle {
	return @"My new cool table";
}
// Sample Fusion Table Columns Definition
- (NSArray *)ftColumns {
    return @[
     @{@"name": @"entryDate",
       @"type": @"STRING"
       },
     @{@"name": @"entryName",
       @"type": @"STRING"
       },
     @{@"name": @"geometry",
       @"type": @"LOCATION"
       }];
}
````

# Compatibility
GroupedUITableViews requires ARC and was optimised for iOS6 and above.

# TODOs
* extend the example with listing Styles / Templates, etc.
* add more tests, to cover SQL rows operations etc.

