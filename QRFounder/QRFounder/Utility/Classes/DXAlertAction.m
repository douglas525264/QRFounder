//
//  DXAlertAction.m
//  QRFounder
//
//  Created by douglas on 2016/11/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXAlertAction.h"

#import <ReactiveCocoa.h>
@implementation DXAlertAction
+ (void)showAlertWithTitle:(NSString*)title msg:(NSString*)message inVC:(UIViewController *)vc  chooseBlock:(void (^)(NSInteger buttonIdx))block  buttonsStatement:(NSString*)cancelString, ...
{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:2];
    [argsArray addObject:cancelString];
    id arg;
    va_list argList;
    if(cancelString)
    {
        va_start(argList,cancelString);
        while ((arg = va_arg(argList,id)))
        {
            [argsArray addObject:arg];
        }
        va_end(argList);
    }
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //UIAlertController style
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for (int i = 0; i < [argsArray count]; i++)
        {
            UIAlertActionStyle style =  (0 == i)? UIAlertActionStyleCancel: UIAlertActionStyleDefault;
            // Create the actions.
            UIAlertAction *action = [UIAlertAction actionWithTitle:[argsArray objectAtIndex:i] style:style handler:^(UIAlertAction *action) {
                if (block) {
                    block(i);
                }
            }];
            [alertController addAction:action];
        }
        
        [vc presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (argsArray.count > 7)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"UIAlertView按钮过多，请修改源代码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //UIAlertView style
    
    UIAlertView* alertView = nil;
    
    switch ([argsArray count])
    {
        case 1:
        {
            alertView = [[UIAlertView alloc]initWithTitle:title message:message
                                                 delegate:nil cancelButtonTitle:cancelString otherButtonTitles:nil, nil];
        }
            break;
        case 2:
        {
            alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelString
                                        otherButtonTitles:argsArray[1], nil];
        }
            break;
        case 3:
        {
            alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelString
                                        otherButtonTitles:argsArray[1],argsArray[2], nil];
        }
            break;
        case 4:
        {
            alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelString
                                        otherButtonTitles:argsArray[1],argsArray[2],argsArray[3], nil];
        }
            break;
        case 5:
        {
            alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelString
                                        otherButtonTitles:argsArray[1],argsArray[2],argsArray[3],argsArray[4], nil];
        }
            break;
        case 6:
        {
            alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelString
                                        otherButtonTitles:argsArray[1],argsArray[2],argsArray[3],argsArray[4], argsArray[5],nil];
        }
            break;
        case 7:
        {
            alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelString
                                        otherButtonTitles:argsArray[1],argsArray[2],argsArray[3],argsArray[4], argsArray[5],argsArray[6],nil];
        }
            break;
            
        default:
            break;
    }
    
    [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *clickIndex) {
        if (block) {
            block(clickIndex.integerValue);
        }
        
    }];
    [alertView show];
    //    [alertView showWithBlock:^(NSInteger buttonIdx)
    //     {
    //
    //         if (block) {
    //             block(buttonIdx);
    //         }
    //     }];


}

+ (UIViewController*)getTopViewController
{
    UIViewController *result = nil;
    
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
