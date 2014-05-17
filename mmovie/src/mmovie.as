package
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Face;
	import away3d.core.base.Vertex;
	import away3d.materials.*;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	import away3d.primitives.Triangle;
	import away3d.primitives.Trident;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.system.Capabilities;
	
	[SWF(height = "600", width="800", frameRate="12")]
	
	public class mmovie extends Sprite
	{
		//[Embed(source="assets/GameMenu.swf")]
		[Embed(source="assets/ConnectToServ.swf")]
		private var FlexAppTexture:Class;
		
		private var cam:Camera3D;
		private var scene:Scene3D;		
		private var view:View3D;		
		
		private var mm:MovieMaterial;		
		private var tri:Triangle;		
		
		public function mmovie()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			init3D();
			createScene();
			addEventListener(Event.ENTER_FRAME, OnEnterFrame);  
		}		
		
		private function createScene():void
		{
			if (flash.system.Capabilities.isDebugger) view.scene.addChild(new Trident(200));	
			
			mm = new MovieMaterial(new FlexAppTexture());			
			mm.interactive = true;
			mm.smooth = true;			
			
			tri = new Triangle();
			tri.a = new Vertex(-200, -300, 0);
			tri.b = new Vertex(0, -100, 0);
			tri.c = new Vertex(0, -300, 0);			
			tri.material = mm;
			
			tri.faces[0].uvs[0].u = 0;
			tri.faces[0].uvs[0].v = 0;
			tri.faces[0].uvs[1].u = 0.33;
			tri.faces[0].uvs[1].v = 0;
			tri.faces[0].uvs[2].u = 0;
			tri.faces[0].uvs[2].v = 1;
			
			view.scene.addChild(tri);
			
			tri = new Triangle();
			tri.a = new Vertex(0, -300, 0);
			tri.b = new Vertex(0, -100, 0);
			tri.c = new Vertex(200, -100, 0);
			tri.material = mm;
			
			tri.faces[0].uvs[0].u = 0;
			tri.faces[0].uvs[0].v = 1;
			tri.faces[0].uvs[1].u = 0.33;
			tri.faces[0].uvs[1].v = 0;
			tri.faces[0].uvs[2].u = 0.33;
			tri.faces[0].uvs[2].v = 1;
			view.scene.addChild(tri);
			
			tri = new Triangle();
			tri.a = new Vertex(0, -100, 0);
			tri.b = new Vertex(0, 100, 0);
			tri.c = new Vertex(200, -100, 0);
			tri.material = mm;
			
			tri.faces[0].uvs[0].u = 0.33;
			tri.faces[0].uvs[0].v = 0;
			tri.faces[0].uvs[1].u = 0.67;
			tri.faces[0].uvs[1].v = 0;
			tri.faces[0].uvs[2].u = 0.33;
			tri.faces[0].uvs[2].v = 1;
			view.scene.addChild(tri);
			
			tri = new Triangle();
			tri.a = new Vertex(200, -100, 0);
			tri.b = new Vertex(0, 100, 0);
			tri.c = new Vertex(200, 100, 0);
			tri.material = mm;
			
			tri.faces[0].uvs[0].u = 0.33;
			tri.faces[0].uvs[0].v = 1;
			tri.faces[0].uvs[1].u = 0.67;
			tri.faces[0].uvs[1].v = 0;
			tri.faces[0].uvs[2].u = 0.67;
			tri.faces[0].uvs[2].v = 1;
			view.scene.addChild(tri);
			
			tri = new Triangle();
			tri.a = new Vertex(0, 100, 0);
			tri.b = new Vertex(0, 300, 0);
			tri.c = new Vertex(200, 100, 0);
			tri.material = mm;
			
			tri.faces[0].uvs[0].u = 0.67;
			tri.faces[0].uvs[0].v = 0;
			tri.faces[0].uvs[1].u = 1;
			tri.faces[0].uvs[1].v = 1;
			tri.faces[0].uvs[2].u = 0.67;
			tri.faces[0].uvs[2].v = 1;
			view.scene.addChild(tri);
			
			tri = new Triangle();
			tri.a = new Vertex(0, 100, 0);
			tri.b = new Vertex(-200, 300, 0);
			tri.c = new Vertex(0, 300, 0);
			tri.material = mm;
			
			tri.faces[0].uvs[0].u = 0.67;
			tri.faces[0].uvs[0].v = 0;
			tri.faces[0].uvs[1].u = 1;
			tri.faces[0].uvs[1].v = 0;
			tri.faces[0].uvs[2].u = 1;
			tri.faces[0].uvs[2].v = 1;
			view.scene.addChild(tri);
		}
		
		private function init3D():void 
		{
			scene = new Scene3D();
			cam = new Camera3D({zoom:15});
			cam.moveTo(0, 0, 1000);
			cam.lookAt(new Vector3D(0, 0, 0), Vector3D.X_AXIS);
			view = new View3D({scene:scene, camera:cam});
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
			addChild(view);			
		}
		
		private function OnEnterFrame(e:Event) : void
		{
			view.render();
		}		
	}
}