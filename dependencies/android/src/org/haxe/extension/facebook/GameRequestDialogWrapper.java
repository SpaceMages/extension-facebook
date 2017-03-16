package org.haxe.extension.facebook;

import java.lang.String;
import java.util.List;

import org.haxe.lime.HaxeObject;

import com.facebook.share.model.GameRequestContent;
import com.facebook.share.widget.GameRequestDialog;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;

import android.util.Log;


public class GameRequestDialogWrapper {

	static GameRequestDialog mGameRequestDialog;
	static HaxeObject mHaxeGameRequestManager;

	public static void gameRequestDialog(String message, String title, String to, String objectId, String type, String filters, HaxeObject callbacks) {

		if (GameRequestDialog.canShow()) {

			mHaxeGameRequestManager = callbacks;

			CallbackManager callbackManager = Facebook.instance.getCallbackManager();

			mGameRequestDialog = new GameRequestDialog(Facebook.instance.mainActivity);

			mGameRequestDialog.registerCallback(callbackManager,
				new FacebookCallback<GameRequestDialog.Result>() {
					public void onSuccess(GameRequestDialog.Result result) {
						String id = result.getRequestId();
						String[] recipients = result.getRequestRecipients().toArray(new String[0]);
						Log.i("trace","onresult");
						if(id==null) id = "";
						mHaxeGameRequestManager.call2("onSuccess", id, recipients);
					}
					public void onCancel() {
						Log.i("trace","oncancel");
						mHaxeGameRequestManager.call0("onCancel");
					}
					public void onError(FacebookException error) {
						Log.i("trace","onerror");
						Log.e("trace",error.getMessage());
						mHaxeGameRequestManager.call1("onError", error.getMessage());
					}
				}
			);

			GameRequestContent.Builder builder = new GameRequestContent.Builder()
						.setMessage(message);

			if(title!="") {
				builder.setTitle(title);
			}

			if(to!="") {
				builder.setTo(to);
			}

			if(type == "SEND") {
				builder.setActionType(GameRequestContent.ActionType.SEND);
				builder.setObjectId(objectId);
			}else if(type == "ASKFOR") {
				builder.setActionType(GameRequestContent.ActionType.ASKFOR);
				builder.setObjectId(objectId);
			}else if(type == "TURN") {
				builder.setActionType(GameRequestContent.ActionType.TURN);
			}

			if(filters == "APP_USERS") {
				builder.setFilters(GameRequestContent.Filters.APP_USERS);
			}else if(filters == "APP_NON_USERS") {
				builder.setFilters(GameRequestContent.Filters.APP_NON_USERS);
			}

			GameRequestContent content = builder.build();

			try {
				mGameRequestDialog.show(content);
			} catch (Exception e) {
				e.printStackTrace();
				Facebook.trace(e.getMessage());
			}
		}
	}
	

}