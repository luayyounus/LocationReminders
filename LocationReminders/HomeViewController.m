//
//  HomeViewController.m
//  LocationReminders
//
//  Created by Luay Younus on 5/1/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import "HomeViewController.h"

@import Parse;
@import MapKit;

@interface HomeViewController ()

@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property(strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestPermission];
    self.mapView.showsUserLocation = YES;
}

-(void)requestPermission{
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestAlwaysAuthorization];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)location1Pressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6566674, -122.351096);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}
- (IBAction)codeFellowsPressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6182169,-122.3529265);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
    
}
- (IBAction)canlisLocationPressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6430933,-122.3489422);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.);
    
    [self.mapView setRegion:region animated:YES];
}


@end
