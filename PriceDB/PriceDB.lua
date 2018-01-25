PriceDB = CreateFrame("Frame", nil, UIParent)
PriceDB:RegisterEvent("ADDON_LOADED")

PriceDB.sellvalue = CreateFrame("Frame" , "PriceDBGameTooltip", GameTooltip)

if GetLocale() == "ruRU" then
	PriceDB_Sell = "Продажа"
	PriceDB_Buy = "Покупка"
else
	PriceDB_Sell = "Sell"
	PriceDB_Buy = "Buy"
end

PriceDB.sellvalue:SetScript("OnHide", function()
    GameTooltip.itemLink = nil
    GameTooltip.itemCount = nil
end)

PriceDB.sellvalue:SetScript("OnShow", function()
    if GameTooltip.itemLink then
		local _, _, itemID = string.find(GameTooltip.itemLink, "item:(%d+):%d+:%d+:%d+")
		local itemID = tonumber(itemID)
		local count = GameTooltip.itemCount or 1
		
		if SellData[itemID] then
			local _, _, sell, buy = strfind(SellData[itemID], "(.*),(.*)")
			sell = tonumber(sell)
			buy = tonumber(buy)
			
			if not MerchantFrame:IsShown() then
				if sell > 0 then PriceDB:SetTooltipMoney(GameTooltip, sell*count) end
			end
			if IsShiftKeyDown() then
				GameTooltip:AddLine(" ")
				
				if count > 1 then
					GameTooltip:AddDoubleLine(PriceDB_Sell..":", PriceDB:CreateGoldString(sell).."|cff555555  //  "..PriceDB:CreateGoldString(sell*count), 1, 1, 1)
				else
					GameTooltip:AddDoubleLine(PriceDB_Sell..":", PriceDB:CreateGoldString(sell*count), 1, 1, 1)
				end
				
				if count > 1 then
					GameTooltip:AddDoubleLine(PriceDB_Buy..":", PriceDB:CreateGoldString(buy).."|cff555555  //  "..PriceDB:CreateGoldString(buy*count), 1, 1, 1)
				else
					GameTooltip:AddDoubleLine(PriceDB_Buy..":", PriceDB:CreateGoldString(buy), 1, 1, 1)
				end
			end
			GameTooltip:Show()
		end
	end
end)

function PriceDB:SetTooltipMoney(frame, money)
	frame:AddLine(SALE_PRICE_COLON.." ", 1.0, 1.0, 1.0)
	local numLines = frame:NumLines()
	local moneyFrame = getglobal(frame:GetName().."MoneyFrame")
	moneyFrame:SetPoint("LEFT", frame:GetName().."TextLeft"..numLines, "RIGHT", 4, 0)
	moneyFrame:Show()
	MoneyFrame_Update(moneyFrame:GetName(), money)
	frame:SetMinimumWidth(moneyFrame:GetWidth())
end

function PriceDB:CreateGoldString(money)
	local gold = floor(money/ 100 / 100)
	local silver = floor(mod((money/100),100))
	local copper = floor(mod(money,100))
	
	local string = ""
	if gold > 0 then string = string .. "|cffffffff" .. gold .. "|cffffd700g" end
	if silver > 0 then string = string .. "|cffffffff " .. silver .. "|cffc7c7cfs" end
	string = string .. "|cffffffff " .. copper .. "|cffeda55fc"
	
	return string
end

local function GetItemLinkByName(name)
	for itemID = 1, 25818 do
		local itemName, hyperLink, itemQuality = GetItemInfo(itemID)
		if (itemName and itemName == name) then
			local _, _, _, hex = GetItemQualityColor(tonumber(itemQuality))
			return hex.. "|H"..hyperLink.."|h["..itemName.."]|h|r"
		end
	end
end

local PriceDBHookSetBagItem = GameTooltip.SetBagItem
function GameTooltip.SetBagItem(PriceDB, container, slot)
    GameTooltip.itemLink = GetContainerItemLink(container, slot)
    _, GameTooltip.itemCount = GetContainerItemInfo(container, slot)
    return PriceDBHookSetBagItem(PriceDB, container, slot)
end

local PriceDBHookSetQuestLogItem = GameTooltip.SetQuestLogItem
function GameTooltip.SetQuestLogItem(PriceDB, itemType, index)
    GameTooltip.itemLink = GetQuestLogItemLink(itemType, index)
    if not GameTooltip.itemLink then return end
    return PriceDBHookSetQuestLogItem(PriceDB, itemType, index)
end

local PriceDBHookSetQuestItem = GameTooltip.SetQuestItem
function GameTooltip.SetQuestItem(PriceDB, itemType, index)
    GameTooltip.itemLink = GetQuestItemLink(itemType, index)
    return PriceDBHookSetQuestItem(PriceDB, itemType, index)
end

local PriceDBHookSetLootItem = GameTooltip.SetLootItem
function GameTooltip.SetLootItem(PriceDB, slot)
    GameTooltip.itemLink = GetLootSlotLink(slot)
    PriceDBHookSetLootItem(PriceDB, slot)
end

local PriceDBHookSetInboxItem = GameTooltip.SetInboxItem
function GameTooltip.SetInboxItem(PriceDB, mailID, attachmentIndex)
    local itemName, itemTexture, inboxItemCount, inboxItemQuality = GetInboxItem(mailID)
    GameTooltip.itemLink = GetItemLinkByName(itemName)
    return PriceDBHookSetInboxItem(PriceDB, mailID, attachmentIndex)
end

local PriceDBHookSetInventoryItem = GameTooltip.SetInventoryItem
function GameTooltip.SetInventoryItem(PriceDB, unit, slot)
    GameTooltip.itemLink = GetInventoryItemLink(unit, slot)
    return PriceDBHookSetInventoryItem(PriceDB, unit, slot)
end

local PriceDBHookSetLootRollItem = GameTooltip.SetLootRollItem
function GameTooltip.SetLootRollItem(PriceDB, id)
    GameTooltip.itemLink = GetLootRollItemLink(id)
    return PriceDBHookSetLootRollItem(PriceDB, id)
end

local PriceDBHookSetLootRollItem = GameTooltip.SetLootRollItem
function GameTooltip.SetLootRollItem(PriceDB, id)
    GameTooltip.itemLink = GetLootRollItemLink(id)
    return PriceDBHookSetLootRollItem(PriceDB, id)
end

local PriceDBHookSetMerchantItem = GameTooltip.SetMerchantItem
function GameTooltip.SetMerchantItem(PriceDB, merchantIndex)
    GameTooltip.itemLink = GetMerchantItemLink(merchantIndex)
    return PriceDBHookSetMerchantItem(PriceDB, merchantIndex)
end

local PriceDBHookSetCraftItem = GameTooltip.SetCraftItem
function GameTooltip.SetCraftItem(PriceDB, skill, slot)
    GameTooltip.itemLink = GetCraftReagentItemLink(skill, slot)
    return PriceDBHookSetCraftItem(PriceDB, skill, slot)
end

local PriceDBHookSetCraftSpell = GameTooltip.SetCraftSpell
function GameTooltip.SetCraftSpell(PriceDB, slot)
    GameTooltip.itemLink = GetCraftItemLink(slot)
    return PriceDBHookSetCraftSpell(PriceDB, slot)
end

local PriceDBHookSetTradeSkillItem = GameTooltip.SetTradeSkillItem
function GameTooltip.SetTradeSkillItem(PriceDB, skillIndex, reagentIndex)
    if reagentIndex then
		GameTooltip.itemLink = GetTradeSkillReagentItemLink(skillIndex, reagentIndex)
	else
		GameTooltip.itemLink = GetTradeSkillItemLink(skillIndex)
	end
    return PriceDBHookSetTradeSkillItem(PriceDB, skillIndex, reagentIndex)
end

local PriceDBHookSetAuctionSellItem = GameTooltip.SetAuctionSellItem
function GameTooltip.SetAuctionSellItem(PriceDB)
    local itemName, _, itemCount = GetAuctionSellItemInfo()
    GameTooltip.itemCount = itemCount
    GameTooltip.itemLink = GetItemLinkByName(itemName)
    return PriceDBHookSetAuctionSellItem(PriceDB)
end

local PriceDBHookSetTradePlayerItem = GameTooltip.SetTradePlayerItem
function GameTooltip.SetTradePlayerItem(PriceDB, index)
    GameTooltip.itemLink = GetTradePlayerItemLink(index)
    return PriceDBHookSetTradePlayerItem(PriceDB, index)
end

local PriceDBHookSetTradeTargetItem = GameTooltip.SetTradeTargetItem
function GameTooltip.SetTradeTargetItem(PriceDB, index)
    GameTooltip.itemLink = GetTradeTargetItemLink(index)
    return PriceDBHookSetTradeTargetItem(PriceDB, index)
end