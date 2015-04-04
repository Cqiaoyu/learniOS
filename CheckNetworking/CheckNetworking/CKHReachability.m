//
//  CKHReachability.m
//  CheckNetworking
//
//  Created by cenkh on 15/4/1.
//  Copyright (c) 2015年 cenkh. All rights reserved.
//

#import "CKHReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <sys/socket.h>
#include <netinet/in.h>

@implementation CKHReachability{
    SCNetworkReachabilityRef reachability;
    SCNetworkReachabilityFlags connectionFlags;
}
-(void)pingReachabilityInternal{
    if (!reachability) {
        BOOL ignoresAdHocWiFi = NO;
        struct sockaddr_in ipAddress;
        bzero(&ipAddress, sizeof(ipAddress));   //置空（初始化）
        ipAddress.sin_len = sizeof(ipAddress);  //长度关系
        ipAddress.sin_family = AF_INET;         //协议簇
        ipAddress.sin_addr.s_addr = htonl(ignoresAdHocWiFi ? INADDR_ANY : IN_LINKLOCALNETNUM);
        
        /*
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
         */
        
        reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *)&ipAddress);
        CFRetain(reachability);
    
    }
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(reachability, &connectionFlags);
    if (!didRetrieveFlags) {
        NSLog(@"Error");
    }
}

-(BOOL)networkAvailable{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self pingReachabilityInternal];
    BOOL isReachable = (connectionFlags&kSCNetworkFlagsReachable) != 0;
    BOOL needsConnection = ((connectionFlags&kSCNetworkFlagsConnectionRequired) != 0);
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    return (isReachable && !needsConnection) ? YES : NO;
    
}



@end
