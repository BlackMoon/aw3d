package {
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.math.Number3D;
	import away3d.core.utils.Cast;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.TransformBitmapMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Cylinder;
	import away3d.primitives.Sphere;
	import away3d.primitives.Torus;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(backgroundColor="#000000")]
	
	public class Example003 extends Sprite {
		
		[Embed(source="/../assets/earth.jpg")] private var EarthImage:Class;
		private var earthBitmap:Bitmap = new EarthImage();
		
		[Embed(source="/../assets/away3D.png")] private var Away3DImage:Class;
		private var away3DBitmap:Bitmap = new Away3DImage();
		
		[Embed(source="/../assets/checker.jpg")] private var CheckerImage:Class;
		private var checkerBitmap:Bitmap = new CheckerImage();
		
		private static const ORBITAL_RADIUS:Number = 150;
		
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		
		private var group:ObjectContainer3D;
		private var sphere:Sphere;
		private var cube:Cube;
		private var centerCube:Cube;
		private var cylinder:Cylinder;
		private var torus:Torus;
		
		public function Example003() {
			
			// set up the stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Add resize event listener
			stage.addEventListener(Event.RESIZE, onResize);
			
			// Initialise Papervision3D
			init3D();
			
			// Create the 3D objects
			createScene();
			
			// Initialise frame-enter loop
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function init3D():void {
			
			// Create a new scene where all the 3D object will be rendered
			scene = new Scene3D();
			
			// Create a new camera, passing some initialisation parameters
			camera = new Camera3D({zoom:25, focus:30, x:-200, y:400, z:-400});
			camera.lookAt(new Number3D(0, 0, 0));
			
			// Create a new view that encapsulates the scene and the camera
			view = new View3D({scene:scene, camera:camera});
			
			// center the viewport to the middle of the stage
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
			addChild(view);
		}
		
		private function createScene():void {
			
			// Create an object container to group the objects on the scene
			group = new ObjectContainer3D();
			scene.addChild(group);
			
			// Create a new sphere object using a bitmap material representing the earth
			var earthMaterial:BitmapMaterial = new BitmapMaterial(Cast.bitmap(earthBitmap));
			sphere = new Sphere({material:earthMaterial, radius:50, segmentsW:10, segmentsH:10});
			sphere.x = ORBITAL_RADIUS;
			group.addChild(sphere);
			
			// Create a new cube object using a tiled bitmap material
			var tiledAway3DMaterial:TransformBitmapMaterial = new TransformBitmapMaterial(Cast.bitmap(away3DBitmap), {repeat:true, scaleX:.5, scaleY:.5});
			cube = new Cube({material:tiledAway3DMaterial, width:75, height:75, depth:75});
			cube.z = -ORBITAL_RADIUS;
			group.addChild(cube);
			
			// Create a cylinder mapping the earth data again
			cylinder = new Cylinder({material:earthMaterial, radius:25, height:100, segmentsW:16});
			cylinder.x = -ORBITAL_RADIUS;
			group.addChild(cylinder);
			
			// Create a torus object and use a checkered bitmap material
			var checkerBitmapMaterial:BitmapMaterial = new BitmapMaterial(Cast.bitmap(checkerBitmap));
			torus = new Torus({material:checkerBitmapMaterial, radius:40, tube:10, segmentsT:8, segmentsR:16});
			torus.z = ORBITAL_RADIUS;
			group.addChild(torus);
			
			// Create a new cube object using a smoothed, precise bitmap material
			var away3DMaterial:BitmapMaterial = new BitmapMaterial(Cast.bitmap(away3DBitmap), {smooth:true, precision:2});
			centerCube = new Cube({material:away3DMaterial, width:75, height:75, depth:75});
			group.addChild(centerCube);
		}
		
		private function loop(event:Event):void {
			
			// rotate the group of objects
			group.yaw(2);
			
			// rotate the objects
			sphere.yaw(-4);
			cube.yaw(-4);
			cylinder.yaw(-4);
			torus.yaw(-4);
			
			// Render the 3D scene
			view.render();
		}
		
		private function onResize(event:Event):void {
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
		}
	}
}