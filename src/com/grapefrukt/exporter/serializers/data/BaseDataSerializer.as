package com.grapefrukt.exporter.serializers.data {
	import com.grapefrukt.exporter.filters.IFilter;
	
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class BaseDataSerializer {
		
		private var _filters:Vector.<IFilter>
		
		public function BaseDataSerializer() {
			_filters = new Vector.<IFilter>();
		}
		
		public function addFilter(filter:IFilter):void {
			_filters.push(filter);
		}
		
		public function filter(data:ByteArray):ByteArray {
			for each(var filter:IFilter in _filters) data = filter.apply(data);
			return data;
		}
		
	}

}