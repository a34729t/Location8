//
//  ViewController.m
//  Location8
//
//  Created by Nicolas Flacco on 11/24/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "ViewController.h"
#import "BeaconEmulator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    [[BeaconEmulator sharedInstance] broadcastBeaconWithMajor:100 minor:500];
}

@end
