package extension.facebook;

#if (android && openfl)
import openfl.utils.JNI;
#end

/**
 * ...
 * @author Markus Stefanko
 */
class GameRequestDialog {

	/**
	 * Open App Invite Dialog
	 *
	 * @param	message		Sets the message users receiving the request will see. The maximum length is 60 characters.
	 * @param	title		Sets an optional title for the dialog; maximum length is 50 characters.
	 * @param	type		Sets the action type for this request. ( SEND, ASKFOR, TURN )
	 * @param	to			Sets the user ID or user name the request will be sent to. If this is not specified, a friend selector will be displayed and the user can select up to 50 friends.
	 * @param	objectId	Sets the open graph id of the object that action type will be performed on Only valid (and required) for ActionTypes SEND, ASKFOR
	 * @param	filters		Sets the filters for everybody/app users/non app users. ( APP_USERS / APP_NON_USERS )
	 */
	public function new(message : String, ?title : String = "", ?type : String = "", ?to : String = "", ?objectId : String = "", ?filters : String = "", ?successCallback : String -> Array<String> -> Void = null, ?cancelCallback : Void -> Void = null, ?errorCallback : String -> Void = null)	{
		#if android
			try{
				var cbHandler = new GameRequestHandler(successCallback, errorCallback, cancelCallback);
				jni_gameRequestDialog(message, title, to, objectId, type, filters, cbHandler);
			} catch (e:Dynamic) {
				trace("gameRequestDialog dialog error", e);
				if(errorCallback != null) errorCallback(e);
			}
		#end
	}

	#if android
	static var jni_gameRequestDialog : Dynamic = JNI.createStaticMethod("org.haxe.extension.facebook.GameRequestDialogWrapper", "gameRequestDialog", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/haxe/lime/HaxeObject;)V");
	#end
}



private class GameRequestHandler {
	
	static var onSuccessCB:String -> Array<String> -> Void;
	static var onErrorCB:String -> Void;
	static var onCancelCB:Void -> Void;
	
	public function new (pSuccess : String -> Array<String> -> Void, pError : String -> Void, pCancel : Void -> Void) {
		onSuccessCB		= pSuccess;
		onErrorCB		= pError;
		onCancelCB		= pCancel;
	}

	public function onSuccess (requestId:String, requestRecipients:Array<String>):Void {
		if(onSuccessCB != null) onSuccessCB(requestId, requestRecipients);
	}

	public function onError (error:String):Void {
		if(onErrorCB != null) onErrorCB(error);				
	}

	public function onCancel ():Void {
		if(onCancelCB != null) onCancelCB();				
	}
}