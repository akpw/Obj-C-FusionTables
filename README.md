![obj-c](https://lh6.googleusercontent.com/-8D0zRsFyC98/VKbxYKNIzoI/AAAAAAAAFA4/9laOrutdy04/w1157-h707-no/u3.png)


[Google Fusion Tables](http://www.google.com/drive/apps.html#fusiontables) is a powerful combination of a big web store and variety of ways to access and visualise the data. While still marked as 'experimental', it has reached its maturity with [Fusion Tables API v2.0](https://developers.google.com/fusiontables/) and offers developers some clean & easy ways to enrich their apps across variety of development platforms.

One potential obstacle for Fusion Tables in iOS apps is that there is no official, dedicated Google API Objective-C API. While the existing libraries such as [gtm-oauth2](https://code.google.com/p/gtm-oauth2/) and [gtm-http-fetcher](https://code.google.com/p/gtm-http-fetcher/) are well-written and provide all that is needed to work with Fusion Tables, being general and a bit lower-level they can also put a lot of extra weight on developers's shoulders.

Obj-C-FusionTables is an easy-to-use soluition for integrating Fusion Tables into iOS apps, built entirely on top of the gtm-oauth2 and gtm-http-fetcher libraries.

# Installation
Drag & drop the ````Obj-C-Fusion Tables Base```` folder into your XCode project. The ````Google Toolbox```` subfolder contains gtm-oauth2 and gtm-http-fetcher classes, if you're already using these two libraries in your project feel free to delete it. If not, you'll need to set the <i>-fno-objc-arc</i> compiler flag for the gtm-oauth2 /  gtm-http-fetcher classes in the ````Google Toolbox```` subfolder as described [here](https://code.google.com/p/gtm-http-fetcher/wiki/GTMHTTPFetcherIntroduction#Adding_the_Fetcher_to_Your_Project).

Next, go to [Google Developer Console](https://console.developers.google.com/) and create a new project. In the  ````APIs```` section, enable the APIs as the shown below:

![apis](https://lh6.googleusercontent.com/-1p19rUbv-5M/VKkWQVL9eOI/AAAAAAAAFBc/x9KVxHF9elA/w1157-h364-no/apis.png)


In the ````Credentials```` section, choose ````Create new Client ID```` for ````Installed Application```` similar to:

![credentials](https://lh3.googleusercontent.com/-V8h0pVBGuBs/VKkWQSGo4BI/AAAAAAAAFBY/FPVwt1Kkbgc/w1155-h665-no/ids.png)

Now go back to your XCode project, and replace the placehoders in your ````GoogleAPIKeys.plist```` with the generated values of ````Client ID```` and ````Client Secret````.

And that's pretty much it!


# Sample Project
The sample project is an universal iOS8 app that runs in both iPhone and iPad simulators. Its main purpose is to show typical usage of ````Obj-C-FusionTables```` for common Fusion Tables operations such as listing tables, creating a table, setting Map styles, adding InfoWindow templates, selecting table rows, executing SQL queries, sharing your fusion tables, etc. For your existing Fusion Tables data safety, only the tables created within the sample app can be modified.

To run the sample project, you need to follow to the above installation instructions, filling in <b>your own Google API key</b> values in  the ````GoogleAPIKeys.plist````.

# Usage
* [Install Obj-C-FusionTables](https://github.com/akpw/Obj-C-FusionTables#installation), filling in <b>your own Google API key</b> values in  the ````GoogleAPIKeys.plist```` as described above
* Take a quick look at the Obj-C-FusionTables classes to famiiarize yourself with the concepts. If you already have some level of experience with [Google Fusion Tables API v2.0](https://developers.google.com/fusiontables/docs/v2/reference/), things should be mostly self-explanatory.
* ````FTTable```` class is the Objective-C representation of the [Fusion Table resource](https://developers.google.com/fusiontables/docs/v2/reference/#Table), with corresponding methods such as ````list....````, ````insert....````, ````update....````, ````delete....````.
* The same applies to other Fusion Tables resources such as Templates and Styles, represented by the ````FTTemplate```` and ````FTStyle```` classes
* ````FTSQLQuery```` class represents the Fusion Table SQL query resource and has corresponding methods such as ````select...````, ````insert...````, ````update...````, ````delete...````.
* ````FTSQLQueryBuilder```` helps build SQL statements for various SQL queries.
* ````GoogleAuthorizationController```` class conviniently wraps around Google Authentication library, providing simple ways to sign-in / sign-out and authenticating general requests to Google Services.
* ````GoogleServicesHelper```` provides an easy & light-weight access to related Google serivces such as URL Shortener or Google Drive ACL (while libraries such as [Google APIs Client](https://code.google.com/p/google-api-objectivec-client/) already cover these other services in greater depth they also require non-trivial installation & introduce yet another set of APIs).

# A few quick code samples
* read a list of Fusion Tables

````
FTTable *ftTable = [[FTTable alloc] init];
ftTable.ftTableDelegate = self;
[ftTable listFusionTablesWithCompletionHandler:^(NSData *data, NSError *error) {
	if (error) {
	    NSString *errorStr = [SimpleGoogleServiceHelpers remoteErrorDataString:error];
	    NSLog(@"Error Listing Fusion Tables: %@", errorStr);
	} else {
	    NSDictionary *ftItems = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:nil];
        NSArray *ftTableObjects = [NSMutableArray arrayWithArray:ftItems[@"items"]];
        for (NSDictionary *ftTable in ftTableObjects) {
        	NSLog(@"Table Name: %@", ftTable[@"name"]);
			NSLog(@"Table ID: %@", ftTable[@"tableId"]);
		}
	}
}];
````


* insert a new Fusion Table

````
FTTable *ftTable = [[FTTable alloc] init];
ftTable.ftTableDelegate = self;
[ftTable insertFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
    if (error) {
        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"Error Inserting Fusion Table: %@", errorStr);
    } else {
        NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions error:nil];
		NSLog(@"Inserted a new Fusion Table: %@", contentDict);
    }
}];
````

* delete a Fusion Table

````
FTTable *ftTable = [[FTTable alloc] init];
ftTable.ftTableDelegate = self;
[ftTable deleteFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
    [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
    if (error) {
        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Error Deleting Fusion Table: %@", errorStr);
    }
}];
````

Similar coding patterns work for Fusion Tables Templates and Styles.

* Insert Fusion Table rows

````
FTSQLQuery *ftSQLQuery = [[FTSQLQuery alloc] init];
ftSQLQuery.ftSQLQueryDelegate = self;
[ftSQLQuery sqlInsertWithCompletionHandler:^(NSData *data, NSError *error) {
    if (error) {
        NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
        NSLog (@"Error Inserting Fusion Table Style: %@", errorStr);
    } else {
        NSDictionary *responceDict = [NSJSONSerialization
                                      JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray *rows = responceDict[@"rows"];
        if (rows) {
            NSLog(@"Inserted %d %@", [rows count], ([rows count] == 1) ? @"row" : @"rows");
            NSLog(@"%@", rows);
            NSUInteger lastInsertedRowID = [(NSString *)((NSArray *)[rows lastObject])[0] intValue];
        } else {
            NSLog (@"Error processing Insert Rows responce");
        }
    }
}];
````

* Delete Fusion Table rows

````
FTSQLQuery *ftSQLQuery = [[FTSQLQuery alloc] init];
ftSQLQuery.ftSQLQueryDelegate = self;
[ftSQLQuery sqlDeleteWithCompletionHandler:^(NSData *data, NSError *error) {
    if (error) {
        NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
        STFail (@"Error Inserting Fusion Table Style: %@", errorStr);
    } else {
        NSDictionary *responceDict = [NSJSONSerialization
                                      JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray *rows = responceDict[@"rows"];
        if (rows) {
            NSUInteger numRowsDeleted = [(NSString *)((NSArray *)[rows lastObject])[0] intValue];
            NSLog(@"Deleted %d %@", numRowsDeleted, (numRowsDeleted == 1) ? @"row" : @"rows");
        } else {
            NSLog (@"Error processing Delete Rows responce");
        }
    }
}];
````


# The Delegates
After a brief glance on e.g. the Delete Table code above, one question might probably be "OK but where the heck is the table ID coming from? a property or what?" Well, as ```FTTable``` class is a representation of a stateless web resource a more logical way of handling parametrization is via a delegate. The ```FTTable``` delegate is defined as follows:

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

````FTSQLQuery```` delegate is slightly different though essentially follows the same design pattern:

````
@protocol FTSQLQueryDelegate <NSObject>
@optional
- (NSString *)ftSQLSelectStatement;
- (NSString *)ftSQLInsertStatement;
- (NSString *)ftSQLUpdateStatement;
- (NSString *)ftSQLDeleteStatement;
@end
````

A simple way to learn more about implementing specific delagates is via looking at the sample project. While obviously it requires some level of the [Fusion Tables API](https://developers.google.com/fusiontables/docs/v2/reference/) knowledge, the Objective-C part of it as quite straightforward. A quick code sample:

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

Another way to learn the API is of course via taking a look at the ````Obj-C-FusionTablesTests```` (see below).


# The Tests
The tests are intended to  cover all essential Obj-C-FusionTables API operations.  The test cases go from creating a table / style / template / inserting sample rows through cleaning everything up and restoring the tested Google account to its initial state.


# Compatibility
GroupedUITableViews requires ARC and are optimised for iOS8 and above.


