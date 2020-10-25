package io.decagames.rotmg.nexusShop {
import com.company.assembleegameclient.objects.SellableObject;
import com.company.assembleegameclient.util.FilterUtil;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import io.decagames.rotmg.shop.ShopBuyButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.labels.UILabel;
import io.decagames.rotmg.ui.popups.modal.ModalPopup;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.spinner.FixedNumbersSpinner;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.util.components.ItemWithTooltip;

import org.osflash.signals.Signal;

public class NexusShopPopupView extends ModalPopup {

    public static const TITLE:String = "Purchase";

    public static const WIDTH:int = 300;

    public static const HEIGHT:int = 170;

    public function NexusShopPopupView(_arg_1:Signal, _arg_2:SellableObject, _arg_3:Number, _arg_4:int) {
        super(5 * 60, 170, "Purchase", DefaultLabelFormat.defaultSmallPopupTitle, new Rectangle(0, 0, 525, 230), 0);
        this.buyItem = _arg_1;
        this.owner_ = _arg_2;
        this.buttonWidth = _arg_3;
        this.availableInventoryNumber = _arg_4;
        this.descriptionLabel = new UILabel();
        DefaultLabelFormat.infoTooltipText(this.descriptionLabel, 0x999999);
        this.descriptionLabel.text = "Are you sure that you want to buy this item?";
        addChild(this.descriptionLabel);
        this.descriptionLabel.x = 150 - this.descriptionLabel.width / 2;
        this.descriptionLabel.y = 10;
        this.addItemContainer();
        this.addBuyButton();
        this.filters = FilterUtil.getStandardDropShadowFilter();
    }
    public var buyItem:Signal;
    public var buttonWidth:int;
    public var descriptionLabel:UILabel;
    public var itemLabel:UILabel;
    public var buyButton:ShopBuyButton;
    public var spinner:FixedNumbersSpinner;
    private var availableInventoryNumber:int;
    private var owner_:SellableObject;
    private var nameText_:TextFieldDisplayConcrete;
    private var quantity_:int = 1;
    private var buySectionContainer:Sprite;
    private var buyButtonBackground:SliceScalingBitmap;

    public function get getBuyButton():ShopBuyButton {
        return this.buyButton;
    }

    public function get getBuyItem():Signal {
        return this.buyItem;
    }

    public function get getOwner():SellableObject {
        return this.owner_;
    }

    public function get getQuantity():int {
        return this.quantity_;
    }

    private function addItemContainer():void {
        var _local2:* = null;
        if (this.owner_.getSellableType() != -1) {
            _local2 = new ItemWithTooltip(this.owner_.getSellableType(), 80);
        }
        _local2.x = 150 - _local2.width / 2;
        _local2.y = 85 - _local2.height + 5;
        addChild(_local2);
        var _local1:String = this.owner_.soldObjectName();
        this.nameText_ = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff);
        this.nameText_.setBold(true);
        this.nameText_.setStringBuilder(new LineBuilder().setParams(_local1));
        this.nameText_.setAutoSize("center");
        addChild(this.nameText_);
        this.nameText_.x = 150 - this.nameText_.width / 2;
        this.nameText_.y = _local2.y + 55;
    }

    private function addBuyButton():void {
        var _local2:int = 0;
        this.buySectionContainer = new Sprite();
        this.buySectionContainer.alpha = 1;
        this.buyButton = new ShopBuyButton(this.owner_.price_, this.owner_.currency_);
        this.buyButton.showCampaignTooltip = true;
        this.buyButton.width = 95;
        this.buyButtonBackground = TextureParser.instance.getSliceScalingBitmap("UI", "buy_button_background", this.buyButton.width + 60);
        var _local1:Vector.<int> = new Vector.<int>();
        if (this.availableInventoryNumber != 0) {
            _local2 = 1;
            while (_local2 <= this.availableInventoryNumber) {
                _local1.push(_local2);
                _local2++;
            }
        } else {
            _local1.push(1);
            this.buyButton.disabled = true;
        }
        this.spinner = new FixedNumbersSpinner(TextureParser.instance.getSliceScalingBitmap("UI", "spinner_up_arrow"), 0, _local1, "x");
        this.buySectionContainer.addChild(this.buyButtonBackground);
        this.buySectionContainer.addChild(this.spinner);
        this.buySectionContainer.addChild(this.buyButton);
        this.buySectionContainer.x = 100;
        this.buySectionContainer.y = 125;
        this.buyButton.x = this.buyButtonBackground.width - this.buyButton.width - 6;
        this.buyButton.y = 4;
        this.spinner.y = -2;
        this.spinner.x = 32;
        addChild(this.buySectionContainer);
        this.buySectionContainer.x = Math.round((300 - this.buySectionContainer.width) / 2);
        this.spinner.upArrow.addEventListener("click", this.countUp);
        this.spinner.downArrow.addEventListener("click", this.countDown);
        this.refreshArrowDisable();
    }

    private function refreshArrowDisable():void {
        this.spinner.downArrow.alpha = this.quantity_ == 1 ? 0.5 : 1;
        if (this.availableInventoryNumber != 0) {
            this.spinner.upArrow.alpha = this.quantity_ == this.availableInventoryNumber ? 0.5 : 1;
        } else {
            this.spinner.upArrow.alpha = 0.5;
        }
    }

    private function refreshValues():void {
        this.refreshArrowDisable();
        this.buyButton.price = this.owner_.price_ * this.quantity_;
    }

    private function countUp(_arg_1:MouseEvent):void {
        if (this.quantity_ < this.availableInventoryNumber) {
            this.quantity_ = this.quantity_ + 1;
        }
        this.refreshValues();
    }

    private function countDown(_arg_1:MouseEvent):void {
        if (this.quantity_ > 1) {
            this.quantity_ = this.quantity_ - 1;
        }
        this.refreshValues();
    }
}
}
