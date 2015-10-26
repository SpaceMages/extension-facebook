#ifndef AccessTokenWrapper_h
#define AccessTokenWrapper_h

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>

#import <hx/CFFI.h>

@interface AccessTokenWrapper : NSObject
@end

namespace facebookExt {
    
    FBSDKAccessToken * mAccessToken;
    
    static value getCurrentToken();
    static value getUserId();
    static value getIsExpired();
    static value getPermissions();
    static value getDeclinedPermissions();
    
    DEFINE_PRIM(getCurrentToken, 0);
    DEFINE_PRIM(getUserId, 0);
    DEFINE_PRIM(getIsExpired, 0);
    DEFINE_PRIM(getPermissions, 0);
    DEFINE_PRIM(getDeclinedPermissions, 0);
    
}

#endif