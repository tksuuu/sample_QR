//
//  TKQRViewController.m
//  sample_QR
//
//  Created by tksuuu on 2014/01/17.
//  Copyright (c) 2014年 tksuuu. All rights reserved.
//

#import "TKQRViewController.h"

@interface TKQRViewController ()

@end

@implementation TKQRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // セッションの生成
    _session = [AVCaptureSession new];
    
    // カメラの取得
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *device = nil;
    AVCaptureDevicePosition camera = AVCaptureDevicePositionBack;
    for (AVCaptureDevice *d in devices) {
        device = d;
        if (d.position == camera) {
            break;
        }
    }
    
    // インプット
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    [self.session addInput:input];
    
    
    // アウトプットのメタデータを作成
    AVCaptureMetadataOutput *metadataOutput = [AVCaptureMetadataOutput new];
    
    // デリゲート("- (void)captureOutput~~")の準備をする
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // アウトプットに追加
    [_session addOutput:metadataOutput];
    
    // 識別したいコードのタイプを指定する。今回は"QR"のみを指定
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    
    // セッションスタート
    [self.session startRunning];
    
    
    // 画面にプレビュー
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preview.frame = self.view.bounds;
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:preview];
    
}

// 認識をするデリゲートメソッド
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *data in metadataObjects) {
        
        // QRコードと認識されたとき
        if ([data.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            // stringとして取得！
            NSString *qrStr = [(AVMetadataMachineReadableCodeObject*)data stringValue];
            NSLog(@"%@", qrStr);
            
            // NSURLに変換して、URLとして認識可能なたときはSafariで開く
            NSURL *url = [NSURL URLWithString:qrStr];
            
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

// QRコードを生成してみる

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
