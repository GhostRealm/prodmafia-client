package io.decagames.rotmg.ui.popups {
import flash.display.DisplayObject;
import flash.display.Sprite;

public class PopupView extends Sprite {


    public function PopupView() {
        super();
        this.popupContainer = new Sprite();
        this.fadeContainer = new Sprite();
        super.addChild(this.popupContainer);
        super.addChild(this.fadeContainer);
    }
    protected var popupFadeColor:uint = 1381653;
    protected var popupFadeAlpha:Number = 0.6;
    private var popupContainer:Sprite;
    private var fadeContainer:Sprite;

    override public function addChild(_arg_1:DisplayObject):DisplayObject {
        return this.popupContainer.addChild(_arg_1);
    }

    override public function removeChild(_arg_1:DisplayObject):DisplayObject {
        return this.popupContainer.removeChild(_arg_1);
    }

    public function showFade():void {
        this.fadeContainer.graphics.beginFill(this.popupFadeColor, this.popupFadeAlpha);
        this.fadeContainer.graphics.drawRect(0, 0, 800, 10 * 60);
        this.fadeContainer.graphics.endFill();
    }

    public function removeFade():void {
        this.fadeContainer.graphics.clear();
    }
}
}
