package {
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.core.render.Renderer;
	import away3d.events.MouseEvent3D;
	import away3d.materials.MovieMaterial;
	import away3d.materials.VideoMaterial;
	import away3d.primitives.Plane;
	
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	[SWF(backgroundColor="#222222")]
	
	public class Example007 extends Sprite {
		
		private var videoURL:String = "http://www.tartiflop.com/away3d/FirstSteps/AmIWrong.flv";
		
		[Embed(source="/../assets/DrawTool.swf")]
		private var DrawToolEmbedded:Class;
		
		private var scene:Scene3D;
		private var camera:HoverCamera3D;
		private var view:View3D;
		
		private var planeGroup:ObjectContainer3D;
		
		private var doRotation:Boolean = true;
		
		public function Example007() {
			
			// set up the stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Add resize event listener
			stage.addEventListener(Event.RESIZE, onResize);
			
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
			camera = new HoverCamera3D({zoom:25, focus:30, distance:200});
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
		 * Create the objects of the scene
		 */
		private function createScene():void {
			
			// Video material using a flash streaming video URL
			var frontMaterial:VideoMaterial = new VideoMaterial({file:videoURL});
			
			// Movie material from an embedded flash animation
			var topMaterial:MovieMaterial = new MovieMaterial(new DrawToolEmbedded(), {lockW:320, lockH:240, interactive:true, smooth:true, precision:5});
			
			// Movie material from another class
			var leftMaterial:MovieMaterial = new MovieMaterial(new Pong(), {smooth:true, precision:5});
			
			// Create three planes with different material, blurred by default
			// and position them them to create tree sides of a cube
			var topPlane:Plane = new Plane({material:topMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			topPlane.rotationY = -180;
			topPlane.y = 50;
			topPlane.filters.push(new BlurFilter(8, 8));
			
			var leftPlane:Plane = new Plane({material:leftMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			leftPlane.rotationZ = -90;
			leftPlane.rotationY = -90;
			leftPlane.x = 50;
			leftPlane.filters.push(new BlurFilter(8, 8));
			
			var frontPlane:Plane = new Plane({material:frontMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			frontPlane.rotationX = -90;
			frontPlane.rotationZ = 180;
			frontPlane.z = 50;
			frontPlane.filters.push(new BlurFilter(8, 8));
			
			// Create an object container to group the sides of the cube
			planeGroup = new ObjectContainer3D();
			scene.addChild(planeGroup);
			planeGroup.addChild(topPlane);
			planeGroup.addChild(leftPlane);
			planeGroup.addChild(frontPlane);
			
			
			// Add mouse listeners to each plane for mouse down, over and out events
			topPlane.addOnMouseDown(onMouseClickOnObject);
			leftPlane.addOnMouseDown(onMouseClickOnObject);
			frontPlane.addOnMouseDown(onMouseClickOnObject);
			topPlane.addOnMouseOver(onMouseOverObject);
			leftPlane.addOnMouseOver(onMouseOverObject);
			frontPlane.addOnMouseOver(onMouseOverObject);
			topPlane.addOnMouseOut(onMouseLeavesObject);
			leftPlane.addOnMouseOut(onMouseLeavesObject);
			frontPlane.addOnMouseOut(onMouseLeavesObject);
			
		}
		
		/**
		 * Frame-enter event handler
		 */
		private function loop(event:Event):void {
			
			// update camera position
			updateCamera();
			camera.hover();
			
			// Render the 3D scene
			view.render();
		}
		
		/**
		 * Update the camera position from mouse positions
		 */
		private function updateCamera():void {
			if (doRotation) {
				camera.targetpanangle =  (stage.stageWidth - stage.mouseX) / stage.stageWidth * 90;
				camera.targettiltangle = (stage.stageHeight - stage.mouseY) / stage.stageHeight * 70
			}
		}
		
		
		/**
		 * Event listener for mouse click on plane. Makes the camera look
		 * directly at the plane and move closer to it.
		 */
		private function onMouseClickOnObject(event:MouseEvent3D):void {
			var object:Object3D = event.object;
			
			doRotation = false;
			
			// Calculate angles necessary for camera     
			var theta:Number = Math.atan2(object.x, object.z);
			var len:Number = Math.sqrt(object.x*object.x + object.z*object.z);
			var phi:Number = Math.atan2(object.y, len);
			
			// rotate camera position
			camera.targetpanangle = theta * 180 / Math.PI;
			camera.targettiltangle = phi * 180 / Math.PI;
			
			// move camera towards plane
			Tweener.addTween(camera, {distance:150, time:0.5, transition:"easeOutSine"});
		}    
		
		/**
		 * Event listener for mouse over plane. Removes the blur filter.
		 */   
		private function onMouseOverObject(event:MouseEvent3D):void {
			var object:Object3D = event.object;
			
			object.filters = new Array();
		}   
		
		/**
		 * Event listener for mouse out of plane. Adds blur filter and moves
		 * camera away from plane if it isn't already.
		 */
		private function onMouseLeavesObject(event:MouseEvent3D):void {
			var object:Object3D = event.object;
			
			object.filters.push(new BlurFilter(8, 8));
			Tweener.addTween(camera, {distance:200, time:0.5, transition:"easeOutSine"});
			doRotation = true;
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