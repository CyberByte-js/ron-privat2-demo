package;

import openfl.display.BlendMode;
import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;
// cyber can we try to make the main menu better plz -ekical
// yea but how? -cyber
// idk we'll make it up as we go -ekical
// ok so we probably need a custom bg for it right? its probably the start -cyber
// yeah yeah, who should we get to make it tho? -ekical
// just ping @artists -cyber
// k -ekical

// hi -sz
// hi -cyber
class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options', 'credits'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var code:String = "";
	var codeInt = 0;
	var codeInt2 = 0;
	var neededCode:Array<String> = ['B', 'R', 'O'];
	var therock:FlxSprite;
	public static var firstStart:Bool = true;

	public static var nightly:String = " (ron eidtion)";

	public static var kadeEngineVer:String = "KE 1.5.4" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var cloud:FlxBackdrop;
	var city:FlxBackdrop;
	var city2:FlxBackdrop;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	public static var b:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		
		var bgTex = 'menuSunset';
		var sunTex = 'menuSun';
		var alphaTex = 1;
		var cityTex = 'menuCity';
		var cityBTex = 'menuCityBack';

		if ((Date.now().getHours() < 6) || (Date.now().getHours() > 20))
		{
			bgTex = 'menuNight';
			sunTex = 'menuMoon';
			alphaTex = 2;
			cityTex = 'menuCityNight';
			cityBTex = 'menuCityBackNight';
		}

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image(bgTex));
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);
		
		var sun:FlxSprite = new FlxSprite();
		sun.frames = Paths.getSparrowAtlas(sunTex);
		sun.scrollFactor.set();
		sun.animation.addByPrefix('sun', 'sun', 2, true);
		sun.antialiasing = true;
		sun.screenCenter();
		sun.x -= 80;
		sun.y -= 80;
		add(sun);
		sun.animation.play('sun');
		
		cloud = new FlxBackdrop(Paths.image('menuClouds'), 32, 0, true, true, 0, -250);
		cloud.alpha = 0.8/alphaTex;
		cloud.scrollFactor.set(0.1);
		add(cloud);
		
		city2 = new FlxBackdrop(Paths.image(cityBTex), 32, 0, true, true, 0, -250);
		city2.scrollFactor.set(0.125);
		add(city2);
		
		city = new FlxBackdrop(Paths.image(cityTex), 32, 0, true, true, 0, -250);
		city.scrollFactor.set(0.2);
		add(city);
		
		var road:FlxSprite = new FlxSprite();
		road.frames = Paths.getSparrowAtlas('menuRoad');
		road.scrollFactor.set();
		road.animation.addByPrefix('road instance 1', 'road instance 1', 24, true);
		road.antialiasing = true;
		road.screenCenter(X);
		road.x += 130;
		add(road);
		road.animation.play('road instance 1');
		
		var car:FlxSprite = new FlxSprite(597.5, 289);
		car.frames = Paths.getSparrowAtlas('menuCar');
		car.animation.addByPrefix('car instance 1', 'car instance 1', 24, true);
		car.antialiasing = true;
		add(car);
		car.scrollFactor.set();
		car.animation.play('car instance 1');

		therock = new FlxSprite().loadGraphic(Paths.image('therock', 'shared'));
		therock.x += 0;
		therock.y += 0;
		therock.alpha = 0;
		add(therock);
		
		if(FlxG.save.data.antialiasing)
			{
				bg.antialiasing = true;
			}

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		var logoBl:FlxSprite = new FlxSprite(160, -380);
		logoBl.scale.set(0.5, 0.5);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, true);
		logoBl.updateHitbox();
		add(logoBl);
		logoBl.animation.play('bump');
		
		var lines:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuLines'));
		lines.scale.set(0.5, 0.5);
		lines.scrollFactor.set();
		lines.screenCenter();
		lines.alpha = 0.5;
		lines.blend = BlendMode.OVERLAY;
		add(lines);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(40, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.95));
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			if(FlxG.save.data.antialiasing)
				{
					menuItem.antialiasing = true;
				}
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 130)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				menuItem.y = 60 + (i * 130);
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + "" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
        if (FlxG.keys.justPressed.ANY)
			{
				var curKey = FlxG.keys.getIsDown()[0].ID.toString();
	
				if (neededCode.contains(curKey) && neededCode[codeInt] == curKey)
				{
					code += curKey;
					codeInt++;
					codeInt2++;
				}
				else
				{
					code = '';
					codeInt = 0;
				}
			}
			
			if (code == 'BRO')
			{
                therock.alpha = 1;
				FlxTween.tween(therock, {alpha: 0}, 1);
				FlxG.sound.play(Paths.sound('hi'), false); // hi ekic cal i think i fix it but im not sure:( -chromasen
				 									// no i did not fix but it still appears - chromasen
			}
			if (codeInt == 10)
				{
					code = 'BRO';
					codeInt = 0;
				} 
	
		cloud.x += 0.33;
		city.x += 2;
		city2.x += 1;
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://ninja-muffin24.itch.io/funkin");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
				b = false;
			case 'freeplay':
				FlxG.switchState(new MasterPlayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
			case 'credits':
				FlxG.switchState(new CreditsState());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
