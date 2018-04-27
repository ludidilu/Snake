package game_time
{
	import com.greensock.TweenLite;
	import com.greensock.easing.ElasticIn;
	import com.greensock.easing.ElasticOut;
	import com.greensock.easing.Linear;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import resource.Resource;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Scale9Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import publicTools.TimeUtil;

	public class Game_time
	{
		private static var gameSpeed:Number = 1;
		
		private static var initOK:Boolean;
		
		public static var container:Sprite;
		
		private static var mapContainer:Sprite;
		
		private static var scoreContainer:Sprite;
		
		private static var alertContainer:Sprite;
		
		private static var maskContainer:Sprite;
		
		private static var frameTexture:Texture;
		
		private static var imgVec:Vector.<Image>;
		
		private static var quadBatch:QuadBatch;
		
		private static var frameQb:QuadBatch;
		
		private static var touchSp:Sprite;
		
		private static var data:Vector.<int>;
		
		private static var chooseVec:Vector.<int>;
		
		private static var resultVec:Vector.<int>;
		
		private static var i:int,m:int;
		
		private static var lastP:Point;
		
		private static var matrix:Matrix = new Matrix;
		
		private static var lifeTfContainer:Sprite;
		
		private static var lifeTf:TextField;
		
		private static var highScoreTf:TextField;
		
		private static var timerSp:Sprite;
		
		private static var timeLong:Number;
		
		private static var isAlert:Boolean;
		
		private static var _highScore:int = int.MIN_VALUE;

		public static function get highScore():int
		{
			return _highScore;
		}

		public static function set highScore(value:int):void
		{
			if(_highScore == value){
				
				return;
			}
			
			_highScore = value;
			
			lifeTfContainer.unflatten();
			
			highScoreTf.text = String(_highScore);
			
			lifeTfContainer.flatten();
		}

		
		private static var _canAction:Boolean;
		
		public static function get canAction():Boolean
		{
			return _canAction;
		}

		public static function set canAction(value:Boolean):void
		{
			if(_canAction == value){
				
				return;
			}
			
			if(value){
				
				touchSp.addEventListener(TouchEvent.TOUCH,beTouch);
				
			}else{
				
				touchSp.removeEventListener(TouchEvent.TOUCH,beTouch);
			}
			
			_canAction = value;
		}

		private static var _life:int = int.MIN_VALUE;

		public static function get life():int
		{
			return _life;
		}

		public static function set life(value:int):void
		{
			if(_life == value){
				
				return;
			}
			
			_life = value;
			
			lifeTfContainer.unflatten();
			
			lifeTf.text = String(_life);
			
			lifeTfContainer.flatten();
		}

		
		public static function start():void{
			
			init();
			
			showMask(true);
			
			highScore = GameScore_time.init();
			
			trace("get highScore:",highScore);
			
			life = GameCom_time.OLIFE;
			
			timeLong = GameCom_time.OTIMELONG;
			
			canAction = true;
			
			for(i = 0 ; i < GameCom_time.HEIGHT * GameCom_time.WIDTH ; i++){
				
				data[i] = -1;
			}
			
			for(i = 0 ; i < GameCom_time.HEIGHT ; i++){
				
				for(m = 0 ; m < GameCom_time.WIDTH ; m++){
					
					var index:int = i * GameCom_time.WIDTH + m;
					
					var colorIndex:int = GameCom_time.getRandomColorIndex(data,index);
					
					data[index] = colorIndex;
					
//					quadBatch.setQuadColor(index,GameCom.COLOR[colorIndex]);
				}
			}
			
			resultVec = new Vector.<int>;
			
			TweenLite.killTweensOf(Game_time);
			
			chooseVec.length = 0;
			
			addFrame();
			
			quadBatchReset();
			
			startTimer();
		}
		
		private static function quadBatchReset():void{
			
			quadBatch.reset();
			
			for(i = 0 ; i < GameCom_time.WIDTH * GameCom_time.HEIGHT ; i++){
				
				imgVec[i].texture = Resource.textureAtlas.getTexture(String(data[i] + 1));
				
				quadBatch.addImage(imgVec[i]);
			}
			
			_disappearNum = 1;
		}
		
		private static function timerComplete():void{
			
			startAlert();
			
//			life = life - GameCom.getLiseUseWhenTimerComplete();
//			
//			startTimer();
		}
		
		private static function init():void{
			
			if(initOK){
				
				return ;
			}
			
			initOK = true;
			
			GameCom_time.init();
			
			TimeUtil.init();
			
			initFrameTexture();
			
			container = new Sprite;
			
			mapContainer = new Sprite;
			
			mapContainer.x = GameCom_time.MAP_CONTAINER_FIXX;
			mapContainer.y = GameCom_time.SCORE_CONTAINER_HEIGHT * 2;
			
			container.addChild(mapContainer);
			
			scoreContainer = new Sprite;
			
			container.addChild(scoreContainer);
			
			alertContainer = new Sprite;
			
			container.addChild(alertContainer);
			
			maskContainer = new Sprite;
			
			container.addChild(maskContainer);
			
			var bg:Scale9Image = new Scale9Image(Resource.textureAtlas.getTexture("bluetiao"),new Rectangle(70,54,2,1));
			
			bg.touchable = false;
			
			bg.width = GameCom_time.WIDTH * GameCom_time.MAP_WIDTH + GameCom_time.BG_WIDTH * 2;
			bg.height = GameCom_time.HEIGHT * GameCom_time.MAP_WIDTH + GameCom_time.BG_WIDTH * 2;
			
			mapContainer.addChild(bg);
			
			touchSp = new Sprite;
			
			touchSp.name = "touchSp";
			
			touchSp.x = GameCom_time.BG_WIDTH;
			touchSp.y = GameCom_time.BG_WIDTH;
			
			var quad:Quad = new Quad(GameCom_time.WIDTH * GameCom_time.MAP_WIDTH,GameCom_time.HEIGHT * GameCom_time.MAP_WIDTH,0);
			
			quad.alpha = 0;
			
			touchSp.addChild(quad);
			
			touchSp.flatten();
			
			mapContainer.addChild(touchSp);
			
			frameQb = new QuadBatch;
			
			frameQb.name = "frameQb";
			
			frameQb.x = GameCom_time.BG_WIDTH;
			frameQb.y = GameCom_time.BG_WIDTH;
			
			frameQb.touchable = false;
			
			mapContainer.addChild(frameQb);
			
			quadBatch = new QuadBatch;
			
			quadBatch.name = "quadBatch";
			
			quadBatch.x = GameCom_time.BG_WIDTH;
			quadBatch.y = GameCom_time.BG_WIDTH;
			
			imgVec = new Vector.<Image>(GameCom_time.WIDTH * GameCom_time.HEIGHT,true);
			
			for(i = 0 ; i < GameCom_time.HEIGHT ; i++){
				
				for(m = 0 ; m < GameCom_time.WIDTH ; m++){
					
					var img:Image = new Image(Resource.textureAtlas.getTexture("1"));
					
					img.width = img.height = GameCom_time.BALL_WIDTH;
					
					img.x = m * GameCom_time.MAP_WIDTH + (GameCom_time.MAP_WIDTH - img.width) * 0.5;
					img.y = i * GameCom_time.MAP_WIDTH + (GameCom_time.MAP_WIDTH - img.height) * 0.5;
					
					quadBatch.addImage(img);
					
					imgVec[i * GameCom_time.WIDTH + m] = img;
					
//					quad = new Quad(GameCom.UNIT_WIDTH - GameCom.UNIT_WIDTH_FIX * 2,GameCom.UNIT_WIDTH - GameCom.UNIT_WIDTH_FIX * 2,GameCom.COLOR[0]);
//					
//					quad.x = m * GameCom.MAP_WIDTH + (GameCom.MAP_WIDTH - quad.width) * 0.5;
//					quad.y = i * GameCom.MAP_WIDTH + (GameCom.MAP_WIDTH - quad.height) * 0.5;
					
//					quadBatch.addQuad(quad);
					
				}
			}
			
			quadBatch.touchable = false;
			
			mapContainer.addChild(quadBatch);
			
			data = new Vector.<int>(GameCom_time.WIDTH * GameCom_time.HEIGHT ,true);
			
			chooseVec = new Vector.<int>;
			
			quad = new Quad(GameCom_time.ALL_WIDTH,GameCom_time.SCORE_CONTAINER_HEIGHT,0xFF0000);
			
			timerSp = new Sprite;
			
			timerSp.touchable = false;
			
			timerSp.addChild(quad);
			
			timerSp.flatten();
			
			scoreContainer.addChild(timerSp);
			
			lifeTfContainer = new Sprite;
			
			lifeTfContainer.name = "lifeTfContainer";
			
			lifeTfContainer.touchable = false;
			
			lifeTf = new TextField(GameCom_time.ALL_WIDTH,GameCom_time.SCORE_CONTAINER_HEIGHT,"",Resource.FONT_NAME0,28,0,true);
			
			lifeTfContainer.addChild(lifeTf);
			
			highScoreTf = new TextField(GameCom_time.ALL_WIDTH,GameCom_time.SCORE_CONTAINER_HEIGHT,"",Resource.FONT_NAME0,28,0,true);
			
			highScoreTf.y = GameCom_time.SCORE_CONTAINER_HEIGHT;
			
			lifeTfContainer.addChild(highScoreTf);
			
//			lifeTfContainer.flatten();
			
			scoreContainer.addChild(lifeTfContainer);
			
			quad = new Quad(Starling.current.viewPort.width,Starling.current.viewPort.height,0xFF0000);
			
			quad.touchable = false;
			
			alertContainer.addChild(quad);
			
			alertContainer.flatten();
			
			alertContainer.visible = false;

			quad = new Quad(Starling.current.viewPort.width,Starling.current.viewPort.height,0);
			
			maskContainer.addChild(quad);
			
			maskContainer.flatten();
			
			maskContainer.visible = false;
			
			maskContainer.addEventListener(TouchEvent.TOUCH,maskTouch);
			
			var testBt:Button = new Button(Texture.fromColor(50,50,0xFF000000));
			
//			container.addChild(testBt);
			
			testBt.addEventListener(Event.TRIGGERED,test);
			
			//----
		}
		
		private static function initFrameTexture():void{
			
			var bitmapData:BitmapData = new BitmapData(GameCom_time.MAP_WIDTH * 4,GameCom_time.MAP_WIDTH,true,0x00000000);
			
			var shape:Shape = new Shape;
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect((GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,(GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5,(GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5);
			
			shape.graphics.drawRect((GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.5,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.5,GameCom_time.UNIT_WIDTH,GameCom_time.UNIT_WIDTH);
			
			bitmapData.draw(shape);
			
			//----
			
			shape.graphics.clear();
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect(0,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,GameCom_time.MAP_WIDTH,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25);
			
			shape.graphics.drawRect(0,(GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5,GameCom_time.MAP_WIDTH,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25);
			
			var matrix:Matrix = new Matrix;
			
			matrix.translate(GameCom_time.MAP_WIDTH,0);
			
			bitmapData.draw(shape,matrix);
			
			//----
			
			shape.graphics.clear();
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect(0,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.5,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25);
			
			shape.graphics.drawRect((GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,0,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25);
			
			shape.graphics.drawRect(0,(GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5,GameCom_time.MAP_WIDTH - (GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25);
			
			shape.graphics.drawRect((GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5,0,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,(GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5);
			
			matrix.translate(GameCom_time.MAP_WIDTH,0);
			
			bitmapData.draw(shape,matrix);
			
			//----
			
			shape.graphics.clear();
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect(0,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,(GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25);
			
			shape.graphics.drawRect((GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25,(GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5);
			
			shape.graphics.drawRect(0,(GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5,(GameCom_time.MAP_WIDTH + GameCom_time.UNIT_WIDTH) * 0.5,(GameCom_time.MAP_WIDTH - GameCom_time.UNIT_WIDTH) * 0.25);

			matrix.translate(GameCom_time.MAP_WIDTH,0);
			
			bitmapData.draw(shape,matrix);
			
			//----
			
			frameTexture = Texture.fromBitmapData(bitmapData,false);
		}
		
		private static function beTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			
			if(touch){
				
				if(touch.phase == TouchPhase.BEGAN){
					
					var p:Point = touch.getLocation(e.currentTarget as DisplayObject);
					
					var index:int = int(p.x / GameCom_time.MAP_WIDTH) + int(p.y /  GameCom_time.MAP_WIDTH) * GameCom_time.WIDTH;
					
					chooseVec.push(index);
					
					addFrame();
					
					lastP = p;
					
				}else if(touch.phase == TouchPhase.MOVED && chooseVec.length > 0){
					
					p = touch.getLocation(e.currentTarget as DisplayObject);
					
					if(p.x >= (e.currentTarget as DisplayObject).width || p.y >= (e.currentTarget as DisplayObject).height || p.x <= 0 || p.y <= 0){
						
						chooseVec.length = 0
						
						addFrame();
						
						return;
					}
					
					index = int(p.x / GameCom_time.MAP_WIDTH) + int(p.y /  GameCom_time.MAP_WIDTH) * GameCom_time.WIDTH;
					
					if(chooseVec[chooseVec.length - 1] == index){
						
						return;
						
					}else{
						
						var x1:int = index % GameCom_time.WIDTH;
						var y1:int = int(index / GameCom_time.WIDTH);
						
						while(true){
							
							var lastIndex:int = chooseVec[chooseVec.length - 1];
							
							var x0:int = lastIndex % GameCom_time.WIDTH;
							var y0:int = int(lastIndex / GameCom_time.WIDTH);
							
							if((x0 == x1 && Math.abs(y0 - y1) == 1) || (Math.abs(x0 - x1) == 1 && y0 == y1)){
								
								break;
								
							}else if(x0 == x1){
								
								if(y1 < y0){
									
									var nextIndex:int = lastIndex - GameCom_time.WIDTH;
									
								}else{
									
									nextIndex = lastIndex + GameCom_time.WIDTH;
								}
								
							}else if(y0 == y1){
								
								if(x1 < x0){
									
									nextIndex = lastIndex - 1;
									
								}else{
									
									nextIndex = lastIndex + 1;
								}
								
							}else{
								
								if(x1 < x0){
									
									var fix0:int = lastIndex - 1;
									
								}else{
									
									fix0 = lastIndex + 1;
								}
								
								if(y1 < y0){
									
									var fix1:int = lastIndex - GameCom_time.WIDTH;
									
								}else{
									
									fix1 = lastIndex + GameCom_time.WIDTH;
								}
									
								var x2:int = fix0 % GameCom_time.WIDTH;
								var y2:int = int(fix0 / GameCom_time.WIDTH);
								
								var p0:Point = new Point;
								
								p0.x = (x2 - 0.5) * GameCom_time.MAP_WIDTH;
								p0.y = (y2 - 0.5) * GameCom_time.MAP_WIDTH;
								
								var x3:int = fix1 % GameCom_time.WIDTH;
								var y3:int = int(fix1 / GameCom_time.WIDTH);
								
								var p1:Point = new Point;
								
								p1.x = (x3 - 0.5) * GameCom_time.MAP_WIDTH;
								p1.y = (y3 - 0.5) * GameCom_time.MAP_WIDTH;
								
								var a0:Number = Point.distance(p0,p);
								var b0:Number = Point.distance(p0,lastP);
								var c0:Number = Point.distance(lastP,p);
								
								var tp0:Number = (a0 + b0 + c0) * 0.5;
								
								var area0:Number = tp0 * (tp0 - a0) * (tp0 - b0) * (tp0 - c0);
								
								var a1:Number = Point.distance(p1,p);
								var b1:Number = Point.distance(p1,lastP);
								var c1:Number = Point.distance(lastP,p);
								
								var tp1:Number = (a1 + b1 + c1) * 0.5;
								
								var area1:Number = tp1 * (tp1 - a1) * (tp1 - b1) * (tp1 - c1);
								
								if(area0 < area1){
									
									nextIndex = fix0;
									
								}else{
									
									nextIndex = fix1;
								}
							}
								
							i = chooseVec.indexOf(nextIndex);
							
							if(i != -1){
								
								if(chooseVec[chooseVec.length - 2] != nextIndex){
									
									chooseVec = chooseVec.slice(i);
									
//									chooseVec.length = 0
									
									addFrame(true);
									
									startMove();
									
									return;
									
								}else{
									
									chooseVec.length = 0
									
									addFrame();
									
									return;
								}
								
							}else{
								
								chooseVec.push(nextIndex);
							}
						}
					}
					
					i = chooseVec.indexOf(index);
					
					if(i != -1){
						
						if(chooseVec[chooseVec.length - 2] != index){
							
							chooseVec = chooseVec.slice(i);
							
//							chooseVec.length = 0
							
							addFrame(true);
							
							startMove();
							
						}else{
							
							chooseVec.pop();
							
//							chooseVec.pop();
							
//							chooseVec.length = 0
							
							addFrame();
						}
						
					}else{
						
						chooseVec.push(index);
						
						addFrame();
					}
					
					lastP = p;
					
				}else if(touch.phase == TouchPhase.ENDED){
					
					chooseVec.length = 0
					
					addFrame();
				}
			}
		}
		
		private static function addFrame(_finish:Boolean = false):void{
			
			frameQb.reset();
			
			if(chooseVec.length == 0){
				
				return;
				
			}else if(chooseVec.length == 1){
				
				var img:Image = new Image(frameTexture);
				
				img.width = frameTexture.width * 0.25;
				
				img.setTexCoordsTo(1,0.25,0);
				img.setTexCoordsTo(3,0.25,1);
				
				img.x = chooseVec[0] % GameCom_time.WIDTH * GameCom_time.MAP_WIDTH;
				img.y = int(chooseVec[0] / GameCom_time.WIDTH) * GameCom_time.MAP_WIDTH;
				
				frameQb.addImage(img);
				
			}else{
				
				if(!_finish){
				
					img = new Image(frameTexture);
					
					img.width = frameTexture.width * 0.25;
					
					var x0:int = chooseVec[0] % GameCom_time.WIDTH;
					var y0:int = int(chooseVec[0] / GameCom_time.WIDTH);
					
					var x1:int = chooseVec[1] % GameCom_time.WIDTH;
					var y1:int = int(chooseVec[1] / GameCom_time.WIDTH);
					
					if(x0 == x1){
						
						if(y1 > y0){
							
							img.setTexCoordsTo(0,1,0);
							img.setTexCoordsTo(1,1,1);
							img.setTexCoordsTo(2,0.75,0);
							img.setTexCoordsTo(3,0.75,1);
							
						}else{
							
							img.setTexCoordsTo(0,0.75,1);
							img.setTexCoordsTo(1,0.75,0);
							img.setTexCoordsTo(2,1,1);
							img.setTexCoordsTo(3,1,0);
						}
						
					}else{
						
						if(x1 > x0){
							
							img.setTexCoordsTo(0,1,0);
							img.setTexCoordsTo(1,0.75,0);
							img.setTexCoordsTo(2,1,1);
							img.setTexCoordsTo(3,0.75,1);
							
						}else{
							
							img.setTexCoordsTo(0,0.75,0);
							img.setTexCoordsTo(2,0.75,1);
						}
					}
					
					img.x = chooseVec[0] % GameCom_time.WIDTH * GameCom_time.MAP_WIDTH;
					img.y = int(chooseVec[0] / GameCom_time.WIDTH) * GameCom_time.MAP_WIDTH;
					
					frameQb.addImage(img);
					
					for(i = 1 ; i < chooseVec.length - 1 ; i++){
						
						img = new Image(frameTexture);
						
						img.width = frameTexture.width * 0.25;
						
						x0 = chooseVec[i - 1] % GameCom_time.WIDTH;
						y0 = int(chooseVec[i - 1] / GameCom_time.WIDTH);
						
						x1 = chooseVec[i] % GameCom_time.WIDTH;
						y1 = int(chooseVec[i] / GameCom_time.WIDTH);
						
						var x2:int = chooseVec[i + 1] % GameCom_time.WIDTH;
						var y2:int = int(chooseVec[i + 1] / GameCom_time.WIDTH);
						
						if(x0 == x1 && x1 == x2){
							
							img.setTexCoordsTo(0,0.25,1);
							img.setTexCoordsTo(1,0.25,0);
							img.setTexCoordsTo(2,0.5,1);
							img.setTexCoordsTo(3,0.5,0);
								
						}else if(y0 == y1 && y1 == y2){
							
							img.setTexCoordsTo(0,0.25,0);
							img.setTexCoordsTo(1,0.5,0);
							img.setTexCoordsTo(2,0.25,1);
							img.setTexCoordsTo(3,0.5,1);
							
						}else{
							
							if((x1 - x0 == 1 && y2 - y1 == -1) || (y1 - y0 == 1 && x2 - x1 == -1)){
								
								img.setTexCoordsTo(0,0.5,0);
								img.setTexCoordsTo(1,0.75,0);
								img.setTexCoordsTo(2,0.5,1);
								img.setTexCoordsTo(3,0.75,1);
								
							}else if((y1 - y0 == 1 && x2 - x1 == 1) || (x1 - x0 == -1 && y2 - y1 == -1)){
								
								img.setTexCoordsTo(0,0.5,1);
								img.setTexCoordsTo(1,0.5,0);
								img.setTexCoordsTo(2,0.75,1);
								img.setTexCoordsTo(3,0.75,0);
								
							}else if((x1 - x0 == 1 && y2 - y1 == 1) || ( y1 - y0 == -1 && x2 - x1 == -1)){
								
								img.setTexCoordsTo(0,0.75,0);
								img.setTexCoordsTo(1,0.75,1);
								img.setTexCoordsTo(2,0.5,0);
								img.setTexCoordsTo(3,0.5,1);
								
							}else{
								
								img.setTexCoordsTo(0,0.75,1);
								img.setTexCoordsTo(1,0.5,1);
								img.setTexCoordsTo(2,0.75,0);
								img.setTexCoordsTo(3,0.5,0);
							}
						}
						
						img.x = chooseVec[i] % GameCom_time.WIDTH * GameCom_time.MAP_WIDTH;
						img.y = int(chooseVec[i] / GameCom_time.WIDTH) * GameCom_time.MAP_WIDTH;
						
						frameQb.addImage(img);
					}
					
					img = new Image(frameTexture);
					
					img.width = frameTexture.width * 0.25;
					
					x0 = chooseVec[i - 1] % GameCom_time.WIDTH;
					y0 = int(chooseVec[i - 1] / GameCom_time.WIDTH);
					
					x1 = chooseVec[i] % GameCom_time.WIDTH;
					y1 = int(chooseVec[i] / GameCom_time.WIDTH);
					
					if(x0 == x1){
						
						if(y1 > y0){
							
							img.setTexCoordsTo(0,0.75,1);
							img.setTexCoordsTo(1,0.75,0);
							img.setTexCoordsTo(2,1,1);
							img.setTexCoordsTo(3,1,0);
							
						}else{
							
							img.setTexCoordsTo(0,1,0);
							img.setTexCoordsTo(1,1,1);
							img.setTexCoordsTo(2,0.75,0);
							img.setTexCoordsTo(3,0.75,1);
						}
						
					}else{
						
						if(x1 > x0){
							
							img.setTexCoordsTo(0,0.75,0);
							img.setTexCoordsTo(2,0.75,1);
							
						}else{
							
							img.setTexCoordsTo(0,1,0);
							img.setTexCoordsTo(1,0.75,0);
							img.setTexCoordsTo(2,1,1);
							img.setTexCoordsTo(3,0.75,1);
						}
					}
					
					img.x = chooseVec[i] % GameCom_time.WIDTH * GameCom_time.MAP_WIDTH;
					img.y = int(chooseVec[i] / GameCom_time.WIDTH) * GameCom_time.MAP_WIDTH;
					
					frameQb.addImage(img);
					
				}else{
					
					for(i = 0 ; i < chooseVec.length ; i++){
						
						img = new Image(frameTexture);
						
						img.width = frameTexture.width * 0.25;
						
						if(i == 0){
							
							x0 = chooseVec[chooseVec.length - 1] % GameCom_time.WIDTH;
							y0 = int(chooseVec[chooseVec.length - 1] / GameCom_time.WIDTH);
							
							x2 = chooseVec[i + 1] % GameCom_time.WIDTH;
							y2 = int(chooseVec[i + 1] / GameCom_time.WIDTH);
							
						}else if(i == chooseVec.length - 1){
							
							x0 = chooseVec[i - 1] % GameCom_time.WIDTH;
							y0 = int(chooseVec[i - 1] / GameCom_time.WIDTH);
							
							x2 = chooseVec[0] % GameCom_time.WIDTH;
							y2 = int(chooseVec[0] / GameCom_time.WIDTH);
							
						}else{
						
							x0 = chooseVec[i - 1] % GameCom_time.WIDTH;
							y0 = int(chooseVec[i - 1] / GameCom_time.WIDTH);
							
							x2 = chooseVec[i + 1] % GameCom_time.WIDTH;
							y2 = int(chooseVec[i + 1] / GameCom_time.WIDTH);
						}
						
						x1 = chooseVec[i] % GameCom_time.WIDTH;
						y1 = int(chooseVec[i] / GameCom_time.WIDTH);
						
						if(x0 == x1 && x1 == x2){
							
							img.setTexCoordsTo(0,0.25,1);
							img.setTexCoordsTo(1,0.25,0);
							img.setTexCoordsTo(2,0.5,1);
							img.setTexCoordsTo(3,0.5,0);
							
						}else if(y0 == y1 && y1 == y2){
							
							img.setTexCoordsTo(0,0.25,0);
							img.setTexCoordsTo(1,0.5,0);
							img.setTexCoordsTo(2,0.25,1);
							img.setTexCoordsTo(3,0.5,1);
							
						}else{
							
							if((x1 - x0 == 1 && y2 - y1 == -1) || (y1 - y0 == 1 && x2 - x1 == -1)){
								
								img.setTexCoordsTo(0,0.5,0);
								img.setTexCoordsTo(1,0.75,0);
								img.setTexCoordsTo(2,0.5,1);
								img.setTexCoordsTo(3,0.75,1);
								
							}else if((y1 - y0 == 1 && x2 - x1 == 1) || (x1 - x0 == -1 && y2 - y1 == -1)){
								
								img.setTexCoordsTo(0,0.5,1);
								img.setTexCoordsTo(1,0.5,0);
								img.setTexCoordsTo(2,0.75,1);
								img.setTexCoordsTo(3,0.75,0);
								
							}else if((x1 - x0 == 1 && y2 - y1 == 1) || ( y1 - y0 == -1 && x2 - x1 == -1)){
								
								img.setTexCoordsTo(0,0.75,0);
								img.setTexCoordsTo(1,0.75,1);
								img.setTexCoordsTo(2,0.5,0);
								img.setTexCoordsTo(3,0.5,1);
								
							}else{
								
								img.setTexCoordsTo(0,0.75,1);
								img.setTexCoordsTo(1,0.5,1);
								img.setTexCoordsTo(2,0.75,0);
								img.setTexCoordsTo(3,0.5,0);
							}
						}
						
						img.x = chooseVec[i] % GameCom_time.WIDTH * GameCom_time.MAP_WIDTH;
						img.y = int(chooseVec[i] / GameCom_time.WIDTH) * GameCom_time.MAP_WIDTH;
						
						frameQb.addImage(img);
					}
				}
				
			}
		}
		
		private static function startTimer():void{
			
			timerSp.width = GameCom_time.ALL_WIDTH;
			
			TweenLite.to(timerSp,timeLong,{width:0,ease:Linear.easeNone,onComplete:timerComplete});
		}
		
		private static function stopTimer():void{
			
			TweenLite.killTweensOf(timerSp);
		}
		
		private static function startMove(_force:Boolean = false):void{
			
			if(!_force){
			
				canAction = false;
				
				life = life - GameCom_time.getLiseUseWhenMove(chooseVec.length);
			}
			
			_moveNum = 0;
			
			TweenLite.to(Game_time,1,{moveNum:1,onComplete:moveOver,onCompleteParams:[_force]});
		}
		
		private static function moveOver(_force:Boolean):void{
			
			moveNum = 0;
			
//			var colorVec:Vector.<uint> = new Vector.<uint>(chooseVec.length,true);
			var dataVec:Vector.<int> = new Vector.<int>(chooseVec.length,true);
			
			for(i = 0 ; i < chooseVec.length ; i++){
				
				if(i == 0){
				
					dataVec[i] = data[chooseVec[chooseVec.length - 1]];
					
				}else{
					
					dataVec[i] = data[chooseVec[i - 1]];
				}
			}
			
			for(i = 0 ; i < chooseVec.length ; i++){
				
				data[chooseVec[i]] = dataVec[i];
			}
			
			quadBatchReset();
			
			if(!_force){//正常开始移动球
				
				resultVec = GameCom_time.check(data,chooseVec);
				
				if(resultVec.length > 0){//移动成功
					
					actionSuccess();
					
				}else{//移动失败
					
					actionFail();
				}
				
			}else{//球逆行结束
				
				chooseVec.length = 0;
				
				addFrame();
				
				canAction = true;
			}
		}
		
		private static function actionSuccess():void{
			
			if(isAlert){
			
				stopAlert();
			}
			
			if(timeLong > GameCom_time.MINTIMELONG){
			
				timeLong = timeLong - GameCom_time.TIMELONGDESC;
			}
			
			chooseVec.length = 0;
			
			addFrame();
			
			stopTimer();
			
			life = life + GameCom_time.getScore(resultVec.length);
			
			if(life > highScore){
				
				GameScore_time.writeHighScore(life);
				
				highScore = life;
			}
			
			TweenLite.to(Game_time,1,{disappearNum:0.00001,onComplete:disappearOver,ease:ElasticIn.ease});
		}
		
		private static function actionFail():void{
			
			chooseVec.reverse();
			
			startMove(true);
		}
		
		private static function disappearOver():void{
			
			for(i = 0 ; i < resultVec.length ; i++){
				
				data[resultVec[i]] = -1;
			}
			
			for(i = 0 ; i < resultVec.length ; i++){
				
				data[resultVec[i]] = GameCom_time.getRandomColorIndex(data,resultVec[i]);
				
//				quadBatch.setQuadColor(resultVec[i],GameCom.COLOR[data[resultVec[i]]]);
			}
			
			quadBatchReset();
			
			disappearNum = 0.00001;
			
			TweenLite.to(Game_time,1,{disappearNum:1,onComplete:actionOver,ease:ElasticOut.ease});
		}
		
		private static function actionOver():void{
			
			if(life < 1){
				
				showMask(true,true);
				
			}else{
			
				canAction = true;
				
				startTimer();
			}
		}
		
		private static var _moveNum:Number;
		
		public static function get moveNum():Number{
			
			return _moveNum;
		}
		
		public static function set moveNum(value:Number):void{
			
			var p:Number = value - _moveNum;
			
			for(i = 0 ; i < chooseVec.length ; i++){
				
				if(i != chooseVec.length - 1){
					
					var d:int = chooseVec[i + 1] - chooseVec[i];
					
				}else{
					
					d = chooseVec[0] - chooseVec[i];
				}
					
				switch(d){
					
					case -1:
						
						var dx:Number = -p * GameCom_time.MAP_WIDTH;
						var dy:Number = 0;
						
						break;
					
					case 1:
						
						dx = p * GameCom_time.MAP_WIDTH;
						dy = 0;
						
						break;
					
					case -GameCom_time.WIDTH:
						
						dx = 0;
						dy = -p * GameCom_time.MAP_WIDTH;
						
						break;
					
					default:
						
						dx = 0;
						dy = p * GameCom_time.MAP_WIDTH;
				}
					
				matrix.identity();
				
				matrix.translate(dx,dy);
				
				quadBatch.transformQuad(chooseVec[i],matrix);
				
			}
			
			_moveNum = value;
		}
		
		private static var _disappearNum:Number = 1;
		
		public static function get disappearNum():Number{
			
			return _disappearNum;
		}
		
		public static function set disappearNum(value:Number):void{
			
			for(i = 0 ; i < resultVec.length ; i++){
				
				matrix.identity();
				
				matrix.translate(-imgVec[resultVec[i]].x - GameCom_time.BALL_WIDTH * 0.5,-imgVec[resultVec[i]].y - GameCom_time.BALL_WIDTH * 0.5);
				
				matrix.scale(value / _disappearNum,value / _disappearNum);
				
				matrix.translate(imgVec[resultVec[i]].x + GameCom_time.BALL_WIDTH * 0.5,imgVec[resultVec[i]].y + GameCom_time.BALL_WIDTH * 0.5);
				
				quadBatch.transformQuad(resultVec[i],matrix);
				
//				quadBatch.setQuadAlpha(resultVec[i],value);
			}
			
			_disappearNum = value;
//			}
		}
		
		private static var _alertNum:Number;

		public static function get alertNum():Number
		{
			return _alertNum;
		}

		public static function set alertNum(value:Number):void
		{
			alertContainer.alpha = value;
			
			_alertNum = value;
		}

		
		private static function startAlert():void{
			
			if(isAlert){
				
				return;
			}
			
			alertContainer.visible = true;
			
			isAlert = true;
			
			alertNum = 0;
			
			startAlertReal();
		}
		
		private static function startAlertReal():void{
			
			life = life - GameCom_time.getLiseUseWhenTimerComplete();
			
			TweenLite.to(Game_time,0.7,{alertNum:0.3,ease:ElasticIn.ease,onComplete:alertEase});
		}
		
		private static function alertEase():void{
			
			TweenLite.to(Game_time,0.3,{alertNum:0,ease:Linear.easeNone,onComplete:alertOver});
		}
		
		private static function alertOver():void{
			
			if(isAlert){
			
				startAlertReal();
				
			}else{
				
				alertContainer.visible = false;
			}
		}
		
		private static function stopAlert():void{
			
			isAlert = false;
		}
		
		private static function showMask(_b:Boolean,_isOver:Boolean = false):void{
			
			maskContainer.visible = _b;
			
			if(_b){
			
				TimeUtil.speed = 0;
				
				if(_isOver){
					
					maskContainer.alpha = 0;
					
				}else{
					
					maskContainer.alpha = 1;
				}
				
			}else{
				
				TimeUtil.speed = gameSpeed;
			}
		}
		
		private static function maskTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject,TouchPhase.ENDED);
			
			if(touch){
				
				if(maskContainer.alpha != 0){
				
					showMask(false);
					
				}else{
					
					start();
				}
			}
		}
		
		public static function deactive():void{
			
			if(initOK){
			
				showMask(true);
			}
		}
		
		
		private static function test(e:Event):void{
			
			if(TimeUtil.speed == 0.2){
				
				TimeUtil.speed = 1;
				
			}else{
				
				TimeUtil.speed = 0.2;
			}
		}
	}
}