package com.grapefrukt.exporter.serializers.files {
	import com.grapefrukt.exporter.debug.Logger;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class ServerUploadSerializer extends ZipFileSerializer {
		
		private var _url:String;
		
		public function ServerUploadSerializer(url:String) {
			_url = url;
		}
		
		override public function output():void {
			Logger.log("ServerUploadSerializer", "upload started");
			var zip:ByteArray = new ByteArray;
			_zip.serialize(zip);
			
			var loader:URLLoader = new URLLoader;
			var req:URLRequest = new URLRequest(_url);
			req.contentType = 'application/octet-stream';
			req.method = URLRequestMethod.POST;
			req.data = zip;
			
			loader.addEventListener(Event.COMPLETE, handleUploadComplete)
			loader.addEventListener(ProgressEvent.PROGRESS, handleProgress)
			
			loader.load(req);
		}
		
		private function handleProgress(e:ProgressEvent):void {
			Logger.log("ServerUploadSerializer", "upload progress...", Math.round(e.bytesLoaded / e.bytesTotal * 100) + "%");
		}
		
		private function handleUploadComplete(e:Event):void {
			Logger.log("ServerUploadSerializer", "upload complete");
			Logger.log("ServerUploadSerializer", "server said", e.target.data);
		}
		
	}

}