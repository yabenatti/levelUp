//
//  EditProfileViewController.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-07.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *editImageButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdateTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end
