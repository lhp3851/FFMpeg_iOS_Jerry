//
//  UIImage+Extension.m


#import "UIImage+Extension.h"
#import "SDWebImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVAsset.h>
@implementation UIImage(Extension)
- (UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

// 图像缩放。origineImage:原始图像，size：缩放之后的图像
+ (UIImage *)scaleImage: (UIImage *)origineImage outputSize:(CGSize)size
{
    if(origineImage == nil)  return nil;
    CGColorSpaceRef colorspacee = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width,  size.height, 8, 0, colorspacee, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);//kCGImageAlphaPremultipliedFirst
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    if(origineImage.imageOrientation != UIImageOrientationUp)
    {
        switch (origineImage.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, size.width, size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
                
            default:
                break;
        }
        
        switch (origineImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            default:
                break;
        }
        CGContextConcatCTM(context, transform);
    }
    
    switch (origineImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), origineImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), origineImage.CGImage);
            break;
    }
    
    CGImageRef shrunkref = CGBitmapContextCreateImage(context);
    UIImage *finial = [UIImage imageWithCGImage: shrunkref];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorspacee);
    CGImageRelease(shrunkref);
    
    return finial;
}


+ (instancetype)circleImageWithImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width;
    CGFloat imageH = oldImage.size.height;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    UIImage *reSizeImage = oldImage;
    // 5.小圆
    if (borderWidth) {
        CGContextFillPath(ctx); // 画圆
        CGFloat smallRadius = bigRadius - borderWidth;
        CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
        reSizeImage = [self scaleImage:oldImage outputSize:CGSizeMake(imageW - 2 * borderWidth, imageH - 2 * borderWidth)];
    }
    
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [reSizeImage drawInRect:CGRectMake(borderWidth, borderWidth, reSizeImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}


+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    return [self circleImageWithImage:oldImage borderWidth:borderWidth borderColor:borderColor];
}

+ (void)loadWebImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure
{
    
    __block id <SDWebImageOperation> webImageOperation;
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    webImageOperation = [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        float progress = receivedSize / (float)expectedSize;
        print(@"%@", [NSString stringWithFormat:@"%f",progress]);
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }
        else
        {
            if (success) {
                success(image);
            }
        }
        webImageOperation = nil;
    }];
}

+ (void)loadWebImageWithURL:(NSURL *)url successWithImage:(void (^)(UIImage *image, NSURL *url))success failure:(void (^)(NSError *error))failure
{
    __block id <SDWebImageOperation> webImageOperation;
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    
    webImageOperation = [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        float progress = receivedSize / (float)expectedSize;
        print(@"%@", [NSString stringWithFormat:@"%f",progress]);
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }
        else
        {
            if (success) {
                success(image, url);
            }
        }
        webImageOperation = nil;
    }];
}
/**
 *  剪切图片为正方形
 *
 *  @param image   原始图片比如size大小为(400x200)pixels
 *  @param newSize 正方形的size比如400pixels
 *
 *  @return 返回正方形图片(400x400)pixels
 */
+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        //image原始高度为200，缩放image的高度为400pixels，所以缩放比率为2
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        //设置绘制原始图片的画笔坐标为CGPoint(-100, 0)pixels
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    //创建画板为(400x400)pixels
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将image原始图片(400x200)pixels缩放为(800x400)pixels
    CGContextConcatCTM(context, scaleTransform);
    //origin也会从原始(-100, 0)缩放到(-200, 0)
    [image drawAtPoint:origin];
    
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//  颜色转换为背景图片(像素线)
+ (UIImage *)solidImageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)fixOrientation{
    return [self.class fixOrientation:self];
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (void)getThumbnailImageWithUrl:(NSURL*)url result:(void(^)(UIImage *image))result{
    ALAssetsLibrary *assetlibrary = [[ALAssetsLibrary alloc]init];
    [assetlibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        if (result) {
            UIImage *thumbImage = [UIImage imageWithCGImage:[asset thumbnail]];
            result(thumbImage);
        }
    } failureBlock:^(NSError *error) {
        if (result) {
            result(nil);
        }
    }];
}

+ (void)getImageWithUrl:(NSURL*)url result:(void(^)(UIImage*image))result{
    
    ALAssetsLibrary *assetlibrary = [[ALAssetsLibrary alloc]init];
    [assetlibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        if (result) {
            result([self getImageWithAsset:asset]);
        }
    } failureBlock:^(NSError *error) {
        if (result) {
            result(nil);
        }
    }];

}

+ (void)getThumbailImageAspect:(BOOL)aspect url:(NSURL*)url result:(void(^)(UIImage*image))result{
    
    ALAssetsLibrary *assetlibrary = [[ALAssetsLibrary alloc]init];
    [assetlibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        UIImage *rImage;
        if (aspect) {
            rImage = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        }else
            rImage = [UIImage imageWithCGImage:[asset thumbnail]];
        if (result) {
            result(rImage);
        }
    } failureBlock:^(NSError *error) {
        if (result) {
            result(nil);
        }
    }];
    
}

+ (UIImage *)getImageWithAsset:(ALAsset*)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    
    if(assetRep == nil) return nil;
    UIImage *img = [UIImage imageWithCGImage:assetRep.fullResolutionImage
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    img = [img fixOrientation];
    return img;
}

- (UIImage *)cropImageInRect:(CGRect)rect
{
    UIImage *fixImage = [self fixOrientation];
    CGFloat scale = fixImage.scale;
    rect.origin.x *= scale;
    rect.origin.y *= scale;
    rect.size.height *= scale;
    rect.size.width *= scale;
    UIImage *cropedImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(fixImage.CGImage, rect)];
    return cropedImage;
}

- (UIImage *)cropImageToSquare
{
    CGSize imageSize = self.size;
    CGRect cropRect;
    CGFloat initWidth = imageSize.width;
    CGFloat initHeight = imageSize.height;
    BOOL WH = initWidth > initHeight;
    CGFloat width = WH ? initHeight : initWidth;
    CGFloat x = WH ? (initWidth - width) / 2.0 : 0;
    CGFloat y = WH ? 0 : (initHeight - width) / 2.0;
    cropRect = CGRectMake(x, y, width, width);
    return [self cropImageInRect:cropRect];
}

- (UIImage *)drawShadowImage {
    UIImage *aImage = self;
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextClearRect(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height));
    CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
    CGContextAddRect(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height));
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithWhite:51 / 255.0 alpha:0.3] CGColor]);
    CGContextDrawPath(ctx, kCGPathFill);
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
