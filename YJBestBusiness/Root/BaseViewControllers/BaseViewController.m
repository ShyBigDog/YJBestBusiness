//
//  BaseViewController.m
//  YJBestBusiness
//
//  Created by 郑少钦 on 2017/7/19.
//  Copyright © 2017年 YJBest. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && _isBackButton) {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ss_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        [barItem setTintColor:[UIColor grayColor]];
        self.navigationItem.leftBarButtonItem = barItem;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    else
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
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
