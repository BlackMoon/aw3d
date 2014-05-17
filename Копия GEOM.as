package
{	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.*;	
	import flash.geom.Vector3D;
	
	public class GEOM
	{
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
	}
}