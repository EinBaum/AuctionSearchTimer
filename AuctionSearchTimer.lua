
B_AST_OldText = nil
B_AST_QueryAuctionItems_Old = nil
B_AST_TimerFrame = nil
B_AST_TimeLeft = nil
B_AST_LastTime = nil

function B_AST_QueryAuctionItems_New(a,b,c,d,e,f,g,h,i,j)
	if (CanSendAuctionQuery()) then
		B_AST_StartTimer()
	end
	B_AST_QueryAuctionItems_Old(a,b,c,d,e,f,g,h,i,j)
end

function B_AST_StartTimer()
	B_AST_TimeLeft = 5
	B_AST_LastTime = GetTime()
	B_AST_Frame:SetScript("OnUpdate", B_AST_OnUpdate)
end
function B_AST_StopTimer()
	B_AST_Frame:SetScript("OnUpdate", nil)
	BrowseSearchButton:SetText(B_AST_OldText)
end


function B_AST_OnLoad()
	this:RegisterEvent("ADDON_LOADED")
	this:RegisterEvent("AUCTION_HOUSE_SHOW")
end

function B_AST_OnEvent()
	if (event == "ADDON_LOADED") then
		if (string.lower(arg1) == "auctionsearchtimer") then
			DEFAULT_CHAT_FRAME:AddMessage("AuctionSearchTimer 1.0 loaded.", 0.37, 1, 0)
		end
	elseif (event == "AUCTION_HOUSE_SHOW" and B_AST_QueryAuctionItems_Old == nil) then
	
		B_AST_QueryAuctionItems_Old = QueryAuctionItems
		QueryAuctionItems = B_AST_QueryAuctionItems_New
		
		B_AST_OldText = BrowseSearchButton:GetText()
	end
end

function B_AST_OnUpdate()
	if (CanSendAuctionQuery()) then
		B_AST_StopTimer()
	else
		local t = GetTime()
		local td = t - B_AST_LastTime
		B_AST_TimeLeft = B_AST_TimeLeft - td
		
		if B_AST_TimeLeft < 0 then
			B_AST_TimeLeft = 0
		end

		local text = math.floor(B_AST_TimeLeft * 10) / 10
		if string.len(text) == 1 then
			text = text .. ".0"
		end
		BrowseSearchButton:SetText(text)
		
		B_AST_LastTime = t
	end
end