package game_round
{
	import starling.core.Starling;

	public class GameCom_round
	{
		public static const IS_FALL:Boolean = true;
		
		public static const WIDTH:int = 8;//不变
		public static const HEIGHT:int = 8;//不变
		
		public static const BG_WIDTH:int = 0;//不变
		public static const SCORE_CONTAINER_HEIGHT:int = 40;//不变
		
		public static const SCALE9IMG_WIDTH:int = 15;//不变
		
		public static var UNIT_WIDTH:int = 55;//ball_width - 3
		
		public static var BALL_WIDTH:int = 58;//map_width - 10

		public static var MAP_WIDTH:int = 69;//(all_width - fixx * 2) / width
		
		public static const COLOR_NUM:int = 6;//不变
		
		public static const MAP_CONTAINER_FIXX:int = 2;//不变
		
		public static var ALL_WIDTH:int;
		
		public static const O_ALL_WIDTH:int = 640;//不变
		
		public static var SCALE:Number;
		
		public static const O_FONT_SIZE:int = 40;//不变
		
		public static const FONT_COLOR:uint = 0x666666;//不变
		
		public static const OMOVETIMES:int = 2;//不变
		
		public static const OSCORE:int = 0;//不变
		
		private static var tmpColorIndexVec:Vector.<int>;
		
		private static var upVec:Vector.<int>;
		private static var downVec:Vector.<int>;
		private static var leftVec:Vector.<int>;
		private static var rightVec:Vector.<int>;
		
		public function GameCom_round()
		{
		}
		
		public static function init():void{
			
			ALL_WIDTH = Starling.current.viewPort.width;
			
			SCALE = ALL_WIDTH / O_ALL_WIDTH;
			
			MAP_WIDTH = (ALL_WIDTH - BG_WIDTH * 2) / WIDTH;
			
			BALL_WIDTH = MAP_WIDTH - 10;
			
			UNIT_WIDTH = BALL_WIDTH - 3;
			
			tmpColorIndexVec = new Vector.<int>(COLOR_NUM,true);
			
			for(var i:int = 0 ; i < COLOR_NUM ; i++){
				
				tmpColorIndexVec[i] = i;
			}
			
			upVec = new Vector.<int>(2,true);
			downVec = new Vector.<int>(2,true);
			leftVec = new Vector.<int>(2,true);
			rightVec = new Vector.<int>(2,true);
		}
		
		public static function getRandomColorIndex(_data:Vector.<int>,_index:int):int{
			
			var vec:Vector.<int> = tmpColorIndexVec.concat();
			
			var tmpInt:int = _index % WIDTH;
			
			if(tmpInt == 0){
				
				leftVec[0] = -1;
				leftVec[1] = -1;
				
			}else if(tmpInt == 1){
				
				leftVec[0] = _data[_index - 1];
				leftVec[1] = -1;
				
			}else{
				
				leftVec[0] = _data[_index - 1];
				leftVec[1] = _data[_index - 2];
				
				if(leftVec[0] == leftVec[1] && leftVec[0] != -1){
					
					var tmpInt2:int = vec.indexOf(leftVec[0]);
					
					if(tmpInt2 != -1){
						
						vec.splice(tmpInt2,1);
					}
				}
			}
			
			if(tmpInt == WIDTH - 1){
				
				rightVec[0] = -1;
				rightVec[1] = -1;
				
			}else if(tmpInt == WIDTH - 2){
				
				rightVec[0] = _data[_index + 1];
				rightVec[1] = -1;
				
			}else{
				
				rightVec[0] = _data[_index + 1];
				rightVec[1] = _data[_index + 2];
				
				if(rightVec[0] == rightVec[1] && rightVec[0] != -1){
					
					tmpInt2 = vec.indexOf(rightVec[0]);
					
					if(tmpInt2 != -1){
						
						vec.splice(tmpInt2,1);
					}
				}
			}
			
			tmpInt = int(_index / WIDTH);
			
			if(tmpInt == 0){
				
				upVec[0] = -1;
				upVec[1] = -1;
				
			}else if(tmpInt == 1){
				
				upVec[0] = _data[_index - WIDTH];
				upVec[1] = -1;
				
			}else{
				
				upVec[0] = _data[_index - WIDTH];
				upVec[1] = _data[_index - WIDTH * 2];
				
				if(upVec[0] == upVec[1] && upVec[0] != -1){
					
					tmpInt2 = vec.indexOf(upVec[0]);
					
					if(tmpInt2 != -1){
						
						vec.splice(tmpInt2,1);
					}
				}
			}
			
			if(tmpInt == HEIGHT - 1){
				
				downVec[0] = -1;
				downVec[1] = -1;
				
			}else if(tmpInt == HEIGHT - 2){
				
				downVec[0] = _data[_index + WIDTH];
				downVec[1] = -1;
				
			}else{
				
				downVec[0] = _data[_index + WIDTH];
				downVec[1] = _data[_index + WIDTH * 2];
				
				if(downVec[0] == downVec[1] && downVec[0] != -1){
					
					tmpInt2 = vec.indexOf(downVec[0]);
					
					if(tmpInt2 != -1){
						
						vec.splice(tmpInt2,1);
					}
				}
			}
			
			if(upVec[0] == downVec[0] && upVec[0] != -1){
				
				tmpInt = vec.indexOf(upVec[0]);
				
				if(tmpInt != -1){
					
					vec.splice(tmpInt,1);
				}
			}
			
			if(leftVec[0] == rightVec[0] && leftVec[0] != -1){
				
				tmpInt = vec.indexOf(leftVec[0]);
				
				if(tmpInt != -1){
					
					vec.splice(tmpInt,1);
				}
			}
			
			return vec[int(Math.random() * vec.length)];
		}
		
		public static function check(_data:Vector.<int>,_vec:Vector.<int>,_resultVec:Vector.<int>):void{
			
			var vec:Vector.<int> = _resultVec;
			
			for each(var index:int in _vec){
				
				var tmpInt:int = index % WIDTH;
				
				if(tmpInt == 0){
					
					leftVec[0] = -1;
					leftVec[1] = -1;
					
				}else if(tmpInt == 1){
					
					leftVec[0] = index - 1;
					leftVec[1] = -1;
					
				}else{
					
					leftVec[0] = index - 1;
					leftVec[1] = index - 2;
				}
				
				if(tmpInt == WIDTH - 1){
					
					rightVec[0] = -1;
					rightVec[1] = -1;
					
				}else if(tmpInt == WIDTH - 2){
					
					rightVec[0] = index + 1;
					rightVec[1] = -1;
					
				}else{
					
					rightVec[0] = index + 1;
					rightVec[1] = index + 2;
				}
				
				tmpInt = int(index / WIDTH);
				
				if(tmpInt == 0){
					
					upVec[0] = -1;
					upVec[1] = -1;
					
				}else if(tmpInt == 1){
					
					upVec[0] = index - WIDTH;
					upVec[1] = -1;
					
				}else{
					
					upVec[0] = index - WIDTH;
					upVec[1] = index - WIDTH * 2;
				}
				
				if(tmpInt == HEIGHT - 1){
					
					downVec[0] = -1;
					downVec[1] = -1;
					
				}else if(tmpInt == HEIGHT - 2){
					
					downVec[0] = index + WIDTH;
					downVec[1] = -1;
					
				}else{
					
					downVec[0] = index + WIDTH;
					downVec[1] = index + WIDTH * 2;
				}
				
				if(upVec[0] != -1 && downVec[0] != -1 && _data[index] == _data[upVec[0]] && _data[index] == _data[downVec[0]]){
					
					if(vec.indexOf(index) == -1){
						
						vec.push(index);
					}
					
					if(vec.indexOf(upVec[0]) == -1){
						
						vec.push(upVec[0]);
					}
					
					if(vec.indexOf(downVec[0]) == -1){
						
						vec.push(downVec[0]);
					}
					
					if(upVec[1] != -1 && _data[index] == _data[upVec[1]]){
						
						if(vec.indexOf(upVec[1]) == -1){
							
							vec.push(upVec[1]);
						}
					}
					
					if(downVec[1] != -1 && _data[index] == _data[downVec[1]]){
						
						if(vec.indexOf(downVec[1]) == -1){
							
							vec.push(downVec[1]);
						}
					}
					
				}else if(upVec[0] != -1 && upVec[1] != -1 && _data[index] == _data[upVec[0]] && _data[index] == _data[upVec[1]]){
					
					if(vec.indexOf(index) == -1){
						
						vec.push(index);
					}
					
					if(vec.indexOf(upVec[0]) == -1){
						
						vec.push(upVec[0]);
					}
					
					if(vec.indexOf(upVec[1]) == -1){
						
						vec.push(upVec[1]);
					}
					
				}else if(downVec[0] != -1 && downVec[1] != -1 && _data[index] == _data[downVec[0]] && _data[index] == _data[downVec[1]]){
					
					if(vec.indexOf(index) == -1){
						
						vec.push(index);
					}
					
					if(vec.indexOf(downVec[0]) == -1){
						
						vec.push(downVec[0]);
					}
					
					if(vec.indexOf(downVec[1]) == -1){
						
						vec.push(downVec[1]);
					}
				}
				
				if(leftVec[0] != -1 && rightVec[0] != -1 && _data[index] == _data[leftVec[0]] && _data[index] == _data[rightVec[0]]){
					
					if(vec.indexOf(index) == -1){
						
						vec.push(index);
					}
					
					if(vec.indexOf(leftVec[0]) == -1){
						
						vec.push(leftVec[0]);
					}
					
					if(vec.indexOf(rightVec[0]) == -1){
						
						vec.push(rightVec[0]);
					}
					
					if(leftVec[1] != -1 && _data[index] == _data[leftVec[1]]){
						
						if(vec.indexOf(leftVec[1]) == -1){
							
							vec.push(leftVec[1]);
						}
					}
					
					if(rightVec[1] != -1 && _data[index] == _data[rightVec[1]]){
						
						if(vec.indexOf(rightVec[1]) == -1){
							
							vec.push(rightVec[1]);
						}
					}
					
				}else if(leftVec[0] != -1 && leftVec[1] != -1 && _data[index] == _data[leftVec[0]] && _data[index] == _data[leftVec[1]]){
					
					if(vec.indexOf(index) == -1){
						
						vec.push(index);
					}
					
					if(vec.indexOf(leftVec[0]) == -1){
						
						vec.push(leftVec[0]);
					}
					
					if(vec.indexOf(leftVec[1]) == -1){
						
						vec.push(leftVec[1]);
					}
					
				}else if(rightVec[0] != -1 && rightVec[1] != -1 && _data[index] == _data[rightVec[0]] && _data[index] == _data[rightVec[1]]){
					
					if(vec.indexOf(index) == -1){
						
						vec.push(index);
					}
					
					if(vec.indexOf(rightVec[0]) == -1){
						
						vec.push(rightVec[0]);
					}
					
					if(vec.indexOf(rightVec[1]) == -1){
						
						vec.push(rightVec[1]);
					}
				}
				
			}
			
			for each(index in vec){
				
				_data[index] = -1;
			}
		}
		
		public static function checkFall(_data:Vector.<int>,_fallStartVec:Vector.<int>,_fallTargetVec:Vector.<int>):void{
			
			for(var i:int = 0 ; i < WIDTH ; i++){
				
				var hasEmpty:int = -1;
				
				for(var m:int = HEIGHT - 1 ; m > -1 ; m--){
					
					var index:int = m * WIDTH + i;
					
					if(hasEmpty == -1){
						
						if(_data[index] == -1){
							
							hasEmpty = index;
						}
						
					}else{
						
						if(_data[index] != -1){
							
							_fallStartVec.push(index);
							
							_fallTargetVec.push(hasEmpty);
							
							_data[hasEmpty] = _data[index];
							
							_data[index] = -1;
							
							hasEmpty = hasEmpty - WIDTH;
						}
					}
				}
			}
		}
		
		public static function getScore(_num:int):int{
			
			return _num;
		}
		
	}
}