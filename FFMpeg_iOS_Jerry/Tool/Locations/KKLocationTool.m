//
//  KKLocationServer.m
//  StarZone
//
//  Created by TinySail on 16/12/12.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKLocationTool.h"
#import <CoreLocation/CoreLocation.h>
#import "KKAlertView.h"
@interface KKLocationMonnitor : NSObject
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, copy) LocationRequestBlock block;
@property (nonatomic, assign) BOOL continus;
@end
@implementation KKLocationMonnitor

@end

@interface KKLocationTool()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL requestLocation;
@property (nonatomic, strong) NSMutableDictionary *monnitor;
@property (nonatomic, assign) BOOL continusUpdating;
@property (nonatomic, assign) BOOL locationgStart;
@property (nonatomic, assign) BOOL paraseLocaton;
@property (nonatomic, strong) NSRecursiveLock *monitorLock;
@property (nonatomic, assign) CLAuthorizationStatus status;
@end
@implementation KKLocationTool
+ (KKLocationTool *)sharedInstance
{
    static KKLocationTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KKLocationTool alloc] init];
        [instance commonInit];
    });
    return instance;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100.0f;
    }
    return _locationManager;
}
- (CLGeocoder *)geoCoder {
    if (_geoCoder == nil) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

- (void)commonInit
{
    _requestLocation = NO;
    _monnitor = [NSMutableDictionary dictionary];
    _continusUpdating = NO;
    _locationgStart = NO;
    _paraseLocaton = NO;
    _monitorLock = [[NSRecursiveLock alloc] init];
    self.locationManager.delegate = self;
}

- (void)authorFailPrompt
{
    
    [[[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
}

- (void)startLocationManager
{
    if (_locationgStart) {
        return;
    }
    self.status = [CLLocationManager authorizationStatus];
}
- (void)setStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            if (_requestLocation) {
                [self.locationManager startUpdatingLocation];
                _locationgStart = YES;
            }
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            _locationgStart = NO;
            _paraseLocaton = NO;
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(authorFailPrompt) object:nil];
            [self performSelector:@selector(authorFailPrompt) withObject:nil afterDelay:0.5];
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            if (_requestLocation) {
                [self.locationManager requestWhenInUseAuthorization];
                break;
            }
            break;
        }
        default:
            break;
    }
}
- (void)stopUpdatingLocation:(NSString *)identifier
{
    if (!identifier.length) return;
    
    [_monitorLock lock];
    KKLocationMonnitor *stopMonitor = nil;
    BOOL shouldStop = YES;
    for (NSString *identi in _monnitor) {
        KKLocationMonnitor *m = [_monnitor valueForKey:identi];
        if ([identi isEqualToString:identifier]) {
            stopMonitor = m;
        }
        shouldStop = shouldStop ? !m.continus : NO;
    }
    
    if (stopMonitor != nil) {
        [_monnitor removeObjectForKey:identifier];
    }
    
    if (shouldStop && _locationgStart) {
        [self.locationManager stopUpdatingLocation];
        _locationgStart = NO;
        _requestLocation = NO;
        _continusUpdating = NO;
    }
    
    [_monitorLock unlock];
}

- (void)stop
{
    if (_locationgStart) {
        [self.locationManager stopUpdatingLocation];
        [self.monnitor removeAllObjects];
        _locationgStart = NO;
        _requestLocation = NO;
    }
}

- (void)getCurrentLocation:(LocationRequestBlock)block continus:(BOOL)continus identifier:(nonnull NSString *)identifier
{
    [_monitorLock lock];
    if (identifier.length && block) {
        KKLocationMonnitor *monitor = [[KKLocationMonnitor alloc] init];
        monitor.block = block;
        monitor.continus = continus;
        monitor.identifier = identifier;
        [_monnitor setValue:monitor forKey:identifier];
        _requestLocation = YES;
        if (continus) {
            _continusUpdating = YES;
        }
        [self startLocationManager];
    }
    [_monitorLock unlock];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    self.status = status;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    if (_paraseLocaton) {
        return;
    }
    _paraseLocaton = YES;
    [self.geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSMutableString *currentLocation = [NSMutableString string];
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks firstObject];
            NSString *city = placeMark.locality;
            if (!city) {
                [currentLocation appendString:placeMark.administrativeArea];
                [currentLocation appendFormat:@" %@", placeMark.administrativeArea];
            }else
            {
                [currentLocation appendString:placeMark.administrativeArea];
                [currentLocation appendFormat:@" %@", placeMark.locality];
            }
        }else if (error == nil)
        {
            print(@"NO results were returned.");
        }else if (error != nil)
        {
            print(@"An error occurred = %@", error);
        }
        
        [_monitorLock lock];
        NSMutableArray *removeKeys = [NSMutableArray array];
        for (NSString *identi in _monnitor) {
            KKLocationMonnitor *m = [_monnitor valueForKey:identi];
            if (m.block) {
                m.block(currentLocation);
            }
            if (!m.continus) {
                [removeKeys addObject:m.identifier];
            }
        }
        if (removeKeys.count) {
            [_monnitor removeObjectsForKeys:removeKeys];
        }
        
        if (!_monnitor.count) {
            [manager stopUpdatingLocation];
            _locationgStart = NO;
            _requestLocation = NO;
            _continusUpdating = NO;
        }
        [_monitorLock unlock];
        _paraseLocaton = NO;
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        KKAlertView *alertView = [[KKAlertView alloc] init];
        alertView.message = @"定位失败,是否重新定位?";
        [alertView addOtherButtonWithTitle:@"确定" block:^{
            [manager startUpdatingLocation];
        }];
        [alertView addCancelButtonWithTitle:@"取消" block:^{
        }];
        [alertView show];
    }
    [manager stopUpdatingLocation];
}

@end
