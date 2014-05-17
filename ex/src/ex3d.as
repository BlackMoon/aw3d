package {
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.core.math.Number3D;
	import away3d.core.utils.Cast;
	import away3d.events.MouseEvent3D;
	import away3d.loaders.Max3DS;
	import away3d.loaders.Object3DLoader;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.TransformBitmapMaterial;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Cylinder;
	import away3d.primitives.Sphere;
	import away3d.primitives.Torus;
	
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.graphics.codec.JPEGEncoder;
	
	
	[SWF(backgroundColor="#ffffff")]
	
	public class ex3d extends Sprite {
		
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
		private var model:Object3DLoader;
		//private var loader:Object3DLoader;
		
		private var doRotation:Boolean = false;
		private var lastMouseX:int;
		private var lastMouseY:int;
		private var cameraPitch:Number = 60;
		private var cameraYaw:Number = -60;
		
		
		public function ex3d() {
			
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
			view = new View3D({scene:scene, camera:camera});
			
			// center the viewport to the middle of the stage
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
			addChild(view);
		}
		
		private function modelOnSuccess(event:Event):void {
			
			
			trace("loaded");
			
		}
		
		private function createScene():void {
			
			// Create an object container to group the objects on the scene
			//group = new ObjectContainer3D();
			//scene.addChild(group);
			
			
			
			
			model = Max3DS.load("d:/FORDGT90.3ds", {material:new WireframeMaterial(0xff0000, {width:4})});			
			
			model.addOnSuccess(modelOnSuccess);
			if (/*loaded*/model)
			{				
				var x:Number = model.objectWidth;
				var y:Number = model.objectHeight;
				var z:Number = model.objectDepth;
				
				model.scale(0.01);
				x = model.objectWidth;
				scene.addChild(model);
			}
			
			
			//model.materialLibrary 
			
			
			
			
			// Create a new sphere object using a bitmap material representing the earth
			/*var earthMaterial:BitmapMaterial = new BitmapMaterial(Cast.bitmap(earthBitmap));
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
			
			// add mouse listeners to all the 3D objects
			sphere.addOnMouseDown(onMouseDownOnObject);
			cube.addOnMouseDown(onMouseDownOnObject);
			cylinder.addOnMouseDown(onMouseDownOnObject);
			torus.addOnMouseDown(onMouseDownOnObject);
			centerCube.addOnMouseDown(onMouseDownOnObject);			
			*/
		}			
		
		private function loop(event:Event):void {
			
			// rotate the group of objects
			//group.yaw(2);
			
			// rotate the objects
			/*sphere.yaw(-4);
			cube.yaw(-4);
			cylinder.yaw(-4);
			torus.yaw(-4);*/
			
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
			camera.lookAt(new Number3D(0, 0, 0));
		}
		
		// called when mouse down on stage
		private function onMouseDown(event:MouseEvent):void {
			doRotation = true;
			lastMouseX = event.stageX;
			lastMouseY = event.stageY;
			
			/*var bmpData:BitmapData = new BitmapData(width, height);
			bmpData.draw(this.stage);			
			
			var a:uint = bmpData.getPixel(0, 0);
			var b:uint = a << 1;
			
			
			
			
			var jpgEncoder:JPEGEncoder = new JPEGEncoder();
			var data:ByteArray = jpgEncoder.encode(bmpData); 
			
			var header:flash.net.URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var uRLRequest:flash.net.URLRequest = new URLRequest("/saveAsImage.php?name=chart.png");
			uRLRequest.requestHeaders.push(header);
			uRLRequest.method = flash.net.URLRequestMethod.POST;
			uRLRequest.data = data;
			flash.net.navigateToURL(uRLRequest);*/
			
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
