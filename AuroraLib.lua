--!nocheck

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local FontId = "rbxassetid://12187365364"
local HasFontNew = typeof(Font) == "table" or typeof(Font) == "userdata"
if HasFontNew then
	local Ok = pcall(function() return Font.new(FontId, Enum.FontWeight.Regular, Enum.FontStyle.Normal) end)
	HasFontNew = Ok
end

local function ResolveWeight(Weight)
	local Ok, W = pcall(function()
		if Weight == "Medium" then return Enum.FontWeight.Medium end
		if Weight == "SemiBold" then return Enum.FontWeight.SemiBold end
		if Weight == "Bold" then return Enum.FontWeight.Bold end
		return Enum.FontWeight.Regular
	end)
	if Ok and W then return W end
	local Ok2, R = pcall(function() return Enum.FontWeight.Regular end)
	if Ok2 then return R end
	return nil
end

local function MakeFont(Weight)
	if not HasFontNew then return nil end
	local W = ResolveWeight(Weight)
	if not W then return nil end
	local Ok, F = pcall(function() return Font.new(FontId, W, Enum.FontStyle.Normal) end)
	if Ok then return F end
	return nil
end

local FontRegular = MakeFont("Regular")
local FontMedium = MakeFont("Medium")
local FontSemiBold = MakeFont("SemiBold")
local FontBold = MakeFont("Bold")

local function ApplyInter(Object, Weight)
	if not Object then return end
	local F = FontRegular
	if Weight == "Medium" then F = FontMedium
	elseif Weight == "SemiBold" then F = FontSemiBold
	elseif Weight == "Bold" then F = FontBold end
	if F then
		pcall(function() Object.FontFace = F end)
	else
		pcall(function() Object.Font = Enum.Font.GothamMedium end)
	end
end

local Icons
do
	local Ok, Mod = pcall(function()
		return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/3cb5d51beee5c36d2a868f2e761dc272eb2a466b/Main-v2.lua"))()
	end)
	if Ok and Mod then
		Icons = Mod
		pcall(function() Icons.Init(nil, nil) end)
		pcall(function() Icons.SetIconsType("lucide") end)
	end
end

local function MakeIcon(IconString, Parent, Size, Color)
	if not Icons or not IconString then return nil end
	local Ok, Result = pcall(function()
		return Icons.Image({
			Icon = IconString,
			Size = Size or UDim2.fromOffset(14, 14),
			Colors = { Color or Theme.Text },
		})
	end)
	if not Ok or not Result or not Result.IconFrame then return nil end
	Result.IconFrame.Parent = Parent
	return Result.IconFrame
end

local LocalPlayer = Players.LocalPlayer

local ConfigFile = "Aurora.json"
local LayoutFile = "Aurora_Layout.json"

local function SetConfigName(Name)
	if typeof(Name) ~= "string" or Name == "" then return end
	local Clean = Name:gsub("[^%w%-_]", "")
	if Clean == "" then return end
	ConfigFile = Clean .. ".json"
	LayoutFile = Clean .. "_Layout.json"
end

local Spring = TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local SpringFast = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local SpringSlow = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local SpringSnap = TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local Snap = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local Linear = TweenInfo.new(0.12, Enum.EasingStyle.Linear)

local Themes = {
	Dark = {
		Background = Color3.fromRGB(20, 20, 24),
		Surface = Color3.fromRGB(28, 28, 34),
		SurfaceAlt = Color3.fromRGB(36, 36, 44),
		Elevated = Color3.fromRGB(46, 46, 56),
		Accent = Color3.fromRGB(255, 255, 255),
		AccentHover = Color3.fromRGB(230, 230, 235),
		Text = Color3.fromRGB(240, 240, 248),
		TextDim = Color3.fromRGB(155, 155, 170),
		TextMuted = Color3.fromRGB(100, 100, 115),
		Border = Color3.fromRGB(55, 55, 68),
		BorderSoft = Color3.fromRGB(40, 40, 50),
		Success = Color3.fromRGB(80, 200, 130),
		Warning = Color3.fromRGB(255, 180, 80),
		Danger = Color3.fromRGB(255, 90, 100),
		Info = Color3.fromRGB(100, 180, 255),
		OnAccent = Color3.fromRGB(20, 20, 24),
	},
	Light = {
		Background = Color3.fromRGB(245, 245, 250),
		Surface = Color3.fromRGB(255, 255, 255),
		SurfaceAlt = Color3.fromRGB(238, 238, 244),
		Elevated = Color3.fromRGB(248, 248, 252),
		Accent = Color3.fromRGB(90, 100, 230),
		AccentHover = Color3.fromRGB(110, 120, 245),
		Text = Color3.fromRGB(20, 20, 28),
		TextDim = Color3.fromRGB(90, 90, 105),
		TextMuted = Color3.fromRGB(140, 140, 155),
		Border = Color3.fromRGB(220, 220, 230),
		BorderSoft = Color3.fromRGB(235, 235, 242),
		Success = Color3.fromRGB(40, 170, 100),
		Warning = Color3.fromRGB(230, 150, 40),
		Danger = Color3.fromRGB(220, 60, 80),
		Info = Color3.fromRGB(60, 140, 230),
		OnAccent = Color3.fromRGB(255, 255, 255),
	},
	Midnight = {
		Background = Color3.fromRGB(8, 10, 18),
		Surface = Color3.fromRGB(14, 18, 30),
		SurfaceAlt = Color3.fromRGB(20, 26, 42),
		Elevated = Color3.fromRGB(28, 36, 56),
		Accent = Color3.fromRGB(100, 200, 255),
		AccentHover = Color3.fromRGB(130, 215, 255),
		Text = Color3.fromRGB(220, 230, 250),
		TextDim = Color3.fromRGB(140, 155, 185),
		TextMuted = Color3.fromRGB(80, 95, 125),
		Border = Color3.fromRGB(40, 52, 80),
		BorderSoft = Color3.fromRGB(24, 32, 50),
		Success = Color3.fromRGB(80, 220, 160),
		Warning = Color3.fromRGB(255, 195, 100),
		Danger = Color3.fromRGB(255, 100, 130),
		Info = Color3.fromRGB(120, 200, 255),
		OnAccent = Color3.fromRGB(8, 10, 18),
	},
	Ocean = {
		Background = Color3.fromRGB(12, 22, 32),
		Surface = Color3.fromRGB(18, 32, 46),
		SurfaceAlt = Color3.fromRGB(26, 44, 62),
		Elevated = Color3.fromRGB(36, 58, 80),
		Accent = Color3.fromRGB(80, 210, 200),
		AccentHover = Color3.fromRGB(110, 225, 215),
		Text = Color3.fromRGB(225, 240, 245),
		TextDim = Color3.fromRGB(140, 170, 185),
		TextMuted = Color3.fromRGB(90, 115, 130),
		Border = Color3.fromRGB(50, 78, 100),
		BorderSoft = Color3.fromRGB(32, 52, 70),
		Success = Color3.fromRGB(90, 220, 170),
		Warning = Color3.fromRGB(255, 190, 90),
		Danger = Color3.fromRGB(255, 110, 110),
		Info = Color3.fromRGB(120, 210, 230),
		OnAccent = Color3.fromRGB(12, 22, 32),
	},
	Rose = {
		Background = Color3.fromRGB(26, 18, 24),
		Surface = Color3.fromRGB(38, 26, 34),
		SurfaceAlt = Color3.fromRGB(50, 34, 44),
		Elevated = Color3.fromRGB(64, 44, 56),
		Accent = Color3.fromRGB(255, 120, 160),
		AccentHover = Color3.fromRGB(255, 145, 180),
		Text = Color3.fromRGB(248, 235, 242),
		TextDim = Color3.fromRGB(180, 155, 170),
		TextMuted = Color3.fromRGB(125, 100, 115),
		Border = Color3.fromRGB(80, 55, 70),
		BorderSoft = Color3.fromRGB(56, 38, 50),
		Success = Color3.fromRGB(120, 220, 150),
		Warning = Color3.fromRGB(255, 185, 95),
		Danger = Color3.fromRGB(255, 95, 115),
		Info = Color3.fromRGB(200, 160, 255),
		OnAccent = Color3.fromRGB(26, 18, 24),
	},
}

local function CloneTheme(Source)
	local Out = {}
	for K, V in pairs(Source) do Out[K] = V end
	if not Out.OnAccent then
		Out.OnAccent = Out.Background or Color3.fromRGB(20, 20, 24)
	end
	return Out
end

local function ResolveTheme(Input, Fallback)
	if typeof(Input) == "string" and Themes[Input] then
		return CloneTheme(Themes[Input])
	end
	if typeof(Input) == "table" then
		local Base = CloneTheme(Fallback or Themes.Dark)
		for K, V in pairs(Input) do
			if typeof(V) == "Color3" then Base[K] = V end
		end
		return Base
	end
	return CloneTheme(Fallback or Themes.Dark)
end

local Theme = CloneTheme(Themes.Dark)

local ThemeRegistry = {}

local function RegisterColor(Object, Property, Key, ThemeRef)
	if not Object or not Property or not Key then return Object end
	ThemeRegistry[#ThemeRegistry + 1] = {
		Object = Object,
		Property = Property,
		Key = Key,
		ThemeRef = ThemeRef,
	}
	return Object
end

local ThemeTweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local _ActiveTweens = setmetatable({}, { __mode = "k" })

local function CancelTween(Object, Property)
	local Map = _ActiveTweens[Object]
	if not Map then return end
	local T = Map[Property]
	if T then
		pcall(function() T:Cancel() end)
		Map[Property] = nil
	end
end

local function TrackTween(Object, Property, T)
	local Map = _ActiveTweens[Object]
	if not Map then
		Map = {}
		_ActiveTweens[Object] = Map
	end
	Map[Property] = T
end

local function ApplyThemeTween(GlobalNewTheme, PanelFilter, PanelNewTheme)
	for i = #ThemeRegistry, 1, -1 do
		local Entry = ThemeRegistry[i]
		local Obj = Entry.Object
		if not Obj or not Obj.Parent then
			table.remove(ThemeRegistry, i)
		else
			local Match = true
			if PanelFilter ~= nil then
				if Entry.ThemeRef ~= PanelFilter then
					Match = false
				end
			else
				if Entry.ThemeRef ~= nil then
					Match = false
				end
			end
			if Match then
				local Source = (PanelFilter and PanelNewTheme) or GlobalNewTheme
				local NewColor = Source[Entry.Key]
				if NewColor then
					CancelTween(Obj, Entry.Property)
					local Ok, T = pcall(function()
						return TweenService:Create(Obj, ThemeTweenInfo, { [Entry.Property] = NewColor })
					end)
					if Ok and T then
						TrackTween(Obj, Entry.Property, T)
						T:Play()
					end
				end
			end
		end
	end
end

local function SafeCall(Fn, ...)
	if typeof(Fn) ~= "function" then return end
	local Ok, Err = pcall(Fn, ...)
	if not Ok then warn("[Aurora]", Err) end
end

local function Tween(Object, Info, Props)
	local T = TweenService:Create(Object, Info, Props)
	T:Play()
	return T
end

local ColorProperties = {
	BackgroundColor3 = true,
	TextColor3 = true,
	ImageColor3 = true,
	BorderColor3 = true,
	Color = true,
	PlaceholderColor3 = true,
	ScrollBarImageColor3 = true,
}

local function ReverseLookupThemeKey(Value)
	if typeof(Value) ~= "Color3" then return nil end
	for K, V in pairs(Theme) do
		if V == Value then return K end
	end
	return nil
end

local _ActiveThemeRef = nil

local function Make(Class, Props, Children)
	local Object = Instance.new(Class)
	if Props then
		local ParentRef = Props.Parent
		for Key, Value in pairs(Props) do
			if Key ~= "Parent" then
				if Key == "FontFace" and Value == nil then
					pcall(function() Object.Font = Enum.Font.GothamMedium end)
				else
					local Ok = pcall(function() Object[Key] = Value end)
					if Ok and ColorProperties[Key] then
						local ThemeKey = ReverseLookupThemeKey(Value)
						if ThemeKey then
							RegisterColor(Object, Key, ThemeKey, _ActiveThemeRef)
						end
					end
				end
			end
		end
		if ParentRef then Object.Parent = ParentRef end
	end
	if Children then
		for _, Child in ipairs(Children) do Child.Parent = Object end
	end
	return Object
end

local function Corner(Parent, Radius)
	return Make("UICorner", { CornerRadius = UDim.new(0, Radius or 8), Parent = Parent })
end

local function Stroke(Parent, Color, Thickness, Transparency)
	return Make("UIStroke", {
		Color = Color or Theme.Border,
		Thickness = Thickness or 1,
		Transparency = Transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = Parent,
	})
end

local function Padding(Parent, Top, Right, Bottom, Left)
	Right = Right or Top
	Bottom = Bottom or Top
	Left = Left or Right
	return Make("UIPadding", {
		PaddingTop = UDim.new(0, Top),
		PaddingRight = UDim.new(0, Right),
		PaddingBottom = UDim.new(0, Bottom),
		PaddingLeft = UDim.new(0, Left),
		Parent = Parent,
	})
end

local function ListLayout(Parent, Spacing, Direction)
	return Make("UIListLayout", {
		FillDirection = Direction or Enum.FillDirection.Vertical,
		Padding = UDim.new(0, Spacing or 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Parent = Parent,
	})
end

local function GetMountParent()
	local Ok, Hui = pcall(function() return gethui and gethui() end)
	if Ok and Hui then return Hui end
	local Ok2, Cg = pcall(function() return game:GetService("CoreGui") end)
	if Ok2 and Cg then
		local Ok3 = pcall(function() local _ = Cg:GetChildren() end)
		if Ok3 then return Cg end
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local function HasIO()
	return typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"
end

local function ReadJson(Path)
	if not HasIO() then return nil end
	local Ok, Exists = pcall(isfile, Path)
	if not Ok or not Exists then return nil end
	local Ok2, Contents = pcall(readfile, Path)
	if not Ok2 then return nil end
	local Ok3, Decoded = pcall(function() return HttpService:JSONDecode(Contents) end)
	if not Ok3 then return nil end
	return Decoded
end

local function WriteJson(Path, Data)
	if not HasIO() then return false end
	local Ok, Encoded = pcall(function() return HttpService:JSONEncode(Data) end)
	if not Ok then return false end
	local Ok2 = pcall(writefile, Path, Encoded)
	return Ok2
end

local function EncodeColor(Color)
	return { Type = "Color3", R = Color.R, G = Color.G, B = Color.B }
end

local function DecodeColor(Data)
	if typeof(Data) == "table" and Data.Type == "Color3" then
		return Color3.new(Data.R, Data.G, Data.B)
	end
	return nil
end

local function EncodeKey(Key)
	return { Type = "KeyCode", Name = Key.Name }
end

local function DecodeKey(Data)
	if typeof(Data) == "table" and Data.Type == "KeyCode" then
		local Ok, Key = pcall(function() return Enum.KeyCode[Data.Name] end)
		if Ok then return Key end
	end
	return nil
end

local function EncodeValue(Value)
	if typeof(Value) == "Color3" then return EncodeColor(Value) end
	if typeof(Value) == "EnumItem" and Value.EnumType == Enum.KeyCode then return EncodeKey(Value) end
	if typeof(Value) == "table" then
		local Out = {}
		for K, V in pairs(Value) do Out[tostring(K)] = EncodeValue(V) end
		return Out
	end
	return Value
end

local function DecodeValue(Data)
	if typeof(Data) == "table" then
		if Data.Type == "Color3" then return DecodeColor(Data) end
		if Data.Type == "KeyCode" then return DecodeKey(Data) end
		local Out = {}
		for K, V in pairs(Data) do Out[K] = DecodeValue(V) end
		return Out
	end
	return Data
end

local Aurora = {}
Aurora.__index = Aurora
Aurora.Flags = {}
Aurora.Theme = Theme
Aurora.Themes = Themes
Aurora.Version = "4.0.0"

Aurora._Initialized = false
Aurora._Panels = {}
Aurora._FlagControls = {}
Aurora._Layout = {}
Aurora._SavedConfig = {}
Aurora._Visible = true
Aurora._ToggleKey = Enum.KeyCode.LeftControl
Aurora._Connections = {}
Aurora._OverlayRoot = nil

local Panel = {}
Panel.__index = Panel

local Section = {}
Section.__index = Section

local function SaveLayout()
	WriteJson(LayoutFile, Aurora._Layout)
end

local _ActiveDrag = nil
local _DragChangedConn = nil
local _DragEndedConn = nil

local function _EnsureDragGlobals()
	if not _DragChangedConn then
		_DragChangedConn = UserInputService.InputChanged:Connect(function(Input)
			local D = _ActiveDrag
			if not D then return end
			if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
			if not D.Frame or not D.Frame.Parent then _ActiveDrag = nil return end
			local Delta = Input.Position - D.DragStart
			D.Frame.Position = UDim2.new(
				D.StartPos.X.Scale,
				D.StartPos.X.Offset + Delta.X,
				D.StartPos.Y.Scale,
				D.StartPos.Y.Offset + Delta.Y
			)
		end)
	end
	if not _DragEndedConn then
		_DragEndedConn = UserInputService.InputEnded:Connect(function(Input)
			if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
			local D = _ActiveDrag
			if not D then return end
			_ActiveDrag = nil
			if D.Panel and D.Panel._PersistLayout then
				pcall(function() D.Panel:_PersistLayout() end)
			end
		end)
	end
end

local function MakeDraggable(Frame, Handle, Panel)
	_EnsureDragGlobals()
	Handle.InputBegan:Connect(function(Input)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
		_ActiveDrag = {
			Frame = Frame,
			Panel = Panel,
			DragStart = Input.Position,
			StartPos = Frame.Position,
		}
	end)
end

local function _UpdatePanelAutoHeight(Self)
	if Self._Minimized or Self._Hidden then return end
	if not Self._Body or not Self._Wrapper then return end
	
	local ContentH = Self._Body.AbsoluteCanvasSize.Y
	
	local TotalH = math.min(38 + ContentH + 22, Self._MaxAutoHeight)
	TotalH = math.max(TotalH, Self._MinHeight + 10)

	local CurrentW = Self._Wrapper.Size.X.Offset
	local NewSize = UDim2.fromOffset(CurrentW, TotalH)
	Self._FullSize = NewSize
	Tween(Self._Wrapper, SpringFast, { Size = NewSize })
end

function Aurora:Init(Options)
	if self._Initialized then return self end
	Options = Options or {}
	if Options.ConfigName then SetConfigName(Options.ConfigName) end
	self._ToggleKey = Options.ToggleKey or Enum.KeyCode.LeftControl
	if Options.Theme ~= nil then
		local Resolved = ResolveTheme(Options.Theme, Themes.Dark)
		for K, V in pairs(Resolved) do Theme[K] = V end
	end
	self._Screen = Make("ScreenGui", {
		Name = "Aurora_" .. HttpService:GenerateGUID(false):sub(1, 8),
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		DisplayOrder = 999,
		Parent = GetMountParent(),
	})
	
	self._OverlayRoot = Make("Frame", {
		Name = "DropdownOverlay",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 200,
		Parent = self._Screen,
	})

	self._NotifRoot = Make("Frame", {
		Name = "Notifications",
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -16, 1, -16),
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.new(0, 300, 1, -32),
		Parent = self._Screen,
	})
	Make("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, 8),
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = self._NotifRoot,
	})

	local LoadedLayout = ReadJson(LayoutFile)
	if typeof(LoadedLayout) == "table" then self._Layout = LoadedLayout end

	local LoadedConfig = ReadJson(ConfigFile)
	if typeof(LoadedConfig) == "table" then self._SavedConfig = LoadedConfig end

	self._Connections.Toggle = UserInputService.InputBegan:Connect(function(Input, Processed)
		if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if UserInputService:GetFocusedTextBox() then return end
		if Input.KeyCode == self._ToggleKey then
			local AllHidden = true
			for _, P in ipairs(self._Panels) do
				if not P._Hidden then AllHidden = false break end
			end
			if AllHidden and #self._Panels > 0 then
				self:ShowAllPanels()
				self._Visible = true
			else
				self:ToggleVisible()
			end
			return
		end
		if Processed then return end
	end)

	self:_BuildSwitcher()
	if self._RefreshSwitcher then self._RefreshSwitcher() end
	self._Initialized = true
	return self
end

function Aurora:_BuildSwitcher()
	self._SwitcherBtn = Make("TextButton", {
		Parent = self._Screen,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 16, 1, -16),
		Size = UDim2.fromOffset(44, 44),
		BackgroundColor3 = Theme.Elevated,
		AutoButtonColor = false,
		Text = "",
		ZIndex = 50,
		Visible = false,
		BorderSizePixel = 0,
	})
	Corner(self._SwitcherBtn, 22)
	Stroke(self._SwitcherBtn, Theme.Border, 1, 0.3)

	local SwitcherIcon
	if Icons then
		SwitcherIcon = MakeIcon("layout-grid", self._SwitcherBtn, 18, Theme.Text)
		if SwitcherIcon then
			SwitcherIcon.AnchorPoint = Vector2.new(0.5, 0.5)
			SwitcherIcon.Position = UDim2.fromScale(0.5, 0.5)
			SwitcherIcon.Size = UDim2.fromOffset(18, 18)
			for _, C in ipairs(SwitcherIcon:GetChildren()) do
				if C:IsA("ImageLabel") or C:IsA("ImageButton") then
					C.AnchorPoint = Vector2.new(0.5, 0.5)
					C.Position = UDim2.fromScale(0.5, 0.5)
					C.Size = UDim2.fromScale(1, 1)
				end
			end
		end
	end
	if not SwitcherIcon then
		self._SwitcherBtn.Text = "+"
		self._SwitcherBtn.TextColor3 = Theme.Text
		self._SwitcherBtn.TextSize = 22
		if FontMedium then self._SwitcherBtn.FontFace = FontMedium else ApplyInter(self._SwitcherBtn, "Medium") end
	end

	self._SwitcherMenu = Make("Frame", {
		Parent = self._Screen,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 16, 1, -68),
		Size = UDim2.fromOffset(200, 0),
		BackgroundColor3 = Theme.Surface,
		Visible = false,
		ZIndex = 50,
		ClipsDescendants = true,
		BorderSizePixel = 0,
	})
	Corner(self._SwitcherMenu, 10)
	Stroke(self._SwitcherMenu, Theme.Border, 1, 0.3)
	Make("UIPadding", {
		Parent = self._SwitcherMenu,
		PaddingTop = UDim.new(0, 6),
		PaddingBottom = UDim.new(0, 6),
		PaddingLeft = UDim.new(0, 6),
		PaddingRight = UDim.new(0, 6),
	})
	Make("UIListLayout", {
		Parent = self._SwitcherMenu,
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local function RefreshSwitcher()
		if not self._SwitcherMenu or not self._SwitcherMenu.Parent then return end
		for _, C in ipairs(self._SwitcherMenu:GetChildren()) do
			if C:IsA("TextButton") then C:Destroy() end
		end
		local Closed = self:GetClosedPanels()
		if #Closed == 0 then
			self._SwitcherBtn.Visible = false
			self._SwitcherMenu.Visible = false
			return
		end
		self._SwitcherBtn.Visible = true
		for _, Info in ipairs(Closed) do
			local Row = Make("TextButton", {
				Parent = self._SwitcherMenu,
				Size = UDim2.new(1, 0, 0, 28),
				BackgroundColor3 = Theme.SurfaceAlt,
				AutoButtonColor = false,
				Text = "  " .. Info.Title,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = 13,
				BorderSizePixel = 0,
			})
			Corner(Row, 6)
			if FontMedium then Row.FontFace = FontMedium else ApplyInter(Row, "Medium") end
			Row.MouseEnter:Connect(function() Tween(Row, SpringFast, { BackgroundColor3 = Theme.Elevated }) end)
			Row.MouseLeave:Connect(function() Tween(Row, SpringFast, { BackgroundColor3 = Theme.SurfaceAlt }) end)
			Row.MouseButton1Click:Connect(function()
				self:ShowPanel(Info.Key)
				RefreshSwitcher()
			end)
		end
		local Rows = math.min(#Closed, 8)
		local TargetH = Rows * 28 + (Rows - 1) * 2 + 12
		self._SwitcherMenu.Size = UDim2.fromOffset(200, TargetH)
	end

	self._RefreshSwitcher = RefreshSwitcher

	self._SwitcherBtn.MouseButton1Click:Connect(function()
		if not self._SwitcherMenu.Visible then RefreshSwitcher() end
		self._SwitcherMenu.Visible = not self._SwitcherMenu.Visible
	end)
end

function Aurora:SetTheme(Input)
	self:_EnsureInit()
	local NewTheme = ResolveTheme(Input, Theme)
	for K, V in pairs(NewTheme) do Theme[K] = V end
	ApplyThemeTween(NewTheme, nil, nil)
	for _, Pnl in ipairs(self._Panels) do
		if Pnl._OwnTheme and Pnl._ThemeDeltas then
			local Merged = {}
			for K, V in pairs(NewTheme) do Merged[K] = V end
			for K, V in pairs(Pnl._ThemeDeltas) do Merged[K] = V end
			Pnl._Theme = Merged
			ApplyThemeTween(NewTheme, Pnl, Merged)
		end
	end
	return self
end

function Aurora:GetTheme()
	self:_EnsureInit()
	local Out = {}
	for K, V in pairs(Theme) do Out[K] = V end
	return Out
end

function Aurora:_EnsureInit()
	if not self._Initialized then self:Init() end
end

function Aurora:ToggleVisible()
	self:SetVisible(not self._Visible)
end

function Aurora:SetVisible(State)
	self._Visible = State
	for _, P in ipairs(self._Panels) do
		if State then
			if not P._Hidden then P._Wrapper.Visible = true end
		else
			P._Wrapper.Visible = false
		end
	end
end

function Aurora:ShowPanel(Key)
	for _, P in ipairs(self._Panels) do
		if P._Key == Key or P._Title == Key then
			P:Show()
			if self._RefreshSwitcher then self._RefreshSwitcher() end
			return true
		end
	end
	return false
end

function Aurora:ShowAllPanels()
	for _, P in ipairs(self._Panels) do
		if P._Hidden then P:Show() end
	end
	if self._RefreshSwitcher then self._RefreshSwitcher() end
end

function Aurora:GetClosedPanels()
	local List = {}
	for _, P in ipairs(self._Panels) do
		if P._Hidden then table.insert(List, { Key = P._Key, Title = P._Title }) end
	end
	return List
end

function Aurora:CreatePanel(Options)
	self:_EnsureInit()
	Options = Options or {}
	local Self = setmetatable({}, Panel)
	Self._Aurora = self
	Self._Title = Options.Title or "Panel"
	Self._Key = Options.Key or Self._Title
	Self._DefaultSize = Options.Size or UDim2.fromOffset(290, 360)
	Self._DefaultPosition = Options.Position or UDim2.fromOffset(40 + (#self._Panels * 24), 60 + (#self._Panels * 24))
	Self._MinHeight = 38
	Self._Minimized = false
	Self._Hidden = false
	Self._Sections = {}
	Self._MaxAutoHeight = Self._DefaultSize.Y.Offset

	local Saved = self._Layout[Self._Key]
	if typeof(Saved) == "table" then
		if Saved.X and Saved.Y then Self._DefaultPosition = UDim2.fromOffset(Saved.X, Saved.Y) end
		if Saved.W and Saved.H then Self._DefaultSize = UDim2.fromOffset(Saved.W, Saved.H) end
		Self._Minimized = Saved.Minimized == true
		Self._Hidden = Saved.Hidden == true
	end

	Self._FullSize = Self._DefaultSize

	local PanelThemeOverride = nil
	local SavedTheme = nil
	if Options.Theme ~= nil then
		local Deltas = {}
		if typeof(Options.Theme) == "string" and Themes[Options.Theme] then
			for K, V in pairs(Themes[Options.Theme]) do Deltas[K] = V end
		elseif typeof(Options.Theme) == "table" then
			for K, V in pairs(Options.Theme) do
				if typeof(V) == "Color3" then Deltas[K] = V end
			end
		end
		Self._ThemeDeltas = Deltas
		PanelThemeOverride = {}
		for K, V in pairs(Theme) do PanelThemeOverride[K] = V end
		for K, V in pairs(Deltas) do PanelThemeOverride[K] = V end
		Self._Theme = PanelThemeOverride
		Self._OwnTheme = true
		SavedTheme = {}
		for K, V in pairs(Theme) do SavedTheme[K] = V end
		for K, V in pairs(Deltas) do Theme[K] = V end
	else
		Self._Theme = Theme
		Self._OwnTheme = false
	end

	local PrevThemeRef = _ActiveThemeRef
	if Self._OwnTheme then _ActiveThemeRef = Self end

	local Wrapper = Make("Frame", {
		Name = "PanelWrap_" .. Self._Title,
		BackgroundTransparency = 1,
		Position = Self._DefaultPosition,
		Size = Self._DefaultSize,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Parent = self._Screen,
	})
	Self._Wrapper = Wrapper

	local Clip = Make("CanvasGroup", {
		Name = "PanelClip",
		BackgroundColor3 = Theme.Background,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		GroupTransparency = 0,
		Parent = Wrapper,
	})
	Corner(Clip, 12)

	local Frame = Make("Frame", {
		Name = "Panel_" .. Self._Title,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		Parent = Clip,
	})
	local PanelStroke = Stroke(Clip, Theme.Border, 1, 0.4)
	PanelStroke.LineJoinMode = Enum.LineJoinMode.Round

	Self._Frame = Frame

	local Topbar = Make("Frame", {
		Name = "Topbar",
		BackgroundColor3 = Theme.Surface,
		Size = UDim2.new(1, 0, 0, 38),
		BorderSizePixel = 0,
		Parent = Frame,
	})
	Self._TopbarDivider = Make("Frame", {
		BackgroundColor3 = Theme.BorderSoft,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -1),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundTransparency = 0,
		Parent = Topbar,
	})

	local TitleLabel = Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -86, 1, 0),
		FontFace = FontMedium,
		Text = Self._Title,
		TextColor3 = Theme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Topbar,
	})
	Self._TitleLabel = TitleLabel

	local function MakeTopButton(IconName, FallbackSymbol, OffsetX, Hover)
		local Btn = Make("TextButton", {
			BackgroundColor3 = Theme.SurfaceAlt,
			BackgroundTransparency = 1,
			Position = UDim2.new(1, OffsetX, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.fromOffset(22, 22),
			FontFace = FontBold,
			Text = "",
			TextColor3 = Theme.TextDim,
			TextSize = 14,
			AutoButtonColor = false,
			Parent = Topbar,
		})
		Corner(Btn, 6)
		local IconObj
		if Icons then
			local Ok, Result = pcall(function()
				return Icons.Image({
					Icon = IconName,
					Size = UDim2.fromOffset(14, 14),
					Colors = { Theme.TextDim },
				})
			end)
			if Ok and Result and Result.IconFrame then
				Result.IconFrame.Parent = Btn
				Result.IconFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				Result.IconFrame.Position = UDim2.fromScale(0.5, 0.5)
				IconObj = Result.IconFrame
			end
		end
		if not IconObj then
			Btn.Text = FallbackSymbol
		end
		Btn.MouseEnter:Connect(function()
			Tween(Btn, SpringFast, { BackgroundTransparency = 0, TextColor3 = Hover or Theme.Text })
			if IconObj then pcall(function() Tween(IconObj, SpringFast, { ImageColor3 = Hover or Theme.Text }) end) end
		end)
		Btn.MouseLeave:Connect(function()
			Tween(Btn, SpringFast, { BackgroundTransparency = 1, TextColor3 = Theme.TextDim })
			if IconObj then pcall(function() Tween(IconObj, SpringFast, { ImageColor3 = Theme.TextDim }) end) end
		end)
		return Btn, IconObj
	end

	local CloseBtn = MakeTopButton("x", "x", -28, Theme.Danger)
	local MinBtn, MinIcon = MakeTopButton(Self._Minimized and "plus" or "minus", Self._Minimized and "+" or "-", -56, Theme.Accent)
	Self._MinIcon = MinIcon
	Self._MinBtn = MinBtn

	CloseBtn.MouseButton1Click:Connect(function()
		Self:Hide()
		if Self._Aurora._RefreshSwitcher then Self._Aurora._RefreshSwitcher() end
	end)
	MinBtn.MouseButton1Click:Connect(function() Self:ToggleMinimize() end)

	local BodyWrap = Make("CanvasGroup", {
		Name = "BodyWrap",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 38),
		Size = UDim2.new(1, 0, 1, -38),
		GroupTransparency = 0,
		ClipsDescendants = true,
		Parent = Frame,
	})

	local Body = Make("ScrollingFrame", {
		Name = "Body",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.Border,
		ScrollBarImageTransparency = 0.3,
		ClipsDescendants = true,
		Parent = BodyWrap,
	})
	Padding(Body, 10, 12, 12, 12)
	ListLayout(Body, 8)

	Self._Body = Body
	Self._BodyWrap = BodyWrap
	Self._Topbar = Topbar
	
	Body:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
		_UpdatePanelAutoHeight(Self)
	end)

	MakeDraggable(Wrapper, Topbar, Self)

	if Self._Hidden then
		Wrapper.Visible = false
		Wrapper.Size = Self._FullSize
		BodyWrap.GroupTransparency = Self._Minimized and 1 or 0
	elseif Self._Minimized then
		Wrapper.Visible = true
		Wrapper.Size = UDim2.fromOffset(Self._FullSize.X.Offset, Self._MinHeight)
		BodyWrap.GroupTransparency = 1
	else
		Wrapper.Visible = true
		Wrapper.Size = Self._FullSize
		BodyWrap.GroupTransparency = 0
	end

	if SavedTheme then
		for K, V in pairs(SavedTheme) do Theme[K] = V end
	end
	_ActiveThemeRef = PrevThemeRef

	table.insert(self._Panels, Self)
	if self._RefreshSwitcher then self._RefreshSwitcher() end
	return Self
end

function Panel:_PersistLayout()
	local Entry = self._Aurora._Layout[self._Key] or {}
	Entry.X = self._Wrapper.Position.X.Offset
	Entry.Y = self._Wrapper.Position.Y.Offset
	Entry.W = self._FullSize.X.Offset
	Entry.H = self._FullSize.Y.Offset
	Entry.Minimized = self._Minimized
	Entry.Hidden = self._Hidden
	self._Aurora._Layout[self._Key] = Entry
	SaveLayout()
end

function Panel:ToggleMinimize()
	self:SetMinimized(not self._Minimized)
end

function Panel:SetMinimized(State)
	self._Minimized = State
	local IconName = State and "plus" or "minus"
	local Fallback = State and "+" or "-"
	if State then
		Tween(self._Wrapper, Spring, { Size = UDim2.fromOffset(self._FullSize.X.Offset, self._MinHeight) })
		Tween(self._BodyWrap, Spring, { GroupTransparency = 1 })
	else
		Tween(self._Wrapper, Spring, { Size = self._FullSize })
		Tween(self._BodyWrap, Spring, { GroupTransparency = 0 })
	end
	if self._MinIcon then
		pcall(function() self._MinIcon:Destroy() end)
		self._MinIcon = nil
	end
	if Icons then
		local Ok, Result = pcall(function()
			return Icons.Image({
				Icon = IconName,
				Size = UDim2.fromOffset(14, 14),
				Colors = { Theme.TextDim },
			})
		end)
		if Ok and Result and Result.IconFrame then
			Result.IconFrame.Parent = self._MinBtn
			Result.IconFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			Result.IconFrame.Position = UDim2.fromScale(0.5, 0.5)
			self._MinIcon = Result.IconFrame
			self._MinBtn.Text = ""
		else
			self._MinBtn.Text = Fallback
		end
	else
		self._MinBtn.Text = Fallback
	end
	self:_PersistLayout()
end

function Panel:Hide()
	self._Hidden = true
	Tween(self._Wrapper, SpringFast, { Size = UDim2.fromOffset(self._FullSize.X.Offset, 0) })
	task.delay(0.3, function()
		if self._Hidden then self._Wrapper.Visible = false end
	end)
	self:_PersistLayout()
end

function Panel:Show()
	self._Hidden = false
	self._Wrapper.Visible = true
	self._Wrapper.Size = UDim2.fromOffset(self._FullSize.X.Offset, 0)
	if self._Minimized then
		Tween(self._Wrapper, Spring, { Size = UDim2.fromOffset(self._FullSize.X.Offset, self._MinHeight) })
	else
		Tween(self._Wrapper, Spring, { Size = self._FullSize })
	end
	self:_PersistLayout()
end

local function BuildSectionInto(BodyFrame, TitleOrOptions)
	local Self = setmetatable({}, Section)

	local Title, IconStr
	if typeof(TitleOrOptions) == "table" then
		Title = TitleOrOptions.Title or "Section"
		IconStr = TitleOrOptions.Icon
	else
		Title = TitleOrOptions or "Section"
	end

	local Container = Make("Frame", {
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = BodyFrame,
	})
	Corner(Container, 10)
	Stroke(Container, Theme.BorderSoft, 1, 0.2)

	local TitleOffset = 12
	if IconStr and Icons then
		local IconFrame = MakeIcon(IconStr, Container, UDim2.fromOffset(14, 14), Theme.Accent)
		if IconFrame then
			IconFrame.Position = UDim2.fromOffset(12, 10)
			TitleOffset = 30
		end
	end

	Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(TitleOffset, 8),
		Size = UDim2.new(1, -TitleOffset - 12, 0, 18),
		FontFace = FontBold,
		Text = Title,
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Container,
	})

	local Content = Make("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 30),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = Container,
	})
	Padding(Content, 0, 10, 10, 10)
	ListLayout(Content, 6)

	Self._Container = Container
	Self._Content = Content
	return Self
end

function Panel:AddSection(TitleOrOptions)
	local Self = BuildSectionInto(self._Body, TitleOrOptions)
	Self._Panel = self
	Self._Aurora = self._Aurora
	table.insert(self._Sections, Self)
	return Self
end

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

function Aurora:CreateWindow(Options)
	self:_EnsureInit()
	Options = Options or {}
	local Self = setmetatable({}, Window)
	Self._Aurora = self
	Self._Title = Options.Title or "Window"
	Self._Key = "Window_" .. (Options.Key or Self._Title)
	Self._Size = Options.Size or UDim2.fromOffset(560, 380)
	Self._Position = Options.Position or UDim2.fromOffset(120, 90)
	Self._SidebarW = Options.SidebarWidth or 140
	Self._Tabs = {}
	Self._ActiveTab = nil
	Self._Hidden = false

	local Saved = self._Layout[Self._Key]
	if typeof(Saved) == "table" then
		if Saved.X and Saved.Y then Self._Position = UDim2.fromOffset(Saved.X, Saved.Y) end
		if Saved.W and Saved.H then Self._Size = UDim2.fromOffset(Saved.W, Saved.H) end
		Self._Hidden = Saved.Hidden == true
	end

	local Wrapper = Make("Frame", {
		Name = "WindowWrap_" .. Self._Title,
		BackgroundTransparency = 1,
		Position = Self._Position,
		Size = Self._Size,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Parent = self._Screen,
	})
	Self._Wrapper = Wrapper

	local Clip = Make("CanvasGroup", {
		Name = "WindowClip",
		BackgroundColor3 = Theme.Background,
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		GroupTransparency = 0,
		Parent = Wrapper,
	})
	Corner(Clip, 12)
	local WinStroke = Stroke(Clip, Theme.Border, 1, 0.4)
	WinStroke.LineJoinMode = Enum.LineJoinMode.Round
	Self._Clip = Clip

	local Frame = Make("Frame", {
		Name = "Window_" .. Self._Title,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		Parent = Clip,
	})

	local Topbar = Make("Frame", {
		Name = "Topbar",
		BackgroundColor3 = Theme.Surface,
		Size = UDim2.new(1, 0, 0, 38),
		BorderSizePixel = 0,
		Parent = Frame,
	})
	Make("Frame", {
		BackgroundColor3 = Theme.BorderSoft,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -1),
		Size = UDim2.new(1, 0, 0, 1),
		Parent = Topbar,
	})

	Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -60, 1, 0),
		FontFace = FontMedium,
		Text = Self._Title,
		TextColor3 = Theme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Topbar,
	})

	local MinBtn = Make("TextButton", {
		BackgroundColor3 = Theme.SurfaceAlt,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(1, -28, 0.5, 0),
		Size = UDim2.fromOffset(22, 22),
		FontFace = FontBold,
		Text = "",
		TextColor3 = Theme.TextDim,
		TextSize = 14,
		AutoButtonColor = false,
		Parent = Topbar,
	})
	Corner(MinBtn, 6)
	local MinIcon
	if Icons then
		local Ok, Result = pcall(function()
			return Icons.Image({ Icon = "minus", Size = UDim2.fromOffset(14, 14), Colors = { Theme.TextDim } })
		end)
		if Ok and Result and Result.IconFrame then
			Result.IconFrame.Parent = MinBtn
			Result.IconFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			Result.IconFrame.Position = UDim2.fromScale(0.5, 0.5)
			MinIcon = Result.IconFrame
		end
	end
	if not MinIcon then MinBtn.Text = "-" end
	MinBtn.MouseEnter:Connect(function()
		Tween(MinBtn, SpringFast, { BackgroundTransparency = 0, TextColor3 = Theme.Accent })
		if MinIcon then pcall(function() Tween(MinIcon, SpringFast, { ImageColor3 = Theme.Accent }) end) end
	end)
	MinBtn.MouseLeave:Connect(function()
		Tween(MinBtn, SpringFast, { BackgroundTransparency = 1, TextColor3 = Theme.TextDim })
		if MinIcon then pcall(function() Tween(MinIcon, SpringFast, { ImageColor3 = Theme.TextDim }) end) end
	end)
	MinBtn.MouseButton1Click:Connect(function() Self:Hide() end)

	local Body = Make("Frame", {
		Name = "WindowBody",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 38),
		Size = UDim2.new(1, 0, 1, -38),
		BorderSizePixel = 0,
		Parent = Frame,
	})

	local Sidebar = Make("ScrollingFrame", {
		Name = "Sidebar",
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(0, Self._SidebarW, 1, 0),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Border,
		ScrollBarImageTransparency = 0.3,
		ClipsDescendants = true,
		Parent = Body,
	})
	Padding(Sidebar, 8, 6, 8, 6)
	ListLayout(Sidebar, 4)

	Make("Frame", {
		BackgroundColor3 = Theme.BorderSoft,
		BorderSizePixel = 0,
		Position = UDim2.new(0, Self._SidebarW, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		Parent = Body,
	})

	local ContentArea = Make("Frame", {
		Name = "ContentArea",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, Self._SidebarW + 1, 0, 0),
		Size = UDim2.new(1, -Self._SidebarW - 1, 1, 0),
		Parent = Body,
	})

	Self._Sidebar = Sidebar
	Self._ContentArea = ContentArea
	Self._Frame = Frame
	Self._Topbar = Topbar

	MakeDraggable(Wrapper, Topbar, Self)

	if Self._Hidden then
		Wrapper.Visible = false
	end

	if Options.ToggleKey then
		Self._ToggleKey = Options.ToggleKey
		Self._ToggleConn = UserInputService.InputBegan:Connect(function(Input, Processed)
			if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if UserInputService:GetFocusedTextBox() then return end
			if Input.KeyCode == Self._ToggleKey then
				Self:ToggleVisible()
				return
			end
			if Processed then return end
		end)
	end

	return Self
end

function Window:_PersistLayout()
	local Entry = self._Aurora._Layout[self._Key] or {}
	Entry.X = self._Wrapper.Position.X.Offset
	Entry.Y = self._Wrapper.Position.Y.Offset
	Entry.W = self._Wrapper.Size.X.Offset
	Entry.H = self._Wrapper.Size.Y.Offset
	Entry.Hidden = self._Hidden
	self._Aurora._Layout[self._Key] = Entry
	SaveLayout()
end

function Window:Hide()
	if self._Hidden then return end
	self._Hidden = true
	Tween(self._Clip, SpringFast, { GroupTransparency = 1 })
	task.delay(0.25, function()
		if self._Hidden then self._Wrapper.Visible = false end
	end)
	self:_PersistLayout()
end

function Window:Show()
	if not self._Hidden then return end
	self._Hidden = false
	self._Wrapper.Visible = true
	self._Clip.GroupTransparency = 1
	Tween(self._Clip, SpringFast, { GroupTransparency = 0 })
	self:_PersistLayout()
end

function Window:ToggleVisible()
	if self._Hidden then self:Show() else self:Hide() end
end

function Window:SetToggleKey(NewKey)
	self._ToggleKey = NewKey
end

function Window:AddTab(Options)
	Options = Options or {}
	local Self = setmetatable({}, Tab)
	Self._Window = self
	Self._Aurora = self._Aurora
	Self._Title = Options.Title or "Tab"
	Self._Sections = {}

	local Btn = Make("TextButton", {
		Name = "TabBtn_" .. Self._Title,
		BackgroundColor3 = Theme.SurfaceAlt,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 32),
		AutoButtonColor = false,
		Text = "",
		Parent = self._Sidebar,
	})
	Corner(Btn, 6)

	local LabelX = 12
	if Options.Icon and Icons then
		local IconFrame = MakeIcon(Options.Icon, Btn, UDim2.fromOffset(14, 14), Theme.TextDim)
		if IconFrame then
			IconFrame.AnchorPoint = Vector2.new(0, 0.5)
			IconFrame.Position = UDim2.new(0, 10, 0.5, 0)
			LabelX = 30
		end
	end

	local Label = Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(LabelX, 0),
		Size = UDim2.new(1, -LabelX - 8, 1, 0),
		FontFace = FontMedium,
		Text = Self._Title,
		TextColor3 = Theme.TextDim,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Btn,
	})

	local Body = Make("ScrollingFrame", {
		Name = "TabBody_" .. Self._Title,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.Border,
		ScrollBarImageTransparency = 0.3,
		ClipsDescendants = true,
		Visible = false,
		Parent = self._ContentArea,
	})
	Padding(Body, 10, 12, 12, 12)
	ListLayout(Body, 8)

	Self._Btn = Btn
	Self._Label = Label
	Self._Body = Body

	Btn.MouseButton1Click:Connect(function() self:SelectTab(Self) end)
	Btn.MouseEnter:Connect(function()
		if self._ActiveTab ~= Self then Tween(Btn, SpringFast, { BackgroundTransparency = 0 }) end
	end)
	Btn.MouseLeave:Connect(function()
		if self._ActiveTab ~= Self then Tween(Btn, SpringFast, { BackgroundTransparency = 1 }) end
	end)

	table.insert(self._Tabs, Self)
	if not self._ActiveTab then self:SelectTab(Self) end
	return Self
end

function Window:SelectTab(TargetTab)
	for _, T in ipairs(self._Tabs) do
		local IsActive = T == TargetTab
		T._Body.Visible = IsActive
		Tween(T._Btn, SpringFast, { BackgroundTransparency = IsActive and 0 or 1, BackgroundColor3 = IsActive and Theme.Accent or Theme.SurfaceAlt })
		Tween(T._Label, SpringFast, { TextColor3 = IsActive and Theme.OnAccent or Theme.TextDim })
	end
	self._ActiveTab = TargetTab
end

function Tab:AddSection(TitleOrOptions)
	local Self = BuildSectionInto(self._Body, TitleOrOptions)
	Self._Tab = self
	Self._Aurora = self._Aurora
	table.insert(self._Sections, Self)
	return Self
end

local function HookHover(Object, NormalKey, HoverKey, Property, TextObj)
	Property = Property or "BackgroundColor3"
	if typeof(NormalKey) ~= "string" then NormalKey = ReverseLookupThemeKey(NormalKey) or "Elevated" end
	if typeof(HoverKey) ~= "string" then HoverKey = ReverseLookupThemeKey(HoverKey) or "Accent" end

	local FlipsText = (HoverKey == "Accent" or HoverKey == "AccentHover")
	local TextTarget = TextObj or Object

	Object.MouseEnter:Connect(function()
		CancelTween(Object, Property)
		local T = TweenService:Create(Object, SpringFast, { [Property] = Theme[HoverKey] })
		TrackTween(Object, Property, T)
		T:Play()
		if FlipsText then
			CancelTween(TextTarget, "TextColor3")
			local Tt = TweenService:Create(TextTarget, SpringFast, { TextColor3 = Theme.OnAccent })
			TrackTween(TextTarget, "TextColor3", Tt)
			Tt:Play()
		end
	end)
	Object.MouseLeave:Connect(function()
		CancelTween(Object, Property)
		local T = TweenService:Create(Object, SpringFast, { [Property] = Theme[NormalKey] })
		TrackTween(Object, Property, T)
		T:Play()
		if FlipsText then
			CancelTween(TextTarget, "TextColor3")
			local Tt = TweenService:Create(TextTarget, SpringFast, { TextColor3 = Theme.Text })
			TrackTween(TextTarget, "TextColor3", Tt)
			Tt:Play()
		end
	end)
end

local function BindFlag(Aurora, Flag, Value, Setter)
	if not Flag then return end
	Aurora.Flags[Flag] = Value
	Aurora._FlagControls[Flag] = { Set = Setter }
	if Aurora._SavedConfig and Aurora._SavedConfig[Flag] ~= nil then
		local Decoded = DecodeValue(Aurora._SavedConfig[Flag])
		if Decoded ~= nil then
			Setter(Decoded, true)
		end
	end
end

function Section:AddLabel(Options)
	Options = Options or {}
	local Label = Make("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		FontFace = FontRegular,
		Text = Options.Text or "Label",
		TextColor3 = Theme.TextDim,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self._Content,
	})
	return {
		SetText = function(_, NewText) Label.Text = NewText end,
		Instance = Label,
	}
end

function Section:AddParagraph(Options)
	Options = Options or {}
	local Container = Make("Frame", {
		BackgroundColor3 = Theme.SurfaceAlt,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self._Content,
	})
	Corner(Container, 6)
	Padding(Container, 8, 10, 10, 10)
	local List = ListLayout(Container, 4)
	List.SortOrder = Enum.SortOrder.LayoutOrder

	local TitleLabel
	if Options.Title and Options.Title ~= "" then
		TitleLabel = Make("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 16),
			FontFace = FontBold,
			Text = Options.Title,
			TextColor3 = Theme.Text,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1,
			Parent = Container,
		})
	end

	local Body = Make("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		FontFace = FontRegular,
		Text = Options.Text or "",
		TextColor3 = Theme.TextDim,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		RichText = Options.RichText == true,
		LayoutOrder = 2,
		Parent = Container,
	})

	return {
		SetText = function(_, NewText) Body.Text = NewText end,
		SetTitle = function(_, NewTitle) if TitleLabel then TitleLabel.Text = NewTitle end end,
		Instance = Container,
	}
end

function Section:AddDivider()
	local Line = Make("Frame", {
		BackgroundColor3 = Theme.BorderSoft,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		Parent = self._Content,
	})
	return { Instance = Line }
end

function Section:AddButton(Options)
	Options = Options or {}
	local Button = Make("TextButton", {
		BackgroundColor3 = Theme.Elevated,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 30),
		FontFace = FontMedium,
		Text = Options.Text or "Button",
		TextColor3 = Theme.Text,
		TextSize = 12,
		AutoButtonColor = false,
		ClipsDescendants = true,
		Parent = self._Content,
	})
	Corner(Button, 6)
	HookHover(Button, "Elevated", "Accent")
	local IconFrame
	if Options.Icon and Icons then
		IconFrame = MakeIcon(Options.Icon, Button, UDim2.fromOffset(14, 14), Theme.Text)
	end
	if IconFrame then
		IconFrame.Size = UDim2.fromOffset(14, 14)
		IconFrame.AnchorPoint = Vector2.new(0, 0.5)
		IconFrame.Position = UDim2.new(0, 10, 0.5, 0)
		for _, Child in ipairs(IconFrame:GetChildren()) do
			if Child:IsA("ImageLabel") or Child:IsA("ImageButton") then
				Child.AnchorPoint = Vector2.new(0.5, 0.5)
				Child.Position = UDim2.fromScale(0.5, 0.5)
				Child.Size = UDim2.fromScale(1, 1)
			end
		end
		Button.Text = ""
		local BtnLabel = Make("TextLabel", {
			Name = "ButtonLabel",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 30, 0, 0),
			Size = UDim2.new(1, -40, 1, 0),
			FontFace = FontMedium,
			Text = Options.Text or "Button",
			TextColor3 = Theme.Text,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			Parent = Button,
		})
		HookHover(Button, "Elevated", "Accent", "BackgroundColor3", BtnLabel)
	end

	Button.MouseButton1Click:Connect(function()
		local Ripple = Make("Frame", {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.7,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(0, 0),
			Parent = Button,
		})
		Corner(Ripple, 100)
		Tween(Ripple, Spring, { Size = UDim2.fromOffset(Button.AbsoluteSize.X * 2, Button.AbsoluteSize.X * 2), BackgroundTransparency = 1 })
		task.delay(0.55, function() Ripple:Destroy() end)
		SafeCall(Options.Callback)
	end)

	return { Instance = Button }
end

function Section:AddToggle(Options)
	Options = Options or {}
	local Value = Options.Default == true
	local Flag = Options.Flag

	local Row = Make("Frame", {
		BackgroundColor3 = Theme.Elevated,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 32),
		Parent = self._Content,
	})
	Corner(Row, 6)

	local LabelOffset = 10
	if Options.Icon and Icons then
		local IconFrame = MakeIcon(Options.Icon, Row, UDim2.fromOffset(14, 14), Theme.TextDim)
		if IconFrame then
			IconFrame.AnchorPoint = Vector2.new(0, 0.5)
			IconFrame.Position = UDim2.new(0, 10, 0.5, 0)
			LabelOffset = 30
		end
	end

	Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(LabelOffset, 0),
		Size = UDim2.new(1, -LabelOffset - 50, 1, 0),
		FontFace = FontMedium,
		Text = Options.Text or "Toggle",
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})

	local Switch = Make("Frame", {
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(38, 20),
		Parent = Row,
	})
	Corner(Switch, 10)
	Stroke(Switch, Theme.Border, 1, 0.3)

	local Knob = Make("Frame", {
		BackgroundColor3 = Theme.Text,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		Parent = Switch,
	})
	Corner(Knob, 10)

	local Click = Make("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		Parent = Row,
	})

	local function Render(Animate)
		if Animate ~= false then
			Tween(Switch, SpringSnap, { BackgroundColor3 = Value and Theme.Accent or Theme.Surface })
			Tween(Knob, SpringSnap, { Position = Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) })
		else
			Switch.BackgroundColor3 = Value and Theme.Accent or Theme.Surface
			Knob.Position = Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		end
	end

	local function Set(NewValue, FromLoad)
		Value = NewValue == true
		if Flag then Aurora.Flags[Flag] = Value end
		Render(not FromLoad)
		if not FromLoad then SafeCall(Options.Callback, Value) end
	end

	Click.MouseButton1Click:Connect(function() Set(not Value) end)

	Render(false)
	BindFlag(Aurora, Flag, Value, Set)

	SafeCall(Options.Callback, Value)
	
	return {
		Set = function(_, V) Set(V) end,
		Get = function() return Value end,
		Instance = Row,
	}
end

function Section:AddSlider(Options)
	Options = Options or {}
	local Min = Options.Min or 0
	local Max = Options.Max or 100
	local Decimals = Options.Decimals or 0
	local Value = math.clamp(Options.Default or Min, Min, Max)
	local Flag = Options.Flag

	local function Round(N)
		local Mult = 10 ^ Decimals
		return math.floor(N * Mult + 0.5) / Mult
	end

	local Container = Make("Frame", {
		BackgroundColor3 = Theme.Elevated,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 48),
		Parent = self._Content,
	})
	Corner(Container, 6)

	local Title = Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 4),
		Size = UDim2.new(1, -20, 0, 18),
		FontFace = FontMedium,
		Text = Options.Text or "Slider",
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Container,
	})

	local ValueLabel = Make("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 4),
		Size = UDim2.fromOffset(60, 18),
		FontFace = FontBold,
		Text = tostring(Round(Value)),
		TextColor3 = Theme.Accent,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = Container,
	})

	local Track = Make("CanvasGroup", {
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(10, 28),
		Size = UDim2.new(1, -20, 0, 6),
		GroupTransparency = 0,
		Parent = Container,
	})
	Corner(Track, 3)

	local Fill = Make("Frame", {
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		Parent = Track,
	})

	local Knob = Make("Frame", {
		BackgroundColor3 = Theme.Text,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 10, 0, 31),
		Size = UDim2.fromOffset(10, 10),
		ZIndex = 3,
		Parent = Container,
	})
	Corner(Knob, 10)
	Stroke(Knob, Theme.Accent, 2, 0)

	local function Render(Animate)
		local Alpha = (Value - Min) / (Max - Min)
		local TrackW = Track.AbsoluteSize.X
		local KnobX = 10 + Alpha * TrackW
		if Animate ~= false then
			Tween(Fill, SpringFast, { Size = UDim2.new(Alpha, 0, 1, 0) })
			Tween(Knob, SpringFast, { Position = UDim2.new(0, KnobX, 0, 31) })
		else
			Fill.Size = UDim2.new(Alpha, 0, 1, 0)
			Knob.Position = UDim2.new(0, KnobX, 0, 31)
		end
		ValueLabel.Text = tostring(Round(Value))
	end

	local function Set(NewValue, FromLoad)
		Value = math.clamp(Round(NewValue), Min, Max)
		if Flag then Aurora.Flags[Flag] = Value end
		Render(not FromLoad)
		if not FromLoad then SafeCall(Options.Callback, Value) end
	end

	local Dragging = false
	local function UpdateFromInput(Input)
		local Alpha = math.clamp((Input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
		Set(Min + (Max - Min) * Alpha)
	end

	Track.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			UpdateFromInput(Input)
		end
	end)
	UserInputService.InputChanged:Connect(function(Input)
		if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			UpdateFromInput(Input)
		end
	end)
	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = false
		end
	end)

	Render(false)
	BindFlag(Aurora, Flag, Value, Set)

	return {
		Set = function(_, V) Set(V) end,
		Get = function() return Value end,
		Instance = Container,
	}
end

local _ActiveDropdown = nil

local function _CloseActiveDropdown()
	if _ActiveDropdown then
		pcall(_ActiveDropdown.Close)
		_ActiveDropdown = nil
	end
end

local _DropdownDismissConn = nil
local function _EnsureDropdownDismiss()
	if _DropdownDismissConn then return end
	_DropdownDismissConn = UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			task.defer(_CloseActiveDropdown)
		end
	end)
end

function Section:AddDropdown(Options)
	Options = Options or {}
	local Multi = Options.Multi == true
	local Items = Options.Options or {}
	local Flag = Options.Flag
	local Selected
	if Multi then
		Selected = {}
		if typeof(Options.Default) == "table" then
			for _, V in ipairs(Options.Default) do Selected[V] = true end
		end
	else
		Selected = Options.Default or (Items[1])
	end

	_EnsureDropdownDismiss()
	
	local Container = Make("Frame", {
		BackgroundColor3 = Theme.Elevated,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 32),
		ClipsDescendants = false,
		Parent = self._Content,
	})
	Corner(Container, 6)

	local Header = Make("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		FontFace = FontMedium,
		Text = "",
		ZIndex = 2,
		Parent = Container,
	})

	Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(0.5, 0, 1, 0),
		FontFace = FontMedium,
		Text = Options.Text or "Dropdown",
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 2,
		Parent = Header,
	})

	local ValueLabel = Make("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -28, 0.5, 0),
		Size = UDim2.new(0.5, -10, 1, 0),
		FontFace = FontRegular,
		Text = "",
		TextColor3 = Theme.TextDim,
		TextSize = 12,
		TextXAlignment = Multi and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 2,
		Parent = Header,
	})

	local Arrow
	if Icons then
		local Ok, Result = pcall(function()
			return Icons.Image({
				Icon = "chevron-down",
				Size = UDim2.fromOffset(16, 16),
				Colors = { Theme.TextDim },
			})
		end)
		if Ok and Result and Result.IconFrame then
			Result.IconFrame.Parent = Header
			Result.IconFrame.AnchorPoint = Vector2.new(1, 0.5)
			Result.IconFrame.Position = UDim2.new(1, -10, 0.5, 0)
			Result.IconFrame.Size = UDim2.fromOffset(16, 16)
			Result.IconFrame.ZIndex = 2
			for _, Child in ipairs(Result.IconFrame:GetChildren()) do
				if Child:IsA("ImageLabel") or Child:IsA("ImageButton") then
					Child.AnchorPoint = Vector2.new(0.5, 0.5)
					Child.Position = UDim2.fromScale(0.5, 0.5)
					Child.Size = UDim2.fromScale(1, 1)
				end
			end
			Arrow = Result.IconFrame
		end
	end
	if not Arrow then
		Arrow = Make("TextLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Size = UDim2.fromOffset(14, 14),
			FontFace = FontBold,
			Text = "v",
			TextColor3 = Theme.TextDim,
			TextSize = 11,
			ZIndex = 2,
			Parent = Header,
		})
	end
	
	local OverlayMenu = Make("Frame", {
		Name = "DropdownMenu",
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(200, 0),
		Position = UDim2.fromOffset(0, 0),
		Visible = false,
		ZIndex = 200,
		ClipsDescendants = true,
		Parent = Aurora._OverlayRoot or (Aurora._Screen),
	})
	Corner(OverlayMenu, 8)
	Stroke(OverlayMenu, Theme.Border, 1, 0.2)

	local HeaderH = Multi and 22 or 0
	local CloseBtn

	if Multi then
		CloseBtn = Make("TextButton", {
			Name = "CloseBtn",
			BackgroundColor3 = Theme.SurfaceAlt,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -4, 0, 4),
			Size = UDim2.fromOffset(16, 16),
			Text = "",
			AutoButtonColor = false,
			ZIndex = 211,
			Parent = OverlayMenu,
		})
		Corner(CloseBtn, 4)
		local CloseLabel = Make("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			FontFace = FontBold,
			Text = "x",
			TextColor3 = Theme.TextDim,
			TextSize = 11,
			ZIndex = 212,
			Parent = CloseBtn,
		})
		CloseBtn.MouseEnter:Connect(function()
			Tween(CloseBtn, SpringFast, { BackgroundColor3 = Theme.Danger })
			Tween(CloseLabel, SpringFast, { TextColor3 = Theme.OnAccent })
		end)
		CloseBtn.MouseLeave:Connect(function()
			Tween(CloseBtn, SpringFast, { BackgroundColor3 = Theme.SurfaceAlt })
			Tween(CloseLabel, SpringFast, { TextColor3 = Theme.TextDim })
		end)
	end

	local ItemsList = Make("Frame", {
		Name = "ItemsList",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, HeaderH),
		Size = UDim2.new(1, 0, 1, -HeaderH),
		ZIndex = 201,
		Parent = OverlayMenu,
	})
	Make("UIPadding", {
		Parent = ItemsList,
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
	})
	Make("UIListLayout", {
		Parent = ItemsList,
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local Open = false
	local Buttons = {}

	local function DisplayText()
		if Multi then
			local Names = {}
			for K, V in pairs(Selected) do if V then table.insert(Names, K) end end
			if #Names == 0 then return "None" end
			return table.concat(Names, ", ")
		end
		return tostring(Selected or "None")
	end

	local function UpdateButtons(Instant)
		for Name, Btn in pairs(Buttons) do
			local IsSel = Multi and (Selected[Name] == true) or (Selected == Name)
			local TargetBg = IsSel and Theme.Accent or Theme.Surface
			local TargetText = IsSel and Theme.OnAccent or Theme.TextDim
			if Instant then
				Btn.BackgroundColor3 = TargetBg
				Btn.TextColor3 = TargetText
			else
				Tween(Btn, SpringFast, { BackgroundColor3 = TargetBg, TextColor3 = TargetText })
			end
		end
		ValueLabel.Text = DisplayText()
	end

	local function CloseMenu()
		if not Open then return end
		Open = false
		Tween(Arrow, Spring, { Rotation = 0 })
		Tween(OverlayMenu, SpringFast, { Size = UDim2.fromOffset(OverlayMenu.Size.X.Offset, 0) })
		task.delay(0.3, function()
			if not Open then OverlayMenu.Visible = false end
		end)
	end

	if CloseBtn then
		CloseBtn.MouseButton1Click:Connect(function()
			CloseMenu()
			_ActiveDropdown = nil
		end)
	end

	local function Rebuild()
		for _, Child in ipairs(ItemsList:GetChildren()) do
			if Child:IsA("TextButton") then Child:Destroy() end
		end
		Buttons = {}
		for _, Name in ipairs(Items) do
			local Btn = Make("TextButton", {
				BackgroundColor3 = Theme.Surface,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 26),
				FontFace = FontRegular,
				Text = Name,
				TextColor3 = Theme.TextDim,
				TextSize = 12,
				AutoButtonColor = false,
				ZIndex = 201,
				Parent = ItemsList,
			})
			Corner(Btn, 5)
			Buttons[Name] = Btn
			Btn.MouseButton1Click:Connect(function()
				if Multi then
					Selected[Name] = not Selected[Name]
				else
					Selected = Name
					CloseMenu()
					_ActiveDropdown = nil
				end
				if Flag then Aurora.Flags[Flag] = Selected end
				UpdateButtons(false)
				SafeCall(Options.Callback, Selected)
			end)
		end
		UpdateButtons(true)
	end

	local function OpenMenu()
		_CloseActiveDropdown()
		Open = true

		pcall(function()
			if Aurora._OverlayRoot then Aurora._OverlayRoot.Parent = Aurora._Screen end
		end)

		local RowH = 26
		local Gap = 2
		local Pad = 8
		local Rows = math.min(#Items, 8)
		local TargetH = HeaderH + Rows * RowH + math.max(0, Rows - 1) * Gap + Pad
		if #Items == 0 then TargetH = HeaderH + 32 end
		
		local AbsPos = Container.AbsolutePosition
		local AbsSize = Container.AbsoluteSize
		local MenuW = AbsSize.X
		local ScreenH = Aurora._Screen.AbsoluteSize.Y
		
		local SpaceBelow = ScreenH - (AbsPos.Y + AbsSize.Y)
		local PosY
		if SpaceBelow >= TargetH + 4 then
			PosY = AbsPos.Y + AbsSize.Y + 4
		else
			PosY = AbsPos.Y - TargetH - 4
		end

		OverlayMenu.Position = UDim2.fromOffset(AbsPos.X, PosY)
		OverlayMenu.Size = UDim2.fromOffset(MenuW, 0)
		OverlayMenu.Visible = true

		Tween(Arrow, Spring, { Rotation = 180 })
		Tween(OverlayMenu, Spring, { Size = UDim2.fromOffset(MenuW, TargetH) })

		_ActiveDropdown = { Close = CloseMenu }
	end

	Header.MouseButton1Click:Connect(function()
		if Open then
			CloseMenu()
			_ActiveDropdown = nil
		else
			OpenMenu()
		end
	end)
	
	Header.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			
		end
	end)
	OverlayMenu.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			
		end
	end)

	local function Set(NewValue, FromLoad)
		if Multi then
			Selected = {}
			if typeof(NewValue) == "table" then
				for K, V in pairs(NewValue) do
					if typeof(K) == "number" then Selected[V] = true else Selected[K] = V end
				end
			end
		else
			Selected = NewValue
		end
		if Flag then Aurora.Flags[Flag] = Selected end
		UpdateButtons(FromLoad == true)
		if not FromLoad then SafeCall(Options.Callback, Selected) end
	end

	local function SetOptions(NewOptions)
		Items = NewOptions or {}
		if not Multi and not table.find(Items, Selected) then
			Selected = Items[1]
		end
		Rebuild()
	end

	Rebuild()
	BindFlag(Aurora, Flag, Selected, Set)

	return {
		Set = function(_, V) Set(V) end,
		Get = function() return Selected end,
		SetOptions = function(_, O) SetOptions(O) end,
		Instance = Container,
	}
end

function Section:AddKeybind(Options)
	Options = Options or {}
	local Key = Options.Default or Enum.KeyCode.E
	local Flag = Options.Flag
	local Listening = false

	local Row = Make("Frame", {
		BackgroundColor3 = Theme.Elevated,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 32),
		Parent = self._Content,
	})
	Corner(Row, 6)

	Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -80, 1, 0),
		FontFace = FontMedium,
		Text = Options.Text or "Keybind",
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})

	local Btn = Make("TextButton", {
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(64, 22),
		FontFace = FontBold,
		Text = Key.Name,
		TextColor3 = Theme.Text,
		TextSize = 11,
		AutoButtonColor = false,
		Parent = Row,
	})
	Corner(Btn, 4)
	Stroke(Btn, Theme.Border, 1, 0.3)

	local function Set(NewKey, FromLoad)
		Key = NewKey
		Btn.Text = Key.Name
		if Flag then Aurora.Flags[Flag] = Key end
		if not FromLoad then SafeCall(Options.Changed, Key) end
	end

	Btn.MouseButton1Click:Connect(function()
		Listening = true
		Btn.Text = "..."
		Btn.TextColor3 = Theme.Accent
	end)

	UserInputService.InputBegan:Connect(function(Input, Processed)
		if Listening and Input.UserInputType == Enum.UserInputType.Keyboard then
			Listening = false
			Btn.TextColor3 = Theme.Text
			Set(Input.KeyCode)
			return
		end
		if Processed then return end
		if UserInputService:GetFocusedTextBox() then return end
		if not Listening and Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Key then
			SafeCall(Options.Callback)
		end
	end)

	BindFlag(Aurora, Flag, Key, Set)

	return {
		Set = function(_, K) Set(K) end,
		Get = function() return Key end,
		Instance = Row,
	}
end

function Section:AddTextbox(Options)
	Options = Options or {}
	local Flag = Options.Flag
	local Value = Options.Default or ""

	local Row = Make("Frame", {
		BackgroundColor3 = Theme.Elevated,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 32),
		Parent = self._Content,
	})
	Corner(Row, 6)

	Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(0.4, 0, 1, 0),
		FontFace = FontMedium,
		Text = Options.Text or "Input",
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Row,
	})

	local BoxFrame = Make("Frame", {
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.new(0.55, 0, 0, 22),
		Parent = Row,
	})
	Corner(BoxFrame, 4)
	local BoxStroke = Stroke(BoxFrame, Theme.Border, 1, 0.3)

	local Box = Make("TextBox", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -10, 1, 0),
		Position = UDim2.fromOffset(5, 0),
		FontFace = FontRegular,
		Text = Value,
		PlaceholderText = Options.Placeholder or "",
		TextColor3 = Theme.Text,
		PlaceholderColor3 = Theme.TextMuted,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Parent = BoxFrame,
	})

	Box.Focused:Connect(function() Tween(BoxStroke, SpringFast, { Color = Theme.Accent, Transparency = 0 }) end)
	Box.FocusLost:Connect(function(Enter)
		Tween(BoxStroke, SpringFast, { Color = Theme.Border, Transparency = 0.3 })
		Value = Box.Text
		if Flag then Aurora.Flags[Flag] = Value end
		SafeCall(Options.Callback, Value, Enter)
	end)

	local function Set(NewValue, FromLoad)
		Value = tostring(NewValue or "")
		Box.Text = Value
		if Flag then Aurora.Flags[Flag] = Value end
		if not FromLoad then SafeCall(Options.Callback, Value, false) end
	end

	BindFlag(Aurora, Flag, Value, Set)

	return {
		Set = function(_, V) Set(V) end,
		Get = function() return Value end,
		Instance = Row,
	}
end

function Section:AddColorPicker(Options)
	Options = Options or {}
	local Flag = Options.Flag
	local Value = Options.Default or Color3.fromRGB(255, 255, 255)
	local H, S, V = Color3.toHSV(Value)
	local Open = false

	local Container = Make("Frame", {
		BackgroundColor3 = Theme.Elevated,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 32),
		ClipsDescendants = true,
		Parent = self._Content,
	})
	Corner(Container, 6)

	local Header = Make("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 32),
		Text = "",
		Parent = Container,
	})

	Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -50, 1, 0),
		FontFace = FontMedium,
		Text = Options.Text or "Color",
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Header,
	})

	local Preview = Make("Frame", {
		BackgroundColor3 = Value,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(28, 18),
		Parent = Header,
	})
	Corner(Preview, 4)
	Stroke(Preview, Theme.Border, 1, 0.2)

	local Picker = Make("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 38),
		Size = UDim2.new(1, -20, 0, 130),
		Parent = Container,
	})

	local SV = Make("ImageLabel", {
		BackgroundColor3 = Color3.fromHSV(H, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 90),
		Image = "rbxassetid://4155801252",
		Parent = Picker,
	})
	Corner(SV, 4)

	local SVCursor = Make("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(10, 10),
		Parent = SV,
	})
	Corner(SVCursor, 10)
	Stroke(SVCursor, Color3.new(1, 1, 1), 2, 0)

	local HueBar = Make("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 98),
		Size = UDim2.new(1, 0, 0, 12),
		Parent = Picker,
	})
	Corner(HueBar, 4)
	Make("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.166, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.666, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
		}),
		Parent = HueBar,
	})

	local HueCursor = Make("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 4, 1, 4),
		Parent = HueBar,
	})
	Corner(HueCursor, 2)
	Stroke(HueCursor, Color3.new(0, 0, 0), 1, 0.4)

	local HexBox = Make("TextBox", {
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 116),
		Size = UDim2.new(1, 0, 0, 18),
		FontFace = FontBold,
		Text = "#FFFFFF",
		TextColor3 = Theme.Text,
		TextSize = 11,
		Parent = Picker,
	})
	Corner(HexBox, 3)

	local function Render()
		Value = Color3.fromHSV(H, S, V)
		SV.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
		SVCursor.Position = UDim2.new(S, 0, 1 - V, 0)
		HueCursor.Position = UDim2.new(H, 0, 0.5, 0)
		Preview.BackgroundColor3 = Value
		HexBox.Text = ("#%02X%02X%02X"):format(math.floor(Value.R * 255 + 0.5), math.floor(Value.G * 255 + 0.5), math.floor(Value.B * 255 + 0.5))
	end

	local function Fire(FromLoad)
		Render()
		if Flag then Aurora.Flags[Flag] = Value end
		if not FromLoad then SafeCall(Options.Callback, Value) end
	end

	local DraggingSV, DraggingHue = false, false

	SV.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			DraggingSV = true
			local X = math.clamp((Input.Position.X - SV.AbsolutePosition.X) / SV.AbsoluteSize.X, 0, 1)
			local Y = math.clamp((Input.Position.Y - SV.AbsolutePosition.Y) / SV.AbsoluteSize.Y, 0, 1)
			S, V = X, 1 - Y
			Fire(false)
		end
	end)
	HueBar.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			DraggingHue = true
			H = math.clamp((Input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
			Fire(false)
		end
	end)
	UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		if DraggingSV then
			local X = math.clamp((Input.Position.X - SV.AbsolutePosition.X) / SV.AbsoluteSize.X, 0, 1)
			local Y = math.clamp((Input.Position.Y - SV.AbsolutePosition.Y) / SV.AbsoluteSize.Y, 0, 1)
			S, V = X, 1 - Y
			Fire(false)
		end
		if DraggingHue then
			H = math.clamp((Input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
			Fire(false)
		end
	end)
	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			DraggingSV = false
			DraggingHue = false
		end
	end)

	HexBox.FocusLost:Connect(function()
		local Hex = HexBox.Text:gsub("#", "")
		if #Hex == 6 then
			local R = tonumber(Hex:sub(1, 2), 16)
			local G = tonumber(Hex:sub(3, 4), 16)
			local B = tonumber(Hex:sub(5, 6), 16)
			if R and G and B then
				H, S, V = Color3.toHSV(Color3.fromRGB(R, G, B))
				Fire(false)
				return
			end
		end
		Render()
	end)

	Header.MouseButton1Click:Connect(function()
		Open = not Open
		Tween(Container, Spring, { Size = UDim2.new(1, 0, 0, Open and 178 or 32) })
	end)

	local function Set(NewColor, FromLoad)
		if typeof(NewColor) ~= "Color3" then return end
		H, S, V = Color3.toHSV(NewColor)
		Fire(FromLoad)
	end

	Render()
	BindFlag(Aurora, Flag, Value, Set)

	return {
		Set = function(_, C) Set(C) end,
		Get = function() return Value end,
		Instance = Container,
	}
end

function Section:AddProgressBar(Options)
	Options = Options or {}
	local Flag = Options.Flag
	local Value = math.clamp(Options.Default or 0, 0, 1)
	local BarColor = Options.Color or Theme.Accent

	local Container = Make("Frame", {
		BackgroundColor3 = Theme.Elevated,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 44),
		Parent = self._Content,
	})
	Corner(Container, 6)

	local Title = Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 4),
		Size = UDim2.new(1, -70, 0, 16),
		FontFace = FontMedium,
		Text = Options.Text or "Progress",
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Container,
	})

	local Percent = Make("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 4),
		Size = UDim2.fromOffset(50, 16),
		FontFace = FontBold,
		Text = "0%",
		TextColor3 = BarColor,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = Container,
	})

	local Track = Make("Frame", {
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(10, 24),
		Size = UDim2.new(1, -20, 0, 10),
		ClipsDescendants = false,
		Parent = Container,
	})
	Corner(Track, 5)

	local FillWrap = Make("CanvasGroup", {
		BackgroundColor3 = BarColor,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		GroupTransparency = 0,
		Parent = Track,
	})
	local FillCorner = Make("UICorner", { CornerRadius = UDim.new(0, 5), Parent = FillWrap })

	local Fill = FillWrap

	local Sheen = Make("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, -40, 0.5, 0),
		Size = UDim2.new(0, 40, 1, 0),
		Visible = false,
		Parent = FillWrap,
	})
	Make("UIGradient", {
		Color = ColorSequence.new(Color3.new(1, 1, 1)),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0.65),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Rotation = 20,
		Parent = Sheen,
	})

	local SheenAlive = false
	local SheenTask

	local function StopSheen()
		SheenAlive = false
		Sheen.Visible = false
	end

	local function StartSheen()
		if SheenAlive then return end
		SheenAlive = true
		Sheen.Visible = true
		SheenTask = task.spawn(function()
			while SheenAlive do
				if not Fill.Parent then break end
				local Width = Fill.AbsoluteSize.X
				if Width < 4 then
					task.wait(0.15)
				else
					Sheen.Position = UDim2.new(0, -40, 0.5, 0)
					local Step = TweenService:Create(Sheen, TweenInfo.new(1.1, Enum.EasingStyle.Linear), {
						Position = UDim2.new(0, Width + 4, 0.5, 0),
					})
					Step:Play()
					Step.Completed:Wait()
					if not SheenAlive then break end
					task.wait(0.5)
				end
			end
		end)
	end

	local _CornerTask
	local function Render(Animate)
		local Pct = math.floor(Value * 100 + 0.5)
		Percent.Text = Pct .. "%"
		if Animate ~= false then
			Tween(FillWrap, Spring, { Size = UDim2.new(Value, 0, 1, 0) })
		else
			FillWrap.Size = UDim2.new(Value, 0, 1, 0)
		end
		if _CornerTask then
			pcall(function() _CornerTask:Disconnect() end)
			_CornerTask = nil
		end
		local Elapsed = 0
		_CornerTask = RunService.Heartbeat:Connect(function(Dt)
			Elapsed = Elapsed + Dt
			if not FillWrap.Parent then
				_CornerTask:Disconnect()
				_CornerTask = nil
				return
			end
			local W = FillWrap.AbsoluteSize.X
			local H = FillWrap.AbsoluteSize.Y
			local Cap = math.min(5, math.floor(math.min(W, H) * 0.5))
			FillCorner.CornerRadius = UDim.new(0, math.max(0, Cap))
			if Elapsed > 0.7 then
				_CornerTask:Disconnect()
				_CornerTask = nil
			end
		end)
		if Value > 0.001 and Value < 0.999 then
			StartSheen()
		else
			StopSheen()
		end
	end

	local function Set(NewValue, FromLoad)
		Value = math.clamp(tonumber(NewValue) or 0, 0, 1)
		if Flag then Aurora.Flags[Flag] = Value end
		Render(not FromLoad)
		if not FromLoad then SafeCall(Options.Callback, Value) end
	end

	local function SetColor(NewColor)
		BarColor = NewColor
		FillWrap.BackgroundColor3 = BarColor
		Percent.TextColor3 = BarColor
	end

	local function SetText(NewText)
		Title.Text = NewText
	end

	Render(false)
	BindFlag(Aurora, Flag, Value, Set)

	return {
		Set = function(_, V) Set(V) end,
		Get = function() return Value end,
		SetColor = function(_, C) SetColor(C) end,
		SetText = function(_, T) SetText(T) end,
		Instance = Container,
	}
end

function Section:AddButtonBind(Options)
	Options = Options or {}
	local Key = Options.Default or Enum.KeyCode.E
	local Flag = Options.Flag
	local Listening = false

	local Row = Make("Frame", {
		BackgroundColor3 = Theme.Elevated,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 32),
		ClipsDescendants = true,
		Parent = self._Content,
	})
	Corner(Row, 6)
	
	local BtnRegion = Make("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -84, 1, 0),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 2,
		Parent = Row,
	})
	
	local LabelX = 10
	if Options.Icon and Icons then
		local IconFrame = MakeIcon(Options.Icon, Row, UDim2.fromOffset(14, 14), Theme.TextDim)
		if IconFrame then
			IconFrame.AnchorPoint = Vector2.new(0, 0.5)
			IconFrame.Position = UDim2.new(0, 10, 0.5, 0)
			IconFrame.ZIndex = 3
			LabelX = 30
		end
	end

	local BtnLabel = Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(LabelX, 0),
		Size = UDim2.new(1, -84 - LabelX, 1, 0),
		FontFace = FontMedium,
		Text = Options.Text or "Action",
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 3,
		Parent = Row,
	})
	
	Make("Frame", {
		BackgroundColor3 = Theme.BorderSoft,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -80, 0, 4),
		Size = UDim2.fromOffset(1, 24),
		ZIndex = 2,
		Parent = Row,
	})
	
	local KeyBtn = Make("TextButton", {
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(66, 22),
		FontFace = FontBold,
		Text = Key.Name,
		TextColor3 = Theme.Text,
		TextSize = 11,
		AutoButtonColor = false,
		ZIndex = 3,
		Parent = Row,
	})
	Corner(KeyBtn, 4)
	Stroke(KeyBtn, Theme.Border, 1, 0.3)
	
	BtnRegion.MouseEnter:Connect(function()
		Tween(Row, SpringFast, { BackgroundColor3 = Theme.Accent })
		Tween(BtnLabel, SpringFast, { TextColor3 = Theme.OnAccent })
	end)
	BtnRegion.MouseLeave:Connect(function()
		Tween(Row, SpringFast, { BackgroundColor3 = Theme.Elevated })
		Tween(BtnLabel, SpringFast, { TextColor3 = Theme.Text })
	end)
	
	BtnRegion.MouseButton1Click:Connect(function()
		local Ripple = Make("Frame", {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.7,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(0, 0),
			Parent = Row,
		})
		Corner(Ripple, 100)
		Tween(Ripple, Spring, {
			Size = UDim2.fromOffset(Row.AbsoluteSize.X * 2, Row.AbsoluteSize.X * 2),
			BackgroundTransparency = 1,
		})
		task.delay(0.55, function() Ripple:Destroy() end)
		SafeCall(Options.Callback, Key)
	end)
	
	local function SetKey(NewKey, FromLoad)
		Key = NewKey
		KeyBtn.Text = Key.Name
		if Flag then Aurora.Flags[Flag] = Key end
		if not FromLoad then SafeCall(Options.Changed, Key) end
	end

	KeyBtn.MouseButton1Click:Connect(function()
		if Listening then return end
		Listening = true
		KeyBtn.Text = "..."
		KeyBtn.TextColor3 = Theme.Accent
	end)

	UserInputService.InputBegan:Connect(function(Input, Processed)
		if Listening and Input.UserInputType == Enum.UserInputType.Keyboard then
			Listening = false
			KeyBtn.TextColor3 = Theme.Text
			SetKey(Input.KeyCode)
			return
		end
		if Processed then return end
		if UserInputService:GetFocusedTextBox() then return end
		if not Listening and Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Key then
			SafeCall(Options.Callback, Key)
		end
	end)

	BindFlag(Aurora, Flag, Key, SetKey)

	return {
		SetKey = function(_, K) SetKey(K) end,
		GetKey = function() return Key end,
		Instance = Row,
	}
end

function Aurora:Notify(Options)
	self:_EnsureInit()
	Options = Options or {}
	local Title = Options.Title or "Notification"
	local Text = Options.Text or ""
	local Duration = Options.Duration or 4
	local Kind = Options.Type or "Info"
	local AccentColor = ({
		Info = Theme.Info,
		Success = Theme.Success,
		Warning = Theme.Warning,
		Danger = Theme.Danger,
		Error = Theme.Danger,
	})[Kind] or Theme.Info

	local Width = 300
	local Height = 64

	local Wrap = Make("CanvasGroup", {
		Name = "NotificationWrap",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(Width, Height),
		Position = UDim2.fromOffset(Width + 40, 0),
		GroupTransparency = 0,
		Parent = self._NotifRoot,
	})

	local Card = Make("Frame", {
		Name = "Notification",
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
		Parent = Wrap,
	})
	Corner(Card, 8)
	Stroke(Card, Theme.Border, 1, 0.2)

	local AccentBar = Make("Frame", {
		BackgroundColor3 = AccentColor,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 3, 1, -12),
		Position = UDim2.fromOffset(8, 6),
		Parent = Card,
	})
	Corner(AccentBar, 2)

	local TextOffset = 20
	if Options.Icon and Icons then
		local IconFrame = MakeIcon(Options.Icon, Card, UDim2.fromOffset(18, 18), AccentColor)
		if IconFrame then
			IconFrame.AnchorPoint = Vector2.new(0, 0.5)
			IconFrame.Position = UDim2.new(0, 18, 0.5, -2)
			TextOffset = 44
		end
	end

	local TitleLabel = Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(TextOffset, 8),
		Size = UDim2.new(1, -TextOffset - 8, 0, 16),
		Text = Title,
		TextColor3 = Theme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = Card,
	})
	ApplyInter(TitleLabel, "SemiBold")

	local BodyLabel = Make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(TextOffset, 26),
		Size = UDim2.new(1, -TextOffset - 8, 0, 30),
		Text = Text,
		TextColor3 = Theme.TextDim,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = Card,
	})
	ApplyInter(BodyLabel, "Regular")

	local TrackBG = Make("Frame", {
		BackgroundColor3 = Theme.BorderSoft,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -2),
		Size = UDim2.new(1, 0, 0, 2),
		Parent = Card,
	})

	local Bar = Make("Frame", {
		BackgroundColor3 = AccentColor,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = TrackBG,
	})

	Tween(Wrap, Spring, { Position = UDim2.fromOffset(0, 0) })
	Tween(Bar, TweenInfo.new(Duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) })

	task.delay(Duration, function()
		Tween(Wrap, SpringFast, { Position = UDim2.fromOffset(Width + 40, 0), GroupTransparency = 1 })
		task.wait(0.3)
		Wrap:Destroy()
	end)
end

function Aurora:SaveConfig()
	self:_EnsureInit()
	local Data = {}
	for Flag, _ in pairs(self._FlagControls) do
		Data[Flag] = EncodeValue(self.Flags[Flag])
	end
	self._SavedConfig = Data
	return WriteJson(ConfigFile, Data)
end

function Aurora:LoadConfig()
	self:_EnsureInit()
	local Data = ReadJson(ConfigFile)
	if typeof(Data) ~= "table" then return false end
	self._SavedConfig = Data
	for Flag, Encoded in pairs(Data) do
		local Ctrl = self._FlagControls[Flag]
		if Ctrl then
			local Decoded = DecodeValue(Encoded)
			Ctrl.Set(Decoded, true)
		end
	end
	return true
end

function Aurora:Destroy()
	for _, Conn in pairs(self._Connections) do
		if typeof(Conn) == "RBXScriptConnection" then Conn:Disconnect() end
	end
	if self._Screen then self._Screen:Destroy() end
	self._Initialized = false
	self._Panels = {}
	self._FlagControls = {}
end

return Aurora
