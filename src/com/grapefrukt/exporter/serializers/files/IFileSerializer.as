package com.grapefrukt.exporter.serializers.files {
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public interface IFileSerializer {
		function serialize(filename:String, file:ByteArray):void;
		function output():void;
	}
	
}