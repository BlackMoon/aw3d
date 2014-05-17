package
{
    import away3d.containers.*;
    import away3d.core.render.Renderer;
    import away3d.core.utils.Cast;
    import away3d.materials.*;
    import away3d.primitives.*;
    import away3d.test.Button;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
    import flash.text.TextField;
    import flash.text.TextFormat;

    [SWF(width="500", height="400", frameRate="30", backgroundColor="#FFFFFF")]
	public class Textures extends Sprite
	{
		// "global" vars
		private var plane:Plane;
		private var planeBorder:Plane;
		private var planeComplexity:Number = 1;
		private var my_material:Material;
		private var View:View3D;
		private var toggle:Boolean = false;
		
		// Embed texture for use in Flex
		[Embed(source="resources/chess.jpg")]
        private var chessBitmap:Class;
        private var chessTexture:BitmapData;
        
		public function Textures()
		{
			super();
			// create a 3D-viewport
			View = new View3D({x:250, y:200});
			View.renderer = Renderer.CORRECT_Z_ORDER;
			
			// add viewport to the stage
			addChild(View);
			
			// Store texture and create plane
			var bitmap:Bitmap = new chessBitmap() as Bitmap;
			chessTexture = bitmap.bitmapData;
			my_material = new BitmapMaterial(Cast.bitmap(chessTexture));
			makePlane();
			
			// position camera
			View.camera.position = new Vector3D(400, 500, 400);
			View.camera.lookAt( new Vector3D(0, 0, 0) );
			
			// add some controls
			addControls();
			
			// Turn on rotation
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		// functions used
		private function onEnterFrame(e:Event):void
		{
			update();
		}
		
		private function update(e:MouseEvent = null):void
		{
            View.render();
            plane.rotationY = planeBorder.rotationY += 1;
		}
		
		private function makePlane():void
		{
			var rot:Number;
			if(plane){
				rot = plane.rotationY;
				destroy();
			}
			
			// Add new plane
			plane = new Plane({material:my_material,width:250,height:250,x:0,y:30,segmentsH:planeComplexity, segmentsW:planeComplexity});
			planeBorder = new Plane({material:"grey",width:265,height:265,x:0,y:28,segmentsH:1, segmentsW:1});
			
			// add plane to the scene
			View.scene.addChild(planeBorder);
			View.scene.addChild(plane);
			if(rot){
				plane.rotationY = planeBorder.rotationY = rot;
			}
		}
		
		private function addControls():void
		{
            var txtFormat:TextFormat = new TextFormat("_sans",12);
			var pad:Number = 10;
			var label1:TextField = new TextField();
			label1.x = pad;
			label1.y = pad;
			label1.width = 180 -(pad*2);
			label1.height = 30;
            label1.defaultTextFormat = txtFormat;
			label1.text = "Increase/decrease complexity";
			var plusButt:Button = new Button("+",20, 20);
            plusButt.addEventListener(MouseEvent.CLICK, increaseComplexity);
            plusButt.x = pad;
            plusButt.y = label1.height+label1.y;
			var minButt:Button = new Button("-",20, 20);
            minButt.addEventListener(MouseEvent.CLICK, decreaseComplexity);
            minButt.x = 50;
            minButt.y = label1.height+label1.y;
			var toggleButt:Button = new Button("Toggle texture", 140, 20);
            toggleButt.addEventListener(MouseEvent.CLICK, wiresTextureToggle);
			toggleButt.x = pad;
            toggleButt.y = plusButt.height+plusButt.y+pad;

            addChild( label1 );
            addChild( plusButt );
            addChild( minButt );
            addChild( toggleButt );
		}
		
		private function decreaseComplexity(e:MouseEvent):void
		{
			planeComplexity > 0 ? planeComplexity -= 1 : planeComplexity = 1;
			makePlane();
		}
		
		private function increaseComplexity(e:MouseEvent):void
		{
			planeComplexity += 1;
			makePlane();
		}
		
		private function wiresTextureToggle(e:MouseEvent):void
		{
			trace("wiresTextureToggle"+toggle);
			if(!toggle){
				my_material = new WireColorMaterial({color:"blue"});
				toggle = true;
			} else {
				my_material = new BitmapMaterial(Cast.bitmap(chessTexture));
				toggle = false;
			}
			makePlane();
		}
		
		private function destroy():void
		{
			if(plane){
				plane.material = null;
				View.scene.removeChild(plane);
				View.scene.removeChild(planeBorder);
				plane = null;
				planeBorder = null;
			}
		}
	}
}