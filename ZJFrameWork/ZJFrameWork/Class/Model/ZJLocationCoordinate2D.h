//
//  ZJLocationCoordinate2D.h
//  waimai
//
//  Created by DL on 14/11/24.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface ZJLocationCoordinate2D : NSObject
//纬度
@property(nonatomic,assign)CLLocationDegrees latitude;
//经度
@property(nonatomic,assign)CLLocationDegrees longitude;
+(ZJLocationCoordinate2D*)ZJLocationCoordinate2DFromCLLocationCoordinate2D:(CLLocationCoordinate2D)coor;

@end
