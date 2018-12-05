//
//  KKKeyChainManager.m
//  StarZone
//
//  Created by TinySail on 16/7/4.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKKeyChainManager.h"
#import <Security/Security.h>
#import "NSString+RSA.h"
#import "KanKanUserDefine.h"
@interface KKKeyChainItem()
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;
@property (nonatomic, strong) NSMutableDictionary *keychainItemData;
@end
@implementation KKKeyChainItem
- (id)initWithAccount: (NSString *)account service:(NSString *) service;
{
    if (self = [super init])
    {
        _genericPasswordQuery = [[NSMutableDictionary alloc] init];
        
        [_genericPasswordQuery setObject:(__bridge_transfer id)kSecClassGenericPassword forKey:(__bridge_transfer id)kSecClass];
        [_genericPasswordQuery setObject:service     forKey:(__bridge_transfer id)kSecAttrService];
        [_genericPasswordQuery setObject:account ? account : kKeyChainItemDefaultAccount forKey:(__bridge_transfer id)kSecAttrAccount];
        // Use the proper search constants, return only the attributes of the first match.
        
        CFDictionaryRef outDictionary = NULL;
        
        if (! (SecItemCopyMatching((CFDictionaryRef)[self queryDictionary], ( CFTypeRef *)&outDictionary) == noErr))
        {
            // Stick these default values into keychain item if nothing found.
            [self resetKeychainItem];
        }
        else
        {
            // load the saved data from Keychain.
            self.keychainItemData = [self loadItemDataWithQueryDict:(__bridge NSDictionary *)(outDictionary)];
        }
    }
    
    return self;
}
- (NSDictionary *)queryDictionary
{
    NSMutableDictionary *tempQuery = [_genericPasswordQuery mutableCopy];
    [tempQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    [tempQuery setObject:(__bridge_transfer id)kCFBooleanTrue    forKey:(__bridge_transfer id)kSecReturnAttributes];
    return tempQuery;
}
- (void)setObject:(id)inObject forKey:(id)key
{
    if (inObject == nil) return;
    id currentObject = [_keychainItemData objectForKey:key];
    if (![currentObject isEqual:inObject])
    {
        [_keychainItemData setObject:inObject forKey:key];
        [self writeToKeychain];
    }
}

- (id)objectForKey:(id)key
{
    return [_keychainItemData objectForKey:key];
}

- (void)resetKeychainItem
{
    OSStatus junk = noErr;
    if (!_keychainItemData)
    {
        self.keychainItemData = [[NSMutableDictionary alloc] init];
    }
    else if (_keychainItemData)
    {
        junk = SecItemDelete((CFDictionaryRef)_genericPasswordQuery);
        if (junk == noErr || junk == errSecItemNotFound) {
            
        }else
        {
            NSLog(@"Problem deleting current dictionary.");
        }
    }
}

- (NSMutableDictionary *)loadItemDataWithQueryDict:(NSDictionary *)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary;
    NSMutableDictionary *tempQuery = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the proper search key and class attribute.
    [tempQuery setObject:(__bridge_transfer id)kCFBooleanTrue           forKey:(__bridge_transfer id)kSecReturnData];
    [tempQuery setObject:(__bridge_transfer id)kSecClassGenericPassword forKey:(__bridge_transfer id)kSecClass];
    
    // Acquire the password data from the attributes.
    CFDataRef passwordData = nil;
    if (SecItemCopyMatching((CFDictionaryRef)tempQuery, (CFTypeRef *)&passwordData) == noErr)
    {
        returnDictionary = (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData * _Nonnull)(passwordData)];
    }
    else
    {
        // Don't do anything if nothing is found.
        NSLog(@"Serious error, no matching item found in the keychain.\n");
    }
    return returnDictionary;
}

- (void)writeToKeychain
{
    CFDictionaryRef attributes = NULL;
    NSMutableDictionary *updateItem = NULL;
    NSMutableDictionary *newItem = NULL;
    OSStatus result;
    
    if (SecItemCopyMatching((CFDictionaryRef)[self queryDictionary], (CFTypeRef *)&attributes) == noErr)
    {
        // First we need the attributes from the Keychain.
        updateItem = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary * _Nonnull)(attributes)];
        // Second we need to add the appropriate search key/values.
        [updateItem setObject:[_genericPasswordQuery objectForKey:(__bridge_transfer id)kSecClass] forKey:(__bridge_transfer id)kSecClass];

        // Lastly, we need to set up the updated attribute list being careful to remove the class.
        newItem = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary * _Nonnull)(attributes)];
        [newItem setObject:[NSKeyedArchiver archivedDataWithRootObject:_keychainItemData] forKey:(__bridge_transfer id)kSecValueData];
        [newItem removeObjectForKey:(__bridge_transfer id)kSecClass];
        // An implicit assumption is that you can only update a single item at a time.
        result = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)newItem);
        if (result != noErr) {
            NSLog(@"Couldn't update the Keychain Item.");
        }
    }
    else
    {
        // No previous item found; add the new one.
        // Lastly, we need to set up the updated attribute list being careful to remove the class.
        newItem = [NSMutableDictionary dictionaryWithDictionary:_genericPasswordQuery];
        [newItem setObject:[NSKeyedArchiver archivedDataWithRootObject:_keychainItemData] forKey:(__bridge_transfer id)kSecValueData];
        // An implicit assumption is that you can only update a single item at a time.
        result = SecItemAdd((CFDictionaryRef)newItem, NULL);
        if (result != noErr) {
            NSLog(@"Couldn't add the Keychain Item.");
        }
    }
}

@end


@implementation KKKeyChainManager
static NSMutableDictionary *keyChainItems;
static NSString *kKeyChainUnityServiceKey = @"device_unity";
+ (void)initialize
{
    keyChainItems = [NSMutableDictionary dictionary];
}

+ (KKKeyChainItem *)getUnityKeyChainItem
{
    KKKeyChainItem *item = [keyChainItems valueForKey:kKeyChainItemDefaultAccount];
    if (!item) {
        item = [[KKKeyChainItem alloc] initWithAccount:kKeyChainItemDefaultAccount service:kKeyChainUnityServiceKey];
        [keyChainItems setValue:item forKey:kKeyChainItemDefaultAccount];
    }
    return item;
}

+ (NSString *)getUUIDString
{
    KKKeyChainItem *item = [self getUnityKeyChainItem];
    NSString *uuidKey = @"device_uuid_sign";
    NSString *uuid = (NSString *)[item objectForKey:uuidKey];
    if (!uuid || !uuid.length ) {
        uuid = [NSUUID UUID].UUIDString;
        if (uuid && uuid.length) {
            
            NSString * md5DeviceID = [uuid md5Encrypt];
            NSString * rawKey = [KanKanUser_RandomKey md5Encrypt];
            NSString * sign = [md5DeviceID stringByAppendingString:@"com.kankan.KKStarZone"];
            NSString * sign1 = [sign stringByAppendingFormat:@"%d%@",KanKanUser_BusinessType_Iphone,rawKey];
            NSString * encryStr = [[sign1 sha1Encrypt] md5Encrypt];
            NSString * deviceIdSing = [NSString stringWithFormat:@"div100.%@%@",md5DeviceID,encryStr];
            
            [item setObject:deviceIdSing forKey:uuidKey];
        }
    }
    return uuid;
}

@end
