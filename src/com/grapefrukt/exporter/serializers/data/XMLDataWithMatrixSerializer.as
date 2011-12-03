package com.grapefrukt.exporter.serializers.data {
	import com.grapefrukt.exporter.animations.AnimationFrame;
	import com.grapefrukt.exporter.settings.Settings;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class XMLDataWithMatrixSerializer extends XMLDataSerializer {
		
		override protected function serializeAnimationFrame(frame:AnimationFrame):XML {
			var xml:XML = <Frame></Frame>;
			var m:Matrix = frame.transformMatrix;
			
			if (frame.alpha > 0) {
				xml.@a 	= m.a.toFixed(Settings.scalePrecision)
				xml.@b 	= m.b.toFixed(Settings.rotationPrecision);
				xml.@c 	= m.c.toFixed(Settings.rotationPrecision);
				xml.@d 	= m.d.toFixed(Settings.scalePrecision);
				xml.@tx = m.tx.toFixed(Settings.positionPrecision)
				xml.@ty = m.ty.toFixed(Settings.positionPrecision)
				
				xml.@alpha 	= frame.alpha.toFixed(Settings.alphaPrecision);
				
				stripAnimationFrameDefaults(xml);
			} else {
				return null;
			}
			
			return xml;
		}
		
		private function stripAnimationFrameDefaults(frameNode:XML):void {
			if (frameNode.@a 	== (1).toFixed(Settings.scalePrecision)) 	delete frameNode.@a;
			if (frameNode.@b	== (0).toFixed(Settings.rotationPrecision))	delete frameNode.@b;
			if (frameNode.@c 	== (0).toFixed(Settings.rotationPrecision)) delete frameNode.@c;
			if (frameNode.@d 	== (1).toFixed(Settings.scalePrecision)) 	delete frameNode.@d;
			if (frameNode.@tx 	== (0).toFixed(Settings.positionPrecision)) delete frameNode.@tx;
			if (frameNode.@ty 	== (0).toFixed(Settings.positionPrecision)) delete frameNode.@ty;
			if (frameNode.@alpha == (1).toFixed(Settings.alphaPrecision)) 	delete frameNode.@alpha;
		}
		
	}

}