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
			trace("hoge");
			var g:Graphics;
			//
			image = new Sprite();
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
				var position:Point = new Point(this.x, this.y);
				var currentMouse:Point = new Point(stage.mouseX, stage.mouseY);
				var radius:Point = preMouse.subtract(position);
				var force:Point = currentMouse.subtract(preMouse);
				var moment:Number = crossProduct(radius, force);
				vr += moment * RATIO;
				v = force;
				
				matrix = transform.matrix;
				matrix.translate( -1 * preMouse.x, -1 * preMouse.y);
				matrix.rotate(vr);
				matrix.translate(currentMouse.x, currentMouse.y);
				transform.matrix = matrix;
				vr *= 0.95;
				
				preMouse = currentMouse.clone();
			}
			else
			{
				matrix = transform.matrix;
				matrix.translate(-1*this.x, -1*this.y);
				matrix.rotate(vr);
				matrix.translate(this.x + v.x, this.y + v.y);
				transform.matrix = matrix;
				v.normalize(v.length * 0.95);
				vr *= 0.75;
				
				if (this.x > stage.stageWidth)
				{
					this.x = stage.stageWidth;
					v.x *= -1;
				}
				else if (this.x < 0)
				{
					this.x = 0;
					v.x *= -1;
				}
				if (this.y > stage.stageHeight)
				{
					this.y = stage.stageHeight;
					v.y *= -1;
				}
				else if (this.y < 0)
				{
					this.y = 0;
					v.y *= -1;
				}
			}
		}
		
		private function mouseDownHander(e:MouseEvent):void 
		{
			isDown = true;
			v = new Point(0, 0);
			vr = 0;
			preMouse = new Point(stage.mouseX, stage.mouseY);
			
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