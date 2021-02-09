local Engine = {
	Prefix = ";",
}

wait()

local GUI = game:GetObjects("rbxassetid://6370630582")[1]
local Main = GUI.Main
local Assets = GUI.Assets
local CMDsF = GUI.CMDS.Border.Frame.ScrollingFrame
local Notification = GUI.Notification
local CommandsGui = GUI.CMDS

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local mouse = Players.LocalPlayer:GetMouse()

local Prefix = Engine.Prefix
local Cmdbar = Main.Box
local CMDs = {}
local cmds = {}
local customAlias = {}
local DEBUG = false

function Startup()
	Main.Position = UDim2.new(0.5, -75, 1.5, -105)
	Notification.Position = UDim2.new(-1, -75, 1.029, -105)
	CommandsGui.Position = UDim2.new(0.694, -75, 10, -105)
	Cmdbar.Text = ""
	mouse.Move:Connect(checkTT)
end

function SmoothDrag(object)
	local a=game:GetService("UserInputService")function drag(b)dragToggle=nil dragSpeed=0.23 dragInput=nil dragStart=nil dragPos=nil function updateInput(a)Delta=a.Position-dragStart Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+Delta.X,startPos.Y.Scale,startPos.Y.Offset+Delta.Y)game:GetService("TweenService"):Create(b,TweenInfo.new(0.25),{Position=Position}):Play()end b.InputBegan:Connect(function(c)if(c.UserInputType==Enum.UserInputType.MouseButton1 or c.UserInputType==Enum.UserInputType.Touch)and a:GetFocusedTextBox()==nil then dragToggle=true dragStart=c.Position startPos=b.Position c.Changed:Connect(function()if c.UserInputState==Enum.UserInputState.End then dragToggle=false end end)end end)b.InputChanged:Connect(function(a)if a.UserInputType==Enum.UserInputType.MouseMovement or a.UserInputType==Enum.UserInputType.Touch then dragInput=a end end)game:GetService("UserInputService").InputChanged:Connect(function(a)if a==dragInput and dragToggle then updateInput(a)end end)end drag(object)
end

function ParentGui(Gui)
	Gui.Name = HttpService:GenerateGUID(false):gsub('-', ''):sub(1, math.random(25, 30))
	Gui.Parent = CoreGui
end

function CaptureCmdBar()
	Cmdbar:CaptureFocus()
	spawn(function()
		repeat Cmdbar.Text = '' until Cmdbar.Text == ''
	end)
	spawn(function()
		CmdBarStatus(true)
	end)
end

function CmdListStatus(bool)
	local Gui_Pos = {
		Shown = UDim2.new(0.694, -75, 0.656, -105),
		Hidden = UDim2.new(0.694, -75, 10, -105),
	}
	if bool == true then
		CommandsGui:TweenPosition(Gui_Pos.Shown, "InOut", "Sine", 0.3, true, nil)
	else
		CommandsGui:TweenPosition(Gui_Pos.Hidden, "InOut", "Sine", 0.5, true, nil)
	end
end

function CmdBarStatus(bool)
	local GuiPositions = {
		Shown = UDim2.new(0.5, -75, 0.997, -105),
		Hidden = UDim2.new(0.5, -75, 1.5, -105),
	}
	if bool == true then
		Main:TweenPosition(GuiPositions.Shown, "InOut", "Sine", 0.4, true, nil)
	else
		Main:TweenPosition(GuiPositions.Hidden, "InOut", "Sine", 0.4, true, nil)
	end
end

function notify(title, desc, length)
	local Top = nil
	local Bottom = nil
	local Time = nil
	local Notif_Pos = {
		Shown = UDim2.new(0.079, -75, 1.029, -105),
		Hidden = UDim2.new(-1, -75, 1.029, -105),
	}
	if title == "" then
		Top = "Notification"
	else
		Top = title
	end
	if desc == "" then
		Bottom = "Description"
	else
		Bottom = desc
	end
	if length ~= nil then
		Time = length
	else
		Time = 5
	end
	wait()
	Notification.Title.Text = Top
	Notification.Border.Frame.Description.Text = Bottom
	Notification:TweenPosition(Notif_Pos.Shown, "InOut", "Sine", 0.4, true, nil)
	wait(Time)
	Notification:TweenPosition(Notif_Pos.Hidden, "InOut", "Sine", 0.4, true, nil)
end

function getText(object)
	if object ~= nil then
		if object:FindFirstChild('Desc') ~= nil then
			return {object.Desc.Value, object:FindFirstChild('Title')}
		elseif object.Parent:FindFirstChild('Desc') ~= nil then
			return {object.Parent.Desc.Value, object.Parent:FindFirstChild('Title')}
		end
	end
	return nil
end

function checkTT()
	local t
	
	local Tooltip = GUI.Tooltip
	local Tooltip_Title = GUI.Tooltip.Title
	local Tooltip_Desc = GUI.Tooltip.Border.Frame.Description
	
	local guisAtPosition = CoreGui:GetGuiObjectsAtPosition(mouse.X, mouse.Y)

	for _, guib in pairs(guisAtPosition) do
		if guib.Parent == CMDsF then
			t = guib
		end
	end

	if t ~= nil then
		local gt = true
		if gt ~= nil then
			local x = mouse.X
			local y = mouse.Y
			local xP
			local yP
			if mouse.X > 200 then
				xP = x - -3
				-- used to be x - 1
			else
				xP = x + 5
			end
			if mouse.Y > (mouse.ViewSizeY-96) then
				yP = y - 20
			else
				yP = y
			end
			Tooltip.Position = UDim2.new(0, xP, 0, yP)
			Tooltip_Desc.Text = t.Desc.Value
			if t.Title ~= nil then
				Tooltip_Title.Text = t.Title.Value
			else
				Tooltip_Title.Text = ''
			end
			Tooltip.Visible = true
		else
			Tooltip.Visible = false
		end
	else
		Tooltip.Visible = false
	end
end

function getstring(begin)
	local start = begin-1
	local AA = '' for i,v in pairs(cargs) do
		if i > start then
			if AA ~= '' then
				AA = AA .. ' ' .. v
			else
				AA = AA .. v
			end
		end
	end
	return AA
end

function FindInTable(tbl,val)
	if tbl == nil then return false end
	for _,v in pairs(tbl) do
		if v == val then return true end
	end 
	return false
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

function GetInTable(Table, Name)
	for i = 1, #Table do
		if Table[i] == Name then
			return i
		end
	end
	return false
end

function getstring(begin)
	local start = begin-1
	local AA = '' for i,v in pairs(cargs) do
		if i > start then
			if AA ~= '' then
				AA = AA .. ' ' .. v
			else
				AA = AA .. v
			end
		end
	end
	return AA
end

function findCmd(cmd_name)
	for i,v in pairs(cmds)do
		if v.NAME:lower()==cmd_name:lower() or FindInTable(v.ALIAS,cmd_name:lower()) then
			return v
		end
	end
	return customAlias[cmd_name:lower()]
end

function splitString(str,delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str,"[^"..delim.."]+") do
		table.insert(broken,w)
	end
	return broken
end

local cmdHistory = {}
local lastCmds = {}
local historyCount = 0
local split=" "
local lastBreakTime = 0
function execCmd(cmdStr,speaker,store)
	cmdStr = cmdStr:gsub("%s+$","")
	spawn(function()
		local rawCmdStr = cmdStr
		cmdStr = string.gsub(cmdStr,"\\\\","%%BackSlash%%")
		local commandsToRun = splitString(cmdStr,"\\")
		for i,v in pairs(commandsToRun) do
			v = string.gsub(v,"%%BackSlash%%","\\")
			local x,y,num = v:find("^(%d+)%^")
			local cmdDelay = 0
			local infTimes = false
			if num then
				v = v:sub(y+1)
				local x,y,del = v:find("^([%d%.]+)%^")
				if del then
					v = v:sub(y+1)
					cmdDelay = tonumber(del) or 0
				end
			else
				local x,y = v:find("^inf%^")
				if x then
					infTimes = true
					v = v:sub(y+1)
					local x,y,del = v:find("^([%d%.]+)%^")
					if del then
						v = v:sub(y+1)
						del = tonumber(del) or 1
						cmdDelay = (del > 0 and del or 1)
					else
						cmdDelay = 1
					end
				end
			end
			num = tonumber(num or 1)

			if v:sub(1,1) == "!" then
				local chunks = splitString(v:sub(2),split)
				if chunks[1] and lastCmds[chunks[1]] then v = lastCmds[chunks[1]] end
			end

			local args = splitString(v,split)
			local cmdName = args[1]
			local cmd = findCmd(cmdName)
			if cmd then
				table.remove(args,1)
				cargs = args
				if not speaker then speaker = Players.LocalPlayer end
				if store then
					if speaker == Players.LocalPlayer then
						if cmdHistory[1] ~= rawCmdStr and rawCmdStr:sub(1,11) ~= 'lastcommand' and rawCmdStr:sub(1,7) ~= 'lastcmd' then
							table.insert(cmdHistory,1,rawCmdStr)
						end
					end
					if #cmdHistory > 30 then table.remove(cmdHistory) end

					lastCmds[cmdName] = v
				end
				local cmdStartTime = tick()
				if infTimes then
					while lastBreakTime < cmdStartTime do
						local success,err = pcall(cmd.FUNC,args, speaker)
						if not success and DEBUG then
							warn("Command Error:", cmdName, err)
						end
						wait(cmdDelay)
					end
				else
					for rep = 1,num do
						if lastBreakTime > cmdStartTime then break end
						local success,err = pcall(function()
							cmd.FUNC(args, speaker)
						end)
						if not success and DEBUG then
							warn("Command Error:", cmdName, err)
						end
						if cmdDelay ~= 0 then wait(cmdDelay) end
					end
				end
			end
		end
	end)
end	

function addcmd(name,alias,func,plgn)
	cmds[#cmds+1]=
		{
			NAME=name;
			ALIAS=alias or {};
			FUNC=func;
			PLUGIN=plgn;
		}
end

local SpecialPlayerCases = {
	["all"] = function(speaker)return game.Players:GetPlayers() end,
	["others"] = function(speaker)
		local plrs = {}
		for i,v in pairs(game.Players:GetPlayers()) do
			if v ~= speaker then
				table.insert(plrs,v)
			end
		end
		return plrs
	end,
	["me"] = function(speaker)return {speaker} end,
	["#(%d+)"] = function(speaker,args,currentList)
		local returns = {}
		local randAmount = tonumber(args[1])
		local players = {unpack(currentList)}
		for i = 1,randAmount do
			if #players == 0 then break end
			local randIndex = math.random(1,#players)
			table.insert(returns,players[randIndex])
			table.remove(players,randIndex)
		end
		return returns
	end,
	["random"] = function(speaker,args,currentList)
		local players = currentList
		return {players[math.random(1,#players)]}
	end,
	["%%(.+)"] = function(speaker,args)
		local returns = {}
		local team = args[1]
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Team and string.sub(string.lower(plr.Team.Name),1,#team) == string.lower(team) then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["allies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["enemies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["team"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonteam"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["friends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonfriends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if not plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["guests"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Guest then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["bacons"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Character:FindFirstChild('Pal Hair') or plr.Character:FindFirstChild('Kate Hair') then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["age(%d+)"] = function(speaker,args)
		local returns = {}
		local age = tonumber(args[1])
		if not age == nil then return end
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.AccountAge <= age then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nearest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local lowest = math.huge
		local NearestPlayer = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance < lowest then
					lowest = distance
					NearestPlayer = {plr}
				end
			end
		end
		return NearestPlayer
	end,
	["farthest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local highest = 0
		local Farthest = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance > highest then
					highest = distance
					Farthest = {plr}
				end
			end
		end
		return Farthest
	end,
	["group(%d+)"] = function(speaker,args)
		local returns = {}
		local groupID = tonumber(args[1])
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr:IsInGroup(groupID) then  
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["alive"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["dead"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if (not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid")) or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["rad(%d+)"] = function(speaker,args)
		local returns = {}
		local radius = tonumber(args[1])
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Character and getRoot(plr.Character) then
				local magnitude = (getRoot(plr.Character).Position-getRoot(speakerChar).Position).magnitude
				if magnitude <= radius then table.insert(returns,plr) end
			end
		end
		return returns
	end
}

function toTokens(str)
	local tokens = {}
	for op,name in string.gmatch(str,"([+-])([^+-]+)") do
		table.insert(tokens,{Operator = op,Name = name})
	end
	return tokens
end

function onlyIncludeInTable(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function removeTableMatches(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function getPlayersByName(name)
	local found = {}
	for i,v in pairs(game.Players:GetChildren()) do
		if string.sub(string.lower(v.Name),1,#name) == string.lower(name) then
			table.insert(found,v)
		end
	end
	return found
end

function getPlayer(list,speaker)
	if list == nil then return {speaker.Name} end
	local nameList = splitString(list,",")

	local foundList = {}

	for _,name in pairs(nameList) do
		if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
		local tokens = toTokens(name)
		local initialPlayers = game.Players:GetPlayers()

		for i,v in pairs(tokens) do
			if v.Operator == "+" then
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = onlyIncludeInTable(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent))
				end
			else
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = removeTableMatches(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent))
				end
			end
		end

		for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
	end

	local foundNames = {}
	for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end

	return foundNames
end

function autoComplete(str,curText)
	local endingChar = {"[", "/", "(", " "}
	local stop = 0
	for i=1,#str do
		local c = str:sub(i,i)
		if table.find(endingChar, c) then
			stop = i
			break
		end
	end
	curText = curText or Cmdbar.Text
	local subPos = 0
	local pos = 1
	local findRes = string.find(curText,"\\",pos)
	while findRes do
		subPos = findRes
		pos = findRes+1
		findRes = string.find(curText,"\\",pos)
	end
	if curText:sub(subPos+1,subPos+1) == "!" then subPos = subPos + 1 end
	Cmdbar.Text = curText:sub(1,subPos) .. str:sub(1, stop - 1)..' '
	wait()
	Cmdbar.Text = Cmdbar.Text:gsub( '\t', '' )
	Cmdbar.CursorPosition = #Cmdbar.Text+1
end

function Index()
	local InputText = string.upper(Cmdbar.Text)
	for _,button in pairs(CMDsF:GetChildren())do
		if button:IsA("TextButton")then
			if InputText == "" or string.find(string.upper(button.Name), InputText) ~= nil then
				button.Visible = true
			else
				button.Visible = false
			end
		end
	end
end
Cmdbar.Changed:Connect(Index)
CMDsF.CanvasSize = UDim2.new(0, 0, 0, CMDsF.UIListLayout.AbsoluteContentSize.Y)
CMDsF.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	CMDsF.CanvasSize = UDim2.new(0, 0, 0, CMDsF.UIListLayout.AbsoluteContentSize.Y)
end)

function addcmdtext(text,name,desc)
	local newcommand = Assets.CommandTemplate:Clone()
	pcall(function()
		local tooltipText = tostring(text)
		local tooltipDesc = tostring(desc)
		if desc and desc ~= "" then
			local title = Instance.new("StringValue")
			title.Name = "Title"
			title.Parent = newcommand
			title.Value = tooltipText
			local desc = Instance.new("StringValue")
			desc.Name = "Desc"
			desc.Parent = newcommand
			desc.Value = tooltipDesc
		end
	end)
	newcommand.Label.Text = text
	newcommand.Name = ("CMD_" .. name)
	newcommand.Parent = CMDsF
	newcommand.Visible = true
	newcommand.MouseButton1Down:Connect(function()
		CaptureCmdBar()
		wait()
		autoComplete(newcommand.Label.Text)
	end)
end

Players.LocalPlayer.Chatted:Connect(function(message)
	local message = string.lower(message)
	local msgText = message:gsub("^"..'%'..Prefix,"")
	execCmd(msgText, Players.LocalPlayer,true)
end)

mouse.KeyDown:Connect(function(key)
	if (key == Prefix) then
		CaptureCmdBar()
	end
end)

Cmdbar.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		pcall(function()
			CmdBarStatus(false)
		end)
		local cmdbarText = Cmdbar.Text:gsub("^"..'%'..Prefix,"")
		execCmd(cmdbarText,Players.LocalPlayer,true)
	end
	wait()
	if not Cmdbar:IsFocused() then
		Cmdbar.Text = ""
	end
end)

local LibCmds = {}

local newCmd = function(name, aliases, title, description, func)
	addcmdtext(title, name, description)

	local id = #cmds + 1

	cmds[id] = {
		NAME = name,
		ALIAS = aliases or {},
		FUNC = func
	}

	table.insert(LibCmds, {
		id = id,
		desc = description,
		title = title
	})
end

pcall(function()
	Startup()
	ParentGui(GUI)
	SmoothDrag(CommandsGui)
	CommandsGui.Close.MouseButton1Down:Connect(function()
		CmdListStatus(false)
	end)
end)

newCmd('commands', {"cmds"}, "commands / cmds", "List of Commands", function(args, speaker)
	CmdListStatus(true)
end)

newCmd('prefix', {}, "prefix", "Change the prefix", function(args, speaker)
	local pref = args[1]
	if typeof(pref) == "string" and #pref <= 2 then
        notify("", "Prefix was succesfully changed to: " .. pref)
		Engine.Prefix = pref
    elseif #prefix > 2 then
        notify("", "Prefix cannot be longer than 2 characters.")
    end
end)

newCmd('currentprefix', {}, "currentprefix", "Notify current prefix", function(args, speaker)
	notify("", "Current prefix is " .. Engine.Prefix)
end)

notify("", "Prefix is " .. Engine.Prefix)

Engine.GUI = GUI
Engine.notify = notify
Engine.getPlr = getPlayer
Engine.newCmd = newCmd

return Engine
