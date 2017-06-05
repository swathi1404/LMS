//
//  ForgotPasswordViewController.h
//  LeaveManagement
//
//  Created by User on 7/22/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong)UILabel *userNameLbl;
@property(nonatomic,strong)UITextField *userNameTextField;
@property(nonatomic,strong)UIButton *submitButton;

@end
