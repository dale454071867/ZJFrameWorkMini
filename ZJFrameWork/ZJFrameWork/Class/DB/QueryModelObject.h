//
//  QueryModelObject.h
//  waimai
//
//  Created by DL on 14/12/1.
//
//

#import "ITTBaseModelObject.h"

@interface QueryModelObject : ITTBaseModelObject
@property(nonatomic,assign)BOOL isOverDue;
@property(nonatomic,strong)id data;
@end
