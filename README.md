![obj-c](https://lh6.googleusercontent.com/-8D0zRsFyC98/VKbxYKNIzoI/AAAAAAAAFA4/9laOrutdy04/w1157-h707-no/u3.png)


[Google Fusion Tables](http://www.google.com/drive/apps.html#fusiontables) is a powerful combination of a big web store and variety of ways to access and visualize the data. While still marked as 'experimental', it has reached its maturity with [Fusion Tables API v2.0](https://developers.google.com/fusiontables/) and offers developers clean & easy ways to enrich their apps across variety of development platforms.

One potential obstacle for using Fusion Tables in iOS apps is that there is no official, dedicated Objective-C API.

Obj-C-FusionTables is an easy and ready-to-use solution for integrating Fusion Tables into iOS apps, built entirely on top of the Google gtm-oauth2 and gtm-session-fetcher libraries.


# Blog
[Obj-C-FusionTables](http://www.akpdev.com/tags.html#Obj-C-FusionTables)


# Installation
Use [CocoaPods](https://github.com/akpw/Obj-C-FusionTables#cocoapods), or [Set up manually](https://github.com/akpw/Obj-C-FusionTables#manual)

###CocoaPods
Add Obj-C-FusionTables to your Project's Podfile:
````
target :MyApp do
    pod 'Obj-C-FusionTables'
end
````

Run ````pod update```` or ````pod install```` in your project directory.

###Manual
* Add all files from the ```Source/FusionTablesAPI``` and ```Source/GoogeService``` folders to  your project's target.
* Install [Google gtm-oauth2 library](https://github.com/google/gtm-oauth2)

## Setting up your Google Project
To communicate with Fusion Tables and other Google services, you need an OAuth 2.0 client ID that your application will use when requesting an OAuth 2.0 access token.

The OAuth 2.0 client ID for your project can be set up in the [Google Developers Console](https://console.developers.google.com) as described in details [here](https://support.google.com/cloud/answer/6158849?hl=en&ref_topic=6262490).


In the Google API sections of your project, enable the APIs as shown below:

![api](https://lh3.googleusercontent.com/H9g16IionLVpMpsz9dlQ8xpuu4ci2KiqV9qKwzcYC6l0qzYq3T7F9p2OjXdU7-XLBA-YscIQLjKxmQz10SlH32t1FVCaK1w4_Y52zg5HXk59YHql-qS5Q4q_vjFd5PDVSlyktd-fjE01t-l2Ccb9R05ALw2CPh2ZPUgAwpZYWNKorRzFubAmdMez9EUJZ245IjEVCnmwJiGnlr457AxOcrrmWtNclPDvlW7oHRYEUMjOr69iR5ygPVSM99f-rpEKPKflorTXHsdheAeyqicZbGOFr59ekVwl9-pIDHBeL8Z7mM7VxxVJkRz3G4COlpSKWEH9AWYYsSqhvPbHGJwx94OUhTGsXgE5I6GXN4ifGFO5JI2B_cbnpgE1xD9_JAmySLEwCtNdBGoTjMUp953f848a4TtOgzrXLDjy6yQyYYWJPfbu-rka6rFl5yxBaU6f8-09r_lR9pDIApf_Acuhp-GQWNRJSpsU0MYJ7-Qz_H8k0CsR4mLEz421cUuSoVZtawhuXcLTZtxKIAc33w3tV0BMTAS6JR3iJoEmxJrBqVUklt0mAG2vTrcORPCHmMxbfRIb=w896-h409-no)

Now back in your Xcode project, put this line of code at appropriate place  such as in the App's Delegate ````application:didFinishLaunchingWithOptions:```` method:
````
[[GoogleAuthorizationController sharedInstance] registerClientID:<YOUR-OAUTH2-CLIENT_ID>]
````


# Sample Project
The sample project is an universal iOS8 app that runs in both iPhone and iPad simulators. Its main purpose is to show typical usage of ````Obj-C-FusionTables```` for common Fusion Tables operations such as listing tables, creating a table, setting Map styles, adding InfoWindow templates, executing SQL queries, inserting and deleting rows, sharing your fusion tables, etc.

If you already have Fusion Tables in your Google account, they will show up in the sample app. To ensure safety of your data, only the tables created from within the sample app can be modified.

### Installing pods
In the sample project's directory, run:
````
$ pod install
````

### Googe Project Setup
To run the sample project, you need to follow to the above instructions on [setting up your Google project](https://github.com/akpw/Obj-C-FusionTables/blob/master/README.md#setting-up-your-google-project) and filling in <b>your own Google API key</b> in the App's Delegate ````application:didFinishLaunchingWithOptions:```` method.

### Trying Out via CocoaPods
In your terminal, run:
````
$ pod try Obj-C-FusionTables

````
After the project is opened in Xcode, go to the ````AppDelegate.m```` and fill in your Google API key in its ````application:didFinishLaunchingWithOptions:```` method.



# Usage
* [Install Obj-C-FusionTables](https://github.com/akpw/Obj-C-FusionTables#installation) as described above
* Take a quick look at the Obj-C-FusionTables classes to familiarize yourself with the concepts. If you already have some level of experience with [Google Fusion Tables API v2.0](https://developers.google.com/fusiontables/docs/v2/reference/), things should be mostly self-explanatory.
* ````FTTable```` class is the Objective-C representation of the [Fusion Table resource](https://developers.google.com/fusiontables/docs/v2/reference/#Table), with corresponding methods such as ````list....````, ````insert....````, ````update....````, ````delete....````.
* The same applies to other Fusion Tables resources such as Templates and Styles, represented by the ````FTTemplate```` and ````FTStyle```` classes
* ````FTSQLQuery```` class represents the Fusion Table SQL query resource and has corresponding methods such as ````select...````, ````insert...````, ````update...````, ````delete...````.
* ````FTSQLQueryBuilder```` helps build SQL statements for various SQL queries.
* ````GoogleAuthorizationController```` class conveniently wraps around Google Authentication library, providing simple ways to sign-in / sign-out and authenticating general requests to Google Services.
* ````GoogleServicesHelper```` provides an easy & light-weight access to related Google services such as URL Shortener or Google Drive ACL. While libraries such as [Google APIs Client](https://code.google.com/p/google-api-objectivec-client/) already cover these in greater depth, they would also require non-trivial installation & would introduce yet another set of APIs.

## A few quick code samples
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
            NSLog (@"Error processing Insert Rows response");
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
            NSLog (@"Error processing Delete Rows response");
        }
    }
}];
````


## The Delegates
After a brief glance on e.g. the Delete Table code above, a first quick question might be "so where the heck is the table ID coming from?" Since ```FTTable``` class is a representation of a stateless web resource, a logical way of handling parametrization is via the delegation pattern. The ```FTTable``` delegate is defined as follows:

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

This way things are more flexible, letting you implement the delegate where it makes sense in your app rather than going into parameterizing / subclassing the ```FTTable``` class. A similar approach is used for other Obj-C-FusionTables core classes such as ````FTStyle```` and ````FTTemplate````.

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

A simple way to learn more about implementing specific delegates is via looking at the sample project. While obviously it requires some level of the [Fusion Tables API](https://developers.google.com/fusiontables/docs/v2/reference/) knowledge, the Objective-C part of it as quite straightforward. A quick code sample:

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
The tests are intended to  cover all essential Obj-C-FusionTables API operations. The test cases go from creating a table / style / template / inserting sample rows through cleaning everything up and restoring the tested Google account to its initial state.


# Compatibility
Obj-C-FusionTables requires ARC and are optimized for iOS8 and above.


