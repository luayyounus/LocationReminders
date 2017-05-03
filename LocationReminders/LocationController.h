//
//  LocationController.h
//  LocationReminders
//
//  Created by Luay Younus on 5/2/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@protocol LocationControllerDelegate <NSObject>

-(void)locationControllerUpdatedLocation:(CLLocation *)location;

@end

@interface LocationController : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property(strong,nonatomic) NSMutableArray *allLocations;
@property (weak, nonatomic) id delegate;

+(instancetype)shared;
-(void)requestPermission;
//
//-(void)addLocation:(CLLocation *)location
//         forName:(NSString *)locationName
//      withRadius:(NSNumber *)radius;

@end
