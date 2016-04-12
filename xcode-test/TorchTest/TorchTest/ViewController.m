//
//  ViewController.m
//  TorchTest
//
//  Created by Malcolm Bailey on 07/04/2016.
//  Copyright © 2016 MBX Ltd. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    double torchLevel = 1.0;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (torchLevel <= 0.0) {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        else {
            if (torchLevel >= 1.0)
                torchLevel = AVCaptureMaxAvailableTorchLevel;
            BOOL success = [device setTorchModeOnWithLevel:torchLevel   error:nil];
        }
        [device unlockForConfiguration];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
