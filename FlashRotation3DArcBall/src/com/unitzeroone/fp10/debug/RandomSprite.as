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
	import flash.geom.Vector3D;

	public class RandomSprite extends Sprite
	{
		public var num:int;
		
		public function RandomSprite(num:int)
		{
			super();
			this.num = num;
			rotationY = 0;
			init();
		}
		
		private function init():void
		{
			var a:int = num;
			while(num--){
				var sprite:Sprite = new Sprite();
				drawPlane(sprite, Math.random()*0xFFFFFF);
				sprite.x = -250 + Math.random()*500;
				sprite.y = -250 + Math.random()*500;
				sprite.z = -250 + Math.random()*500;
				sprite.transform.matrix3D.pointAt(new Vector3D(0, 0, 0),new Vector3D(0, 0, -1), Vector3D.Y_AXIS);
				addChild(sprite);
			}	
		}
		
		private function drawPlane(sprite:Sprite, color:int):void
		{
			var size:Number = 50;
			var hs:Number = size/2;
			sprite.graphics.beginFill(color,1);
			sprite.graphics.drawRect(-hs,-hs,size,size);
			sprite.graphics.endFill();
		}
		
	}
}