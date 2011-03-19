package com.grapefrukt.exporter.extractors {
	import com.codeazur.as3swf.data.SWFSymbol;
	import com.codeazur.as3swf.exporters.SVGShapeExporter;
	import com.codeazur.as3swf.SWF;
	import com.codeazur.as3swf.tags.TagDefineShape;
	import com.codeazur.as3swf.tags.TagDefineSprite;
	import com.codeazur.as3swf.tags.TagPlaceObject2;
	import com.codeazur.as3swf.tags.TagSymbolClass;
	import com.grapefrukt.exporter.vectors.VectorTexture;
	import com.grapefrukt.exporter.vectors.VectorTextureSheet;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class VectorExtractor {
		
		private static var _swf		:SWF;
		private static var _symbols	:Vector.<SWFSymbol>;
		private static var _exporter:SVGShapeExporter;
		
		public static function init(loaderInfo:LoaderInfo):void {
			_swf = new SWF(loaderInfo.bytes);
			//trace(_swf);
			var symboltag:TagSymbolClass;
			for (var i:uint = 0; i < _swf.tags.length; i++) {
				symboltag = _swf.tags[i] as TagSymbolClass;
				if (symboltag) break;
			}
			_symbols = symboltag.symbols;
			
			_exporter = new SVGShapeExporter(_swf);
		}
		
		public static function extract(target:DisplayObject):VectorTextureSheet {
			
		}
		
		public static function extractSingle(target:DisplayObject):VectorTexture {
			var name:String = getQualifiedClassName(target);
			for (var i:int = 0; i < _symbols.length; i++) {
				if (_symbols[i].name == name) {
					var shapeTag:TagDefineShape = getSymbolShapeDefinition(_symbols[i])
					
					var vtexture:VectorTexture = new VectorTexture(target.name, )
				}
			}
			return null;
		}
		
			
		static private function getSymbolShapeDefinition(symbol:SWFSymbol):TagDefineShape {
			var tagDefineSprite:TagDefineSprite = _swf.getCharacter(symbol.tagId) as TagDefineSprite;
			
			var tagPlaceObject:TagPlaceObject2;
			for (var i:int = 0; i < tagDefineSprite.tags.length; i++) {
				if ((tagPlaceObject = tagDefineSprite.tags[i] as TagPlaceObject2)) {
					return _swf.getCharacter(tagPlaceObject.characterId) as TagDefineShape;
				}
			}
			return null;
		}
		
	}

}