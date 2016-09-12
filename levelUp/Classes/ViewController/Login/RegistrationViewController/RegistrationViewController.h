//
//  RegistrationViewController.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-08.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableDictionary *parameters;

@property (weak, nonatomic) IBOutlet UIView *petNameCornerView;
@property (weak, nonatomic) IBOutlet UILabel *petNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *petNameTextField;

@property (weak, nonatomic) IBOutlet UIView *beaconIdCornerView;
@property (weak, nonatomic) IBOutlet UILabel *beaconIdLabel;
@property (weak, nonatomic) IBOutlet UITextField *beaconIdTextField;

@property (weak, nonatomic) IBOutlet UIView *beaconMinorCornerView;
@property (weak, nonatomic) IBOutlet UILabel *beaconMinorLabel;
@property (weak, nonatomic) IBOutlet UITextField *beaconMinorTextField;

@property (weak, nonatomic) IBOutlet UIView *beaconMajorCornerView;
@property (weak, nonatomic) IBOutlet UILabel *beaconManjorLabel;
@property (weak, nonatomic) IBOutlet UITextField *beaconMajorTextField;

- (IBAction)registerButtonTouched:(id)sender;

@end
