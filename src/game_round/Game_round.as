package game_round
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.ElasticIn;
	import com.greensock.easing.ElasticOut;
	import com.greensock.easing.Quint;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import publicTools.TimeUtil;
	
	import resource.Resource;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Game_round
	{
		private static var initOK:Boolean;
		
		public static var container:Sprite;
		
		private static var bgContainer:Sprite;
		
		private static var mapContainer:Sprite;
		
		private static var textFieldContainer:Sprite;
		
		private static var maskContainer:Sprite;
		
		private static var finalScoreTf:TextField;
		
		private static var frameTexture:Texture;
		
		private static var imgVec:Vector.<Image>;
		
		private static var quadBatch:QuadBatch;
		
		private static var frameImgVec:Vector.<Image>;
		
		private static var frameQb:QuadBatch;
		
		private static var touchSp:Sprite;
		
		private static var data:Vector.<int>;
		
		private static var chooseVec:Vector.<int>;
		
		private static var resultVec:Vector.<int>;
		
		private static var lastTouchPoint:Point;
		
		private static var scoreTf:TextField;
		
		private static var bestScoreTf:TextField;
		
		private static var moveTimesTf:TextField;
		
		private static var _moveTimes:int = int.MIN_VALUE;

		public static function get moveTimes():int
		{
			return _moveTimes;
		}

		public static function set moveTimes(value:int):void
		{
			if(_moveTimes == value){
				
				return;
			}
			
			_moveTimes = value;
			
			textFieldContainer.unflatten();
			
			moveTimesTf.text = "Move: " + _moveTimes;
			
			textFieldContainer.flatten();
		}

		
		private static var _bestScore:int = int.MIN_VALUE;
		
		public static function get bestScore():int
		{
			return _bestScore;
		}
		
		public static function set bestScore(value:int):void
		{
			if(_bestScore == value){
				
				return;
			}
			
			_bestScore = value;
			
			textFieldContainer.unflatten();
			
			bestScoreTf.text = "Best: " + _bestScore;
			
			textFieldContainer.flatten();
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
		
		private static var _score:int = int.MIN_VALUE;
		
		public static function get score():int
		{
			return _score;
		}
		
		public static function set score(value:int):void
		{
			if(_score == value){
				
				return;
			}
			
			_score = value;
			
			textFieldContainer.unflatten();
			
			scoreTf.text = "Score: " + _score;
			
			textFieldContainer.flatten();
		}
		
		//临时变量
		private static var i:int,m:int;
		
		private static var matrix:Matrix = new Matrix;
		
		private static var tmpIntVec:Vector.<int> = new Vector.<int>;
		
		
		public static function start():void{
			
			init();
			
			bestScore = GameScore_round.init();
			
			trace("get highScore:",bestScore);
			
			score = GameCom_round.OSCORE;
			
			moveTimes = GameCom_round.OMOVETIMES;
			
			canAction = true;
			
			for(i = 0 ; i < GameCom_round.HEIGHT * GameCom_round.WIDTH ; i++){
				
				data[i] = -1;
			}
			
			for(i = 0 ; i < GameCom_round.HEIGHT ; i++){
				
				for(m = 0 ; m < GameCom_round.WIDTH ; m++){
					
					var index:int = i * GameCom_round.WIDTH + m;
					
					var colorIndex:int = GameCom_round.getRandomColorIndex(data,index);
					
					data[index] = colorIndex;
					
					//					quadBatch.setQuadColor(index,GameCom.COLOR[colorIndex]);
				}
			}
			
			resultVec.length = 0;
			
			TweenLite.killTweensOf(Game_round);
			
			chooseVec.length = 0;
			
			addFrame();
			
			quadBatchReset();
		}
		
		private static function quadBatchReset():void{
			
			quadBatch.reset();
			
			for(i = 0 ; i < GameCom_round.WIDTH * GameCom_round.HEIGHT ; i++){
				
				imgVec[i].texture = Resource.textureAtlas.getTexture(String(data[i] + 1));
					
				quadBatch.addImage(imgVec[i]);
			}
			
//			_disappearNum = 1;
		}
		
		private static function init():void{
			
			if(initOK){
				
				return ;
			}
			
			initOK = true;
			
			GameCom_round.init();
			
			TimeUtil.init();
			
			initFrameTexture();
			
			container = new Sprite;
			
			bgContainer = new Sprite;
			
			img = new Image(Resource.textureAtlas.getTexture("bg"));
			
			img.width = Starling.current.viewPort.width;
			img.height = Starling.current.viewPort.height;
			
			bgContainer.blendMode = BlendMode.NONE;
			
			bgContainer.touchable = false;
			
			bgContainer.flatten();
			
			bgContainer.addChild(img);
			
			container.addChild(bgContainer);
			
			mapContainer = new Sprite;
			
			mapContainer.x = GameCom_round.MAP_CONTAINER_FIXX;
			mapContainer.y = (Starling.current.viewPort.height - GameCom_round.MAP_WIDTH * GameCom_round.WIDTH - GameCom_round.MAP_CONTAINER_FIXX * 2) * 0.5;
			
			container.addChild(mapContainer);
			
			textFieldContainer = new Sprite;
			
			textFieldContainer.name = "textFieldContainer";
			
			textFieldContainer.touchable = false;
			
			container.addChild(textFieldContainer);
			
			maskContainer = new Sprite;
			
			maskContainer.visible = false;
			
			var quad:Quad = new Quad(Starling.current.viewPort.width,Starling.current.viewPort.height,0);
			
			quad.alpha = 0.7;
			
			maskContainer.addChild(quad);
			
			container.addChild(maskContainer);
			
			maskContainer.addEventListener(TouchEvent.TOUCH,maskTouch);
			
			finalScoreTf = new TextField(Starling.current.viewPort.width,Starling.current.viewPort.height,"",Resource.FONT_NAME0,GameCom_round.SCALE * 80,0xFFFF00,true);
			
			maskContainer.addChild(finalScoreTf);
			
			maskContainer.flatten();
			
			var bg:QuadBatch = new QuadBatch;
			
			bg.touchable = false;
			
			mapContainer.addChild(bg);
			
			touchSp = new Sprite;
			
			touchSp.name = "touchSp";
			
			touchSp.x = GameCom_round.BG_WIDTH;
			touchSp.y = GameCom_round.BG_WIDTH;
			
			quad = new Quad(GameCom_round.WIDTH * GameCom_round.MAP_WIDTH,GameCom_round.HEIGHT * GameCom_round.MAP_WIDTH,0);
			
			quad.alpha = 0;
			
			touchSp.addChild(quad);
			
			touchSp.flatten();
			
			mapContainer.addChild(touchSp);
			
			frameQb = new QuadBatch;
			
			frameQb.name = "frameQb";
			
			frameQb.x = GameCom_round.BG_WIDTH;
			frameQb.y = GameCom_round.BG_WIDTH;
			
			frameQb.touchable = false;
			
			mapContainer.addChild(frameQb);
			
			quadBatch = new QuadBatch;
			
			quadBatch.name = "quadBatch";
			
			quadBatch.x = GameCom_round.BG_WIDTH;
			quadBatch.y = GameCom_round.BG_WIDTH;
			
			frameImgVec = new Vector.<Image>(GameCom_round.WIDTH * GameCom_round.HEIGHT,true);
			imgVec = new Vector.<Image>(GameCom_round.WIDTH * GameCom_round.HEIGHT,true);
			
			for(i = 0 ; i < GameCom_round.HEIGHT ; i++){
				
				for(m = 0 ; m < GameCom_round.WIDTH ; m++){
					
					var img:Image = new Image(Resource.textureAtlas.getTexture("1"));
					
					img.width = img.height = GameCom_round.BALL_WIDTH;
					
					img.x = m * GameCom_round.MAP_WIDTH + (GameCom_round.MAP_WIDTH - img.width) * 0.5;
					img.y = i * GameCom_round.MAP_WIDTH + (GameCom_round.MAP_WIDTH - img.height) * 0.5;
					
					quadBatch.addImage(img);
					
					imgVec[i * GameCom_round.WIDTH + m] = img;
					
					img = new Image(frameTexture);
					
					img.width = img.height = GameCom_round.MAP_WIDTH;
					
					img.x = m * GameCom_round.MAP_WIDTH;
					img.y = i * GameCom_round.MAP_WIDTH;
					
					frameImgVec[i * GameCom_round.WIDTH + m] = img;
					
					img = new Image(Resource.textureAtlas.getTexture("mapBg"));
					
					img.width = img.height = GameCom_round.MAP_WIDTH;
					
					img.x = m * GameCom_round.MAP_WIDTH;
					img.y = i * GameCom_round.MAP_WIDTH;
					
					bg.addImage(img);
				}
			}
			
			quadBatch.touchable = false;
			
			mapContainer.addChild(quadBatch);
			
			data = new Vector.<int>(GameCom_round.WIDTH * GameCom_round.HEIGHT ,true);
			
			chooseVec = new Vector.<int>;
			
			resultVec = new Vector.<int>;
			
			quad = new Quad(GameCom_round.ALL_WIDTH,GameCom_round.SCORE_CONTAINER_HEIGHT,0xFF0000);
			
			moveTimesTf = new TextField(GameCom_round.ALL_WIDTH / 2,GameCom_round.SCORE_CONTAINER_HEIGHT,"",Resource.FONT_NAME0,GameCom_round.O_FONT_SIZE * GameCom_round.SCALE,GameCom_round.FONT_COLOR,true);
			
			moveTimesTf.y = ((Starling.current.viewPort.height - GameCom_round.ALL_WIDTH) * 0.5 - GameCom_round.SCORE_CONTAINER_HEIGHT * 2) / 3;
			
			textFieldContainer.addChild(moveTimesTf);
			
			scoreTf = new TextField(GameCom_round.ALL_WIDTH / 2,GameCom_round.SCORE_CONTAINER_HEIGHT,"",Resource.FONT_NAME0,GameCom_round.O_FONT_SIZE * GameCom_round.SCALE,GameCom_round.FONT_COLOR,true);
			
			scoreTf.x = GameCom_round.ALL_WIDTH * 0.5;
			
			scoreTf.y = ((Starling.current.viewPort.height - GameCom_round.ALL_WIDTH) * 0.5 - GameCom_round.SCORE_CONTAINER_HEIGHT * 2) / 3;
			
			textFieldContainer.addChild(scoreTf);
			
			bestScoreTf = new TextField(GameCom_round.ALL_WIDTH,GameCom_round.SCORE_CONTAINER_HEIGHT,"",Resource.FONT_NAME0,GameCom_round.O_FONT_SIZE * GameCom_round.SCALE,GameCom_round.FONT_COLOR,true);
			
			bestScoreTf.y = ((Starling.current.viewPort.height - GameCom_round.ALL_WIDTH) * 0.5 - GameCom_round.SCORE_CONTAINER_HEIGHT * 2) / 3 * 2 + GameCom_round.SCORE_CONTAINER_HEIGHT;
			
			textFieldContainer.addChild(bestScoreTf);
			
			quad = new Quad(Starling.current.viewPort.width,Starling.current.viewPort.height,0xFF0000);
			
			quad.touchable = false;
			
			var testBt:Button = new Button(Texture.fromColor(50,50,0xFF000000));
			
			container.addChild(testBt);
			
			testBt.addEventListener(Event.TRIGGERED,test);
			
			//----
		}
		
		private static function initFrameTexture():void{
			
			var bitmapData:BitmapData = new BitmapData(GameCom_round.MAP_WIDTH * 4,GameCom_round.MAP_WIDTH,true,0x00000000);
			
			var shape:Shape = new Shape;
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect((GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,(GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5,(GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5);
			
			shape.graphics.drawRect((GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.5,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.5,GameCom_round.UNIT_WIDTH,GameCom_round.UNIT_WIDTH);
			
			bitmapData.draw(shape);
			
			//----
			
			shape.graphics.clear();
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect(0,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,GameCom_round.MAP_WIDTH,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25);
			
			shape.graphics.drawRect(0,(GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5,GameCom_round.MAP_WIDTH,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25);
			
			matrix.identity();
			
			matrix.translate(GameCom_round.MAP_WIDTH,0);
			
			bitmapData.draw(shape,matrix);
			
			//----
			
			shape.graphics.clear();
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect(0,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.5,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25);
			
			shape.graphics.drawRect((GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,0,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25);
			
			shape.graphics.drawRect(0,(GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5,GameCom_round.MAP_WIDTH - (GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25);
			
			shape.graphics.drawRect((GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5,0,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,(GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5);
			
			matrix.translate(GameCom_round.MAP_WIDTH,0);
			
			bitmapData.draw(shape,matrix);
			
			//----
			
			shape.graphics.clear();
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect(0,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,(GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25);
			
			shape.graphics.drawRect((GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25,(GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5);
			
			shape.graphics.drawRect(0,(GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5,(GameCom_round.MAP_WIDTH + GameCom_round.UNIT_WIDTH) * 0.5,(GameCom_round.MAP_WIDTH - GameCom_round.UNIT_WIDTH) * 0.25);
			
			matrix.translate(GameCom_round.MAP_WIDTH,0);
			
			bitmapData.draw(shape,matrix);
			
			//----
			
			frameTexture = Texture.fromBitmapData(bitmapData,false);
		}
		
		private static function beTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			
			if(touch){
				
				if(touch.phase == TouchPhase.BEGAN){
					
					var p:Point = touch.getLocation(e.currentTarget as DisplayObject);
					
					var index:int = int(p.x / GameCom_round.MAP_WIDTH) + int(p.y /  GameCom_round.MAP_WIDTH) * GameCom_round.WIDTH;
					
					chooseVec.push(index);
					
					addFrame();
					
					lastTouchPoint = p;
					
				}else if(touch.phase == TouchPhase.MOVED && chooseVec.length > 0){
					
					p = touch.getLocation(e.currentTarget as DisplayObject);
					
					if(p.x >= (e.currentTarget as DisplayObject).width || p.y >= (e.currentTarget as DisplayObject).height || p.x <= 0 || p.y <= 0){
						
						chooseVec.length = 0
						
						addFrame();
						
						return;
					}
					
					index = int(p.x / GameCom_round.MAP_WIDTH) + int(p.y /  GameCom_round.MAP_WIDTH) * GameCom_round.WIDTH;
					
					if(chooseVec[chooseVec.length - 1] == index){
						
						return;
						
					}else{
						
						var x1:int = index % GameCom_round.WIDTH;
						var y1:int = int(index / GameCom_round.WIDTH);
						
						while(true){
							
							var lastIndex:int = chooseVec[chooseVec.length - 1];
							
							var x0:int = lastIndex % GameCom_round.WIDTH;
							var y0:int = int(lastIndex / GameCom_round.WIDTH);
							
							if((x0 == x1 && Math.abs(y0 - y1) == 1) || (Math.abs(x0 - x1) == 1 && y0 == y1)){
								
								break;
								
							}else if(x0 == x1){
								
								if(y1 < y0){
									
									var nextIndex:int = lastIndex - GameCom_round.WIDTH;
									
								}else{
									
									nextIndex = lastIndex + GameCom_round.WIDTH;
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
									
									var fix1:int = lastIndex - GameCom_round.WIDTH;
									
								}else{
									
									fix1 = lastIndex + GameCom_round.WIDTH;
								}
								
								var x2:int = fix0 % GameCom_round.WIDTH;
								var y2:int = int(fix0 / GameCom_round.WIDTH);
								
								var p0:Point = new Point;
								
								p0.x = (x2 - 0.5) * GameCom_round.MAP_WIDTH;
								p0.y = (y2 - 0.5) * GameCom_round.MAP_WIDTH;
								
								var x3:int = fix1 % GameCom_round.WIDTH;
								var y3:int = int(fix1 / GameCom_round.WIDTH);
								
								var p1:Point = new Point;
								
								p1.x = (x3 - 0.5) * GameCom_round.MAP_WIDTH;
								p1.y = (y3 - 0.5) * GameCom_round.MAP_WIDTH;
								
								var a0:Number = Point.distance(p0,p);
								var b0:Number = Point.distance(p0,lastTouchPoint);
								var c0:Number = Point.distance(lastTouchPoint,p);
								
								var tp0:Number = (a0 + b0 + c0) * 0.5;
								
								var area0:Number = tp0 * (tp0 - a0) * (tp0 - b0) * (tp0 - c0);
								
								var a1:Number = Point.distance(p1,p);
								var b1:Number = Point.distance(p1,lastTouchPoint);
								var c1:Number = Point.distance(lastTouchPoint,p);
								
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
							
							addFrame(true);
							
							startMove();
							
						}else{
							
							chooseVec.pop();
							
							addFrame();
						}
						
					}else{
						
						chooseVec.push(index);
						
						addFrame();
					}
					
					lastTouchPoint = p;
					
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
				
				var img:Image = frameImgVec[chooseVec[0]];
				
				img.setTexCoordsTo(0,0,0);
				img.setTexCoordsTo(1,0.25,0);
				img.setTexCoordsTo(2,0,1);
				img.setTexCoordsTo(3,0.25,1);
				
				frameQb.addImage(img);
				
			}else{
				
				if(!_finish){
					
					img = frameImgVec[chooseVec[0]];
					
					var x0:int = chooseVec[0] % GameCom_round.WIDTH;
					var y0:int = int(chooseVec[0] / GameCom_round.WIDTH);
					
					var x1:int = chooseVec[1] % GameCom_round.WIDTH;
					var y1:int = int(chooseVec[1] / GameCom_round.WIDTH);
					
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
							img.setTexCoordsTo(1,1,0);
							img.setTexCoordsTo(2,0.75,1);
							img.setTexCoordsTo(3,1,1);
						}
					}
					
					frameQb.addImage(img);
					
					for(i = 1 ; i < chooseVec.length - 1 ; i++){
						
						img = frameImgVec[chooseVec[i]];
						
						x0 = chooseVec[i - 1] % GameCom_round.WIDTH;
						y0 = int(chooseVec[i - 1] / GameCom_round.WIDTH);
						
						x1 = chooseVec[i] % GameCom_round.WIDTH;
						y1 = int(chooseVec[i] / GameCom_round.WIDTH);
						
						var x2:int = chooseVec[i + 1] % GameCom_round.WIDTH;
						var y2:int = int(chooseVec[i + 1] / GameCom_round.WIDTH);
						
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
						
						frameQb.addImage(img);
					}
					
					img = frameImgVec[chooseVec[i]];
					
					x0 = chooseVec[i - 1] % GameCom_round.WIDTH;
					y0 = int(chooseVec[i - 1] / GameCom_round.WIDTH);
					
					x1 = chooseVec[i] % GameCom_round.WIDTH;
					y1 = int(chooseVec[i] / GameCom_round.WIDTH);
					
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
							img.setTexCoordsTo(1,1,0);
							img.setTexCoordsTo(2,0.75,1);
							img.setTexCoordsTo(3,1,1);
							
						}else{
							
							img.setTexCoordsTo(0,1,0);
							img.setTexCoordsTo(1,0.75,0);
							img.setTexCoordsTo(2,1,1);
							img.setTexCoordsTo(3,0.75,1);
						}
					}
					
					frameQb.addImage(img);
					
				}else{
					
					for(i = 0 ; i < chooseVec.length ; i++){
						
						img = frameImgVec[chooseVec[i]];
						
						if(i == 0){
							
							x0 = chooseVec[chooseVec.length - 1] % GameCom_round.WIDTH;
							y0 = int(chooseVec[chooseVec.length - 1] / GameCom_round.WIDTH);
							
							x2 = chooseVec[i + 1] % GameCom_round.WIDTH;
							y2 = int(chooseVec[i + 1] / GameCom_round.WIDTH);
							
						}else if(i == chooseVec.length - 1){
							
							x0 = chooseVec[i - 1] % GameCom_round.WIDTH;
							y0 = int(chooseVec[i - 1] / GameCom_round.WIDTH);
							
							x2 = chooseVec[0] % GameCom_round.WIDTH;
							y2 = int(chooseVec[0] / GameCom_round.WIDTH);
							
						}else{
							
							x0 = chooseVec[i - 1] % GameCom_round.WIDTH;
							y0 = int(chooseVec[i - 1] / GameCom_round.WIDTH);
							
							x2 = chooseVec[i + 1] % GameCom_round.WIDTH;
							y2 = int(chooseVec[i + 1] / GameCom_round.WIDTH);
						}
						
						x1 = chooseVec[i] % GameCom_round.WIDTH;
						y1 = int(chooseVec[i] / GameCom_round.WIDTH);
						
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
						
						frameQb.addImage(img);
					}
				}
				
			}
		}
		
		private static function startMove(_force:Boolean = false):void{
			
			if(!_force){
				
				canAction = false;
			}
			
			_moveNum = 0;
			
			TweenLite.to(Game_round,1,{moveNum:1,onComplete:moveOver,onCompleteParams:[_force]});
		}
		
		private static function moveOver(_force:Boolean):void{
			
			tmpIntVec.length = chooseVec.length;
			
			for(i = 0 ; i < chooseVec.length ; i++){
				
				if(i == 0){
					
					tmpIntVec[i] = data[chooseVec[chooseVec.length - 1]];
					
				}else{
					
					tmpIntVec[i] = data[chooseVec[i - 1]];
				}
			}
			
			for(i = 0 ; i < chooseVec.length ; i++){
				
				data[chooseVec[i]] = tmpIntVec[i];
			}
			
			quadBatchReset();
			
			if(!_force){//正常开始移动球
				
				resultVec.length = 0;
				
				GameCom_round.check(data,chooseVec,resultVec);
				
				if(resultVec.length > 0){//移动成功
					
					moveTimes--;
					
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
			
			chooseVec.length = 0;
			
			addFrame();
			
			score = score + GameCom_round.getScore(resultVec.length);
			
			if(score > bestScore){
				
				GameScore_round.writeBestScore(score);
				
				bestScore = score;
			}
			
			_disappearNum = 1;
			
			TweenLite.to(Game_round,1,{disappearNum:0.00001,onComplete:disappearOver,ease:ElasticIn.ease});
		}
		
		private static function actionFail():void{
			
			chooseVec.reverse();
			
			startMove(true);
		}
		
		private static function disappearOver():void{
			
			if(!GameCom_round.IS_FALL){
			
				for(i = 0 ; i < resultVec.length ; i++){
					
					data[resultVec[i]] = GameCom_round.getRandomColorIndex(data,resultVec[i]);
				}
				
				quadBatchReset();
				
				_disappearNum = 1;
				
				disappearNum = 0.00001;
				
				TweenLite.to(Game_round,1,{disappearNum:1,onComplete:actionOver,ease:ElasticOut.ease});
				
			}else{
				
				startFall();
			}
		}
		
		private static function startFall():void{
			
			resultVec.length = 0;
			
			GameCom_round.checkFall(data,resultVec,chooseVec);
			
			if(resultVec.length > 0){
			
				fallMove();
				
			}else{
				
				//没有球掉落了
				
				trace("over1");
				
				addNewBall();
			}
		}
		
		private static function fallMove():void{
			
			var maxDistance:int = -1;
			
			for(i = 0 ; i < resultVec.length ; i++){
				
				m = chooseVec[i] - resultVec[i];
				
				if(m > maxDistance){
					
					maxDistance = m;
				}
			}
			
			maxDistance = maxDistance / GameCom_round.WIDTH;
			
			_fallNum = 0;
			
			TweenLite.to(Game_round,1,{fallNum:maxDistance,ease:Quint.easeIn,onComplete:fallMoveOver});
		}
		
		private static function fallMoveOver():void{
			
			quadBatchReset();
			
			resultVec.length = 0;
			
			GameCom_round.check(data,chooseVec,resultVec);
			
			chooseVec.length = 0;
			
			if(resultVec.length > 0){
				
				actionSuccess();
				
			}else{
				
				//没有球可以消了
				
				trace("over2");
				
				addNewBall();
			}
		}
		
		private static function addNewBall():void{
			
			resultVec.length = 0;
			
			chooseVec.length = 0;
			
			var maxDistance:int = -1;
			
			for(i = 0 ; i < GameCom_round.WIDTH ; i++){
				
				var maxDistanceColumn:int = -1;
				
				for(m = GameCom_round.HEIGHT - 1 ; m > -1 ; m--){
					
					var index:int = m * GameCom_round.WIDTH + i;
					
					if(data[index] == -1){
						
						if(maxDistanceColumn == -1){
							
							maxDistanceColumn = m;
						}
						
						data[index] = GameCom_round.getRandomColorIndex(data,index);
						
						resultVec.push(index);
						
						chooseVec.push(maxDistanceColumn);
					}
				}
				
				if(maxDistanceColumn > maxDistance){
					
					maxDistance = maxDistanceColumn;
				}
			}
			
//			for(i = 0 ; i < GameCom_round.WIDTH * GameCom_round.HEIGHT ; i++){
//				
//				if(data[i] == -1){
//				
//					data[i] = GameCom_round.getRandomColorIndex(data,i);
//					
//					resultVec.push(i);
//				}
//			}
			
			maxDistance++;
			
			quadBatchReset();
			
			addNewBallMove(maxDistance);
		}
		
		private static function addNewBallMove(_maxDistance:int):void{
			
			for(i = 0 ; i < resultVec.length ; i++){
				
				m = int(resultVec[i] / GameCom_round.WIDTH);
				
				matrix.identity();
				
				matrix.translate(-imgVec[resultVec[i]].x - GameCom_round.BALL_WIDTH * 0.5,-imgVec[resultVec[i]].y - GameCom_round.BALL_WIDTH * 0.5);
				
				matrix.scale(0.00001 , 0.00001);
				
				matrix.translate(imgVec[resultVec[i]].x + GameCom_round.BALL_WIDTH * 0.5,imgVec[resultVec[i]].y + GameCom_round.BALL_WIDTH * 0.5);
				
				matrix.translate(0,-m * GameCom_round.MAP_WIDTH);
				
				quadBatch.transformQuad(resultVec[i],matrix);
			}
			
			_addNewBallNum = 0;
			
			TweenLite.to(Game_round,1,{addNewBallNum:_maxDistance,ease:Quint.easeIn,onComplete:actionOver});
		}
		
		private static var _addNewBallNum:Number;

		public static function get addNewBallNum():Number
		{
			return _addNewBallNum;
		}

		public static function set addNewBallNum(value:Number):void
		{
			for(i = 0 ; i < resultVec.length ; i++){
				
				m = int(resultVec[i] / GameCom_round.WIDTH);
				
				var d:Number = value - (chooseVec[i] - m);
				
				var e:Number = _addNewBallNum - (chooseVec[i] - m);
				
				if(e <= 0){
					
					e = 0.00001;
				}
				
				if(d > m + 1){
					
					if(e < m + 1){
					
						if(m == 0){
							
							matrix.identity();
							
							matrix.translate(-imgVec[resultVec[i]].x - GameCom_round.BALL_WIDTH * 0.5, -GameCom_round.MAP_WIDTH * 0.5);
							
							matrix.scale(1 / e , 1 / e);
							
							matrix.translate(imgVec[resultVec[i]].x + GameCom_round.BALL_WIDTH * 0.5,GameCom_round.MAP_WIDTH * 0.5);
							
							quadBatch.transformQuad(resultVec[i],matrix);
							
						}else{
							
							matrix.identity();
							
							matrix.translate(0,((m + 1) - e) * GameCom_round.MAP_WIDTH);
							
							quadBatch.transformQuad(resultVec[i],matrix);
						}
					}
					
				}else if(d > 1){//移动
					
					if(e < 1){//放大转到移动
						
						matrix.identity();
						
						matrix.translate(-imgVec[resultVec[i]].x - GameCom_round.BALL_WIDTH * 0.5, -GameCom_round.MAP_WIDTH * 0.5);
						
						matrix.scale(1 / e , 1 / e);
						
						matrix.translate(imgVec[resultVec[i]].x + GameCom_round.BALL_WIDTH * 0.5,GameCom_round.MAP_WIDTH * 0.5);
						
						matrix.translate(0,(d - 1) * GameCom_round.MAP_WIDTH);
						
						quadBatch.transformQuad(resultVec[i],matrix);
						
					}else{
						
						matrix.identity();
						
						matrix.translate(0,(d - e) * GameCom_round.MAP_WIDTH);
						
						quadBatch.transformQuad(resultVec[i],matrix);
					}
					
				}else if(d > 0){//放大
					
					matrix.identity();
					
					matrix.translate(-imgVec[resultVec[i]].x - GameCom_round.BALL_WIDTH * 0.5, -GameCom_round.MAP_WIDTH * 0.5);
					
					matrix.scale(d / e,d / e);
					
					matrix.translate(imgVec[resultVec[i]].x + GameCom_round.BALL_WIDTH * 0.5,GameCom_round.MAP_WIDTH * 0.5);
					
					quadBatch.transformQuad(resultVec[i],matrix);				
				}
			}
			
			_addNewBallNum = value;
		}

		private static var _fallNum:Number;

		public static function get fallNum():Number
		{
			return _fallNum;
		}

		public static function set fallNum(value:Number):void
		{
			for(i = 0 ; i < resultVec.length ; i++){
				
				if(resultVec[i] != -1){
					
					m = resultVec[i];
					
					if(value * GameCom_round.WIDTH > chooseVec[i] - resultVec[i]){
						
						var newValue:Number = (chooseVec[i] - resultVec[i]) / GameCom_round.WIDTH;
						
						resultVec[i] = -1;
						
					}else{
						
						newValue = value;
					}
					
					var p:Number = newValue - _fallNum;
					
					var dy:Number = p * GameCom_round.MAP_WIDTH;
					
					matrix.identity();
					
					matrix.translate(0,dy);
					
					quadBatch.transformQuad(m,matrix);
				}
			}
			
			_fallNum = value;
		}

		
		private static function actionOver():void{
			
			chooseVec.length = 0;
			
			if(moveTimes > 0){
				
				canAction = true;
				
			}else{
				
				showMaskContainer();
			}
		}
		
		private static function showMaskContainer():void{
			
			maskContainer.visible = true;
			
			maskContainer.unflatten();
			
			finalScoreTf.text = "score\n\n" + score + "\n\n\nTouch To Restart\n\n\n";
			
			maskContainer.flatten();
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
						
						var dx:Number = -p * GameCom_round.MAP_WIDTH;
						var dy:Number = 0;
						
						break;
					
					case 1:
						
						dx = p * GameCom_round.MAP_WIDTH;
						dy = 0;
						
						break;
					
					case -GameCom_round.WIDTH:
						
						dx = 0;
						dy = -p * GameCom_round.MAP_WIDTH;
						
						break;
					
					default:
						
						dx = 0;
						dy = p * GameCom_round.MAP_WIDTH;
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
				
				matrix.translate(-imgVec[resultVec[i]].x - GameCom_round.BALL_WIDTH * 0.5,-imgVec[resultVec[i]].y - GameCom_round.BALL_WIDTH * 0.5);
				
				matrix.scale(value / _disappearNum,value / _disappearNum);
				
				matrix.translate(imgVec[resultVec[i]].x + GameCom_round.BALL_WIDTH * 0.5,imgVec[resultVec[i]].y + GameCom_round.BALL_WIDTH * 0.5);
				
				quadBatch.transformQuad(resultVec[i],matrix);				
			}
			
			_disappearNum = value;
		}
		
		
		
		private static function maskTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject,TouchPhase.ENDED);
			
			if(touch){
				
				maskContainer.visible = false;
				
				start();
			}
		}
		
		private static var sp:Sprite;
		
		private static function test(e:Event):void{
			
			sp = new Sprite;
			
			sp.alpha = 0.8;
			
			sp.touchable = false;
			
			var tf:TextField = new TextField(Starling.current.viewPort.width,Starling.current.viewPort.height,"32",Resource.FONT_NAME0,20,0xFF0000,true);
			
			tf.x = - Starling.current.viewPort.width * 0.5;
			tf.y = - Starling.current.viewPort.height * 0.5;
			
			sp.addChild(tf);
			
			sp.x = Starling.current.viewPort.width * 0.5;
			
			sp.y = Starling.current.viewPort.height * 0.5;
			
			g = sp.scaleX = sp.scaleY = 0;
			
			container.addChild(sp);
			
			TweenLite.to(Game_round,1,{g:2,ease:Elastic.easeOut,onComplete:sss,onCompleteParams:[sp]});
		}
		
		private static var _g:Number;

		public static function get g():Number
		{
			return _g;
		}

		public static function set g(value:Number):void
		{
			trace("value:",value);
			
			sp.scaleX = sp.scaleY = Math.abs(value);
			
			_g = value;
		}

		
		private static function sss(_sp:Sprite):void{
			
			container.removeChild(_sp);
		}
	}
}