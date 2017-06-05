//
//  ForgotPasswordViewController.m
//  LeaveManagement
//
//  Created by User on 7/22/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize userNameLbl,userNameTextField,submitButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view.layer setShouldRasterize:YES];
    [self.view.layer setRasterizationScale:[UIScreen mainScreen].scale];
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationItem.hidesBackButton=TRUE;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg = [UIImage imageNamed:@"arrow-left_red.png"];
    [btn setImage:btnImg forState:UIControlStateNormal];
    
    btn.frame = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn] ;
    UIButton *logutbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg1 = [UIImage imageNamed:@"logout.jpeg"];
    [logutbtn setImage:btnImg1 forState:UIControlStateNormal];
    
    logutbtn.frame = CGRectMake(0, 0, btnImg1.size.width, btnImg1.size.height);
    [logutbtn addTarget:self action:@selector(logoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logutbtn] ;
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    self.view.frame=[UIScreen mainScreen].bounds;

    CGRect tabFrame=[UIScreen mainScreen].bounds;
    
    userNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(tabFrame.origin.x+20, 80,100, 30)];
    
    userNameLbl.textAlignment=NSTextAlignmentLeft;
    userNameLbl.text=@"UserName:";
    //userNameLbl.backgroundColor=[UIColor yellowColor];
    userNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(userNameLbl.frame.origin.x+userNameLbl.frame.size.width, 80, tabFrame.size.width-(userNameLbl.frame.size.width+40), 30)];
    
    //userNameTextField.backgroundColor=[UIColor redColor];
    userNameTextField.borderStyle=UITextBorderStyleBezel;
    userNameTextField.textAlignment=NSTextAlignmentLeft;
    
    submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"smallButton.jpeg"] forState:UIControlStateNormal];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setBackgroundColor:[UIColor redColor]];
    [submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.frame=CGRectMake((tabFrame.size.width/2)-40,170,80,30);
    [submitButton setUserInteractionEnabled:YES];
    
    [self.view addSubview:submitButton];
    [self.view addSubview:userNameTextField];
    [self.view addSubview:userNameLbl];
    
    
    
    
}
-(void)submitButtonAction:(id)sender{
    
    NSLog(@"USERNAME %@",userNameTextField.text);
    
    if (userNameTextField.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter the UserName" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:^{
                //[self.navigationController popViewControllerAnimated:YES];
            }];
        });

    }
    else{
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSLog(@"appDelegate.accessTokenString : %@",appDelegate.accessTokenString);
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/nonRest/forgetPassword"];
    NSLog(@"URL STRING %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Post method
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", appDelegate.accessTokenString];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:authValue];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setValue:userNameTextField.text forKey:@"userName"];
    [request appendPostData:[[SBJsonWriter new] dataWithObject:dict]];
    request.tag=111;
    [request setDelegate:self];
    [request startAsynchronous];
    }

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationItem setTitle:@"Forgot Password"];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:@"Helvetica Neue" size:14], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
-(void)goBack
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)logoutButtonAction:(id)sender{
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/logout?access_token=%@",appDelegate.accessTokenString];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.tag=111;
    
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    
    [request startAsynchronous];
    
}
-(void) requestFinished: (ASIHTTPRequest *) request {
    if (request.tag==111)
    {
   
      
        NSString *theJSON = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary* jsonDictionary = [parser objectWithString:theJSON error:nil];
        NSLog(@"Dictionary %@",jsonDictionary);
        NSString *str=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"response"]];
        NSLog(@"Password Sent : %@",str);
        
        if ([str isEqualToString:@"Password Sent"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Password sent successfully" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:^{
                
                 [self.navigationController popViewControllerAnimated:YES];
                
                
                
            }];
        });
           
        }
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter the valid username" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertController dismissViewControllerAnimated:YES completion:^{
                    
                    userNameTextField.text=@"";
                    
                    
                    
                }];
            });

        
        }
        
    }
    
    else{
        
        NSString *theJSON = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary* jsonDictionary = [parser objectWithString:theJSON error:nil];
        NSLog(@"Dictionary %@",jsonDictionary);
        NSString *str=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"response"]];
        NSLog(@"str %@",str);
        if([str isEqualToString:@"SUCCESS"])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
