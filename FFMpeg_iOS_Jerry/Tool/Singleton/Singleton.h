// .h
#define singleton_interface(class) + (instancetype)shared##class;

// .m
#define singleton_implementation(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
if (_instance == nil) {\
_instance = [super allocWithZone:zone]; \
}\
\
return _instance; \
} \
\
+ (instancetype)shared##class \
{ \
@synchronized(self) { \
_instance = [[class alloc] init]; \
} \
return _instance; \
}\
\
- (instancetype)copyWithZone:(NSZone *)zone \
{\
return [class shared##class];\
}\
- (instancetype)mutableCopyWithZone:(NSZone *)zone \
{\
return [class shared##class];\
}\

