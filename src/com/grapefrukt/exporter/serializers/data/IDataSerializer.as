package com.grapefrukt.exporter.serializers.data {
	import com.grapefrukt.exporter.filters.IFilter;
	
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public interface IDataSerializer {
		function serialize(target:*, useFilters:Boolean = false):ByteArray;
		function filter(data:ByteArray):ByteArray;
		function addFilter(filter:IFilter):void;
	}
	
}