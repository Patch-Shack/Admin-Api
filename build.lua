local CMD_API = {
	Prefix = ";",
	Keybind = "BackSlash",
	Interface = "WAITING FOR API INTERFACE"
}

local CMDS = {}
local _CMDCODEBAR = ("_CMDBAR")
local CMDBAR
local DEBOUNCE_CMD = false
local EVENTS = {}
local LocalPlayer = game:GetService("Players").LocalPlayer

CMD_API.Interface.Parent = game:GetService("CoreGui")

for i,base in pairs(CMD_API.Interface):GetDescendants() do
	if base:IsA("TextBox") then
		if base.Name == (_CMDCODEBAR) then
			CMDBAR = base
		end
	end
end

-------------------------------------------------------------
local NotificationFrame = Instance.new("TextLabel")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = CMD_API.Interface
NotificationFrame.AnchorPoint = Vector2.new(0.5, 0)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NotificationFrame.BackgroundTransparency = 1.000
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Position = UDim2.new(0.5, 0, -0.5, 0)
NotificationFrame.Size = UDim2.new(0.5, 0, 0, 20)
NotificationFrame.Visible = false
NotificationFrame.Font = Enum.Font.SourceSans
NotificationFrame.Text = ""
NotificationFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationFrame.TextSize = 20.000
NotificationFrame.TextStrokeTransparency = 0.800
NotificationFrame.TextWrapped = true
NotificationFrame.TextYAlignment = Enum.TextYAlignment.Top
-------------------------------------------------------------

local function notifyAbility(message, possibletimer)
	spawn(function()
		for i, v in pairs(CMD_API.Interface:GetChildren()) do
			if v.Name == "-NewNotification" then
				spawn(function()
					game:GetService("TweenService"):Create(v, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {TextTransparency = 1, TextStrokeTransparency = 1, Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
					wait(0.25)
					v:Destroy()
				end)
			end
		end
		
		local Notification = NotificationFrame:Clone()
		Notification.Name = "-NewNotification"
		Notification.Parent = CMD_API.Interface
		Notification.Visible = true 
		Notification.Text = tostring(message)
		game:GetService("TweenService"):Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0, TextStrokeTransparency = 0.8, Position = UDim2.new(0.5, 0, 0.0250000004, 0)}):Play()
		
		local NotificationRemove = false
		local Timer = 1
		
		if typeof(possibletimer) == "table" and typeof(possibletimer[1]) == "number" and typeof(possibletimer[2]) == "number" and typeof(possibletimer[3]) == "number" then
			spawn(function()
				
				for i = possibletimer[1], possibletimer[2], -possibletimer[3] do
					Timer = i
					
					if NotificationRemove == false and Timer > 0 then
						wait(possibletimer[3])
					else
						break
					end
				end
				if NotificationRemove == false then
					NotificationRemove = true 
				end
			end)
		end
		
		repeat
			if typeof(possibletimer) == "table" and typeof(possibletimer[1]) == "number" and typeof(possibletimer[2]) == "number" and typeof(possibletimer[3]) == "number" then
				Notification.Text = tostring(message) .. "\n(" .. Timer .. ")"
			else
				Notification.Text = tostring(message)
			end
			Notification.Size = UDim2.new(0.5, 0, 9e9, 0)
			Notification.Size = UDim2.new(0.5, 0, Notification.TextBounds.Y, 0)
			
			wait()
		until NotificationRemove == true or CMD_API.Interface.Parent ~= game:GetService("CoreGui") or Timer <= 0
		
		game:GetService("TweenService"):Create(Notification, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {TextTransparency = 1, TextStrokeTransparency = 1, Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
		wait(0.25)
		Notification:Destroy()
	end)
end

local function GetShortenedPlrFromName(name)
	name = string.lower(tostring(name))
	
	if not game:GetService("Players"):FindFirstChild("me") and name == "me" or game:GetService("Players"):FindFirstChild("me") and game:GetService("Players"):FindFirstChild("me").ClassName ~= "Player" and name == "me" then
		return {LocalPlayer}
	end
	if not game:GetService("Players"):FindFirstChild("all") and name == "all" or game:GetService("Players"):FindFirstChild("all") and game:GetService("Players"):FindFirstChild("all").ClassName ~= "Player" and name == "all" then
		return game:GetService("Players"):GetPlayers()
	end
	if not game:GetService("Players"):FindFirstChild("others") and name == "others" or game:GetService("Players"):FindFirstChild("others") and game:GetService("Players"):FindFirstChild("others").ClassName ~= "Player" and name == "others" then
		name = game:GetService("Players"):GetPlayers()
		for i, v in pairs(name) do
			if v == LocalPlayer then
				table.remove(name, i)
			end
		end
		return name
	end
	
	for i, v in pairs(game.Players:GetPlayers()) do
		if string.lower(string.sub(v.Name, 1, #name)) == name then
			return {v}
		end
	end
	
	return nil
end

local function AddCommand(cmdname, description, mainfunction, cmdargs)
	for i, v in pairs(CMDS) do
		if v[1] ~= nil and string.lower(v[1]) == string.lower(cmdname) then
			return nil
		end
	end
	
	if typeof(mainfunction) == "function" then
		if cmdargs then
			table.insert(CMDS, {cmdname, description, mainfunction, cmdargs})
		else
			table.insert(CMDS, {cmdname, description, mainfunction})
		end
	else
		return nil
	end
end

if not (typeof(CMD_API.Keybind) == "string" and Enum.KeyCode[CMD_API.Keybind]) then
	print("Error in command key, key has been set to Back Slash.")
	CMD_API.Keybind = "BackSlash"
end

EVENTS.InputBegan = game:GetService("UserInputService").InputBegan:Connect(function(Key)
	if Key.KeyCode.Name == CMD_API.Keybind then
		if DEBOUNCE_CMD == false then
			DEBOUNCE_CMD = true
			CMDBAR:CaptureFocus()
			wait(0.25)
			DEBOUNCE_CMD = false
		end
	end
end)

CMDBAR.FocusLost:Connect(function(EnterPressed)
	spawn(function()
		if DEBOUNCE_CMD == false then
			if EnterPressed then
				
				DEBOUNCE_CMD = true
				
				local getcmd = string.split(string.lower(CMDBAR.Text), " ")[1]
				local getargs = string.split(string.lower(CMDBAR.Text), " ")
				
				if string.sub(getcmd, 1, #CMD_API.Prefix) == CMD_API.Prefix then
					getcmd = string.sub(getcmd, #CMD_API.Prefix + 1, #getcmd)
				end
				
				for i, v in pairs(string.split(string.lower(CMD_API.Text), ",")) do
					if i ~= 1 then
						table.insert(getargs, v)
					end
				end
				for i, v in pairs(string.split(string.lower(CMD_API.Text), ", ")) do
					if i ~= 1 then
						table.insert(getargs, v)
					end
				end
				
				table.remove(getargs, 1)
				
				for i, v in pairs(CMDS) do
					if v[1] ~= nil and string.find(v[1], "/") then
						for i2, v2 in pairs( string.split(v[1], "/") ) do
							
							v2 = string.lower(v2)
							if getcmd == v2 then
								if v[4] ~= nil then
									spawn(function()
										v[3](unpack(getargs))
									end)
								else
									spawn(function()
										v[3]()
									end) 
								end
								break
							end
							
						end
					elseif v[1] ~= nil then
						v[1] = string.lower(v[1])
						if getcmd == v[1] then
							if v[4] ~= nil then
								spawn(function()
									v[3](unpack(getargs))
								end)
							else
								spawn(function()
									v[3]() 
								end)
							end
							break
						end
					end
				end
				
			end
			
			CMDBAR:ReleaseFocus()
			wait(0.25)
			CMDBAR.Text = ""
			DEBOUNCE_CMD = false
		end
	end)
end)

LocalPlayer.Chatted:Connect(function(msg)
	spawn(function()
		if DEBOUNCE_CMD == false and string.sub(msg, 1, #CMD_API.Prefix) == CMD_API.Prefix then
			
			DEBOUNCE_CMD = true
			
			local getcmd = string.split(string.lower(msg), " ")[1]
			local getargs = string.split(string.lower(msg), " ")
			
			if string.sub(getcmd, 1, #CMD_API.Prefix) == CMD_API.Prefix then
				getcmd = string.sub(getcmd, #CMD_API.Prefix + 1, #getcmd)
			end
			
			for i, v in pairs(string.split(string.lower(msg), ",")) do
				if i ~= 1 then
					table.insert(getargs, v)
				end
			end
			for i, v in pairs(string.split(string.lower(msg), ", ")) do
				if i ~= 1 then
					table.insert(getargs, v)
				end
			end
			
			table.remove(getargs, 1)
			
			for i, v in pairs(CMDS) do
				if v[1] ~= nil and string.find(v[1], "/") then
					for i2, v2 in pairs( string.split(v[1], "/") ) do
						
						v2 = string.lower(v2)
						if getcmd == v2 then
							if v[4] ~= nil then
								spawn(function()
									v[3](unpack(getargs))
								end)
							else
								spawn(function()
									v[3]() 
								end)
							end
							break
						end
						
					end
				elseif v[1] ~= nil then
					v[1] = string.lower(v[1])
					if getcmd == v[1] then
						if v[4] ~= nil then
							spawn(function()
								v[3](unpack(getargs))
							end)
						else
							spawn(function()
								v[3]() 
							end)
						end
						break
					end
				end
			end
			
			CMDBAR:ReleaseFocus()
			wait(0.25)
			CMDBAR.Text = ""
			DEBOUNCE_CMD = false
		end
	end)
end)

repeat
	wait()
until CMD_API.Interface.Parent ~= game:GetService("CoreGui")

for i, v in pairs(EVENTS) do
	pcall(function()
		v:Disconnect()
	end)
end

-->					BUILD				<--
CMD_API.ShortedName = GetShortenedPlrFromName
CMD_API.addcmd = AddCommand
CMD_API.notify = notifyAbility
--!			     END OF BUILD		    !--

return CMD_API
