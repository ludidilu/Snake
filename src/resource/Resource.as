package resource
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import record.Record;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Resource
	{
		public static const FONT_NAME0:String = "myFont0";
		
		public static const FONT_NAME1:String = "myFont1";
		
		private static var loadNum:int = 6;
		
		public static var textureAtlas:TextureAtlas;
		
		private static var texture:Texture;
		
		private static var xml:XML;
		
		private static var fontTexture0:Texture;
		
		private static var fontXML0:XML;
		
		private static var fontTexture1:Texture;
		
		private static var fontXML1:XML;
		
		private static var soundVec:Vector.<Sound>;
		
		private static var callBack:Function;
		
		public static function init(_callBack:Function):void{
			
			callBack = _callBack;
			
			var loader:Loader = new Loader;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,picLoadOK);
			
			loader.load(new URLRequest("./asset/ui/pic.png"));
			
			var urlLoader:URLLoader = new URLLoader;
			
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			urlLoader.addEventListener(Event.COMPLETE,xmlLoadOK);
			
			urlLoader.load(new URLRequest("./asset/ui/pic.xml"));
			
			loader = new Loader;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,fontPicLoadOK0);
			
			loader.load(new URLRequest("./asset/font/font0.png"));
			
			urlLoader = new URLLoader;
			
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			urlLoader.addEventListener(Event.COMPLETE,fontXMLLoadOK0);
			
			urlLoader.load(new URLRequest("./asset/font/font0.fnt"));
			
			loader = new Loader;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,fontPicLoadOK1);
			
			loader.load(new URLRequest("./asset/font/font1.png"));
			
			urlLoader = new URLLoader;
			
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			urlLoader.addEventListener(Event.COMPLETE,fontXMLLoadOK1);
			
			urlLoader.load(new URLRequest("./asset/font/font1.fnt"));
			
			soundVec = new Vector.<Sound>(3,true);
			
			soundVec[0] = new Sound(new URLRequest("./asset/audio/touch.mp3"));
			
			soundVec[0].addEventListener(Event.COMPLETE,soundLoadOK);
			
			soundVec[1] = new Sound(new URLRequest("./asset/audio/move.mp3"));
			
			soundVec[1].addEventListener(Event.COMPLETE,soundLoadOK);
			
			soundVec[2] = new Sound(new URLRequest("./asset/audio/success.mp3"));
			
			soundVec[2].addEventListener(Event.COMPLETE,soundLoadOK);
		}
		
		private static function picLoadOK(e:Event):void{
			
			e.currentTarget.removeEventListener(Event.COMPLETE,picLoadOK);
			
			texture = Texture.fromBitmap(e.currentTarget.loader.content,false)
			
			if(xml){
				
				textureAtlas = new TextureAtlas(texture,xml);
				
				checkOver();
			}
		}
		
		private static function xmlLoadOK(e:Event):void{
			
			e.currentTarget.removeEventListener(Event.COMPLETE,xmlLoadOK);
			
			xml = new XML(e.currentTarget.data);
			
			if(texture){
				
				textureAtlas = new TextureAtlas(texture,xml);
				
				checkOver();
			}
		}
		
		private static function fontPicLoadOK0(e:Event):void{
			
			e.currentTarget.removeEventListener(Event.COMPLETE,fontPicLoadOK0);
			
			fontTexture0 = Texture.fromBitmap(e.currentTarget.loader.content,false);
			
			if(fontXML0){
				
				var bitmapFont:BitmapFont = new BitmapFont(fontTexture0,fontXML0);
				
				//注册
				TextField.registerBitmapFont(bitmapFont,FONT_NAME0);
				
				checkOver();
			}
		}
		
		private static function fontXMLLoadOK0(e:Event):void{
			
			e.currentTarget.removeEventListener(Event.COMPLETE,fontXMLLoadOK0);
			
			fontXML0 = new XML(e.target.data);
			
			if(fontTexture0){
				
				var bitmapFont:BitmapFont = new BitmapFont(fontTexture0,fontXML0);
				
				//注册
				TextField.registerBitmapFont(bitmapFont,FONT_NAME0);
				
				checkOver();
			}
		}
		
		private static function fontPicLoadOK1(e:Event):void{
			
			e.currentTarget.removeEventListener(Event.COMPLETE,fontPicLoadOK1);
			
			fontTexture1 = Texture.fromBitmap(e.currentTarget.loader.content,false);
			
			if(fontXML1){
				
				var bitmapFont:BitmapFont = new BitmapFont(fontTexture1,fontXML1);
				
				//注册
				TextField.registerBitmapFont(bitmapFont,FONT_NAME1);
				
				checkOver();
			}
		}
		
		private static function fontXMLLoadOK1(e:Event):void{
			
			e.currentTarget.removeEventListener(Event.COMPLETE,fontXMLLoadOK1);
			
			fontXML1 = new XML(e.target.data);
			
			if(fontTexture1){
				
				var bitmapFont:BitmapFont = new BitmapFont(fontTexture1,fontXML1);
				
				//注册
				TextField.registerBitmapFont(bitmapFont,FONT_NAME1);
				
				checkOver();
			}
		}
		
		private static function soundLoadOK(e:Event):void{
			
			checkOver();
		}
		
		private static function checkOver():void{
			
			loadNum--;
			
			if(loadNum == 0){
				
				callBack();
			}
		}
		
		public static function playSound(_id:int,_startTime:Number = 0,_loops:int = 0):void{
			
			if(Record.data.musicOn){
			
				soundVec[_id].play(_startTime,_loops);
			}
		}
	}
}