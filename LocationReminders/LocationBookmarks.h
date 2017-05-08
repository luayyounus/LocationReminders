//
//  LocationBookmarks.h
//  LocationReminders
//
//  Created by Luay Younus on 5/7/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface LocationBookmarks : NSObject

@property (strong, nonatomic) NSString* name;
@property (nonatomic) CLLocation *location;

-(id)initBookmarkLocationWithName:(NSString *)name andLocation:(CLLocation *)location;


@end
