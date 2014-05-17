package {
	import away3d.containers.*;
	import away3d.core.utils.Cast;
	import away3d.lights.DirectionalLight3D;
	import away3d.materials.*;
	import away3d.primitives.Sphere;
	
	import com.adobe.viewsource.ViewSource;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF (width="600",height="600",frameRate="31",backgroundColor="0xececec")]
	public class away3d_prj05_materials extends Sprite
	{
		[Embed (source="assets/earthmap.png")]
		private var bitmapTexture:Class;
		[Embed (source="assets/earthnightmap.png")]
		private var bitmapTexture2:Class;
		[Embed (source="assets/earthnormalmapz.png")]
		private var bitmapNZ:Class;
		private var view:View3D;
		private var sphere:Sphere;
		private var matIndex:int=-1;
		private var matlib:Array;
		
		public function away3d_prj05_materials()
		{
			//ViewSource.addMenuItem(this, "srcview/index.html");

			initMatlib();
			
			view=new View3D;
			view.x=stage.stageWidth*0.5;
			view.y=stage.stageHeight*0.5;
			addChild(view);
			view.camera.z=-500;
			
			var scene:Scene3D=new Scene3D;
			view.scene=scene;
			
			var m:PhongColorMaterial
			m=new PhongColorMaterial(0xff0000);
			m.shininess=100;
			m.specular=0.7;
			
			sphere=new Sphere;
			sphere.segmentsW=20;
			sphere.segmentsH=10;
			scene.addChild(sphere);
			assignNextMaterial();
			
			var light:DirectionalLight3D=new DirectionalLight3D;
			light.direction.x = 200;
		    light.direction.z = -100;
      		light.direction.y = 300;			
			light.color = 0xFFFFFF;
			light.ambient = 0.5;
			light.diffuse = 0.7;
			scene.addLight(light);
			  
			this.addEventListener(Event.ENTER_FRAME,renderLoop);
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMW);
			this.stage.addEventListener(MouseEvent.CLICK,onSphereMD);
		}
		private function renderLoop(e:*=null):void
		{
			sphere.rotationY+=-(mouseX-stage.stageWidth*0.5)/50
			sphere.rotationX+=(mouseY-stage.stageHeight*0.5)/50
			view.render();
		}
		private function initMatlib():void
		{
			matlib=[];
			
			var curr:WireColorMaterial;
			curr=new WireColorMaterial;
			curr.color=0xff0000;
			curr.wireColor=0;
			//matlib.push(curr);
			
			var curr1:PhongColorMaterial;
			curr1=new PhongColorMaterial({});
			curr1.color=0xff0000;
			//matlib.push(curr1);
			
			var curr2:BitmapMaterial=new BitmapMaterial(Cast.bitmap(new bitmapTexture));
			curr2.smooth=true;
			//matlib.push(curr2);
			
			var curr21:WhiteShadingBitmapMaterial=new WhiteShadingBitmapMaterial(Cast.bitmap(new bitmapTexture));
			curr21.shininess=1
			matlib.push(curr21);

			var curr3:PhongBitmapMaterial=new PhongBitmapMaterial(Cast.bitmap(new bitmapTexture));
			matlib.push(curr3);
			
			var curr4:EnviroBitmapMaterial=new EnviroBitmapMaterial(Cast.bitmap(new bitmapTexture),Cast.bitmap(new bitmapTexture2));
			curr4.reflectiveness=0.3
			matlib.push(curr4);
			
			var curr5:Dot3BitmapMaterial=new Dot3BitmapMaterial(Cast.bitmap(new bitmapTexture),Cast.bitmap(new bitmapNZ));
			matlib.push(curr5);
				
		}
		private function onMW(e:MouseEvent):void
		{
			view.camera.z+=e.delta*10;
		}
		private function onSphereMD(e:*):void
		{
			assignNextMaterial();
		}
		private function assignNextMaterial():void
		{
			matIndex++;
			matIndex=matIndex == matlib.length ? 0 : matIndex;
			sphere.material=matlib[matIndex];
		}
	}
}
