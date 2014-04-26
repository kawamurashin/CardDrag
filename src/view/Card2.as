package view 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Jaiko
	 */
	public class Card extends Sprite 
	{
		private var preMouse:Point;
		private var vr:Number = 0;
		private var v:Point = new Point(0, 0);
		private var isDown:Boolean = false;
		private var image:Sprite;
		public function Card() 
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//
			layout();
		}
		private function layout():void 
		{
			var g:Graphics;
			//
			image = new Sprite();
			image.x = stage.stageWidth*0.5;
			image.y = stage.stageHeight*0.5;
			addChild(image);
			g = image.graphics;
			g.beginFill(0xCCCCCC);
			g.drawRect( -80, -40, 160, 80);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHander);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			var matrix:Matrix;
			const RATIO:Number = 0.025 * Math.PI / 180;
			if (isDown)
			{	
				var position:Point = new Point(image.x, image.y);
				var currentMouse:Point = new Point(this.mouseX, this.mouseY);
				var radius:Point = preMouse.subtract(position);
				var force:Point = currentMouse.subtract(preMouse);
				var moment:Number = crossProduct(radius, force);
				vr += moment * RATIO;
				v = force;
				
				matrix = image.transform.matrix;
				matrix.translate( -1 * preMouse.x, -1 * preMouse.y);
				matrix.rotate(vr);
				matrix.translate(currentMouse.x, currentMouse.y);
				image.transform.matrix = matrix;
				vr *= 0.95;
				
				preMouse = currentMouse.clone();
			}
			else
			{
				matrix = image.transform.matrix;
				//matrix.translate(-1*image.x, -1*image.y);
				matrix.rotate(vr);
				//matrix.translate(image.x + v.x, image.y + v.y);
				matrix.translate(v.x, v.y);
				image.transform.matrix = matrix;
				v.normalize(v.length * 0.75);
				vr *= 0.75;
				
				if (image.x > stage.stageWidth)
				{
					image.x = stage.stageWidth;
					v.x *= -1;
				}
				else if (image.x < 0)
				{
					image.x = 0;
					v.x *= -1;
				}
				if (image.y > stage.stageHeight)
				{
					image.y = stage.stageHeight;
					v.y *= -1;
				}
				else if (image.y < 0)
				{
					image.y = 0;
					v.y *= -1;
				}
			}
		}
		
		private function mouseDownHander(e:MouseEvent):void 
		{
			isDown = true;
			v = new Point(0, 0);
			vr = 0;
			preMouse = new Point(this.mouseX, this.mouseY);
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHander);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			isDown = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHander);
		}
		private function crossProduct(point0:Point, point1:Point):Number
		{
			return point0.x * point1.y - point0.y * point1.x;
		}
		
	}

}