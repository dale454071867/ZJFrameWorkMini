//
//  ZJLocationCoordinate2D.m
//  waimai
//
//  Created by DL on 14/11/24.
//
//

#import "ZJLocationCoordinate2D.h"

@implementation ZJLocationCoordinate2D
+(ZJLocationCoordinate2D*)ZJLocationCoordinate2DFromCLLocationCoordinate2D:(CLLocationCoordinate2D)coor
{
    ZJLocationCoordinate2D *zjlocation = [[ZJLocationCoordinate2D alloc] init];
    zjlocation.latitude = coor.latitude;
    zjlocation.longitude = coor.longitude;
    return zjlocation;
}


@end
