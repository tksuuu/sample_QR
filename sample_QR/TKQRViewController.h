//
//  TKQRViewController.h
//  sample_QR
//
//  Created by tksuuu on 2014/01/17.
//  Copyright (c) 2014年 tksuuu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

@interface TKQRViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;

@end
