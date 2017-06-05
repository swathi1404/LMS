//
//  ChangePasswordsViewController.m
//  LeaveManagement
//
//  Created by User on 7/19/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "ChangePasswordsViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>

@interface ChangePasswordsViewController ()

@end

@implementation ChangePasswordsViewController

//
//  changePasswordViewController.m
//  LeaveManagement
//
//  Created by User on 7/19/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
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
    
    oldPasswordLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 80, self.view.frame.size.width/2, 30)];
    oldPasswordLbl.textAlignment=NSTextAlignmentCenter;
    oldPasswordLbl.text=@"Old Password";
   // oldPasswordLbl.layer.masksToBounds = NO;
   //oldPasswordLbl.layer.shouldRasterize = YES;
    newPasswordLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 160, self.view.frame.size.width/2, 30)];
    newPasswordLbl.textAlignment=NSTextAlignmentCenter;
    newPasswordLbl.text=@"New Password";
    //newPasswordLbl.layer.shouldRasterize = YES;

    
    confirmPasswordLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 240, self.view.frame.size.width/2, 30)];
    confirmPasswordLbl.textAlignment=NSTextAlignmentCenter;
    confirmPasswordLbl.text=@"Confirm Password";
    //confirmPasswordLbl.layer.shouldRasterize = YES;

    
    oldPasswordTxtFld=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 80, (self.view.frame.size.width/2)-20, 30)];

    oldPasswordTxtFld.textAlignment=NSTextAlignmentCenter;
    oldPasswordTxtFld.backgroundColor=[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    oldPasswordTxtFld.borderStyle=UITextBorderStyleBezel;

    oldPasswordTxtFld.delegate=self;
    
    
    newPasswordTxtFld=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 160, (self.view.frame.size.width/2)-20, 30)];
    
    newPasswordTxtFld.textAlignment=NSTextAlignmentCenter;
    newPasswordTxtFld.backgroundColor=[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    newPasswordTxtFld.borderStyle=UITextBorderStyleBezel;
    newPasswordTxtFld.delegate=self;

    
    confirmPasswordTxtFld=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 240, (self.view.frame.size.width/2)-20, 30)];
    
    confirmPasswordTxtFld.textAlignment=NSTextAlignmentCenter;
    confirmPasswordTxtFld.backgroundColor=[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    confirmPasswordTxtFld.borderStyle=UITextBorderStyleBezel;
    confirmPasswordTxtFld.delegate=self;
    
    
    
    
    submit=[UIButton buttonWithType:UIButtonTypeCustom];
    [submit setBackgroundImage:[UIImage imageNamed:@"smallButton.jpeg"] forState:UIControlStateNormal];
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
    [submit setBackgroundColor:[UIColor redColor]];
    [submit addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    submit.frame=CGRectMake((self.view.frame.size.width/2)-40,320,80,30);
    [submit setUserInteractionEnabled:YES];

    [self.view addSubview:oldPasswordLbl];
    [self.view addSubview:newPasswordLbl];
    [self.view addSubview:confirmPasswordLbl];
    [self.view addSubview:oldPasswordTxtFld];
    [self.view addSubview:newPasswordTxtFld];
    [self.view addSubview:confirmPasswordTxtFld];
    [self.view addSubview:submit];
    
    
    
    
    [super viewWillAppear:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //user friendly for entry in textfields
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480)
        {
            //iPhone 4
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,-60,320,480);
            [UIView commitAnimations];
        }
        
        else if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            //iPhone 5
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,-30,320,568);
            [UIView commitAnimations];
            
        }
        
    }
    
    else
    {
        //[ipad]
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,60,320,480);
            [UIView commitAnimations];
            
        }
        
        else if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,60,320,568);
            [UIView commitAnimations];
        }
    }
    else
    {
        //[ipad]
    }
    
    [textField resignFirstResponder];
    return YES;
    
    
}

-(void)submitButtonAction:(id)sender
{
    if(oldPasswordTxtFld.text.length==0||newPasswordTxtFld.text.length==0||confirmPasswordTxtFld.text.length==0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please fill all the fields" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:^{
                //[self.navigationController popViewControllerAnimated:YES];
            }];
        });
    }
    else{
        
   if([newPasswordTxtFld.text isEqualToString:confirmPasswordTxtFld.text]){
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSLog(@"appDelegate.accessTokenString : %@",appDelegate.accessTokenString);
        NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/changePassword"];
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
    [dict setValue:newPasswordTxtFld.text forKey:@"password"];
   [request appendPostData:[[SBJsonWriter new] dataWithObject:dict]];
    request.tag=111;
    [request setDelegate:self];
    [request startAsynchronous];
        
   }
   else{
       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please check the passwords" preferredStyle:UIAlertControllerStyleAlert];
       [self presentViewController:alertController animated:YES completion:nil];
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [alertController dismissViewControllerAnimated:YES completion:^{
               //[self.navigationController popViewControllerAnimated:YES];
           }];
       });
   }
       
        
        
        
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationItem setTitle:@"Change Password"];
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
        NSLog(@"str %@",str);
        
            if ([str isEqualToString:@"Password Updated Successfully"]) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertController animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertController dismissViewControllerAnimated:YES completion:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }
            else{
                //Apply error message
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alertController dismissViewControllerAnimated:YES completion:^{
                        // [self.navigationController popViewControllerAnimated:YES];
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
