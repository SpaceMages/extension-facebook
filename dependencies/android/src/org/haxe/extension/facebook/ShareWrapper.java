package org.haxe.extension.facebook;

import org.haxe.lime.HaxeObject;

import android.util.Log;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;

import android.net.Uri;

public class ShareWrapper {
	
	static HaxeObject mHaxeShareDialog;
	static ShareDialog mShareDialog;
	
	public static void init(HaxeObject obj){
		mHaxeShareDialog = obj;
		
		mShareDialog = new ShareDialog(Facebook.mainActivity);
		
		CallbackManager callbackManager = Facebook.instance.getCallbackManager();

		mShareDialog.registerCallback(callbackManager,
			new FacebookCallback<ShareDialog.Result>() {

				@Override
				public void onSuccess(ShareDialog.Result result) {
					if (mHaxeShareDialog!=null) {
						mHaxeShareDialog.call0("shareSuccess");
					}
				}

				@Override
				public void onCancel() {
					if (mHaxeShareDialog!=null) {
						mHaxeShareDialog.call0("shareCanceled");
					}
				}

				@Override
				public void onError(FacebookException error) {
					if (mHaxeShareDialog!=null) {
						mHaxeShareDialog.call1("shareError", error.getMessage());
					}
				}

		});

	}

	public static void shareLink(String contentURL, String contentTitle, String imageURL, String contentDescription){
		ShareLinkContent.Builder builder = new ShareLinkContent.Builder();
		builder.setContentUrl(Uri.parse(contentURL));
		if (contentTitle!="") {
			builder.setContentTitle(contentTitle);
			builder.setQuote(contentTitle);
		}
		if (imageURL!="") {
			builder.setImageUrl(Uri.parse(imageURL));
		}
		if (contentDescription!="") {
			builder.setContentDescription(contentDescription);
		}
		ShareLinkContent content = builder.build();
		if (mShareDialog!=null) {
			mShareDialog.show(content);
		}
	}
	
}
