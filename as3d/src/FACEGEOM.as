package
{	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.*;
	import away3d.materials.Material;	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class FACEGEOM
	{
		/** @private */
		private var _obj:ObjectContainer3D;
		private var _faceLib:Vector.<Material>;
		
		public var xMin:Number;
		public var xMax:Number;
		public var yMin:Number;
		public var yMax:Number;
		public var zMin:Number;
		public var zMax:Number;
		/**
		 * Store for all materials and bounds associated with each mesh face.
		 */
		public function FACEGEOM(obj:ObjectContainer3D)
		{
			_obj = obj;
			xMin = yMin = zMin = Number.MAX_VALUE;	
			xMax = yMax = zMax = -Number.MAX_VALUE;
			
			_faceLib = new Vector.<Material>();
			for each (var child:Mesh in _obj.children)
			{				 
				for each (var face:Face in child.faces)
				{					
					/*for each (var v:Vertex in face. .vertices)
					{
						if (v.x < xMin) xMin = v.x;
						else if (v.x > xMax) xMax = v.x;
						
						if (v.y < yMin) yMin = v.y;
						else if (v.y > yMax) yMax = v.y;
						
						if (v.z < zMin) zMin = v.z;
						else if (v.z > zMax) zMax = v.z;						
					}*/	
					_faceLib.push(face.material);
				}
			}
		}
		
		public function get obj():ObjectContainer3D
		{
			return _obj;
		}
		
		public function set obj(value:ObjectContainer3D):void
		{
			if (_obj != value) _obj = value;
		}		
				
		public function faceMaterial(i:uint):Material
		{			
			return _faceLib[i];
		}
		/**
		 * Returns the center point of 3d object
		 */
		public function get centerPt():Vector3D
		{
			return new Vector3D(xMin + (xMax - xMin) / 2, yMin + (yMax - yMin) / 2, zMin + (zMax - zMin) / 2);
		}
		/**
		 * Returns max value of objectDepth, objectHeight and objectWidth
		 */
		public function get diametr():Number
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