package {
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Vertex;
	import away3d.materials.WireColorMaterial;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.LineSegment;
	import away3d.primitives.Sphere;
	import away3d.loaders.Max3DS;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(backgroundColor="#000000")]
	
	public class Example001 extends Sprite {
		
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		
		
		public function Example001() {
			
			// set up the stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Initialise Papervision3D
			init3D();
			
			// Create the 3D objects
			createScene();
			
			// Initialise Event loop
			this.addEventListener(Event.ENTER_FRAME, loop);   
		}
		
		private function init3D():void {
			
			// Create a new scene where all the 3D object will be rendered
			scene = new Scene3D();
			
			// Create a new camera, passing some initialisation parameters
			camera = new Camera3D({zoom:20, focus:30, x:-100, y:-100, z:-500});
			
			// Create a new view that encapsulates the scene and the camera
			view = new View3D({scene:scene, camera:camera});
			
			// center the viewport to the middle of the stage
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
			addChild(view);
		}
		
		private function createScene():void {
			
			// First object : a sphere
			
			// Create a new material for the sphere : simple white wireframe
			var sphereMaterial:WireColorMaterial = new WireColorMaterial(0x000000, {wirecolor:0xFFFFFF});
			
			// Create a new sphere object using wireframe material, radius 50 with
			//   10 horizontal and vertical segments
			var sphere:Sphere = new Sphere({material:sphereMaterial, radius:50, segmentsW:10, segmentsH:10});
			
			// Position the sphere (default = [0, 0, 0])
			sphere.x = -100;
			scene.addChild(sphere);
			
			// Second object : x-, y- and z-axis
			
			// Create a origin vertex
			var origin:Vertex = new Vertex(0, 0, 0);
			
			// Create the red-coloured x-axis with a width of 2
			var xAxis:LineSegment = new LineSegment({material:new WireframeMaterial(0xFF0000, {width:2})});
			xAxis.start = origin;
			xAxis.end = new Vertex(100, 0, 0);
			scene.addChild(xAxis);
			
			// Create the green-coloured y-axis with a width of 2
			var yAxis:LineSegment = new LineSegment({material:new WireframeMaterial(0x00FF00, {width:2})});
			yAxis.start = origin;
			yAxis.end = new Vertex(0, 100, 0);
			scene.addChild(yAxis);
			
			// Create the blue-coloured z-axis with a width of 2
			var zAxis:LineSegment = new LineSegment({material:new WireframeMaterial(0x0000FF, {width:2})});
			zAxis.start = origin;
			zAxis.end = new Vertex(0, 0, 100);
			scene.addChild(zAxis);
			
		}
		
		private function loop(event:Event):void {
			// Render the 3D scene
			view.render();
		}
		
	}
}