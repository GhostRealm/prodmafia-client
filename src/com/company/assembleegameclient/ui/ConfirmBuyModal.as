package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.objects.SellableObject;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;

import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.pets.view.components.PopupWindowBackground;
import kabam.rotmg.text.view.TextFieldConcreteBuilder;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.util.components.ItemWithTooltip;
import kabam.rotmg.util.components.LegacyBuyButton;
import kabam.rotmg.util.components.UIAssetsHelper;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeSignal;

public class ConfirmBuyModal extends Sprite {

    public static const WIDTH:int = 280;

    public static const HEIGHT:int = 240;

    public static const TEXT_MARGIN:int = 20;
    private const closeButton:DialogCloseButton = PetsViewAssetFactory.returnCloseButton(280);
    private const buyButton:LegacyBuyButton = new LegacyBuyButton("SellableObjectPanel.buy", 16, 0, -1);
    public static var free:Boolean = true;

    private static function makeModalBackground(_arg_1:int, _arg_2:int):PopupWindowBackground {
        var _local3:PopupWindowBackground = new PopupWindowBackground();
        _local3.draw(_arg_1, _arg_2);
        _local3.divide("HORIZONTAL_DIVISION", 30);
        return _local3;
    }

    public function ConfirmBuyModal(_arg_1:Signal, _arg_2:SellableObject, _arg_3:Number, _arg_4:int) {
        var _local7:* = null;
        var _local6:* = null;
        super();
        ConfirmBuyModal.free = false;
        this.buyItem = _arg_1;
        this.owner_ = _arg_2;
        this.buttonWidth = _arg_3;
        this.availableInventoryNumber = _arg_4;
        this.events();
        addEventListener("removedFromStage", this.onRemovedFromStage, false, 0, true);
        this.positionAndStuff();
        this.addChildren();
        this.buyButton.setPrice(this.owner_.price_, this.owner_.currency_);
        var _local8:String = this.owner_.soldObjectName();
        _local6 = new TextFieldConcreteBuilder();
        _local6.containerMargin = 20;
        _local6.containerWidth = 280;
        addChild(_local6.getLocalizedTextObject("ConfirmBuyModal.title", 20, 5));
        addChild(_local6.getLocalizedTextObject("ConfirmBuyModal.desc", 20, 40));
        addChild(_local6.getLocalizedTextObject(_local8, 20, 90));
        var _local5:TextFieldDisplayConcrete = _local6.getLocalizedTextObject("ConfirmBuyModal.amount", 20, 140);
        addChild(_local5);
        this.quantityInputText = _local6.getLiteralTextObject("1", 20, 160);
        if (this.owner_.getSellableType() != -1) {
            _local7 = new ItemWithTooltip(this.owner_.getSellableType(), 64);
        }
        _local7.x = 140 - _local7.width / 2;
        _local7.y = 100;
        addChild(_local7);
        this.quantityInputText = _local6.getLiteralTextObject("1", 20, 160);
        this.quantityInputText.setMultiLine(false);
        addChild(this.quantityInputText);
        this.leftNavSprite = this.makeNavigator("left");
        this.rightNavSprite = this.makeNavigator("right");
        this.leftNavSprite.x = 101.818181818182 - this.rightNavSprite.width / 2;
        this.leftNavSprite.y = 150;
        addChild(this.leftNavSprite);
        this.rightNavSprite.x = 178.181818181818 - this.rightNavSprite.width / 2;
        this.rightNavSprite.y = 150;
        addChild(this.rightNavSprite);
        this.refreshNavDisable();
        this.open = true;
    }
    public var buyItem:Signal;
    public var open:Boolean;
    public var buttonWidth:int;
    private var buyButtonClicked:NativeSignal;
    private var quantityInputText:TextFieldDisplayConcrete;
    private var leftNavSprite:Sprite;
    private var rightNavSprite:Sprite;
    private var quantity_:int = 1;
    private var availableInventoryNumber:int;
    private var owner_:SellableObject;

    public function onCloseClick():void {
        this.close();
    }

    private function refreshNavDisable():void {
        this.leftNavSprite.alpha = this.quantity_ == 1 ? 0.5 : 1;
        this.rightNavSprite.alpha = this.quantity_ == this.availableInventoryNumber ? 0.5 : 1;
    }

    private function positionAndStuff():void {
        this.x = -440;
        this.y = -320;
        this.buyButton.x = this.buyButton.x + 35;
        this.buyButton.y = this.buyButton.y + 195;
        this.buyButton.x = 140 - this.buttonWidth / 2;
    }

    private function events():void {
        this.closeButton.clicked.add(this.onCloseClick);
        this.buyButtonClicked = new NativeSignal(this.buyButton, "click", MouseEvent);
        this.buyButtonClicked.add(this.onBuyClick);
    }

    private function addChildren():void {
        addChild(makeModalBackground(280, 4 * 60));
        addChild(this.closeButton);
        addChild(this.buyButton);
    }

    private function close():void {
        parent.removeChild(this);
        ConfirmBuyModal.free = true;
        this.open = false;
    }

    private function makeNavigator(_arg_1:String):Sprite {
        var _local2:Sprite = UIAssetsHelper.createLeftNevigatorIcon(_arg_1);
        _local2.addEventListener("click", this.onClick, false, 0, true);
        return _local2;
    }

    public function onBuyClick(_arg_1:MouseEvent):void {
        this.owner_.quantity_ = this.quantity_;
        this.buyItem.dispatch(this.owner_);
        this.close();
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        ConfirmBuyModal.free = true;
        this.open = false;
        this.leftNavSprite.removeEventListener("click", this.onClick);
        this.rightNavSprite.removeEventListener("click", this.onClick);
    }

    private function onClick(_arg_1:MouseEvent):void {
        var _local3:* = _arg_1.currentTarget;
        switch (_local3) {
            case this.rightNavSprite:
                if (this.quantity_ < this.availableInventoryNumber) {
                    this.quantity_ = this.quantity_ + 1;
                    break;
                }
                break;
            case this.leftNavSprite:
                if (this.quantity_ > 1) {
                    this.quantity_ = this.quantity_ - 1;
                    break;
                }
        }
        this.refreshNavDisable();
        var _local2:int = this.owner_.price_ * this.quantity_;
        this.buyButton.setPrice(_local2, this.owner_.currency_);
        this.quantityInputText.setText(this.quantity_.toString());
    }
}
}
