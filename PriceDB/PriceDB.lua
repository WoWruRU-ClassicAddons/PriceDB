SELLDB_goodFrames = {
	["ContainerFrameX"] = false,		---! Bags
	["BankFrame"] = true,			---! Bank
	["LootFrame"] = true,			---! Loot
	["PaperDollFrame"] = true,		---! Equip
	["InspectPaperDollFrame"] = true,	---! Inspect
	["TradePlayerItemX"] = true,		---! TradeOut
	["TradeRecipientItemX"] = true,		---! TradeIn
	["MailItemX"] = true,			---! MailGetList
	["OpenMailFrame"] = true,		---! MailGet
	["SendMailFrame"] = true,		---! MailSend
	["BrowseButtonX"] = true,		---! AuctionList
	["BidButtonX"] = true,			---! AuctionRate
	["AuctionFrameAuctions"] = true,	---! AuctionSell
	["AuctionsButtonX"] = true,		---! AuctionSellList
	["TradeSkillDetailScrollChildFrame"] = true,	---! Craft
---!	["ClassTrainerDetailScrollChildFrame"] = true,	---! CraftTrain
	["TextAlphaDependentFrame"] = true,		---! QuestGet
	["QuestProgressScrollChildFrame"] = true,	---! QuestProgress
	["QuestRewardScrollChildFrame"] = true,		---! QuestReward
	["QuestLogDetailScrollChildFrame"] = true,	---! QuestLog
	["EQLX_QuestLogDetailScrollChildFrame"] = true,	---! QuestLog_EQL3
};

function SellValue_OnHide()
	this = this:GetParent();
	return GameTooltip_ClearMoney();
end

function SellValue_OnShow()
	local function SetTooltipMoney(frame, money)
		frame:AddLine(SALE_PRICE_COLON, 0.55, 0.55, 0.55);
		local lastLines = getglobal("GameTooltipTextLeft"..frame:NumLines());
		local frameWidth = lastLines:GetWidth()+9;
		local moneyFrame = GameTooltipMoneyFrame;
		moneyFrame:SetPoint("LEFT", lastLines, "RIGHT", 2, 0);
		moneyFrame:Show();
		MoneyFrame_Update(moneyFrame:GetName(), money);
		frame:SetHeight(moneyFrame:GetHeight()+frame:GetHeight());
		frame:SetMinimumWidth(moneyFrame:GetWidth()+frameWidth-20);
		if (frame:GetWidth() < moneyFrame:GetWidth()+frameWidth) then
			frame:SetWidth(moneyFrame:GetWidth()+frameWidth);
		end
	end
	local function GetMouseFocusParent()
		return GetMouseFocus():GetParent();
	end
	local pcallOK, parentFrame = pcall(GetMouseFocusParent);
	if parentFrame and pcallOK then
		local showMoney = SELLDB_goodFrames[string.gsub(parentFrame:GetName(), "%d+", "X")];
  		if (showMoney or (showMoney == not not MerchantFrame:IsVisible())) and not InRepairMode() then
 			if GameTooltipTextLeft1 then
				local itemName = GameTooltipTextLeft1:GetText();
				local itemShortName = SellValue_ShortenItemName(itemName);
				local price = nil;
				if SELLDB[itemShortName] then
					price = SELLDB[itemShortName];
				end
				if price then
					SetTooltipMoney(GameTooltip, price);
				end
			end
		end
	end
end

function SellValue_ShortenItemName(itemName)
	local ofPos = string.find(itemName, SELLDB_MARK);
	if ofPos then
		for i = 1, table.getn(SELLDB_LIST) do
			if string.find(itemName, SELLDB_LIST[i]) then
				return string.sub(itemName, 1, ofPos-1);
			end
		end
	end
	return itemName;
end