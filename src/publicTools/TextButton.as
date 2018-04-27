package publicTools
{
	import flash.geom.Rectangle;
	
	import game_four_time.GameCom_four_time;
	import game_four_time.GameText_four_time;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class TextButton extends Sprite
	{
		private static const SCALE:Number = 0.8;
		
		private var tf:TextField;
		
		private var isDown:Boolean;
		private var callBack:Function;
		
		private var oWidth:Number;
		private var oHeight:Number;
		
		private var fixWidth:Number;
		private var fixHeight:Number;
		
		private var rect:Rectangle = new Rectangle;
		
		public function TextButton(_text:String,_callBack:Function,_fontSize:int = 80,_fontColor:uint = 0xFFFF00)
		{
			super();
			
			callBack = _callBack;
			
//			tf = new TextField(1,1,_text,Resource.FONT_NAME,_fontSize * GameCom_four_time.SCALE,_fontColor,true);
			
			tf = new TextField(1,1,_text,GameText_four_time.FONT_NAME[GameText_four_time.nowLanguageIndex],_fontSize * GameCom_four_time.SCALE,_fontColor,true);
			
			tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			
			addChild(tf);
			
			flatten();
			
			oWidth = width;
			oHeight = height;
			
			fixWidth = oWidth * (1 - SCALE) * 0.5;
			fixHeight = oHeight * (1 - SCALE) * 0.5;
			
			addEventListener(TouchEvent.TOUCH,beTouch);
		}
		
		public function set text(_text:String):void{
			
			unflatten();
			
			tf.text = _text;
			
			flatten();
			
			x = x - (width - oWidth) * 0.5;
			y = y - (height - oHeight) * 0.5;
			
			oWidth = width;
			oHeight = height;
			
			fixWidth = oWidth * (1 - SCALE) * 0.5;
			fixHeight = oHeight * (1 - SCALE) * 0.5;
		}
		
		private function beTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(this);
			
			if(touch){
				
				switch(touch.phase){
					
					case TouchPhase.BEGAN:
						
						x = x + oWidth * (1 - SCALE) * 0.5;
						y = y + oHeight * (1 - SCALE) * 0.5;
						
						scaleX = scaleY = SCALE;
						
						isDown = true;
						
						break;
					
					case TouchPhase.MOVED:
						
						if(isDown){
							
							if(!check(touch.globalX,touch.globalY)){
								
								x = x - oWidth * (1 - SCALE) * 0.5;
								y = y - oHeight * (1 - SCALE) * 0.5;
								
								scaleX = scaleY = 1;
								
								isDown = false;
							}
						}
						
						break;
					
					case TouchPhase.ENDED:
						
						if(isDown){
							
							isDown = false;
							
							x = x - oWidth * (1 - SCALE) * 0.5;
							y = y - oHeight * (1 - SCALE) * 0.5;
							
							scaleX = scaleY = 1;
								
							if(check(touch.globalX,touch.globalY)){
								
								callBack();
							}
						}
						
						break;
				}
			}
		}
		
		private function check(_x:Number,_y:Number):Boolean{
			
			getBounds(stage,rect);
			
			if(_x > rect.left - fixWidth && _x < rect.right + fixWidth && _y > rect.top - fixHeight && _y < rect.bottom + fixHeight){
				
				return true;
				
			}else{
				
				return false;
			}
		}
	}
}