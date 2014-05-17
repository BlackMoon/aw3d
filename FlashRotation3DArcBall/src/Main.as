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
package {
	import com.theflashblog.fp10.SimpleZSorter;
	import com.unitzeroone.fp10.ArcBall;
	import com.unitzeroone.fp10.debug.BoxSprite;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="430", height="430", backgroundColor="#000000")]
	public class Main extends Sprite
	{
		private var boxSprite:Sprite;
		private var arcBall:ArcBall;
		
		public function Main()
		{
			init();
		}
		
		private function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;
			initBoxSprite();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		
		
		private function scaleToStage(width:Number, height:Number):void
		{
			boxSprite.x = width/2;
			boxSprite.y = height/2;
		}
		
		private function initBoxSprite():void
		{
			boxSprite = new BoxSprite(100);
			boxSprite.x = 215;
			boxSprite.y = 215;
			addChild(boxSprite);
			boxSprite.mouseChildren = true;
			boxSprite.buttonMode = true;
			arcBall = new ArcBall(boxSprite);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			SimpleZSorter.sortClips(boxSprite,true);
		}
	}
}