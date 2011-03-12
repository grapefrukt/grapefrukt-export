package com.grapefrukt.exporter.settings {
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Settings {
		
		/**
		 * Experimental property to change the global scale of all exports. Use with caution.
		 */
		public static var scaleFactor:Number = 1;
		
		/**
		 * This many pixels will be added to the measured size of the DisplayObject when rendered to a bitmap (these may not be empty due to rounding off errors and antialias)
		 */
		public static var edgeMarginRender:int 	= 2;
		
		/**
		 * This many empty pixels will be added to each side of the texture when it's output (these will always be completely empty)
		 */
		public static var edgeMarginOutput:int = 2;
		
		/**
		 * Textures smaller than this will be ignored. Set to a negative value to disable size check. 
		 */
		public static var tinyThreshold:int  = 5;
		
		/**
		 * Extractors will ignore unnamed displayobjects by default, set to false to keep them too
		 */
		public static var ignoreUnnamed:Boolean = true;
		
		/**
		 * These are the chars that will be extracted if none are specified
		 */
		public static var defaultFontChars:String =  	"! \"#$%&'()*+,-./" + 
														"0123456789:;<=>?"  + 
														"@ABCDEFGHIJKLMNO"  + 
														"PQRSTUVWXY>[\\]^_" + 
														"ïabcdefghijklmno"  + 
														"pqrstuvwxyzäÄöÖ "  + 
														"åÅ";
		
	}

}