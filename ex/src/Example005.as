package {
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.core.math.Number3D;
	import away3d.core.render.Renderer;
	import away3d.core.utils.Cast;
	import away3d.events.MouseEvent3D;
	import away3d.lights.DirectionalLight3D;
	import away3d.materials.PhongBitmapMaterial;
	import away3d.materials.WhiteShadingBitmapMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Cylinder;
	import away3d.primitives.Sphere;
	import away3d.primitives.Torus;
	
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(backgroundColor="#000000")]
	
	public class Example005 extends Sprite {
		
		[Embed(source="/../assets/earth.jpg")] private var EarthImage:Class;
		private var earthBitmap:Bitmap = new EarthImage();
		
		[Embed(source="/../assets/away3D.png")] private var Away3DImage:Class;
		private var away3DBitmap:Bitmap = new Away3DImage();
		
		[Embed(source="/../assets/checker.jpg")] private var CheckerImage:Class;
		private var checkerBitmap:Bitmap = new CheckerImage();
		
		private static const ORBITAL_RADIUS:Number = 150;
		private static const CAMERA_ORBIT:Number = 600;
		
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		
		private var group:ObjectContainer3D;
		private var sphere:Sphere;
		private var cube:Cube;
		private var centerCube:Cube;
		private var cylinder:Cylinder;
		private var torus:Torus;
		
		private var doRotation:Boolean = false;
		private var lastMouseX:int;
		private var lastMouseY:int;
		private var cameraPitch:Number = 60;
		private var cameraYaw:Number = -60;
		
		
		public function Example005() {
			
			// set up the stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Add resize event listener
			stage.addEventListener(Event.RESIZE, onResize);
			
			// Listen to mouse up and down events on the stage
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
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
			camera = new Camera3D({zoom:25, focus:30});
			setCameraPosition();
			
			// Create a new view that encapsulates the scene and the camera
			view = new View3D({scene:scene, camera:camera, renderer:Renderer.CORRECT_Z_ORDER});
			
			// center the viewport to the middle of the stage
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
			
			//view.renderer = Renderer.CORRECT_Z_ORDER;
			
			addChild(view);
		}
		
		private function createScene():void {
			
			// create a new directional white light source with specific ambient, diffuse and specular parameters
			var light:DirectionalLight3D = new DirectionalLight3D({color:0xFFFFFF, ambient:0.25, diffuse:0.75, specular:0.9});
			light.x = 100;
			light.z = 500;
			light.y = 500;
			scene.addChild(light);
			
			// Create an object container to group the objects on the scene
			group = new ObjectContainer3D();
			scene.addChild(group);
			
			// Create a new sphere object using a very shiny phong-shaded bitmap material representing the earth
			var earthMaterial:PhongBitmapMaterial = new PhongBitmapMaterial(Cast.bitmap(earthBitmap));
			earthMaterial.shininess = 100;
			sphere = new Sphere({material:earthMaterial, radius:50, segmentsW:10, segmentsH:10});
			sphere.x = ORBITAL_RADIUS;
			sphere.ownCanvas = true;
			group.addChild(sphere);
			
			// Create a new cube object using a tiled, phong-shaded bitmap material
			var tiledAway3DMaterial:PhongBitmapMaterial = new PhongBitmapMaterial(Cast.bitmap(away3DBitmap), {repeat:true, scaleX:.5, scaleY:.5});
			cube = new Cube({material:tiledAway3DMaterial, width:75, height:75, depth:75});
			cube.z = -ORBITAL_RADIUS;
			cube.ownCanvas = true;
			group.addChild(cube);
			
			// Create a cylinder mapping the earth data again
			cylinder = new Cylinder({material:earthMaterial, radius:25, height:100, segmentsW:16});
			cylinder.x = -ORBITAL_RADIUS;
			cylinder.ownCanvas = true;
			group.addChild(cylinder);
			
			// Create a torus object and use a checkered, flat-shaded (from white light) bitmap material
			var checkerBitmapMaterial:WhiteShadingBitmapMaterial = new WhiteShadingBitmapMaterial(Cast.bitmap(checkerBitmap));
			torus = new Torus({material:checkerBitmapMaterial, radius:40, tube:10, segmentsT:8, segmentsR:16});
			torus.z = ORBITAL_RADIUS;
			torus.ownCanvas = true;
			group.addChild(torus);
			
			// Create a new cube object using a smoothed, precise, phong-shaded, mat (not shiny) bitmap material
			var away3DMaterial:PhongBitmapMaterial = new PhongBitmapMaterial(Cast.bitmap(away3DBitmap), {smooth:true, precision:2});
			away3DMaterial.shininess = 0;
			centerCube = new Cube({material:away3DMaterial, width:75, height:75, depth:75});
			centerCube.ownCanvas = true;
			group.addChild(centerCube);
			
			// add mouse listeners to all the 3D objects
			sphere.addOnMouseDown(onMouseDownOnObject);
			cube.addOnMouseDown(onMouseDownOnObject);
			cylinder.addOnMouseDown(onMouseDownOnObject);
			torus.addOnMouseDown(onMouseDownOnObject);
			centerCube.addOnMouseDown(onMouseDownOnObject);
		}
		
		private function loop(event:Event):void {
			
			// rotate the group of objects
			group.yaw(2);
			
			// rotate the objects
			sphere.yaw(-4);
			cube.yaw(-4);
			cylinder.yaw(-4);
			torus.yaw(-4);
			
			// update the camera position
			updateCamera();
			
			// Render the 3D scene
			view.render();
		}
		
		// updates the camera position
		private function updateCamera():void {
			
			// If the mouse button has been clicked then update the camera position     
			if (doRotation) {
				
				// convert the change in mouse position into a change in camera angle
				var dPitch:Number = (mouseY - lastMouseY) / 2;
				var dYaw:Number = (mouseX - lastMouseX) / 2;
				
				// update the camera angles
				cameraPitch -= dPitch;
				cameraYaw -= dYaw;
				// limit the pitch of the camera
				if (cameraPitch <= 0) {
					cameraPitch = 0.1;
				} else if (cameraPitch >= 180) {
					cameraPitch = 179.9;
				}
				
				// reset the last mouse position
				lastMouseX = mouseX;
				lastMouseY = mouseY;
				
				// reposition the camera
				setCameraPosition();
			}
			
		}
		
		// sets the camera position given pitch and yaw angles
		private function setCameraPosition():void {
			camera.y = CAMERA_ORBIT * Math.cos(cameraPitch * Math.PI / 180);
			camera.x = CAMERA_ORBIT * Math.sin(cameraPitch * Math.PI / 180) * Math.cos(cameraYaw * Math.PI / 180);
			camera.z = CAMERA_ORBIT * Math.sin(cameraPitch * Math.PI / 180) * Math.sin(cameraYaw * Math.PI / 180);
			
			// keep the camera looking at the origin
			camera.lookAt(new Number3D);
		}
		
		// called when mouse down on stage
		private function onMouseDown(event:MouseEvent):void {
			doRotation = true;
			lastMouseX = event.stageX;
			lastMouseY = event.stageY;
		}
		
		// called when mouse up on stage
		private function onMouseUp(event:MouseEvent):void {
			doRotation = false;
		}
		
		// called when mouse down on a 3D object
		private function onMouseDownOnObject(event:MouseEvent3D):void {
			var object:Object3D = event.object;
			Tweener.addTween(object, {y:200, time:1, transition:"easeOutSine", onComplete:function():void {goBack(object);} });
		}
		
		// called when a tween created in onMouseDownOnObject has terminated
		private function goBack(object:Object3D):void {
			Tweener.addTween(object, {y:0, time:2, transition:"easeOutBounce"});
		}
		
		// called when the window is resized
		private function onResize(event:Event):void {
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
		}
		
	}
}	
	
