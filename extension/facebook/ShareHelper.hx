package extension.facebook;
import haxe.Timer;

/**
 * ...
 * @author Markus S
 */
class ShareHelper
{
	
	var mShareDialog : ShareDialog;
	
	public var onShareSuccessCB : Void -> Void;
	public var onShareErrorCB : String -> Void;
	public var onShareCanceledCB : Void -> Void; 

	public function new(onShareSuccess : Void -> Void = null, onShareError : String -> Void = null, onShareCanceled : Void -> Void = null)
	{
		onShareSuccessCB = onShareSuccess;
		onShareErrorCB = onShareError;
		onShareCanceledCB = onShareCanceled;
		
		mShareDialog = ShareDialog.getInstance();
	}
	
	public function shareLink(contentURL:String, contentTitle:String, imageURL:String, contentDescription:String) {
		trace("binding listeners");
		bindListeners();
		trace("calling mshare dialog share link");
		mShareDialog.shareLink(contentURL, contentTitle, imageURL, contentDescription);
	}

	function bindListeners() {
		mShareDialog.OnShareSuccess.add(onShareSuccess);
		mShareDialog.OnShareFailed.add(onShareFail);
		mShareDialog.OnShareCanceled.add(onShareCancel);
	}

	function unbindListeners() {
		mShareDialog.OnShareSuccess.remove(onShareSuccess);
		mShareDialog.OnShareFailed.remove(onShareFail);
		mShareDialog.OnShareCanceled.remove(onShareCancel);
	}

	function onShareSuccess() {
		if (onShareSuccessCB != null)
			onShareSuccessCB();

		unbindListeners();
	}
	
	function onShareFail(e : String) {
		if (onShareErrorCB != null)
			onShareErrorCB(e);

		unbindListeners();
	}
	
	function onShareCancel() {
		if (onShareCanceledCB != null)
			onShareCanceledCB();

		unbindListeners();
	}

}