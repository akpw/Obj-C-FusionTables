Obj-C-FusionTables
==================

[Google Fusion Tables](http://www.google.com/drive/apps.html#fusiontables) is a powerful combination of a big web store with variety of ways to access and visualise the data. While marked as 'experimental', it has reached its maturity with [Fusion Tables API v1.0](https://developers.google.com/fusiontables/) and now offers developers clean and easy ways to improve their apps across variety of development platforms. 

One potential obstacle for Fusion Tables in iOS apps is there is no official, dedicated Google API Objective-C API. While the existing libraries such as [gtm-oauth2](https://code.google.com/p/gtm-oauth2/) and [gtm-http-fetcher](https://code.google.com/p/gtm-http-fetcher/) are well-written and provide all that is needed to work with Fusion Tables, being a general and a bit lower-level solution they can also put a lot of extra weight on developers's shoulders.

Obj-C-FusionTables is a light-weight set of classes for integrating Fusion Tables into iOS apps, built entirely on top of the gtm-oauth2 and gtm-http-fetcher libraries.
