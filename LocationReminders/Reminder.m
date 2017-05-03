//
//  Reminder.m
//  LocationReminders
//
//  Created by Luay Younus on 5/3/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

@dynamic name;
@dynamic location;
@dynamic radius;

+(void)load{
    [super load];
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"Reminder";
}

@end
