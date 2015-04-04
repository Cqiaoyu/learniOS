//
//  ViewController.m
//  AutoLayoutDemo-03
//
//  Created by cenkh on 15/4/4.
//  Copyright (c) 2015年 cenkh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    UIView *yellowView;
    UIView *redView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testAutoLayoutWithNSLayoutConstraint];
    [self testVFL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//NSLayoutConstraint
-(void)testAutoLayoutWithNSLayoutConstraint{
    redView = [[UIView alloc]init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;     //非常重要，AutoLayout 与 Autoresizing 不兼容
    [self.view addSubview:redView];
    //约束
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:40];
    [redView addConstraint:height];
    [self.view addConstraint:top];
    [self.view addConstraint:left];
    [self.view addConstraint:right];
    
    
    yellowView = [[UIView alloc] init];
    yellowView.backgroundColor = [UIColor yellowColor];
    yellowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:yellowView];
    
    //黄色视图的约束
    NSLayoutConstraint *yeHeigth = [NSLayoutConstraint constraintWithItem:yellowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *yeWidth = [NSLayoutConstraint constraintWithItem:yellowView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    NSLayoutConstraint *yeTop = [NSLayoutConstraint constraintWithItem:yellowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    NSLayoutConstraint *yeRight = [NSLayoutConstraint constraintWithItem:yellowView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [self.view addConstraint:yeHeigth];
    [self.view addConstraint:yeWidth];
    [self.view addConstraint:yeTop];
    [self.view addConstraint:yeRight];
    
    
    
}

//VFL
-(void)testVFL{
    UIView *blueView = [[UIView alloc]init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:blueView];
    
    //蓝色视图相对于黄色视图左边20和红色视图的上边100以及父视图的左边20来进行约束
    NSArray *blueH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[blueView]-20-[yellowView]" options:0 metrics:nil views:@{@"yellowView":yellowView,@"blueView":blueView}];
    NSArray *blueV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[redView]-100-[blueView(==redView)]" options:0 metrics:nil views:@{@"redView":redView,@"blueView":blueView}];
    [self.view addConstraints:blueV];
    [self.view addConstraints:blueH];
}



@end
