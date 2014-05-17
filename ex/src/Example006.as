package {
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.render.Renderer;
	import away3d.core.utils.Cast;
	import away3d.lights.DirectionalLight3D;
	import away3d.materials.Dot3BitmapMaterial;
	import away3d.materials.EnviroBitmapMaterial;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(backgroundColor="#000000")]
	
	public class Example006 extends Sprite {
		
		[Embed(source="/../assets/away3D.png")] private var Away3DImage:Class;
		private var away3DBitmap:Bitmap = new Away3DImage();
		
		[Embed(source="/../assets/normalMap.png")] private var NormalImage:Class;
		private var normalBitmap:Bitmap = new NormalImage();
		
		[Embed(source="/../assets/asteroidNormal.png")] private var SphereNormalImage:Class;
		private var sphereNormalBitmap:Bitmap = new SphereNormalImage();
		
		[Embed(source="/../assets/checker.jpg")] private var CheckerImage:Class;
		private var checkerBitmap:Bitmap = new CheckerImage();
		
		[Embed(source="/../assets/envMap.png")] private var EnvironmentImage:Class;
		private var envBitmap:Bitmap = new EnvironmentImage();
		
		private static const ORBITAL_RADIUS:Number = 150;
		private static const CAMERA_ORBIT:Number = 600;
		
		private var scene:Scene3D;
		private var camera:HoverCamera3D;
		private var view:View3D;
		
		private var planeGroup:ObjectContainer3D;
		private var normalSphere:Sphere;
		private var envSphere:Sphere;
		private var doRotation:Boolean = false;
		private var lastMouseX:int;
		private var lastMouseY:int;
		private var lastPanAngle:Number = 60;
		private var lastTiltAngle:Number = -60;
		
		
		public function Example006() {
			
			// set up the stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Add resize event listener
			stage.addEventListener(Event.RESIZE, onResize);
			
			// Listen to mouse up and down events on the stage
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			// Initialise Away3D
			init3D();
			
			// Create the 3D objects
			createScene();
			
			// Initialise frame-enter loop
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		/**
		 * Initialise all 3D components.
		 */
		private function init3D():void {
			
			// Create a new scene where all the 3D object will be rendered
			scene = new Scene3D();
			
			// Create a new camera, passing some initialisation parameters
			camera = new HoverCamera3D({zoom:25, focus:30, distance:600});
			camera.targetpanangle = camera.panangle = -10;
			camera.targettiltangle = camera.tiltangle = 20;
			camera.yfactor = 1;
			
			// Create a new view that encapsulates the scene and the camera
			view = new View3D({scene:scene, camera:camera});
			
			// center the view to the middle of the stage
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
			
			// ensure that the z-order is calculated correctly
			view.renderer = Renderer.CORRECT_Z_ORDER;
			
			addChild(view);
		}
		
		/**
		 * Create the objects and lighting of the scene
		 */
		private function createScene():void {
			
			// Create 3 different materials: two normal mapped ones (planar and spherical) and an
			// environment mapped one.
			var normalMapMaterial:Dot3BitmapMaterial = new Dot3BitmapMaterial(Cast.bitmap(away3DBitmap), Cast.bitmap(normalBitmap), {smooth:true, precision:5});
			var envMapMaterial:EnviroBitmapMaterial = new EnviroBitmapMaterial(Cast.bitmap(checkerBitmap), Cast.bitmap(envBitmap), {smooth:true, precision:5});
			var sphereNormalMapMaterial:Dot3BitmapMaterial = new Dot3BitmapMaterial(new BitmapData(1, 1, false, 0x666666), Cast.bitmap(sphereNormalBitmap), {smooth:true, precision:5});
			
			// create a new directional white light source with specific ambient, diffuse and specular parameters
			var light:DirectionalLight3D = new DirectionalLight3D({color:0xFFFFFF, ambient:0.25, diffuse:0.75, specular:0.9});
			light.x = 10000;
			light.z = 50000;
			light.y = 50000;
			scene.addChild(light);
			
			// Create six with the same (normal mapped) material and position them them to create a cube
			var topPlane:Plane = new Plane({material:normalMapMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			topPlane.y = 50;
			var leftPlane:Plane = new Plane({material:normalMapMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			leftPlane.rotationZ = 90;
			leftPlane.x = -50;
			var frontPlane:Plane = new Plane({material:normalMapMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			frontPlane.rotationX = 90;
			frontPlane.z = -50;
			var bottomPlane:Plane = new Plane({material:normalMapMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			bottomPlane.rotationX = 180;
			bottomPlane.y = -50;
			var rightPlane:Plane = new Plane({material:normalMapMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			rightPlane.rotationZ = -90;
			rightPlane.x = 50;
			var backPlane:Plane = new Plane({material:normalMapMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			backPlane.rotationX = -90;
			backPlane.z = 50;
			
			// Create an object container to group the sides of the cube
			planeGroup = new ObjectContainer3D();
			scene.addChild(planeGroup);
			
			planeGroup.addChild(topPlane);
			planeGroup.addChild(leftPlane);
			planeGroup.addChild(frontPlane);
			planeGroup.addChild(bottomPlane);
			planeGroup.addChild(rightPlane);
			planeGroup.addChild(backPlane);
			planeGroup.x = -100;
			planeGroup.z = 100;
			
			// Create a sphere with normal-mapped material
			normalSphere = new Sphere({material:sphereNormalMapMaterial, radius:65, segmentsW:10, segmentsH:10, ownCanvas:true});
			normalSphere.x = 100;
			normalSphere.z = 100;
			scene.addChild(normalSphere);
			
			// Create a sphere with environment-mapped material
			envSphere = new Sphere({material:envMapMaterial, radius:65, segmentsW:10, segmentsH:10, ownCanvas:true});
			envSphere.z = -90;
			scene.addChild(envSphere);
		}
		
		/**
		 * Frame-enter event handler
		 */
		private function loop(event:Event):void {
			
			// rotate the objects
			planeGroup.rotationY += 2;
			normalSphere.rotationY += 2;
			envSphere.rotationY += 2;
			
			// update camera position
			updateCamera();
			camera.hover();  
			
			// Render the 3D scene
			view.render();
		}
		
		/**
		 * Update the camera position from mouse movements
		 */
		private function updateCamera():void {
			if (doRotation) {
				camera.targetpanangle = 0.5 * (stage.mouseX - lastMouseX) + lastPanAngle;
				camera.targettiltangle = 0.5 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}
		}
		
		
		/**
		 * Mouse down listener for camera rotation
		 */
		private function onMouseDown(event:MouseEvent):void {
			lastPanAngle = camera.targetpanangle;
			lastTiltAngle = camera.targettiltangle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			doRotation = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse up listener for camera rotation
		 */
		private function onMouseUp(event:MouseEvent):void {
			doRotation = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse stage leave listener for camera rotation
		 */
		private function onStageMouseLeave(event:Event):void {
			doRotation = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Resize the scene when the stage resizes
		 */ 
		private function onResize(event:Event):void {
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
		}	
	}
}