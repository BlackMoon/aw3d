/*
Copyright (c) 2009 Ralph Hauwert

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package com.unitzeroone.fp10.debug
{
	import flash.display.Sprite;

	public class BoxSprite extends Sprite
	{
		private var size:Number;
		
		public function BoxSprite(size:Number)
		{
			super();
			this.size = size;
			init();
		}
		
		private function init():void
		{
			var hs:Number = size/2;
			var topPlane:Sprite = new Sprite();
			drawPlane(topPlane, 0xFF0000);
			topPlane.rotationX = 90;
			topPlane.y = hs;
			addChild(topPlane);
			
			var bottomPlane:Sprite = new Sprite();
			drawPlane(bottomPlane, 0x00FF00);
			bottomPlane.rotationX = -90;
			bottomPlane.y = -hs;
			addChild(bottomPlane);
			
			var leftPlane:Sprite = new Sprite();
			drawPlane(leftPlane, 0x0000FF);
			leftPlane.x = -hs;
			leftPlane.rotationY = 90;
			addChild(leftPlane);
			
			var rightPlane:Sprite = new Sprite();
			drawPlane(rightPlane, 0xFFFF00);
			rightPlane.x = hs;
			rightPlane.rotationY = -90;
			addChild(rightPlane);
			
			var backPlane:Sprite = new Sprite();
			drawPlane(backPlane, 0x00FFFF);
			backPlane.z = hs;
			addChild(backPlane);
			
			var frontPlane:Sprite = new Sprite();
			drawPlane(frontPlane, 0xFF00FF);
			frontPlane.z = -hs;
			addChild(frontPlane);
		}
		
		private function drawPlane(sprite:Sprite, color:int):void
		{
			var hs:Number = size/2;
			sprite.graphics.beginFill(color,1);
			sprite.graphics.drawRect(-hs,-hs,size,size);
			sprite.graphics.endFill();
		}
		
	}
}