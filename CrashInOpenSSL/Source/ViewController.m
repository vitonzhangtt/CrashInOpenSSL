//
//  ViewController.m
//  CrashInOpenSSL
//
//  Created by zhangchong on 2018/11/21.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

#import "ViewController.h"
#import "CIOWorkerThread.h"


@interface ViewController ()
@property(nonatomic, strong) NSMutableArray *threadPool;
@property(nonatomic, assign) NSUInteger poolSize;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.threadPool = [NSMutableArray array];
    self.poolSize = 8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Handlers
- (IBAction)onTouchStart:(id)sender {
    
    for (NSUInteger i = 0; i < self.poolSize; i++) {
        CIOWorkerThread *workerThread = [[CIOWorkerThread alloc] init];
        [self.threadPool addObject:workerThread];
    }
    
    for (NSUInteger i = 0; i < self.poolSize; i++) {
        CIOWorkerThread *worker = [self.threadPool objectAtIndex:i];
        [worker start];
    }
    
}

@end
