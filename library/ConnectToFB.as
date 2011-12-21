package library {
    import flash.events.*;
    import flash.net.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.adobe.serialization.json.*;
	public class ConnectToFB {
		public var lastRequest:Object;
		public function ConnectToFB():void {

		}
		public function sendRequest(url:String) {
			var myLoader:URLLoader = new URLLoader();
			trace('Load: started');
			myLoader.load(new URLRequest(url));
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			myLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			myLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			myLoader.addEventListener(Event.COMPLETE, onDataLoad);
			sendPost();
		}

		public function sendPost(/*url:String, vars:Array*/) {
			var post:Array = new Array();
			post['user'] = 'bob';
			trace(post.user);
			/*var request:URLRequest = new URLRequest(url);[ { "id": 10, "name": 'Bob' } ]
			var postVars:URLVariables = new URLVariables();
			request.data = requestVars;
			request.method = URLRequestMethod.POST;*/
		}

		public function onDataLoad(evt:Event) {
			trace('Load: completed');
			lastRequest = JSON.decode(evt.target.data);
			trace('JSON: decoded');
			debugData();
		}
		public function debugData() {
			for (var key:Object in lastRequest) {
				trace(lastRequest[key].name);
			}
		}
		function onIOError(evt:IOErrorEvent){
			trace("IOError: " + evt.text);
		}
		function onHTTPStatus(evt:HTTPStatusEvent){
			trace("HTTPStatus: " + evt.status);
		}
		function onSecurityError(evt:SecurityErrorEvent){
			trace("SecurityError: " + evt.text);
		}
	}

}