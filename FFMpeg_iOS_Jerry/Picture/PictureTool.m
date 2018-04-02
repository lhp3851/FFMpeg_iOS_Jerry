//
//  PictureTool.m
//  FFMpeg_iOS_Jerry
//
//  Created by Jerry on 30/03/2018.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import "PictureTool.h"


@interface PictureTool()

@property(nonatomic,strong)UIImagePickerController *pickerController;


@end

@implementation PictureTool

static PictureTool *instance = nil;
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

+(instancetype)shareInstance{
    return [[self alloc] init];
}

-(UIImagePickerController *)pickerController{
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc]init];
        _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _pickerController.delegate = self;
        _pickerController.allowsEditing =true;
        _pickerController.videoMaximumDuration = 3.0;
        _pickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
        _pickerController.showsCameraControls =YES;
//        _pickerController.videoExportPreset = nil;
//        _pickerController.imageExportPreset = nil;
//        _pickerController.cameraOverlayView = nil;
//        _pickerController.cameraViewTransform = nil;
    }
    return _pickerController;
}

// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}




-(BOOL)isAbaliable{
    if (![UIImagePickerController isSourceTypeAvailable:self.pickerController.sourceType]) {
        return false;
    }
    return true;
}

-(void)getImageFromPhotoLibrary{
    
    [self.pickerController takePicture];
}

#pragma mark: UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:^{
        print(@"取消了选择图片");
    }];
}


@end
