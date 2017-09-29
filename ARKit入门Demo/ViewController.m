//
//  ViewController.m
//  ARKit入门Demo
//
//  Created by user on 2017/9/25.
//  Copyright © 2017年 陈泽槟. All rights reserved.
//

#import "ViewController.h"
#import "CatchPlaneController.h"
#import "ChairViewController.h"
#import "PlanetController.h"
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
- (IBAction)catchPlaneClicked:(UIButton *)sender {
    //创建自定义AR控制器
    CatchPlaneController *vc = [[CatchPlaneController alloc] init];
    //跳转
    [self presentViewController:vc animated:YES completion:nil];}

- (IBAction)chairClicked:(UIButton *)sender {
    //创建自定义AR控制器
    ChairViewController *vc = [[ChairViewController alloc] init];
    //跳转
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)planteClicked:(UIButton *)sender {
    //创建自定义AR控制器
    PlanetController *vc = [[PlanetController alloc] init];
    //跳转
    [self presentViewController:vc animated:YES completion:nil];

}

@end
