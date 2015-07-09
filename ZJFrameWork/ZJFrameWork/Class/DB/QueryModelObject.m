//
//  QueryModelObject.m
//  waimai
//
//  Created by DL on 14/12/1.
//
//

#import "QueryModelObject.h"

@implementation QueryModelObject
-(id)init
{
    self = [super init];
    if (self) {
        self.isOverDue = YES;
    }
    return self;
}
@end
