//
//  main.m
//  SocketServer
//
//  Created by cenkh on 15/4/6.
//  Copyright (c) 2015年 cenkh. All rights reserved.
//

/**
    socket 服务端实现，使用CFNetWork
 */

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>



//定义socket回调
/**
    第一个回调方法是主入口的回调方法，是与socket直接绑定的回调方法，第二、第三个回调方法是在第一个回调
    方法中实现的
 */
void acceptCallBack(CFSocketRef,CFSocketCallBackType,CFDataRef,const void *, void *);
void writeStreamClientCallBack(CFWriteStreamRef,CFStreamEventType,void *);
void readStreamClientCallBack(CFReadStreamRef,CFStreamEventType, void *);
//socket 的端口号
#define PORT  9000


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 首先声明一个socket 引用
        CFSocketRef server;
        
        // 然后创建一个socket context 上下文
        CFSocketContext ctx = {0,NULL,NULL,NULL};
        
        // 然后创建一个之前声明的socket<server> 并配置协议簇和回调函数，这个回调函数就是上面声明的第一个回调函数.PF_INET:ipv4; PF_INET6: ipv6
        
        server = CFSocketCreate(NULL, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)acceptCallBack, &ctx);
        if (server == NULL) {
            return -1;
        }
        
        //设置是否重新绑定:第一个参数：获取本地socket对象，第二个级别：一般是SOL_SOCKET常量,第三个：Socket的属性名,SO_REUSEADDR 重用地址,第四个:指定设置属性的参数值，第五个:参数长度
        int yes = 1;
        setsockopt(CFSocketGetNative(server), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
        
        
        //设置端口和地址
        struct sockaddr_in addr;
        memset(&addr, 0, sizeof(addr));     //对指定的地址进行内存复制
        addr.sin_len = sizeof(addr);
        addr.sin_family = AF_INET;      //AF_INET   ：设置IPv4
        addr.sin_port = htons(PORT);    //htons函数 ：无符号短整数转换成『网络字节序』
        addr.sin_addr.s_addr = htonl(INADDR_ANY);       //htonl 无符号长整数转换成『网络字节序』
        
        
        //从指定字节缓冲区复制一个不可变的CFData对象
        
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr, sizeof(addr));
        
        //绑定Socket:将地址和Socket绑定
        if (CFSocketSetAddress(server, address) != kCFSocketSuccess) {
            NSLog(@"绑定失败");
            CFRelease(server);
            return -1;
        }
        
        //创建一个Run Loop Socket 源
        CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, server, 0);
        //将源添加到Run Loop 中
        CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
        CFRelease(sourceRef);
        //运行Run Loop
        CFRunLoopRun();
        
    }
    return 0;
}

// 回调
void acceptCallBack(CFSocketRef socket,
                    CFSocketCallBackType type,
                    CFDataRef address,
                    const void * data,
                    void *info){
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    //获取回调指针
    CFSocketNativeHandle sock = *(CFSocketNativeHandle *)data;
    
    //创建读写流
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, sock, &readStream, &writeStream);
    
    if (!readStream || !writeStream) {
        close(sock);
        return;
    }
    CFStreamClientContext steamCTX = {0,NULL,NULL,NULL,NULL};
    
    //注册两个流回调
    
    CFReadStreamSetClient(readStream, kCFStreamEventHasBytesAvailable, readStreamClientCallBack, &steamCTX);
    CFWriteStreamSetClient(writeStream, kCFStreamEventCanAcceptBytes, writeStreamClientCallBack, &steamCTX);
    
    //将流回调放进Run Loop 中
    CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    CFWriteStreamScheduleWithRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    
    CFReadStreamOpen(readStream);
    CFWriteStreamOpen(writeStream);
    
}
void writeStreamClientCallBack(CFWriteStreamRef stream,
                               CFStreamEventType type,
                               void * info){
    CFWriteStreamRef writeStream = stream;
    
    //写入
    UInt8 buff[] = "Hello,this is a test,just to learn socket ";
    if (NULL != writeStream) {
        CFWriteStreamWrite(writeStream, buff, strlen((const char *)buff) + 1);
        CFWriteStreamClose(writeStream);
        CFWriteStreamUnscheduleFromRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        writeStream = NULL;
    }
    
    
}
void readStreamClientCallBack(CFReadStreamRef stream,
                              CFStreamEventType type,
                              void * info){
    CFReadStreamRef readStream = stream;
    
    //读出
    UInt8 buff[255];
    if (readStream != NULL) {
        CFReadStreamRead(readStream, buff, sizeof(buff));
        CFReadStreamClose(readStream);
        CFReadStreamUnscheduleFromRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        readStream = NULL;
    }
    NSLog(@"rec:%s",buff);
}


