//
//  LocationBookmarks.m
//  LocationReminders
//
//  Created by Luay Younus on 5/7/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import "LocationBookmarks.h"

@implementation LocationBookmarks


-(id)initBookmarkLocationWithName:(NSString *)name andLocation:(CLLocation *)location{
    
    if(self){
        
        _name = name;
        _location = [location initWithLatitude:0 longitude:0];
    }
    return self;
}

@end
