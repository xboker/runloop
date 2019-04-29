//
//  ViewController.m
//  Runloop
//
//  Created by xiekunpeng on 2019/4/28.
//  Copyright © 2019 xboker. All rights reserved.
//

#import "ViewController.h"
#import "XViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (IBAction)pushAction:(UIButton *)sender {
    XViewController *vc = [[XViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
