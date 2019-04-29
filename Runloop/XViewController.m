//
//  ViewController.m
//  Runloop
//
//  Created by xiekunpeng on 2019/4/28.
//  Copyright © 2019 xboker. All rights reserved.
//

#import "XViewController.h"

static BOOL shouldRun = YES;

@interface XViewController ()
@property (nonatomic, strong) NSThread *thread1;
@property (nonatomic, strong) NSThread *thread2;


@end

@implementation XViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    // Do any additional setup after loading the view.
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(threadMethod1) onThread:self.thread1 withObject:nil waitUntilDone:YES];
    [self performSelector:@selector(threadMethod2) onThread:self.thread2 withObject:nil waitUntilDone:YES];
}




- (void)threadMethod1 {
    NSLog(@"常驻线程操作1 %@", [NSThread currentThread]);
}


- (void)threadMethod2 {
    NSLog(@"常驻线程操作2 %@", [NSThread currentThread]);
}




- (void)runThread1 {
    ///创建一个source     这里为什么这样写?
    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    ///当一个runloop中没有事件源处理时, 运行完就会退出;
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    ///1. 2. 创建runloop 同时向runloop中的defaultMode下面添加source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    ///3. 启动runloop
    while (shouldRun) {
        @autoreleasepool {
            ///令当前的runloop运行在defaultMode下
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e20, true);
        }
    }
    ///某个时机, 将静态变量shouldRun = NO时, 退出runloop, 进而退出线程;
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
}


- (void)runThread2 {
    @autoreleasepool {
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}

#pragma mark getter
- (NSThread *)thread1 {
    @synchronized (self) {
        if (!_thread1) {
            _thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
            [_thread1 start];
        }
        return  _thread1;
    }
}

- (NSThread *)thread2 {
    @synchronized (self) {
        if (!_thread2) {
            _thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread2) object:nil];
            [_thread2 start];
        }
        return  _thread2;
    }
}



- (void)dealloc {
    NSLog(@"%@------dealloc", self.class);
}



@end
