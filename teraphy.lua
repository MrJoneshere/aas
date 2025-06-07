local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local PrefabsId = "rbxassetid://" .. ReGui.PrefabsId

--// Services
local InsertService = game:GetService("InsertService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MaterialService = game:GetService("MaterialService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local GameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local LocalPlayer = Players.LocalPlayer
local Rooms = workspace.Rooms

ReGui:Init({
	Prefabs = InsertService:LoadLocalAsset(PrefabsId)
})

local Window = ReGui:TabsWindow({
	Title = `{GameInfo.Name} | Depso`,
	Size = UDim2.new(0, 350, 0, 370),
	Position = UDim2.new(0.5, 0, 0, 70),
	CloseCallback = CloseCallback
}):Center()

local function Alert(Text: string)
    local ModalWindow = Window:PopupModal({
        Title = "Attention"
    })

    ModalWindow:Label({
        Text = Text,
        TextWrapped = true
    })
    ModalWindow:Separator()

    ModalWindow:Button({
        Text = "Okay",
        Callback = function()
            ModalWindow:Close()
        end,
    })
end

local DiscoveredItems = {}
local Doors = {}

local ItemsWhitelist = {
    "Sandwich",
    "Cheese",
    "Closet key",
    "Flower",
    "Explodsive ball",
	"Drink"
}

local Positions = {
	["Painting"] = CFrame.new(-397, 3, -11),
	["Lobby"] = CFrame.new(-277, 4, 0),
	["Office"] = CFrame.new(-484, 4, 11),
	["Basement"] = CFrame.new(-523, -16, -35),
	["Picnic"] = CFrame.new(-615, 4, 6),
	["Roof front"] = CFrame.new(-265, 30, 0),
	["Hallway end"] = CFrame.new(-486, 4, -1),
	["Attic"] = CFrame.new(-367, -28, -260)
}

local Overwrites = { --// Name, Properities
	["Explodsive ball"] = {
		Color = Color3.fromRGB(0, 255, 0)
	},
	["Closet key"] = {
		Color = Color3.fromRGB(245, 205, 48)
	},
	["Sandwich"] = {
        Parent = workspace:FindFirstChild("Picnic Basket"),
		[{
            Child = "Sandwich",
        }] = {
			[{
				Child = "Mesh",
			}] = {
            	MeshId = "http://www.roblox.com/asset/?id=12510164"
			}
        }
	},
    ["Broom stick"] = {
		[{
            Child = "Mesh",
        }] = {
            MeshId = "http://www.roblox.com/asset/?id=99865889"
        }
	},
    ["Cheese"] = {
		[{
            Child = "Mesh",
        }] = {
            MeshId = "http://www.roblox.com/asset/?id=1090700"
        }
	},
	["Drink"] = {
		[{
            Child = "Mesh",
        }] = {
            MeshId = "http://www.roblox.com/asset/?id=21382712"
        }
	},
	["OfficeTV"] = {
		[{
            Child = "Sound",
        }] = {
            SoundId = "rbxassetid://12221976"
        }
	},
	["OfficePC"] = {
		[{
            Child = "BlueScreen",
        }] = {}
	},
	["Cup"] = {
		Name = "Cup"
	},
}

local Spams = {
	["WeatherTv"] = "Weather Tv",
	["Radio"] = "Radio mute",
    ["AtticRadio"] = "Attic radio mute",
	["Curtain"] = "Curtains",
	["Warm"] = "Crouch",
	["OfficeTV"] = "Office TV",
	["OfficePC"] = "Office Computer",
	["Cup"] = "Cup plushie",
	["Opey"] = "Open Painting",
	["Op"] = "Open Booksheilf"
}

local ServerTab = Window:CreateTab({
	Name = "Server",
	Visible = true
})

--// Viewport frame
local PreviewHeader = ServerTab:TreeNode({
	Title = "Preview",
	Collapsed = false
})

local Viewport = PreviewHeader:Viewport({
	Size = UDim2.new(1, 0, 0, 120),
	Clone = true, --// Otherwise will parent
})

local ViewportConnection = RunService.RenderStepped:Connect(function(deltaTime)
	local ItemModel: Instance = Viewport.Model
	if not ItemModel then return end

	local YRotation = 30 * deltaTime
	local Rotation = CFrame.Angles(0,math.rad(YRotation),0)
	local cFrame = ItemModel:GetPivot() * Rotation
	ItemModel:PivotTo(cFrame)
end)

ServerTab:Separator()

local ItemsHeader = ServerTab:TreeNode({
	Title = "Tools 🧹",
})

--// Specific matches
local Items = {
	["^CD%d$"] = ItemsHeader:TreeNode({
		Title = "CDs",
	})
}

local function GetExtentsSize(Item)
	local Size
	if Item:IsA("Model") then
		Size = Item:GetExtentsSize()
	else
		Size = Item.Size
	end

	return Vector3.new(0, Size.Y, Size.Z)
end

local function GetItem(Match: string)
	local Match = tostring(Match)

	for _, Item in next, DiscoveredItems do 
		local Name = Item.Name 
		if Name == Match then
			return Item
		end
	end

	return
end

local function FireItemClick(Item: Instance)
	local ClickDetector = Item:FindFirstChildOfClass("ClickDetector")
	if not ClickDetector then return end

	return fireclickdetector(ClickDetector)
end

local function FireTouchPart(Part: BasePart)
	local TouchTransmitter = Part:FindFirstChildOfClass("TouchTransmitter")
	if not TouchTransmitter then return end

	local Character = LocalPlayer.Character
	local Root = Character.HumanoidRootPart

	firetouchinterest(Root, Part, 0)
	wait()
    firetouchinterest(Root, Part, 1)
end

local function CreateButtons(Config)
	local Item = Config.Item
	local Parent = Config.Parent
	local Name = Config.Name or Item.Name
    local Callback = Config.Callback or function()
		return FireItemClick(Item)
	end

	local ButtonsRow = Parent:Row()
	ButtonsRow:Button({
		Text = `Collect {Name}`,
		Callback = Callback,
	})
	ButtonsRow:Button({
		Text = "Preview",
		Callback = function(self)
			local Size = GetExtentsSize(Item)
			Viewport:SetModel(Item, CFrame.new(0, 0, -Size.Magnitude))
		end,
	})
end

local function CheckProps(Item, Properities)
    for Key, Match in next, Properities do

        --// Child check
        if typeof(Key) == "table" then
            local Name = Key.Child
            local Child = Item:FindFirstChild(Name)
            Properities = Match

            if not Child or not CheckProps(Child, Properities) then
                return
            end

            continue
        end

        local Success, Value = pcall(function()
            return Item[Key]
        end)

        if not Success then return end
        if Value ~= Match then return end
    end

    return true
end

local function CheckItem(Item, Parent, Depth)
	local ClickDetector = Item:FindFirstChildOfClass("ClickDetector")
	if not ClickDetector then return end

	--// No players
	if Players:GetPlayerFromCharacter(Item) then return end
	if Players:GetPlayerFromCharacter(Parent) then return end

	--// Check properities
    for NewName, Properities in next, Overwrites do 
        if not CheckProps(Item, Properities) then
            continue
        end

        Item.Name = NewName
    end

	table.insert(DiscoveredItems, Item)

	--// Create buttons
	local Matched = false
	for Match, Parent in next, Items do
		if Item.Name:match(Match) then
			CreateButtons({
				Item = Item, 
				Parent = Parent,
			})
			Matched = true
		end
	end

    --// --Blacklist-- Whitelist check
	if not table.find(ItemsWhitelist, Item.Name) then return end

	--// Filter hidden/disabled
	if Item:IsA("BasePart") and Item.Transparency >= 1 then 
		return 
	end

	if not Matched then
		CreateButtons({
			Item = Item, 
			Parent = ItemsHeader,
		})
	end
end

local function RecursiveScan(Parent, CallBack, MaxDepth, CurrentDepth)
	CurrentDepth = CurrentDepth or 0
	if CurrentDepth > MaxDepth then return end

	for _, Child in next, Parent:GetChildren() do
		CallBack(Child, Parent, CurrentDepth)
		RecursiveScan(Child, CallBack, MaxDepth, CurrentDepth+1)
	end
end

local function ProcessDoors()
	----// Doors
	for _, Room: Model in next, Rooms:GetChildren() do
		local Door = Room:FindFirstChild("Door")
		if not Door then continue end
		Doors[Door] = Door.Parent
	end
end

--// Items give section, create buttons
RecursiveScan(workspace, CheckItem, 4)
ProcessDoors()

local Broom = GetItem("Broom stick")
CreateButtons({
	Item = Broom, 
	Parent = ItemsHeader,
	Callback = function()
		--// Name of tools
		local KeyName = "Key"
		local BroomName = "Broom"
	
		local Backpack = LocalPlayer.Backpack
		local Character = LocalPlayer.Character
		local Humanoid = Character.Humanoid
		local OldPivot = Character:GetPivot()
	
		local ClosetDoor = workspace.Door
	
		--// Closed
		local ClosedDoor = ClosetDoor.Door1
		local MainDoor = ClosedDoor.Main
		local OpenPrompt = MainDoor:FindFirstChildOfClass("ProximityPrompt")
	
		--// Open
		local OpenDoor = ClosetDoor.Door1Open
		local RandomOpenPart = OpenDoor:GetChildren()[1]
	
		--// Get key
		local KeyTool = Backpack:FindFirstChild(KeyName)
	
		if Backpack:FindFirstChild(BroomName) then
			return Alert("You already own the broom 😱")
		end
	
		if not KeyTool then
			local Key = GetItem("Closet key")
			FireItemClick(Key)
	
			KeyTool = Backpack:WaitForChild(KeyName)
		end
	
		Humanoid:EquipTool(KeyTool)
	
		--// Open door
		local DoorPivot = MainDoor:GetPivot()
		Character:PivotTo(DoorPivot)
	
		repeat 
			fireproximityprompt(OpenPrompt)
			wait(.05)
		until RandomOpenPart.Transparency < 1
	
		--// Collect broom stick
		local BroomPivot = Broom:GetPivot()
		Character:PivotTo(BroomPivot)
	
		repeat
			FireItemClick(Broom)
			wait()
		until Backpack:FindFirstChild(BroomName)
	
		Character:PivotTo(OldPivot)
	end
})

local LadderGet = workspace.LadderGet
CreateButtons({
	Item = LadderGet, 
	Parent = ItemsHeader,
	Name = "Ladder",
	Callback = function()
		local Character = LocalPlayer.Character
		local OldPivot = Character:GetPivot()

		local Prompt = LadderGet:FindFirstChildOfClass("ProximityPrompt")

		local LadderPivot = LadderGet:GetPivot() * CFrame.new(0,0,2)
		Character:PivotTo(LadderPivot)

		wait(.5)
		fireproximityprompt(Prompt)

		Character:PivotTo(OldPivot)
	end
})

local Toggles = ServerTab:TreeNode({
	Title = "Interactive 🖱️",
})

local function AddSpam(Title, Delay, Callback)
	local ButtonsRow = Toggles:Row()

	ButtonsRow:Button({
		Text = Title,
		Callback = Callback,
	})

	local SpamEnabled = false
	ButtonsRow:Button({
		Text = "Spam",
		Callback = function(self)
			SpamEnabled = not SpamEnabled
			self.Text = SpamEnabled and "Stop spam 🔴" or "Spam"

			while SpamEnabled and wait(Delay) do
				pcall(Callback)  --// Connections may cause an error
			end
		end,
	})
end

for Spam, Title in next, Spams do
	AddSpam(Title, .01, function()
		for _, Item in next, DiscoveredItems do
			local Name = Item.Name
			if Name ~= Spam then continue end

			FireItemClick(Item)
		end
	end)
end

AddSpam("Open Room Doors", 0.5, function()
	for _, Room: Model in next, Rooms:GetChildren() do
		local Door = Room:FindFirstChild("Door")
		local DoorClosed = Door.Door1
		local Main = DoorClosed.Main 

		local IsLocked = Door.Locked.Value 

		if IsLocked then continue end
		FireTouchPart(Main)
	end
end)

AddSpam("Open Front Doors", 0.5, function()
	local MainDoor = workspace.MainDoor

	for _, Touch in next, MainDoor:GetDescendants() do 
		if not Touch:IsA("TouchTransmitter") then continue end 

		local Part = Touch.Parent 
		FireTouchPart(Part)
	end
end)

AddSpam("Open Office Door", 0.5, function()
	local Office = workspace.Office
	local Door = Office.Door
	local Open = Door.Ok

	FireTouchPart(Open)
end)

AddSpam("Open Basement", 0.2, function()
	local Basement = workspace.Room 
	local Door = Basement.Door 
	local Open = Door.Main 

	FireTouchPart(Open)
end)

AddSpam("Spam Basement Codes", 0.4, function()
	local Length = 4

	for i = 1, Length do
		local Digit = math.random(1, 9)
		local Button = GetItem(Digit)
		FireItemClick(Button)
	end
end)

function CloseCallback()
	ViewportConnection:Disconnect()
end

local Destruction = ServerTab:TreeNode({
	Title = "Destruction 💥",
})

Destruction:Button({
	Text = "Bring chairs",
	Callback = function(self)
		local Character = LocalPlayer.Character
		local Humanoid = Character.Humanoid
		local Target = Character:GetPivot()

		for _, Room in next, Rooms:GetChildren() do
			local Chairs = Room.ChairZone:FindFirstChild("Chairs")
			if not Chairs then continue end --// Chairs respawning

			--// Chairs
			for _, Chair in next, Chairs:GetChildren() do
				local Seat = Chair:FindFirstChildOfClass("Seat")
				if Seat.Occupant then continue end

				--// Wait until claimed
				while wait() and Seat and not Seat.Occupant do
					Seat:Sit(Humanoid)
				end

				--// Teleport the chair
				Chair:PivotTo(Target)
				wait()
				Humanoid.Sit = false
			end
		end
	end,
})

Destruction:Button({
	Text = "Tool Reach",
	Callback = function(self)
		local Character = LocalPlayer.Character
		local Humanoid = Character.Humanoid
		local Size = 400

		for _, Tool in next, Character:GetChildren() do
			if not Tool:IsA("Tool") then continue end

			Tool.Handle.Massless = true
			Tool.Handle.Size = Vector3.new(Size,Size,Size)
			Humanoid:UnequipTools()
		end
	end,
})

--// Client Tab
local ClientTab = Window:CreateTab({
	Name = "Client"
})

--// Teleports
local MapHeader = ClientTab:TreeNode({
	Title = "Map 🗺️",
})
local Teleports = MapHeader:TreeNode({
	Title = "Teleports 🛸",
})

for Name, Pivot in next, Positions do
	Teleports:Button({
		Text = Name,
		Callback = function(self)
			local Character = LocalPlayer.Character
			Character:PivotTo(Pivot)
		end,
	})
end

MapHeader:Checkbox({
	Label = "No doors",
	Callback = function(self, Value)
		for Door, Parent in next, Doors do
			Door.Parent = not Value and Parent or nil
		end
	end,
})

--// Weather
local WeatherHeader = ClientTab:TreeNode({
	Title = "Weather 🌧️",
})
WeatherHeader:Checkbox({
	Label = "No Rain",
	Callback = function(self, Value)
		LocalPlayer.PlayerScripts.Rai.RainyDay.Enabled = not Value

		local RainFolder: model = workspace:FindFirstChild("Rain Home")
		if Value then
			RainFolder:ClearAllChildren()
		end
	end,
})
WeatherHeader:Button({
	Text = "Stop Rain",
	Callback = function(self)
		ReplicatedStorage.Season.Value = "Sunny"
		ReplicatedStorage.Sound.Rain:Stop()

		local RainySky = Lighting:FindFirstChild("RainySky")
		if RainySky then
			RainySky:Remove()
		end

		local SunnySky = MaterialService:FindFirstChild("Sky")
		SunnySky:Clone().Parent = Lighting
	end,
})

--// Player
local PlayerHeader = ClientTab:TreeNode({
	Title = "Player",
})

PlayerHeader:SliderInt({
	Label = "Walkspeed",
	Value = 16,
	Minimum = 1,
	Maximum = 100,

	Callback = function(self, Value)
		local Character = LocalPlayer.Character
		local Humanoid = Character.Humanoid
		Humanoid.WalkSpeed = Value
	end,
})
