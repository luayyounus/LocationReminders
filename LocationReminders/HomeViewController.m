//
//  HomeViewController.m
//  LocationReminders
//
//  Created by Luay Younus on 5/1/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import "HomeViewController.h"
#import "AddReminderViewController.h"
#import "LocationController.h"

@import Parse;
@import MapKit;

@interface HomeViewController()<LocationControllerDelegate,MKMapViewDelegate>

@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property(strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LocationController shared] requestPermission];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"AddReminderViewController"] && [sender isKindOfClass:[MKAnnotationView class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *) sender;
        
        AddReminderViewController *newReminderViewController = (AddReminderViewController *)segue.destinationViewController;
        
        newReminderViewController.coordinate = annotationView.annotation.coordinate;
        newReminderViewController.annotationTitle = annotationView.annotation.title;
        newReminderViewController.title = annotationView.annotation.title;
    }
}


- (IBAction)locationsButtonPressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6566674, -122.351096);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
    
    MKPointAnnotation *pinLoc = [[MKPointAnnotation alloc]init];
    
    if (self.mapView.annotations.count > 0) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }

    pinLoc.coordinate = coordinate;
    [self.mapView addAnnotation:pinLoc];
    

    
}

- (IBAction)userLongPressed:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        
        newPoint.coordinate = coordinate;
        newPoint.title = @"New Location";
        
        if (self.mapView.annotations.count > 0) {
            [self.mapView removeAnnotations:self.mapView.annotations];
        }
        [self.mapView addAnnotation:newPoint];
    }
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass: [MKUserLocation class]]) {
        return nil;
    }
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    annotationView.annotation = annotation;
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    [self randomPinColor:annotationView];
    
    UIButton *rightCalloutAccessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    annotationView.rightCalloutAccessoryView = rightCalloutAccessory;
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"Accessory tapped!");
    [self performSegueWithIdentifier:@"AddReminderViewController" sender:view];
}

- (void)locationControllerUpdatedLocation:(CLLocation *)location{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Random Color for Pin
-(void)randomPinColor:(MKPinAnnotationView *)annotationView{
    CGFloat red = arc4random() % 255/255.0;
    CGFloat green = arc4random() % 255/255.0;
    CGFloat blue = arc4random() % 255/255.0;
    UIColor *randomPinColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    annotationView.pinTintColor = randomPinColor;
}


@end
