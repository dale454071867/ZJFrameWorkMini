//
//  ITTBaseModelObject.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*!
 *	The Super class of all custom model. All type of property must be NSObject type
 */
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
@interface ITTBaseModelObject : NSObject <NSCoding, NSCopying>
{
}

- (id)initWithDataDic:(NSDictionary*)data;

/*!
 *	Subclass must override this method, otherwise app will crash if call this methods
 *	Key-Value pair by dictionary key name and property name.
 *	key:    property name
 *	value:  dictionary key name
 *	\returns a dictionary key-value pair by property name and key of data dictionary
 */
- (NSDictionary*)attributeMapDictionary;

/*!
 *	You can implement this. Default implementation nil is returned
 */
- (NSString*)customDescription;

- (NSData*)getArchivedData;

- (NSDictionary*)propertiesAndValuesDictionary;

@end
@interface SubStringHelper : NSObject
@property(nonatomic,copy)NSString* substring;
@property(nonatomic,assign)BOOL before;
@property(nonatomic,assign)BOOL keepsubstring;
@property(nonatomic,assign)NSStringCompareOptions CompareOptions;
-(id)initWithSubString:(NSString*) _substring before:(BOOL)_before keepsubstring:(BOOL)_keepsubstring NSStringCompareOptions:(NSStringCompareOptions) CompareOptions;
//关键字，取前面还是后面，是否保留关键字,是否从后搜
@end
