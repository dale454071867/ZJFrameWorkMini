//
//  LocationMander.m
//  anyi
//
//  Created by 周杰 on 15/6/18.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import "LocationUtils.h"
#import "ITTObjectSingleton.h"
#import <UIKit/UIKit.h>
@interface LocationUtils()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,copy)void (^locationResultBlock)(ZJLocationCoordinate2D *location, NSError *error);
@end


@implementation LocationUtils

ITTOBJECT_SINGLETON_BOILERPLATE(LocationUtils, sharedManager)


+(void)starLocationResutl:(void (^)(ZJLocationCoordinate2D *location, NSError *error))locationResultBlock
{
    LocationUtils *location = [LocationUtils sharedManager];
    
    location.locationResultBlock = locationResultBlock;
    if (!location.locationManager) {
        location.locationManager = [[CLLocationManager alloc] init];
        location.locationManager.delegate = location;
        location.locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
        location.locationManager.distanceFilter = 100; //控制定位服务更新频率。单位是“米”
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [location.locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        }
    }
    
    [location.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];

    CLLocation * currLocation = [locations lastObject];
    ZJLocationCoordinate2D *location = [ZJLocationCoordinate2D ZJLocationCoordinate2DFromCLLocationCoordinate2D:currLocation.coordinate];
    self.locationResultBlock(location,nil);
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    self.locationResultBlock(nil,error);
}


@end
