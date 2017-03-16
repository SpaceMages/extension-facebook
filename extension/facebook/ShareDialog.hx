package extension.facebook;
import msignal.Signal;

#if (android && openfl)
import openfl.utils.JNI;
#end

#if cpp
import cpp.Lib;
#end

/**
 * ...
 * @author Markus S
 */
class ShareDialog
{

	static var mInstance : ShareDialog;
	
	public static function getInstance() : ShareDialog {
		if (mInstance == null)
			mInstance = new ShareDialog();
		return mInstance;
	}
	
	/////////////////////
	
	public var OnShareSuccess 	: Signal0;
	public var OnShareFailed 	: Signal1<String>;
	public var OnShareCanceled	: Signal0;
	
	/////////////////////
	
	function new() 
	{
		OnShareSuccess = new Signal0();
		OnShareFailed = new Signal1<String>();
		OnShareCanceled = new Signal0();
		
		trace("new share dialog");
		#if android
		jni_init(this);
		#elseif ios
		trace("ios init");
		objC_init(shareSuccess, shareError, shareCanceled);
		#end
		trace("ios init done");
	}
	
	public function shareLink(?contentURL:String = "", ?contentTitle:String = "", ?imageURL:String = "", ?contentDescription:String = "") {
		trace("calling share link JNI");
		#if android
		jni_shareLink(contentURL, contentTitle, imageURL, contentDescription);
		#elseif ios
		if(objC_shareLink == null) {
			trace("objC shareLink is null");
		}
		objC_shareLink(contentURL, contentTitle, imageURL, contentDescription);
		#end
		trace("calling share link JNI - done");
	}

	function shareSuccess() {
		OnShareSuccess.dispatch();
	}
	
	function shareError(e : String) {
		OnShareFailed.dispatch(e);
	}
	
	function shareCanceled() {
		OnShareCanceled.dispatch();
	}
	
	#if android
	static var jni_shareLink : Dynamic = JNI.createStaticMethod("org.haxe.extension.facebook.ShareWrapper", "shareLink", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	static var jni_init : Dynamic = JNI.createStaticMethod("org.haxe.extension.facebook.ShareWrapper", "init", "(Lorg/haxe/lime/HaxeObject;)V");
	#elseif ios
	static var objC_shareLink : Dynamic = Lib.load("facebookExt", "shareLink", 4);
	static var objC_init : Dynamic = Lib.load("facebookExt", "initShare", 3);
	#end
	
}