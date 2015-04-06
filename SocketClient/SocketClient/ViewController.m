//
//  ViewController.m
//  SocketClient
//
//  Created by cenkh on 15/4/6.
//  Copyright (c) 2015年 cenkh. All rights reserved.
//

#import "ViewController.h"

#define PORT  9000

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

-(void)initNetworkCommunication{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.106", PORT, &readStream, &writeStream);
    _inputStream = (__bridge_transfer NSInputStream *)readStream;
    _outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
    
}

- (IBAction)sendAction:(id)sender {
    flag = 0;
    [self initNetworkCommunication];
}
- (IBAction)recAction:(id)sender {
    flag = 1;
    [self initNetworkCommunication];
}

//NSStreamDelegate 方法
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSString *event;
    switch (eventCode) {
        case NSStreamEventNone:
            event = @"NSStreamEventNone";
            break;
        case NSStreamEventOpenCompleted:{
            
            break;
        }
        case NSStreamEventHasBytesAvailable:{
            //接收到数据
            if (flag == 1 && aStream == _inputStream) {
                NSMutableData *input = [[NSMutableData alloc]init];
                uint8_t buffer[1024];
                long len;
                while ([_inputStream hasBytesAvailable]) {
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        [input appendBytes:buffer length:len];
                    }
                }
                NSString *resultString = [[NSString alloc]initWithData:input encoding:NSUTF8StringEncoding];
                _showLabel.text = resultString;
            }
            break;
        }
        case NSStreamEventHasSpaceAvailable:{
            //发送
            if (flag == 0 && aStream == _outputStream) {
                UInt8 buffer[] = "Hello,Socket.Learn Socket";
                [_outputStream write:buffer maxLength:strlen((const char *)buffer + 1)];
                //关闭流输出
            }
            break;
        }
        case NSStreamEventErrorOccurred:{
            break;
        }
        case NSStreamEventEndEncountered:{
            break;
        }
        default:{
            [self close];
            break;
        }
    }
}
-(void)close{
    [_outputStream close];
    [_inputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream setDelegate:nil];
    [_inputStream setDelegate:nil];
}


@end
