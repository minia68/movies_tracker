#import "AtvChannelsPlugin.h"
#if __has_include(<atv_channels/atv_channels-Swift.h>)
#import <atv_channels/atv_channels-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "atv_channels-Swift.h"
#endif

@implementation AtvChannelsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAtvChannelsPlugin registerWithRegistrar:registrar];
}
@end
