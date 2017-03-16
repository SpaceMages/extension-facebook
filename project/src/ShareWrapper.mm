#include "ShareWrapper.h"
#include <string>

#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>

#define safe_alloc_string(a) (alloc_string(a!=NULL ? a : ""))
#define safe_val_call0(func) if (func!=NULL) val_call0(func->get())
#define safe_val_call1(func, arg1) if (func!=NULL) val_call1(func->get(), arg1)
#define safe_val_string(str) str==NULL ? "" : std::string(val_string(str))

// if I don't add those line , prim are not found!
@implementation ShareWrapper

    - (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
    {
        val_call0(facebookExt::shareSuccessCb->get());
    }

    - (void)sharerDidCancel:(id<FBSDKSharing>)sharer
    {
        val_call0(facebookExt::shareCancelCb->get());
    }

    - (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
    {
        NSString * errorString = [error localizedDescription];
        const char * errorChar = [errorString UTF8String];
        val_call1(facebookExt::shareFailCb->get(), alloc_string(errorChar));
    }
@end

namespace facebookExt {
    
    static void initShare(value onShareSuccess, value onShareFail, value onShareCancel){
        
        if(onShareSuccess != NULL)
            shareSuccessCb = new AutoGCRoot(onShareSuccess);
        
        if(onShareFail != NULL)
            shareFailCb = new AutoGCRoot(onShareFail);
        
        if(onShareCancel != NULL)
            shareCancelCb = new AutoGCRoot(onShareCancel);
        
        mShareDialog = [[FBSDKShareDialog alloc] init];
        mShareViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    }
    
    static void shareLink(value pcontentURL, value pcontentTitle, value pimageURL, value pcontentDescription){
        const std::string contentURL          = safe_val_string(pcontentURL);
        const std::string contentTitle        = safe_val_string(pcontentTitle);
        const std::string imageURL            = safe_val_string(pimageURL);
        const std::string contentDescription  = safe_val_string(pcontentDescription);

        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:[NSString stringWithUTF8String:contentURL.c_str()]];
        if (contentTitle!="") {
          content.contentTitle = [NSString stringWithUTF8String:contentTitle.c_str()];
        }
        if (imageURL!="") {
          content.imageURL = [NSURL URLWithString:[NSString stringWithUTF8String:imageURL.c_str()]];
        }
        if (contentDescription!="") {
          content.contentDescription = [NSString stringWithUTF8String:contentDescription.c_str()];
        }

        int osVersion = [[NSProcessInfo processInfo] operatingSystemVersion].majorVersion;

        mShareDialog.fromViewController = mShareViewController;
        mShareDialog.shareContent = content;

        ShareWrapper *shareInstance = [[ShareWrapper alloc] init];

        mShareDialog.delegate = shareInstance;
        if (osVersion>=9) {
          mShareDialog.mode = FBSDKShareDialogModeFeedWeb;
        }
        [mShareDialog show];

    }

        
}