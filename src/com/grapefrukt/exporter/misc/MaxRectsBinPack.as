/*
	Implements different bin packer algorithms that use the MAXRECTS data structure.
	See http://clb.demon.fi/projects/even-more-rectangle-bin-packing
 
	Author: Jukka Jylänki
		- Original
	
	Author: Claus Wahlers
		- Ported to ActionScript3
		
	Author: Martin Jonasson
		- Additional modifications to better interface with grapefrukt-exporter

	This work is released to Public Domain, do whatever you want with it.
*/
package com.grapefrukt.exporter.misc
{
	import flash.display.Shape;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	public class MaxRectsBinPack extends EventDispatcher
	{
		public static const METHOD_RECT_BEST_SHORT_SIDE_FIT:uint = 1;
		public static const METHOD_RECT_BOTTOM_LEFT_RULE:uint = 2;
		public static const METHOD_RECT_CONTACT_POINT_RULE:uint = 3;
		public static const METHOD_RECT_BEST_LONG_SIDE_FIT:uint = 4;
		public static const METHOD_RECT_BEST_AREA_FIT:uint = 5;

		public var timeLimit:int = 25;
		public var allowFlip:Boolean = false;
		
		public var usedRectangles:Vector.<Rectangle>;
		public var freeRectangles:Vector.<Rectangle>;
		
		protected var binWidth:Number = 0;
		protected var binHeight:Number = 0;
		
		protected var enterFrameProvider:Shape;
		protected var tmpRects:Vector.<Rectangle>;
		protected var tmpMethod:uint;
		
		public function MaxRectsBinPack(width:Number, height:Number) {
			enterFrameProvider = new Shape();
			init(width, height);
		}
		
		private function init(width:Number, height:Number):void {
			binWidth = width;
			binHeight = height;
			usedRectangles = new Vector.<Rectangle>();
			freeRectangles = new Vector.<Rectangle>();
			freeRectangles.push(new Rectangle(0, 0, width, height));
		}
		
		public function insert(width:Number, height:Number, method:uint):Rectangle {
			if(enterFrameProvider.hasEventListener(Event.ENTER_FRAME)) {
				throw(new Error("Bulk insert in progress."));
			}
			var newNode:Rectangle;
			switch(method) {
				case METHOD_RECT_BEST_SHORT_SIDE_FIT:
					newNode = findPositionForNewNodeBestShortSideFit(width, height);
					break;
				case METHOD_RECT_BOTTOM_LEFT_RULE:
					newNode = findPositionForNewNodeBottomLeft(width, height);
					break;
				case METHOD_RECT_CONTACT_POINT_RULE:
					newNode = findPositionForNewNodeContactPoint(width, height);
					break;
				case METHOD_RECT_BEST_LONG_SIDE_FIT:
					newNode = findPositionForNewNodeBestLongSideFit(width, height);
					break;
				case METHOD_RECT_BEST_AREA_FIT:
					newNode = findPositionForNewNodeBestAreaFit(width, height);
					break;
				default:
					throw(new Error("Invalid method."));
					break;
			}
			if (newNode.height == 0) {
				return newNode;
			}
			var numRectanglesToProcess:uint = freeRectangles.length;
			for(var i:uint = 0; i < numRectanglesToProcess; ++i) {
				if (splitFreeNode(freeRectangles[i], newNode)) {
					freeRectangles.splice(i, 1);
					--numRectanglesToProcess;
					--i;
				}
			}
			pruneFreeList();
			usedRectangles.push(newNode);
			return newNode;
		}
		
		public function insertBulk(rects:Vector.<Rectangle>, method:uint):void {
			if(enterFrameProvider.hasEventListener(Event.ENTER_FRAME)) {
				throw(new Error("Bulk insert in progress."));
			}
			tmpRects = rects;
			tmpMethod = method;
			enterFrameProvider.addEventListener(Event.ENTER_FRAME, insertBulkWorker);
			insertBulkWorker(null);
		}
		
		public function insertBulkWorker(event:Event):void {
			var t:int = getTimer();
			while(tmpRects.length > 0) {
				if(getTimer() - t < timeLimit) {
					var bestScore:Score = new Score();
					var bestRectIndex:int = -1;
					var bestNode:Rectangle = rectFactory();
					for(var i:uint = 0; i < tmpRects.length; ++i) {
						var score:Score = new Score();
						var newNode:Rectangle = scoreRect(tmpRects[i].width, tmpRects[i].height, tmpMethod, score);
						if (score.score1 < bestScore.score1 || (score.score1 == bestScore.score1 && score.score2 < bestScore.score2)) {
							bestScore.score1 = score.score1;
							bestScore.score2 = score.score2;
							bestNode = newNode;
							bestRectIndex = i;
						}
					}
					if (bestRectIndex == -1) {
						// Rect didn't fit, break out of the loop and terminate
						break;
					}
					placeRect(bestNode);
					tmpRects.splice(bestRectIndex, 1);
				} else {
					// time limit exceeded, break out of the function, wait for next enterframe
					trace((getTimer() - t) + "ms");
					dispatchEvent(new Event("progress"));
					return;
				}
			}
			tmpRects = null;
			enterFrameProvider.removeEventListener(Event.ENTER_FRAME, insertBulkWorker);
			dispatchEvent(new Event("complete"));
		}

		protected function scoreRect(width:Number, height:Number, method:uint, score:Score):Rectangle {
			var newNode:Rectangle = rectFactory();
			score.score1 = Number.MAX_VALUE;
			score.score2 = Number.MAX_VALUE;
			switch(method) {
				case METHOD_RECT_BEST_SHORT_SIDE_FIT:
					newNode = findPositionForNewNodeBestShortSideFit(width, height, score);
					break;
				case METHOD_RECT_BOTTOM_LEFT_RULE:
					newNode = findPositionForNewNodeBottomLeft(width, height, score);
					break;
				case METHOD_RECT_CONTACT_POINT_RULE:
					newNode = findPositionForNewNodeContactPoint(width, height, score);
					// Reverse since we are minimizing, but for contact point score bigger is better.
					score.score1 = -score.score1;
					break;
				case METHOD_RECT_BEST_LONG_SIDE_FIT:
					newNode = findPositionForNewNodeBestLongSideFit(width, height, score);
					break;
				case METHOD_RECT_BEST_AREA_FIT:
					newNode = findPositionForNewNodeBestAreaFit(width, height, score);
					break;
				default:
					throw(new Error("Invalid method."));
					break;
			}
			// Cannot fit the current rectangle.
			if (newNode.isEmpty()) {
				score.score1 = Number.MAX_VALUE;
				score.score2 = Number.MAX_VALUE;
			}
			return newNode;
		}

		protected function placeRect(node:Rectangle):void {
			var numRectanglesToProcess:uint = freeRectangles.length;
			for(var i:uint = 0; i < numRectanglesToProcess; ++i) {
				if (splitFreeNode(freeRectangles[i], node)) {
					freeRectangles.splice(i, 1);
					--numRectanglesToProcess;
					--i;
				}
			}
			pruneFreeList();
			usedRectangles.push(node);
		}
		
		protected function findPositionForNewNodeBestShortSideFit(width:Number, height:Number, score:Score = null):Rectangle {
			if(score == null) {
				score = new Score();
			}
			score.score1 = Number.MAX_VALUE;
			var bestNode:Rectangle = rectFactory();
			for(var i:uint = 0; i < freeRectangles.length; ++i) {
				// Try to place the rectangle in upright (non-flipped) orientation.
				if (freeRectangles[i].width >= width && freeRectangles[i].height >= height) {
					var leftoverHoriz:Number = Math.abs(freeRectangles[i].width - width);
					var leftoverVert:Number = Math.abs(freeRectangles[i].height - height);
					var shortSideFit:Number = Math.min(leftoverHoriz, leftoverVert);
					var longSideFit:Number = Math.max(leftoverHoriz, leftoverVert);
					if (shortSideFit < score.score1 || (shortSideFit == score.score1 && longSideFit < score.score2)) {
						bestNode.x = freeRectangles[i].x;
						bestNode.y = freeRectangles[i].y;
						bestNode.width = width;
						bestNode.height = height;
						score.score1 = shortSideFit;
						score.score2 = longSideFit;
					}
				}
				// Try to place the rectangle in flipped orientation.
				if(allowFlip && height != width) {
					if (freeRectangles[i].width >= height && freeRectangles[i].height >= width) {
						var flippedLeftoverHoriz:Number = Math.abs(freeRectangles[i].width - height);
						var flippedLeftoverVert:Number = Math.abs(freeRectangles[i].height - width);
						var flippedShortSideFit:Number = Math.min(flippedLeftoverHoriz, flippedLeftoverVert);
						var flippedLongSideFit:Number = Math.max(flippedLeftoverHoriz, flippedLeftoverVert);
						if (flippedShortSideFit < score.score1 || (flippedShortSideFit == score.score1 && flippedLongSideFit < score.score2)) {
							bestNode.x = freeRectangles[i].x;
							bestNode.y = freeRectangles[i].y;
							bestNode.width = height;
							bestNode.height = width;
							score.score1 = flippedShortSideFit;
							score.score2 = flippedLongSideFit;
						}
					}
				}
			}
			return bestNode;
		}
		
		protected function findPositionForNewNodeBottomLeft(width:Number, height:Number, score:Score = null):Rectangle {
			if(score == null) {
				score = new Score();
			}
			score.score1 = Number.MAX_VALUE;
			var topSideY:Number;
			var bestNode:Rectangle = rectFactory();
			for(var i:uint = 0; i < freeRectangles.length; ++i) {
				// Try to place the rectangle in upright (non-flipped) orientation.
				if (freeRectangles[i].width >= width && freeRectangles[i].height >= height) {
					topSideY = freeRectangles[i].y + height;
					if (topSideY < score.score1 || (topSideY == score.score1 && freeRectangles[i].x < score.score2)) {
						bestNode.x = freeRectangles[i].x;
						bestNode.y = freeRectangles[i].y;
						bestNode.width = width;
						bestNode.height = height;
						score.score1 = topSideY;
						score.score2 = freeRectangles[i].x;
					}
				}
				if(allowFlip && height != width) {
					if (freeRectangles[i].width >= height && freeRectangles[i].height >= width) {
						topSideY = freeRectangles[i].y + width;
						if (topSideY < score.score1 || (topSideY == score.score1 && freeRectangles[i].x < score.score2)) {
							bestNode.x = freeRectangles[i].x;
							bestNode.y = freeRectangles[i].y;
							bestNode.width = height;
							bestNode.height = width;
							score.score1 = topSideY;
							score.score2 = freeRectangles[i].x;
						}
					}
				}
			}
			return bestNode;
		}

		protected function findPositionForNewNodeContactPoint(width:Number, height:Number, score:Score = null):Rectangle {
			if(score == null) {
				score = new Score();
			}
			score.score1 = -1;
			var bestContactScore:Number;
			var bestNode:Rectangle = rectFactory();
			for(var i:uint = 0; i < freeRectangles.length; ++i) {
				// Try to place the rectangle in upright (non-flipped) orientation.
				if (freeRectangles[i].width >= width && freeRectangles[i].height >= height) {
					bestContactScore = contactPointScoreNode(freeRectangles[i].x, freeRectangles[i].y, width, height);
					if (bestContactScore > score.score1) {
						bestNode.x = freeRectangles[i].x;
						bestNode.y = freeRectangles[i].y;
						bestNode.width = width;
						bestNode.height = height;
						score.score1 = bestContactScore;
					}
				}
				if(allowFlip && height != width) {
					if (freeRectangles[i].width >= height && freeRectangles[i].height >= width) {
						bestContactScore = contactPointScoreNode(freeRectangles[i].x, freeRectangles[i].y, width, height);
						if (bestContactScore > score.score1) {
							bestNode.x = freeRectangles[i].x;
							bestNode.y = freeRectangles[i].y;
							bestNode.width = height;
							bestNode.height = width;
							score.score1 = bestContactScore;
						}
					}
				}
			}
			return bestNode;
		}

		protected function findPositionForNewNodeBestLongSideFit(width:Number, height:Number, score:Score = null):Rectangle {
			if(score == null) {
				score = new Score();
			}
			score.score2 = Number.MAX_VALUE;
			var shortSideFit:Number, longSideFit:Number;
			var leftoverHoriz:Number, leftoverVert:Number;
			var bestNode:Rectangle = rectFactory();
			for(var i:uint = 0; i < freeRectangles.length; ++i) {
				// Try to place the rectangle in upright (non-flipped) orientation.
				if (freeRectangles[i].width >= width && freeRectangles[i].height >= height) {
					leftoverHoriz = Math.abs(freeRectangles[i].width - width);
					leftoverVert = Math.abs(freeRectangles[i].height - height);
					shortSideFit = Math.min(leftoverHoriz, leftoverVert);
					longSideFit = Math.max(leftoverHoriz, leftoverVert);
					if (longSideFit < score.score2 || (longSideFit == score.score2 && shortSideFit < score.score1)) {
						bestNode.x = freeRectangles[i].x;
						bestNode.y = freeRectangles[i].y;
						bestNode.width = width;
						bestNode.height = height;
						score.score1 = shortSideFit;
						score.score2 = longSideFit;
					}
				}
				if(allowFlip && height != width) {
					if (freeRectangles[i].width >= height && freeRectangles[i].height >= width) {
						leftoverHoriz = Math.abs(freeRectangles[i].width - height);
						leftoverVert = Math.abs(freeRectangles[i].height - width);
						shortSideFit = Math.min(leftoverHoriz, leftoverVert);
						longSideFit = Math.max(leftoverHoriz, leftoverVert);
						if (longSideFit < score.score2 || (longSideFit == score.score2 && shortSideFit < score.score1)) {
							bestNode.x = freeRectangles[i].x;
							bestNode.y = freeRectangles[i].y;
							bestNode.width = height;
							bestNode.height = width;
							score.score1 = shortSideFit;
							score.score2 = longSideFit;
						}
					}
				}
			}
			return bestNode;
		}

		protected function findPositionForNewNodeBestAreaFit(width:Number, height:Number, score:Score = null):Rectangle {
			if(score == null) {
				score = new Score();
			}
			score.score1 = Number.MAX_VALUE;
			var areaFit:Number;
			var shortSideFit:Number;
			var leftoverHoriz:Number, leftoverVert:Number;
			var bestNode:Rectangle = rectFactory();
			for(var i:uint = 0; i < freeRectangles.length; ++i) {
				areaFit = freeRectangles[i].width * freeRectangles[i].height - width * height;
				// Try to place the rectangle in upright (non-flipped) orientation.
				if (freeRectangles[i].width >= width && freeRectangles[i].height >= height) {
					leftoverHoriz = Math.abs(freeRectangles[i].width - width);
					leftoverVert = Math.abs(freeRectangles[i].height - height);
					shortSideFit = Math.min(leftoverHoriz, leftoverVert);
					if (areaFit < score.score1 || (areaFit == score.score1 && shortSideFit < score.score2)) {
						bestNode.x = freeRectangles[i].x;
						bestNode.y = freeRectangles[i].y;
						bestNode.width = width;
						bestNode.height = height;
						score.score1 = areaFit;
						score.score2 = shortSideFit;
					}
				}
				if(allowFlip && height != width) {
					if (freeRectangles[i].width >= height && freeRectangles[i].height >= width) {
						leftoverHoriz = Math.abs(freeRectangles[i].width - height);
						leftoverVert = Math.abs(freeRectangles[i].height - width);
						shortSideFit = Math.min(leftoverHoriz, leftoverVert);
						if (areaFit < score.score1 || (areaFit == score.score1 && shortSideFit < score.score2)) {
							bestNode.x = freeRectangles[i].x;
							bestNode.y = freeRectangles[i].y;
							bestNode.width = height;
							bestNode.height = width;
							score.score1 = areaFit;
							score.score2 = shortSideFit;
						}
					}
				}
			}
			return bestNode;
		}

		protected function contactPointScoreNode(x:Number, y:Number, width:Number, height:Number):Number {
			var score:Number = 0;
			if (x == 0 || x + width == binWidth) {
				score += height;
			}
			if (y == 0 || y + height == binHeight) {
				score += width;
			}
			for(var i:uint = 0; i < usedRectangles.length; ++i) {
				if (usedRectangles[i].x == x + width || usedRectangles[i].x + usedRectangles[i].width == x) {
					score += commonIntervalLength(usedRectangles[i].y, usedRectangles[i].y + usedRectangles[i].height, y, y + height);
				}
				if (usedRectangles[i].y == y + height || usedRectangles[i].y + usedRectangles[i].height == y) {
					score += commonIntervalLength(usedRectangles[i].x, usedRectangles[i].x + usedRectangles[i].width, x, x + width);
				}
			}
			return score;
		}

		// Returns 0 if the two intervals i1 and i2 are disjoint, 
		// or the length of their overlap otherwise.
		protected function commonIntervalLength(i1start:Number, i1end:Number, i2start:Number, i2end:Number):Number {
			if (i1end < i2start || i2end < i1start) {
				return 0;
			}
			return Math.min(i1end, i2end) - Math.max(i1start, i2start);
		}

		protected function splitFreeNode(freeNode:Rectangle, usedNode:Rectangle):Boolean {
			var newNode:Rectangle;
			// Test with SAT if the rectangles even intersect.
			if (usedNode.x >= freeNode.x + freeNode.width ||
				usedNode.x + usedNode.width <= freeNode.x ||
				usedNode.y >= freeNode.y + freeNode.height ||
				usedNode.y + usedNode.height <= freeNode.y) {
					return false;
			}
			if (usedNode.x < freeNode.x + freeNode.width && usedNode.x + usedNode.width > freeNode.x) {
				// New node at the top side of the used node.
				if (usedNode.y > freeNode.y && usedNode.y < freeNode.y + freeNode.height) {
					newNode = freeNode.clone();
					newNode.height = usedNode.y - newNode.y;
					freeRectangles.push(newNode);
				}
				// New node at the bottom side of the used node.
				if (usedNode.y + usedNode.height < freeNode.y + freeNode.height) {
					newNode = freeNode.clone();
					newNode.y = usedNode.y + usedNode.height;
					newNode.height = freeNode.y + freeNode.height - (usedNode.y + usedNode.height);
					freeRectangles.push(newNode);
				}
			}
			if (usedNode.y < freeNode.y + freeNode.height && usedNode.y + usedNode.height > freeNode.y) {
				// New node at the left side of the used node.
				if (usedNode.x > freeNode.x && usedNode.x < freeNode.x + freeNode.width) {
					newNode = freeNode.clone();
					newNode.width = usedNode.x - newNode.x;
					freeRectangles.push(newNode);
				}
				// New node at the right side of the used node.
				if (usedNode.x + usedNode.width < freeNode.x + freeNode.width) {
					newNode = freeNode.clone();
					newNode.x = usedNode.x + usedNode.width;
					newNode.width = freeNode.x + freeNode.width - (usedNode.x + usedNode.width);
					freeRectangles.push(newNode);
				}
			}
			return true;
		}
		
		protected function pruneFreeList():void {
			// Go through each pair and remove any rectangle that is redundant.
			for(var i:uint = 0; i < freeRectangles.length; ++i) {
				for(var j:uint = i + 1; j < freeRectangles.length; ++j) {
					if (freeRectangles[j].containsRect(freeRectangles[i])) {
						freeRectangles.splice(i, 1);
						--i;
						break;
					}
					if (freeRectangles[i].containsRect(freeRectangles[j])) {
						freeRectangles.splice(j, 1);
						--j;
					}
				}
			}
		}
		
		protected function rectFactory():Rectangle {
			return new Rectangle();
		}
	}
}

class Score
{
	public var score1:Number;
	public var score2:Number;
	
	public function Score(score1:Number = Number.MAX_VALUE, score2:Number = Number.MAX_VALUE)
	{
		this.score1 = score1;
		this.score2 = score2;
	}
}
