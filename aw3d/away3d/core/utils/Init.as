package away3d.core.utils
{
    import away3d.arcane;
    import away3d.core.base.*;
    import away3d.materials.*;
    import away3d.primitives.data.*;
    
    import flash.display.*;
    import flash.geom.*;

	use namespace arcane;
	
    /** Convinient object initialization support */
    public class Init
    {
		/** @private */
        arcane var _init:Object;

        public function Init(init:Object)
        {
            this._init = init;
        }

        public static function parse(init:Object):Init
        {
            if (init == null)
                return new Init(null);
            if (init is Init)
                return init as Init;

            inits.push(init);
            return new Init(init);
        }

        public function getInt(name:String, def:int, bounds:Object = null):int
        {
            if (this._init == null)
                return def;
        
            if (!this._init.hasOwnProperty(name))
                return def;
        
            var result:int = this._init[name];

            if (bounds != null)
            {
                if (bounds.hasOwnProperty("min"))
                {
                    var min:int = bounds["min"];
                    if (result < min)
                        result = min;
                }
                if (bounds.hasOwnProperty("max"))
                {
                    var max:int = bounds["max"];
                    if (result > max)
                        result = max;
                }
            }
        
            delete this._init[name];
        
            return result;
        }

        public function getNumber(name:String, def:Number, bounds:Object = null):Number
        {
            if (this._init == null)
                return def;
        
            if (!this._init.hasOwnProperty(name))
                return def;
        
            var result:Number = this._init[name];
                                        
            if (bounds != null)
            {
                if (bounds.hasOwnProperty("min"))
                {
                    var min:Number = bounds["min"];
                    if (result < min)
                        result = min;
                }
                if (bounds.hasOwnProperty("max"))
                {
                    var max:Number = bounds["max"];
                    if (result > max)
                        result = max;
                }
            }
        
            delete this._init[name];
        
            return result;
        }

        public function getString(name:String, def:String):String
        {
            if (this._init == null)
                return def;
        
            if (!this._init.hasOwnProperty(name))
                return def;
        
            var result:String = this._init[name];

            delete this._init[name];
        
            return result;
        }

        public function getBoolean(name:String, def:Boolean):Boolean
        {
            if (this._init == null)
                return def;
        
            if (!this._init.hasOwnProperty(name))
                return def;
        
            var result:Boolean = this._init[name];

            delete this._init[name];
        
            return result;
        }

        public function getObject(name:String, type:Class = null):Object
        {
            if (this._init == null)
                return null;
        
            if (!this._init.hasOwnProperty(name))
                return null;
        
            var result:Object = this._init[name];

            delete this._init[name];

            if (result == null)
                return null;

            if (type != null)
                if (!(result is type))
                    throw new CastError("Parameter \""+name+"\" is not of class "+type+": "+result);

            return result;
        }

        public function getObjectOrInit(name:String, type:Class = null):Object
        {
            if (this._init == null)
                return null;
        
            if (!this._init.hasOwnProperty(name))
                return null;
        
            var result:Object = this._init[name];

            delete this._init[name];

            if (result == null)
                return null;

            if (type != null)
                if (!(result is type))
                    return new type(result);

            return result;
        }

        public function getObject3D(name:String):Object3D
        {
            return getObject(name, Object3D) as Object3D;
        }

        public function getVector3D(name:String):Vector3D
        {
            return getObject(name, Vector3D) as Vector3D;
        }

        public function getPosition(name:String):Vector3D
        {
            var value:Object = getObject(name);

            if (value == null)
                return null;

            if (value is Vector3D)
                return value as Vector3D;

            if (value is Object3D)
            {
                var o:Object3D = value as Object3D;
                return o.scene ? o.scenePosition : o.position;
            }

            if (value is String)
                if (value == "center")
                    return new Vector3D();

            throw new CastError("Cast get position of "+value);
        }

        public function getArray(name:String):Array
        {
            if (this._init == null)
                return [];
        
            if (!this._init.hasOwnProperty(name))
                return [];
        
            var result:Array = this._init[name];

            delete this._init[name];
        
            return result;
        }

        public function getInit(name:String):Init
        {
            if (this._init == null)
                return new Init(null);
        
            if (!this._init.hasOwnProperty(name))
                return new Init(null);
        
            var result:Init = Init.parse(this._init[name]);

            delete this._init[name];
        
            return result;
        }
		
        public function getCubeMaterials(name:String):CubeMaterialsData
        {
            if (this._init == null)
                return null;
        
            if (!this._init.hasOwnProperty(name))
                return null;
        	
        	var result:CubeMaterialsData;
        	
        	if (this._init[name] is CubeMaterialsData)
        		result = this._init[name] as CubeMaterialsData;
        	else if (this._init[name] is Object)
        		result = new CubeMaterialsData(this._init[name]);

            delete this._init[name];
        
            return result;
        }
        
        public function getColor(name:String, def:uint):uint
        {
            if (this._init == null)
                return def;
        
            if (!this._init.hasOwnProperty(name))
                return def;
        
            var result:uint = Cast.color(this._init[name]);

            delete this._init[name];
        
            return result;
        }

        public function getBitmap(name:String):BitmapData
        {
            if (this._init == null)
                return null;
        
            if (!this._init.hasOwnProperty(name))
                return null;
        
            var result:BitmapData = Cast.bitmap(this._init[name]);

            delete this._init[name];
        
            return result;
        }

        public function getMaterial(name:String):Material
        {
            if (this._init == null)
                return null;
        
            if (!this._init.hasOwnProperty(name))
                return null;
        
            var result:Material = Cast.material(this._init[name]);

            delete this._init[name];
        
            return result;
        }

        private static var inits:Array = [];

        arcane function removeFromCheck():void
        {
            if (this._init == null)
                return;

			this._init["dontCheckUnused"] = true;
        }

        arcane function addForCheck():void
        {
            if (this._init == null)
                return;

			this._init["dontCheckUnused"] = false;
            inits.push(this._init);
        }

        arcane static function checkUnusedArguments():void
        {
            if (inits.length == 0)
                return;

            var list:Array = inits;
            inits = [];
            for each (var init:Object in list)
            {
                if (init.hasOwnProperty("dontCheckUnused"))
                    if (init["dontCheckUnused"])
                        continue;
                        
                var s:String = null;
                for (var name:String in init)
                {
                    if (name == "dontCheckUnused")
                        continue;

                    if (s == null)
                        s = "";
                    else
                        s +=", ";
                    s += name+":"+init[name];
                }
                if (s != null)
                {
                    Debug.warning("Unused arguments: {"+s+"}");
                }
            }
        }
    }
}
