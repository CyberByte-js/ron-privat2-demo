package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-inv', [0, 1], 0, false, isPlayer);
		animation.add('bf-b', [20, 21], 0, false, isPlayer);
		animation.add('bf-run', [30, 31], 0, false, isPlayer);
		animation.add('bfbloodshed-death', [30, 31], 0, false, isPlayer);
		animation.add('bf-d', [40, 41], 0, false, isPlayer);
		animation.add('gf', [10], 0, false, isPlayer);
		animation.add('gf-d', [10], 0, false, isPlayer);
		animation.add('gf-b', [11], 0, false, isPlayer);
		// organized ron health icons because cyber didnt
		// also cyber plz add the other health icons ok ty
		// ok
		// ty :)
		
		// i organized them even better now
		// Cry about it
		// -sz
		
		// week 1
		animation.add('ron', [2, 3], 0, false, isPlayer);
		animation.add('ron-angry', [4, 5], 0, false, isPlayer);		
		animation.add('ron-mad', [6, 7], 0, false, isPlayer);		
		animation.add('hellron', [8, 9], 0, false, isPlayer);	
		animation.add('hacker', [8, 9], 0, false, isPlayer);	
		animation.add('hellron-drippin', [8, 9], 0, false, isPlayer);	
		animation.add('hellron-crazy', [8, 9], 0, false, isPlayer);		
		animation.add('demonron', [62, 63], 0, false, isPlayer);				
		
		// bonus songs for the future
		animation.add('ronDave', [2, 3], 0, false, isPlayer);
		animation.add('bijuuron', [42, 43], 0, false, isPlayer);
		animation.add('devilron', [44, 45], 0, false, isPlayer);
		animation.add('douyhe', [48, 49], 0, false, isPlayer);
		animation.add('dave', [58, 59], 0, false, isPlayer);	

		// idk why this exists but ill put it in just in case
		animation.add('gf-in', [59], 0, false, isPlayer);

		animation.add('gf-in', [44], 0, false, isPlayer);

		// the
		animation.add('chezburgir', [2, 3], 0, false, isPlayer);

		animation.play(char);

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
