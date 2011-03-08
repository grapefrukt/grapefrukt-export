package com.grapefrukt.exporter.filters {
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public interface IFilter {
		function apply(data:ByteArray):ByteArray;
	}
	
}