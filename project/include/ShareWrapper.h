#ifndef SHARE_WRAPPER_H
#define SHARE_WRAPPER_H

#import <Foundation/Foundation.h>
#import <FBSDKShareKit/FBSDKSharing.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>

#include <hx/CFFI.h>

@interface ShareWrapper : NSObject<
    FBSDKSharingDelegate
>
@end

@class ShareWrapper;

namespace facebookExt {
    
    FBSDKShareDialog* mShareDialog;
    UIViewController* mShareViewController;
    
    AutoGCRoot* shareSuccessCb = 0;
    AutoGCRoot* shareFailCb = 0;
    AutoGCRoot* shareCancelCb = 0;
    
    static void initShare(value onShareSuccess, value onShareFail, value onShareCancel);
    static void shareLink(value contentURL, value contentTitle, value imageURL, value contentDescription);
    
    DEFINE_PRIM(initShare, 3);
    DEFINE_PRIM(shareLink, 4);

}

#endif