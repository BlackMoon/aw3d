package
{	
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Mesh;
	import away3d.core.base.Object3D;
	import away3d.core.base.Vertex;
	import away3d.core.render.Renderer;
	import away3d.exporters.ObjExporter;
	import away3d.loaders.Loader3D;
	import away3d.loaders.Max3DS;
	import away3d.loaders.utils.MaterialLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.Sphere;
	import away3d.primitives.Trident;
	import away3d.test.Button;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import mx.events.ModuleEvent;
	
	
	[SWF(height = "300", width="400", frameRate="30", backgroundColor="#F0F0F0")]	
	public class ex3d extends Sprite
	{
		private var bt1:Button;
		private var bt2:Button;
		private var model:ObjectContainer3D;
		private var matLib:MaterialLibrary;
		private var view:View3D;		
		// HoverCam controls
		private var cam:HoverCamera3D;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var bLoaded:Boolean = false;
		private var bRollNeeded:Boolean = false;
		private var rot:Boolean = false;		
		private var bWire:Boolean = false;	
		
		private function addControls():void
		{
			bt1 = new Button("Load",50);
			bt1.alpha = 0.20;
			bt1.x = 10;
			bt1.y = 60;			
			bt1.addEventListener(MouseEvent.CLICK, onBtn1Click);
			addChild(bt1);
			
			bt2 = new Button("Roll", 50);
			bt2.alpha = 0.20;
			bt2.x = 10;
			bt2.y = stage.stageHeight - 20;			
			bt2.addEventListener(MouseEvent.CLICK, onBtn2Click);
			addChild(bt2);
		}
		
		private function onBtn1Click(event:MouseEvent):void
		{	
			if (!bLoaded)
			{				
				var max3ds:Max3DS =new Max3DS({centerMeshes:true});				
				max3ds.material = new WireframeMaterial({wireColor:"#000000", thickness:1});
			
				var loader:Loader3D = new Loader3D();
				loader.loadGeometry("d:/dev/flex/3DS MAX/cup2.3ds", max3ds);				
				loader.addOnSuccess(onSuccess);
			}
		}
		
		private function onBtn2Click(e:MouseEvent):void
		{	
			bWire = !bWire;			
			bRollNeeded = !bRollNeeded;
			/*model.material = null;//(bWire) ? new WireColorMaterial({color:"blue"}) : null;
			//(model.children[1] as Mesh).material = null;//(bWire) ? new WireColorMaterial({color:"blue"}) : null;
			model.materialLibrary = null;//(bWire) ? null : matLib;
			//model.children[1].materialLibrary = null;//(bWire) ? null : matLib;*/
		}
		
		public function ex3d():void
		{			
			super();
			// prep for handling resizing events
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// create a 3D-viewport
			cam = new HoverCamera3D({steps:48, zoom:2});
			
			cam.x = -2500;
			cam.y = cam.z = 0;			
			cam.panAngle = 0;
			cam.tiltAngle = 0;
			
			cam.hover();
			//cam.minTiltAngle = -90;
			
			
			view = new View3D({camera:cam, x:stage.stageWidth / 2, y: stage.stageHeight / 2, renderer:Renderer.BASIC});			
			//view.camera.eulers = new Vector3D(90, -90, 0);
			view.scene.eulers = new Vector3D(90, 90, 0);
			
			
			// add viewport to the stage
			addChild(view);		
			
			
			
			// Show the axis
			var axis:Trident = new Trident(2000);
			
			view.scene.addChild(axis);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addControls();
						
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.RESIZE, onResize);

		}	
		
		private function onSuccess(e:Event) : void
		{			
			model = e.target.handle as ObjectContainer3D;
			var geom:GEOM = new GEOM();
			geom.bounds(model);
			
			var v:Vector3D = geom.centerPt();
			model.moveTo(-v.x, -v.y, -v.z);		
			view.scene.addChild(model);
			bLoaded = true;	
						
			cam.distance = geom.radius();
			//cam.hover();	
		}	
		
		private function onResize(e:Event):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{		
			lastPanAngle = cam.panAngle;
			lastTiltAngle = cam.tiltAngle;						
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (e.ctrlKey) scale(stage.mouseY - lastMouseY);
			else if (e.shiftKey) move(stage.mouseX - lastMouseX, stage.mouseY - lastMouseY);
			else if (e.buttonDown) mouseDrag(stage.mouseX - lastMouseX, stage.mouseY - lastMouseY);					
				
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{		
			
			
		}	
		
		private function mouseDrag(nx:int, ny:int):void
		{
			var camSpeed:Number = 0.3; // Approximately same speed as mouse movement.	
			cam.panAngle = camSpeed*(nx) + lastPanAngle;
			cam.tiltAngle = camSpeed*(ny) + lastTiltAngle;	
		}
		
		private function move(nx:int, ny:int):void
		{
			var fmove:Number = 100;
			if (nx != 0) cam.moveForward(100);// += (nx > 0) ? fmove : -fmove;
			if (ny != 0) cam.moveUp(100);// += (ny > 0) ? fmove : -fmove;				
		}
		
		private function scale(ny:int):void
		{			
			if (ny != 0)
			{
				var fscale:Number = (ny > 0) ? 0.95 : 1/0.95;				
				cam.distance *= fscale;
			}
		}
		
		private function onEnterFrame(e:Event):void 
		{			
			/*if (bLoaded && bRollNeeded) model.roll(2);			
					
			
			cam.hover();			
			view.render();*/
			view.scene.rotationZ += 0.1;
			//view.scene.rotationZ++;
			view.render();
		}		
		
		private function destroy():void
		{
			view.scene.removeChild(model);
			matLib = null;
			model = null;
			bLoaded = false;
		}
	}
}

class GEOM
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.*;	
	import flash.geom.Vector3D;
	
	public var xMin:Number = 0;
	public var xMax:Number = 0;
	public var yMin:Number = 0;
	public var yMax:Number = 0;
	public var zMin:Number = 0;
	public var zMax:Number = 0;	
	
	public function bounds(obj:ObjectContainer3D):void
	{	
		for each (var child:Object3D in obj.children)
		{
			if (child is Object3D)
			{
				for each (var v:Vertex in (child as Mesh).vertices)
				{					
					if (v.x < xMin) xMin = v.x;
					else if (v.x > xMax) xMax = v.x;
					
					if (v.y < yMin) yMin = v.y;
					else if (v.y > yMax) yMax = v.y;
					
					if (v.z < zMin) zMin = v.z;
					else if (v.z > zMax) zMax = v.z;					
				}
			}			  
			else bounds(child as ObjectContainer3D);			
		}			
	}
	public function centerPt():Vector3D
	{
		return new Vector3D(xMin + (xMax - xMin) / 2, yMin + (yMax - yMin) / 2, zMin + (zMax - zMin) / 2);
	}
	public function radius():Number
	{
		var div0:Number = xMax - xMin;
		var div1:Number = yMax - yMin;
		var div2:Number = zMax - zMin;
		
		if (div0 > div1) div1 = div0;
		if (div1 > div2) div2 = div1;
		return div2;
	}
};
		