//
//  ViewController.h
//  SocketClient
//
//  Created by cenkh on 15/4/6.
//  Copyright (c) 2015年 cenkh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSStreamDelegate>{
    int flag;
}
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (strong, nonatomic)NSInputStream *inputStream;
@property (strong, nonatomic)NSOutputStream *outputStream;

@end

