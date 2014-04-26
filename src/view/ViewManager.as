package view 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jaiko
	 */
	public class ViewManager extends Sprite 
	{
		
		public function ViewManager() 
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
			var card:Card;
			//
			card = new Card();
			addChild(card);
		}
		
	}

}