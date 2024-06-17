repeat task.wait() until game:IsLoaded()

local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local stats = game:GetService("Stats")

local viewport = workspace.CurrentCamera.ViewportSize
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local mouse = players.LocalPlayer:GetMouse()

local zindexcount = 999
local zindexcount2 = 999

local Library = {
	tweenInfoDragSpeed = 0.15,
	tweenInfoFadeSpeed = 0.3,
	tweenInfoEasingStyle = Enum.EasingStyle.Sine,
	performanceDrag = true,
	Sections = {};
	Flags = {},
	UnnamedFlags = 0,
	ThemeObjects = {},
	LightContrastObjects = {},
	DarkContrastObjects = {},
	OutlineObjects = {},
	InnerOutlineObjects = {},
	TextObjects = {},
	InlineObjects = {},
	Theme = {
		Accent = Color3.fromRGB(0, 255, 0),
		InlineContrast = Color3.fromRGB(18, 18, 18),
		LightContrast = Color3.fromRGB(26, 26, 26),
		DarkContrast = Color3.fromRGB(20, 20, 20),
		Outline = Color3.fromRGB(20, 20, 20),
		InnerOutline = Color3.fromRGB(26, 26, 26),
		TextColor = Color3.fromRGB(255, 255, 255),
	},
}

Library.Sections.__index = Library.Sections

local newInfo = TweenInfo.new

local keys = {
	[Enum.KeyCode.LeftShift] = "L-SHIFT",
	[Enum.KeyCode.RightShift] = "R-SHIFT",
	[Enum.KeyCode.LeftControl] = "L-CTRL",
	[Enum.KeyCode.RightControl] = "R-CTRL",
	[Enum.KeyCode.LeftAlt] = "L-ALT",
	[Enum.KeyCode.RightAlt] = "R-ALT",
	[Enum.KeyCode.CapsLock] = "CAPS",
	[Enum.KeyCode.One] = "1",
	[Enum.KeyCode.Two] = "2",
	[Enum.KeyCode.Three] = "3",
	[Enum.KeyCode.Four] = "4",
	[Enum.KeyCode.Five] = "5",
	[Enum.KeyCode.Six] = "6",
	[Enum.KeyCode.Seven] = "7",
	[Enum.KeyCode.Eight] = "8",
	[Enum.KeyCode.Nine] = "9",
	[Enum.KeyCode.Zero] = "0",
	[Enum.KeyCode.KeypadOne] = "NUM1",
	[Enum.KeyCode.KeypadTwo] = "NUM2",
	[Enum.KeyCode.KeypadThree] = "NUM3",
	[Enum.KeyCode.KeypadFour] = "NUM4",
	[Enum.KeyCode.KeypadFive] = "NUM5",
	[Enum.KeyCode.KeypadSix] = "NUM6",
	[Enum.KeyCode.KeypadSeven] = "NUM7",
	[Enum.KeyCode.KeypadEight] = "NUM8",
	[Enum.KeyCode.KeypadNine] = "NUM9",
	[Enum.KeyCode.KeypadZero] = "NUM0",
	[Enum.KeyCode.Minus] = "-",
	[Enum.KeyCode.Equals] = "=",
	[Enum.KeyCode.Tilde] = "~",
	[Enum.KeyCode.LeftBracket] = "[",
	[Enum.KeyCode.RightBracket] = "]",
	[Enum.KeyCode.RightParenthesis] = ")",
	[Enum.KeyCode.LeftParenthesis] = "(",
	[Enum.KeyCode.Semicolon] = ";",
	[Enum.KeyCode.Quote] = "'",
	[Enum.KeyCode.BackSlash] = "\\",
	[Enum.KeyCode.Comma] = ",",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Slash] = "/",
	[Enum.KeyCode.Asterisk] = "*",
	[Enum.KeyCode.Plus] = "+",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Backquote] = "`",
	[Enum.UserInputType.MouseButton1] = "MB1",
	[Enum.UserInputType.MouseButton2] = "MB2",
	[Enum.UserInputType.MouseButton3] = "MB3"
}

local Notifications = {}
local Notifications2 = {}
local Dragging = {Gui = nil, True = false}
local Draggables = {}
local isFadedOut = false
local Debounce = false
local originalTransparencies = {}
local originalTransparencies2 = {}

function Library:Validate(defaults, options)
	for i, v in pairs(defaults) do
		if options[i] == nil then
			options[i] = v
		end
	end
	return options
end
--
function Library:tween(object, goal, callback)
	local tween = tweenService:Create(object, tweenInfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end
--
local function GetDictionaryLength(Dictionary: table)
	local Length = 1
	for _ in pairs(Dictionary) do
		Length += 1
	end
	return Length
end
--
function Library:NewFlag()
	Library.UnnamedFlags += 1
	--
	return tostring(Library.UnnamedFlags)
end
--
function Library:ChangeTheme(Color, Type)
	if Type == "Accent" then
		Library.Theme.Accent = Color

		for obj, theme in next, Library.ThemeObjects do
			if theme:IsA("Frame") or theme:IsA("TextButton") then
				theme.BackgroundColor3 = Color
			elseif theme:IsA("TextLabel") then
				theme.TextColor3 = Color
			elseif theme:IsA("ImageLabel") or theme:IsA("ImageButton") then
				theme.ImageColor3 = Color
			elseif theme:IsA("ScrollingFrame") then
				theme.ScrollBarImageColor3 = Color
			elseif theme:IsA("UIStroke") then
				theme.Color = Color
			end
		end
	elseif Type == "InlineContrast" then
		for obj, theme in next, Library.InlineObjects do
			if theme:IsA("Frame") or theme:IsA("TextButton") then
				theme.BackgroundColor3 = Color
			elseif theme:IsA("TextLabel") then
				theme.TextColor3 = Color
			elseif theme:IsA("ImageLabel") or theme:IsA("ImageButton") then
				theme.ImageColor3 = Color
			elseif theme:IsA("ScrollingFrame") then
				theme.ScrollBarImageColor3 = Color
			elseif theme:IsA("UIStroke") then
				theme.Color = Color
			end
		end
	elseif Type == "TextColor" then
		Library.Theme.TextColor = Color

		for obj, theme in next, Library.TextObjects do
			if theme:IsA("TextButton") then
				theme.BackgroundColor3 = Color
			elseif theme:IsA("TextLabel") then
				theme.TextColor3 = Color
			end
		end
	elseif Type == "LightContrast" then
		Library.Theme.LightContrast = Color

		for obj, theme in next, Library.LightContrastObjects do
			if theme:IsA("Frame") or theme:IsA("TextButton") then
				theme.BackgroundColor3 = Color
			elseif theme:IsA("TextLabel") then
				theme.TextColor3 = Color
			elseif theme:IsA("ImageLabel") or theme:IsA("ImageButton") then
				theme.ImageColor3 = Color
			elseif theme:IsA("ScrollingFrame") then
				theme.ScrollBarImageColor3 = Color
			elseif theme:IsA("UIStroke") then
				theme.Color = Color
			end
		end
	elseif Type == "DarkContrast" then
		Library.Theme.DarkContrast = Color

		for obj, theme in next, Library.DarkContrastObjects do
			if theme:IsA("Frame") or theme:IsA("TextButton") then
				theme.BackgroundColor3 = Color
			elseif theme:IsA("TextLabel") then
				theme.TextColor3 = Color
			elseif theme:IsA("ImageLabel") or theme:IsA("ImageButton") then
				theme.ImageColor3 = Color
			elseif theme:IsA("ScrollingFrame") then
				theme.ScrollBarImageColor3 = Color
			elseif theme:IsA("UIStroke") then
				theme.Color = Color
			end
		end
	elseif Type == "Outline" then
		Library.Theme.Outline = Color

		for obj, theme in next, Library.OutlineObjects do
			if theme:IsA("UIStroke") then
				theme.Color = Color
			end
		end
	elseif Type == "InnerOutline" then
		Library.Theme.InnerOutline = Color

		for obj, theme in next, Library.InnerOutlineObjects do
			if theme:IsA("UIStroke") then
				theme.Color = Color
			end
		end
	end
end
--
function Library:IsMouseOverFrame(Frame)
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize

	if mouse.X >= AbsPos.X and mouse.X <= AbsPos.X + AbsSize.X
		and mouse.Y >= AbsPos.Y and mouse.Y <= AbsPos.Y + AbsSize.Y then

		return true
	end
end
--
local Section = Library.Sections
--
function Library:Window(options)
	options = Library:Validate({
		Name = "UI Library",
		Side = "Left",
		Icon = "rbxassetid://16863027979",
		Theme = Library.Theme.Accent,
		Size = UDim2.new(0, 850, 0, 677),
		MinResize = UDim2.new(0, 650, 0, 360),
		MaxResize = UDim2.new(0, 950, 0, 777),
		CloseBind = Enum.KeyCode.LeftControl,
		KeybindList = false,
		Watermark = false,
		Indicators = false,
		VelocityStats = false,
	}, options or {})

	local GUI = {
		Theme = options.Theme,
		CurrentTab = nil,
		Hover = false,
	}

	Library.Theme.Accent = GUI.Theme

	do -- Main Frame
		GUI["1"] = Instance.new("ScreenGui", runService:IsStudio() and players.LocalPlayer:WaitForChild("PlayerGui") or coreGui);
		GUI["1"]["Name"] = [[MyLibrary]];
		GUI["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
		GUI["1"]["ResetOnSpawn"] = false;
		GUI["1"]["IgnoreGuiInset"] = true;

		-- StarterGui.MyLibrary.MainBackground
		GUI["2"] = Instance.new("Frame", GUI["1"]);
		GUI["2"]["BorderSizePixel"] = 0;
		GUI["2"]["BackgroundColor3"] = Library.Theme.InlineContrast;
		GUI["2"]["AnchorPoint"] = Vector2.new(0, 0);
		GUI["2"]["Size"] = uis.TouchEnabled and options.MinResize or uis.KeyboardEnabled and options.Size;
		GUI["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["2"]["Position"] = UDim2.fromOffset((viewport.X / 2) - (GUI["2"].Size.X.Offset / 2), (viewport.Y / 2) - (GUI["2"].Size.Y.Offset / 2));
		GUI["2"]["Name"] = [[MainBackground]];
		GUI["2"]["ZIndex"] = 5;
		
		table.insert(Library.InlineObjects, GUI["2"])

		GUI["2"]:SetAttribute("CurrentTab", nil)

		-- StarterGui.MyLibrary.MainBackground
		GUI["ggxxgg"] = Instance.new("Frame", GUI["1"]);
		GUI["ggxxgg"]["Visible"] = false;
		GUI["ggxxgg"]["BorderSizePixel"] = 0;
		GUI["ggxxgg"]["BackgroundTransparency"] = 0;
		GUI["ggxxgg"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
		GUI["ggxxgg"]["AnchorPoint"] = Vector2.new(0, 0);
		GUI["ggxxgg"]["Size"] = UDim2.new(0, 100, 0, 20);
		GUI["ggxxgg"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["ggxxgg"]["Position"] = UDim2.fromOffset((viewport.X / 2) - (GUI["2"].Size.X.Offset / 2), (viewport.Y / 2) - (GUI["2"].Size.Y.Offset / 2));
		GUI["ggxxgg"]["Name"] = [[Outline]];
		GUI["ggxxgg"]["ZIndex"] = 10;
		
		-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Button.UIStroke
		GUI["14z"] = Instance.new("UIStroke", GUI["ggxxgg"]);
		GUI["14z"]["Color"] = Color3.fromRGB(27, 27, 27);

		-- StarterGui.MyLibrary.MainBackground.TopBar.TextLabel
		GUI["ggxxgg2"] = Instance.new("TextLabel", GUI["ggxxgg"]);
		GUI["ggxxgg2"]["BorderSizePixel"] = 0;
		GUI["ggxxgg2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["ggxxgg2"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		GUI["ggxxgg2"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
		GUI["ggxxgg2"]["TextSize"] = 14;
		GUI["ggxxgg2"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
		GUI["ggxxgg2"]["Size"] = UDim2.new(1, 0, 1, 0);
		GUI["ggxxgg2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["ggxxgg2"]["RichText"] = true;
		GUI["ggxxgg2"]["Text"] = "Tool Tip";
		GUI["ggxxgg2"]["BackgroundTransparency"] = 1;
		
		-- StarterGui.MyLibrary.MainBackground.TopBar.TextLabel.UIPadding
		GUI["5as"] = Instance.new("UIPadding", GUI["ggxxgg2"]);
		GUI["5as"]["PaddingLeft"] = UDim.new(0, 5);
		--
		function Library:UpdateToolTip(Value)
			GUI["ggxxgg2"].Text = Value
			GUI["ggxxgg"].Size = UDim2.new(0, GUI["ggxxgg2"].TextBounds.X + 10, 0, 20)
		end
		
		function Library:UpdateToolTipPosition()
			local mouseLocation = uis:GetMouseLocation()
			GUI["ggxxgg"].Position = UDim2.new(0, mouseLocation.X - (GUI["ggxxgg"].AbsoluteSize.X / 2), 0, mouseLocation.Y - 20)
		end
		--
		-- StarterGui.MyLibrary.MainBackground
		GUI["gggg"] = Instance.new("Frame", GUI["1"]);
		GUI["gggg"]["Visible"] = false;
		GUI["gggg"]["BorderSizePixel"] = 0;
		GUI["gggg"]["BackgroundTransparency"] = 1;
		GUI["gggg"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["gggg"]["AnchorPoint"] = Vector2.new(0, 0);
		GUI["gggg"]["Size"] = uis.TouchEnabled and options.MinResize or uis.KeyboardEnabled and options.Size;
		GUI["gggg"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["gggg"]["Position"] = UDim2.fromOffset((viewport.X / 2) - (GUI["2"].Size.X.Offset / 2), (viewport.Y / 2) - (GUI["2"].Size.Y.Offset / 2));
		GUI["gggg"]["Name"] = [[Outline]];
		GUI["gggg"]["ZIndex"] = 10;

		-- StarterGui.MyLibrary.MainBackground.UIStroke
		GUI["ggg2"] = Instance.new("UIStroke", GUI["gggg"]);
		GUI["ggg2"]["Color"] = Library.Theme.Accent;
		GUI["ggg2"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
		GUI["ggg2"]["Thickness"] = 2;

		-- StarterGui.MyLibrary.MainBackground.UIStroke
		GUI["3"] = Instance.new("UIStroke", GUI["2"]);
		GUI["3"]["Color"] = Library.Theme.Outline;
		GUI["3"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
		
		table.insert(Library.OutlineObjects, GUI["3"])

		-- StarterGui.MyLibrary.MainBackground.DropShadowHolder
		GUI["4"] = Instance.new("Frame", GUI["1"]);
		GUI["4"]["ZIndex"] = 4;
		GUI["4"]["BorderSizePixel"] = 0;
		GUI["4"]["BackgroundTransparency"] = 1;
		GUI["4"]["Size"] = options.Size;
		GUI["4"]["Name"] = [[DropShadowHolder]];
		GUI["4"]["Position"] = UDim2.fromOffset((viewport.X / 2) - (GUI["2"].Size.X.Offset / 2), (viewport.Y / 2) - (GUI["2"].Size.Y.Offset / 2));

		-- StarterGui.MyLibrary.MainBackground.DropShadowHolder.DropShadow
		GUI["5"] = Instance.new("ImageLabel", GUI["4"]);
		GUI["5"]["ZIndex"] = 0;
		GUI["5"]["BorderSizePixel"] = 0;
		GUI["5"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
		GUI["5"]["ScaleType"] = Enum.ScaleType.Slice;
		GUI["5"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["5"]["ImageTransparency"] = 0.5;
		GUI["5"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["5"]["Image"] = [[rbxassetid://6015897843]];
		GUI["5"]["Size"] = UDim2.new(1, 55, 1, 55);
		GUI["5"]["Name"] = [[DropShadow]];
		GUI["5"]["BackgroundTransparency"] = 1;
		GUI["5"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
		
		function Library:UpdateGlow(Value, State)
			GUI["5"][Value] = State
		end

		-- StarterGui.MyLibrary.MainBackground.TopBar
		GUI["57"] = Instance.new("Frame", GUI["2"]);
		GUI["57"]["ZIndex"] = 2;
		GUI["57"]["BorderSizePixel"] = 0;
		GUI["57"]["BackgroundColor3"] = Color3.fromRGB(24, 24, 24);
		GUI["57"]["Size"] = UDim2.new(1, 0, 0, 25);
		GUI["57"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["57"]["Position"] = UDim2.new(-5.1747466756069116e-08, 0, 4.09169338411175e-08, 0);
		GUI["57"]["Name"] = [[TopBar]];

		-- StarterGui.MyLibrary.MainBackground.TopBar.Close
		GUI["58"] = Instance.new("ImageLabel", GUI["57"]);
		GUI["58"]["ZIndex"] = 2;
		GUI["58"]["AnchorPoint"] = Vector2.new(0, 0.5);
		GUI["58"]["BorderSizePixel"] = 0;
		GUI["58"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["58"]["ImageColor3"] = Color3.fromRGB(216, 216, 216);
		GUI["58"]["Image"] = [[rbxassetid://15269329696]];
		GUI["58"]["ImageRectSize"] = Vector2.new(256, 256);
		GUI["58"]["Size"] = UDim2.new(0, 16, 0, 16);
		GUI["58"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["58"]["Name"] = [[Close]];
		GUI["58"]["ImageRectOffset"] = Vector2.new(0, 514);
		GUI["58"]["BackgroundTransparency"] = 1;
		GUI["58"]["Position"] = UDim2.new(0.97, 0, 0.5, 0);

		-- StarterGui.MyLibrary.MainBackground.TopBar.TextLabel
		GUI["59"] = Instance.new("TextLabel", GUI["57"]);
		GUI["59"]["BorderSizePixel"] = 0;
		GUI["59"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["59"]["TextXAlignment"] = Enum.TextXAlignment[options.Side];
		GUI["59"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
		GUI["59"]["TextSize"] = 14;
		GUI["59"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
		GUI["59"]["Size"] = UDim2.new(1, 0, 0, 25);
		GUI["59"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["59"]["RichText"] = true;
		GUI["59"]["Text"] = options["Name"];
		GUI["59"]["BackgroundTransparency"] = 1;

		-- StarterGui.MyLibrary.MainBackground.TopBar.TextLabel.UIPadding
		GUI["5a"] = Instance.new("UIPadding", GUI["59"]);
		GUI["5a"]["PaddingBottom"] = UDim.new(0, 2);
		GUI["5a"]["PaddingLeft"] = UDim.new(0, 27);

		-- StarterGui.MyLibrary.MainBackground.TopBar.Icon
		GUI["5b"] = Instance.new("ImageLabel", GUI["57"]);
		GUI["5b"]["ZIndex"] = 2;
		GUI["5b"]["BorderSizePixel"] = 0;
		GUI["5b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["5b"]["ImageColor3"] = Library.Theme.Accent;
		GUI["5b"]["Image"] = options.Icon;
		GUI["5b"]["Size"] = UDim2.new(0, 20, 0, 20);
		GUI["5b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["5b"]["Name"] = [[Icon]];
		GUI["5b"]["BackgroundTransparency"] = 1;
		GUI["5b"]["Position"] = UDim2.new(0.004999999888241291, 0, 0.03799999877810478, 0);

		table.insert(Library.ThemeObjects, GUI["5b"])

		-- StarterGui.MyLibrary.MainBackground.ContentContainer
		GUI["6"] = Instance.new("Frame", GUI["2"]);
		GUI["6"]["BorderSizePixel"] = 0;
		GUI["6"]["BackgroundColor3"] = Color3.fromRGB(21, 21, 21);
		GUI["6"]["AnchorPoint"] = Vector2.new(1, 0);
		GUI["6"]["BackgroundTransparency"] = 1;
		GUI["6"]["Size"] = UDim2.new(1, -80, 1, -41);
		GUI["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["6"]["Position"] = UDim2.new(1, 0, 0, 40);
		GUI["6"]["Name"] = [[ContentContainer]];
	end

	function GUI:UpdateTitle(Text)
		GUI["59"].Text = Text
	end

	function GUI:UpdateTextPosition(Pos)
		if Pos == "Right" then
			GUI["5a"]["PaddingRight"] = UDim.new(0, 25)
			GUI["59"]["TextXAlignment"] = Enum.TextXAlignment[Pos]
		else
			GUI["5a"]["PaddingRight"] = UDim.new(0, 0)
			GUI["59"]["TextXAlignment"] = Enum.TextXAlignment[Pos]
		end
	end

	if options.KeybindList then
		-- StarterGui.MyLibrary.GUI
		GUI["1c"] = Instance.new("Frame", GUI["1"]);
		GUI["1c"]["BorderSizePixel"] = 0;
		GUI["1c"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
		GUI["1c"]["Size"] = UDim2.new(0, 160, 0, 30);
		GUI["1c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["1c"]["Position"] = UDim2.fromOffset(10, (viewport.Y / 2) - (GUI["1c"].Size.Y.Offset / 2));
		GUI["1c"]["Name"] = [[KeybindList]];

		-- StarterGui.MyLibrary.GUI.Bar
		GUI["1d"] = Instance.new("Frame", GUI["1c"]);
		GUI["1d"]["BorderSizePixel"] = 0;
		GUI["1d"]["BackgroundColor3"] = Library.Theme.Accent;
		GUI["1d"]["Size"] = UDim2.new(1, 0, 0, 3);
		GUI["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["1d"]["Name"] = [[Bar]];

		table.insert(Library.ThemeObjects, GUI["1d"])

		-- StarterGui.MyLibrary.GUI.DropShadowHolder
		GUI["1e"] = Instance.new("Frame", GUI["1c"]);
		GUI["1e"]["ZIndex"] = 0;
		GUI["1e"]["BorderSizePixel"] = 0;
		GUI["1e"]["BackgroundTransparency"] = 1;
		GUI["1e"]["Size"] = UDim2.new(1, 0, 1, 0);
		GUI["1e"]["Name"] = [[DropShadowHolder]];

		-- StarterGui.MyLibrary.GUI.DropShadowHolder.DropShadow
		GUI["1f"] = Instance.new("ImageLabel", GUI["1e"]);
		GUI["1f"]["ZIndex"] = 0;
		GUI["1f"]["BorderSizePixel"] = 0;
		GUI["1f"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
		GUI["1f"]["ScaleType"] = Enum.ScaleType.Slice;
		GUI["1f"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["1f"]["ImageTransparency"] = 0.5;
		GUI["1f"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["1f"]["Image"] = [[rbxassetid://6015897843]];
		GUI["1f"]["Size"] = UDim2.new(1, 30, 1, 30);
		GUI["1f"]["Name"] = [[DropShadow]];
		GUI["1f"]["BackgroundTransparency"] = 1;
		GUI["1f"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

		-- StarterGui.MyLibrary.GUI.Title
		GUI["gg"] = Instance.new("TextLabel", GUI["1c"]);
		GUI["gg"]["BorderSizePixel"] = 0;
		GUI["gg"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["gg"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		GUI["gg"]["TextSize"] = 14;
		GUI["gg"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
		GUI["gg"]["Size"] = UDim2.new(1, 0, 1, -3);
		GUI["gg"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["gg"]["Text"] = [[Keybinds]];
		GUI["gg"]["Name"] = [[Title]];
		GUI["gg"]["BackgroundTransparency"] = 1;
		GUI["gg"]["Position"] = UDim2.new(0, 0, 0, 3);

		-- StarterGui.MyLibrary.GUI.ContentContainer
		GUI["hh"] = Instance.new("Frame", GUI["1c"]);
		GUI["hh"]["BorderSizePixel"] = 0;
		GUI["hh"]["BackgroundColor3"] = Library.Theme.InlineContrast;
		GUI["hh"]["Size"] = UDim2.new(1, 0, 0, 0);
		GUI["hh"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["hh"]["Position"] = UDim2.new(0, 0, 1, 0);
		GUI["hh"]["AutomaticSize"] = Enum.AutomaticSize.XY;
		GUI["hh"]["Name"] = [[ContentContainer]];
		GUI["hh"]["Visible"] = false;
		
		table.insert(Library.InlineObjects, GUI["hh"])

		-- StarterGui.MyLibrary.GUI.ContentContainer.UIStroke
		GUI["jj"] = Instance.new("UIStroke", GUI["hh"]);
		GUI["jj"]["Color"] = Color3.fromRGB(21, 21, 21);

		-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.UIListLayout
		GUI["c6"] = Instance.new("UIListLayout", GUI["hh"]);
		GUI["c6"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

		-- StarterGui.MyLibrary.GUI.UIStroke
		GUI["zz"] = Instance.new("UIStroke", GUI["1c"]);
		GUI["zz"]["Color"] = Color3.fromRGB(21, 21, 21);

		local function CheckChildren()
			if #GUI["hh"]:GetChildren() == 0 then
				GUI["hh"].Visible = false
			else
				GUI["hh"].Visible = true
			end
		end

		local function GetLargestTextBounds()
			local largestTextBounds = Vector2.new(0, 0)

			for _, child in ipairs(GUI["hh"]:GetDescendants()) do
				if child:IsA("TextLabel") then
					local textBounds = child.TextBounds

					largestTextBounds = Vector2.new(math.max(largestTextBounds.X, textBounds.X), math.max(largestTextBounds.Y, textBounds.Y))
				end
			end

			return largestTextBounds
		end

		local function Set1cSize()
			local size = UDim2.new(0, 160, 0, 30)

			if #GUI["hh"]:GetChildren() > 2 then
				local largestTextBounds = GetLargestTextBounds()

				size = UDim2.new(0, math.max(largestTextBounds.X + 12, 160), 0, 30)
			end

			GUI["1c"].Size = size
		end

		GUI["hh"].ChildAdded:Connect(function()
			Set1cSize()
			CheckChildren()
		end)

		GUI["hh"].ChildRemoved:Connect(function()
			Set1cSize()
			CheckChildren()
		end)

		Set1cSize()
		CheckChildren()

		function GUI:RemoveKeybind(Toggle)
			for i, v in pairs(GUI["hh"]:GetChildren()) do
				if v.Name == Toggle then
					v:Destroy()
				end
			end
		end

		function GUI:AddKeybind(Toggle, Key, Mode)
			if GUI["hh"]:FindFirstChild(tostring(Toggle)) and GUI["ll"].Text == string.format("[%s] %s [%s]", tostring(Key), tostring(Toggle), "Always") and tostring(Mode) == "Always" then return end
			if GUI["hh"]:FindFirstChild(tostring(Toggle)) then GUI:RemoveKeybind(tostring(Toggle)) end

			do -- Render
				-- StarterGui.MyLibrary.GUI.ContentContainer.KeybindFrame
				GUI["kk"] = Instance.new("Frame", GUI["hh"]);
				GUI["kk"]["BorderSizePixel"] = 0;
				GUI["kk"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				GUI["kk"]["BackgroundTransparency"] = 1;
				GUI["kk"]["Size"] = UDim2.new(1, 0, 0, 20);
				GUI["kk"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				GUI["kk"]["Name"] = tostring(Toggle);

				-- StarterGui.MyLibrary.GUI.ContentContainer.KeybindFrame.Keybind
				GUI["ll"] = Instance.new("TextLabel", GUI["kk"]);
				GUI["ll"]["BorderSizePixel"] = 0;
				GUI["ll"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				GUI["ll"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				GUI["ll"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				GUI["ll"]["TextSize"] = 14;
				GUI["ll"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				GUI["ll"]["Size"] = UDim2.new(1, 0, 1, 0);
				GUI["ll"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				GUI["ll"]["Text"] = Key ~= "None" and string.format("[%s] %s [%s]", tostring(Key), tostring(Toggle), tostring(Mode)) or string.format("%s", tostring(Toggle));
				GUI["ll"]["Name"] = [[Keybind]];
				GUI["ll"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.GUI.ContentContainer.KeybindFrame.Keybind.UIPadding
				GUI["xx"] = Instance.new("UIPadding", GUI["ll"]);
				GUI["xx"]["PaddingBottom"] = UDim.new(0, 2);
				GUI["xx"]["PaddingLeft"] = UDim.new(0, 7);
			end

		end

		do -- Dragging
			local gui = GUI["1c"]

			local dragging
			local dragInput
			local dragStart
			local startPos

			local function update(input)
				local delta = input.Position - dragStart
				tweenService:Create(gui, newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
			end

			gui.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					dragStart = input.Position
					startPos = gui.Position

					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragging = false
						end
					end)
				end
			end)

			gui.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					dragInput = input
				end
			end)

			uis.InputChanged:Connect(function(input)
				if input == dragInput and dragging then
					update(input)
				end
			end)
		end
	end

	if options.Watermark then
		-- StarterGui.MyLibrary.Watermark
		GUI["f"] = Instance.new("Frame", GUI["1"]);
		GUI["f"]["BorderSizePixel"] = 0;
		GUI["f"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
		GUI["f"]["Size"] = UDim2.new(0, 160, 0, 30);
		GUI["f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["f"]["Position"] = UDim2.new(0, 165, 0, 17);
		GUI["f"]["Name"] = [[Watermark]];

		-- StarterGui.MyLibrary.Watermark.Bar
		GUI["10"] = Instance.new("Frame", GUI["f"]);
		GUI["10"]["BorderSizePixel"] = 0;
		GUI["10"]["BackgroundColor3"] = Library.Theme.Accent;
		GUI["10"]["Size"] = UDim2.new(1, 0, 0, 3);
		GUI["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["10"]["Name"] = [[Bar]];

		table.insert(Library.ThemeObjects, GUI["10"])

		-- StarterGui.MyLibrary.Watermark.DropShadowHolder
		GUI["11"] = Instance.new("Frame", GUI["f"]);
		GUI["11"]["ZIndex"] = 0;
		GUI["11"]["BorderSizePixel"] = 0;
		GUI["11"]["BackgroundTransparency"] = 1;
		GUI["11"]["Size"] = UDim2.new(1, 0, 1, 0);
		GUI["11"]["Name"] = [[DropShadowHolder]];

		-- StarterGui.MyLibrary.Watermark.DropShadowHolder.DropShadow
		GUI["12"] = Instance.new("ImageLabel", GUI["11"]);
		GUI["12"]["ZIndex"] = 0;
		GUI["12"]["BorderSizePixel"] = 0;
		GUI["12"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
		GUI["12"]["ScaleType"] = Enum.ScaleType.Slice;
		GUI["12"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["12"]["ImageTransparency"] = 0.5;
		GUI["12"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["12"]["Image"] = [[rbxassetid://6015897843]];
		GUI["12"]["Size"] = UDim2.new(1, 30, 1, 30);
		GUI["12"]["Name"] = [[DropShadow]];
		GUI["12"]["BackgroundTransparency"] = 1;
		GUI["12"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

		-- StarterGui.MyLibrary.Watermark.Text
		GUI["13"] = Instance.new("TextLabel", GUI["f"]);
		GUI["13"]["BorderSizePixel"] = 0;
		GUI["13"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["13"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		GUI["13"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
		GUI["13"]["TextSize"] = 14;
		GUI["13"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
		GUI["13"]["Size"] = UDim2.new(1, 0, 1, -3);
		GUI["13"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["13"]["Text"] = options.Name;
		GUI["13"]["Name"] = [[Text]];
		GUI["13"]["BackgroundTransparency"] = 1;
		GUI["13"]["Position"] = UDim2.new(0, 0, 0, 3);
		GUI["13"]["RichText"] = true;

		-- StarterGui.MyLibrary.Watermark.Text.UIPadding
		GUI["14"] = Instance.new("UIPadding", GUI["13"]);
		GUI["14"]["PaddingLeft"] = UDim.new(0, 7);

		-- StarterGui.MyLibrary.Watermark.UIStroke
		GUI["15"] = Instance.new("UIStroke", GUI["f"]);
		GUI["15"]["Color"] = Color3.fromRGB(21, 21, 21);

		function GUI:UpdateWatermark(Text)
			GUI["13"].Text = Text
			GUI["f"].Size = UDim2.new(0, GUI["13"].TextBounds.X + 15, 0, GUI["f"].Size.Y.Offset)
		end
	end

	if options.Indicators then
		do -- Render
			-- StarterGui.MyLibrary.Indicators
			GUI["16"] = Instance.new("Frame", GUI["1"]);
			GUI["16"]["BorderSizePixel"] = 0;
			GUI["16"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
			GUI["16"]["Size"] = UDim2.new(0, 240, 0, 30);
			GUI["16"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["16"]["Position"] = UDim2.fromOffset(10, (viewport.Y / 2) - (GUI["16"].Size.Y.Offset / 2) - 135);
			GUI["16"]["Name"] = [[Indicators]];

			-- StarterGui.MyLibrary.Indicators.Bar
			GUI["17"] = Instance.new("Frame", GUI["16"]);
			GUI["17"]["BorderSizePixel"] = 0;
			GUI["17"]["BackgroundColor3"] = Library.Theme.Accent;
			GUI["17"]["Size"] = UDim2.new(1, 0, 0, 3);
			GUI["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["17"]["Name"] = [[Bar]];

			table.insert(Library.ThemeObjects, GUI["17"])

			-- StarterGui.MyLibrary.Indicators.DropShadowHolder
			GUI["18"] = Instance.new("Frame", GUI["16"]);
			GUI["18"]["ZIndex"] = 0;
			GUI["18"]["BorderSizePixel"] = 0;
			GUI["18"]["BackgroundTransparency"] = 1;
			GUI["18"]["Size"] = UDim2.new(1, 0, 1, 0);
			GUI["18"]["Name"] = [[DropShadowHolder]];

			-- StarterGui.MyLibrary.Indicators.DropShadowHolder.DropShadow
			GUI["19"] = Instance.new("ImageLabel", GUI["18"]);
			GUI["19"]["ZIndex"] = 0;
			GUI["19"]["BorderSizePixel"] = 0;
			GUI["19"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
			GUI["19"]["ScaleType"] = Enum.ScaleType.Slice;
			GUI["19"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["19"]["ImageTransparency"] = 0.5;
			GUI["19"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
			GUI["19"]["Image"] = [[rbxassetid://6015897843]];
			GUI["19"]["Size"] = UDim2.new(1, 30, 1, 30);
			GUI["19"]["Name"] = [[DropShadow]];
			GUI["19"]["BackgroundTransparency"] = 1;
			GUI["19"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

			-- StarterGui.MyLibrary.Indicators.Title
			GUI["1a"] = Instance.new("TextLabel", GUI["16"]);
			GUI["1a"]["BorderSizePixel"] = 0;
			GUI["1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["1a"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
			GUI["1a"]["TextSize"] = 14;
			GUI["1a"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
			GUI["1a"]["Size"] = UDim2.new(1, 0, 1, -3);
			GUI["1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["1a"]["Text"] = [[Indicators]];
			GUI["1a"]["Name"] = [[Title]];
			GUI["1a"]["BackgroundTransparency"] = 1;
			GUI["1a"]["Position"] = UDim2.new(0, 0, 0, 3);

			-- StarterGui.MyLibrary.Indicators.ContentContainer
			GUI["1b"] = Instance.new("Frame", GUI["16"]);
			GUI["1b"]["BorderSizePixel"] = 0;
			GUI["1b"]["BackgroundColor3"] = Library.Theme.InlineContrast;
			GUI["1b"]["Size"] = UDim2.new(1, 0, 0, 0);
			GUI["1b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["1b"]["Position"] = UDim2.new(0, 0, 1, 0);
			GUI["1b"]["AutomaticSize"] = Enum.AutomaticSize.Y;
			GUI["1b"]["Name"] = [[ContentContainer]];
			
			table.insert(Library.InlineObjects, GUI["1b"])

			-- StarterGui.MyLibrary.Indicators.ContentContainer.UIStroke
			GUI["2c"] = Instance.new("UIStroke", GUI["1b"]);
			GUI["2c"]["Color"] = Color3.fromRGB(21, 21, 21);

			-- StarterGui.MyLibrary.Indicators.UIStroke
			GUI["3d"] = Instance.new("UIStroke", GUI["16"]);
			GUI["3d"]["Color"] = Color3.fromRGB(21, 21, 21);

			-- StarterGui.MyLibrary.Indicators.ContentContainer.TextFrame
			GUI["2d"] = Instance.new("Frame", GUI["1b"]);
			GUI["2d"]["BorderSizePixel"] = 0;
			GUI["2d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["2d"]["BackgroundTransparency"] = 1;
			GUI["2d"]["Size"] = UDim2.new(1, 0, 0, 20);
			GUI["2d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["2d"]["Name"] = "TargetFrame";

			-- StarterGui.MyLibrary.Indicators.ContentContainer.TextFrame.Text
			GUI["2e"] = Instance.new("TextLabel", GUI["2d"]);
			GUI["2e"]["BorderSizePixel"] = 0;
			GUI["2e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["2e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			GUI["2e"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			GUI["2e"]["TextSize"] = 14;
			GUI["2e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["2e"]["Size"] = UDim2.new(0.5, 0, 1, 0);
			GUI["2e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["2e"]["Text"] = [[Target]];
			GUI["2e"]["Name"] = [[Text]];
			GUI["2e"]["BackgroundTransparency"] = 1;

			-- StarterGui.MyLibrary.Indicators.ContentContainer.TextFrame.Text.UIPadding
			GUI["2f"] = Instance.new("UIPadding", GUI["2e"]);
			GUI["2f"]["PaddingBottom"] = UDim.new(0, 2);
			GUI["2f"]["PaddingLeft"] = UDim.new(0, 7);

			-- StarterGui.MyLibrary.Indicators.ContentContainer.TextFrame.Value
			GUI["20"] = Instance.new("TextLabel", GUI["2d"]);
			GUI["20"]["BorderSizePixel"] = 0;
			GUI["20"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["20"]["TextXAlignment"] = Enum.TextXAlignment.Right;
			GUI["20"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			GUI["20"]["TextSize"] = 14;
			GUI["20"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["20"]["Size"] = UDim2.new(0.5, 0, 1, 0);
			GUI["20"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["20"]["Text"] = "nil";
			GUI["20"]["Name"] = [[Value]];
			GUI["20"]["BackgroundTransparency"] = 1;
			GUI["20"]["Position"] = UDim2.new(0.5, 0, 0, 0);

			-- StarterGui.MyLibrary.Indicators.ContentContainer.TextFrame.Value.UIPadding
			GUI["21"] = Instance.new("UIPadding", GUI["20"]);
			GUI["21"]["PaddingRight"] = UDim.new(0, 7);
			GUI["21"]["PaddingBottom"] = UDim.new(0, 2);
		end

		local AntiConnection
		local HealthConnection

		function GUI:UpdateIndicator(Target)
			if Target ~= nil then
				GUI["20"].Text = Target.Name

				do
					-- StarterGui.MyLibrary.Indicators.ContentContainer.UIListLayout
					GUI["22"] = Instance.new("UIListLayout", GUI["1b"]);
					GUI["22"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

					-- StarterGui.MyLibrary.Indicators.ContentContainer.ArmorSlider
					GUI["23"] = Instance.new("Frame", GUI["1b"]);
					GUI["23"]["BorderSizePixel"] = 0;
					GUI["23"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					GUI["23"]["BackgroundTransparency"] = 1;
					GUI["23"]["LayoutOrder"] = 1;
					GUI["23"]["Size"] = UDim2.new(1, -8, 0, 25);
					GUI["23"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					GUI["23"]["Position"] = UDim2.new(0, 0, 0, 25);
					GUI["23"]["Name"] = [[ArmorSlider]];

					-- StarterGui.MyLibrary.Indicators.ContentContainer.ArmorSlider.Text
					GUI["24"] = Instance.new("TextLabel", GUI["23"]);
					GUI["24"]["TextWrapped"] = true;
					GUI["24"]["BorderSizePixel"] = 0;
					GUI["24"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					GUI["24"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					GUI["24"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					GUI["24"]["TextSize"] = 14;
					GUI["24"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
					GUI["24"]["Size"] = UDim2.new(0.5, 0, 1, -10);
					GUI["24"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					GUI["24"]["Text"] = [[Health]];
					GUI["24"]["Name"] = [[Text]];
					GUI["24"]["BackgroundTransparency"] = 1;
					GUI["24"]["Position"] = UDim2.new(0, 0, 0, -1);

					-- StarterGui.MyLibrary.Indicators.ContentContainer.ArmorSlider.Value
					GUI["25"] = Instance.new("TextLabel", GUI["23"]);
					GUI["25"]["TextWrapped"] = true;
					GUI["25"]["BorderSizePixel"] = 0;
					GUI["25"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					GUI["25"]["TextXAlignment"] = Enum.TextXAlignment.Right;
					GUI["25"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					GUI["25"]["TextSize"] = 12;
					GUI["25"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
					GUI["25"]["Size"] = UDim2.new(0.5, 0, 1, -8);
					GUI["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					GUI["25"]["Text"] = [[100]];
					GUI["25"]["Name"] = [[Value]];
					GUI["25"]["BackgroundTransparency"] = 1;
					GUI["25"]["Position"] = UDim2.new(0.5, 0, 0, -6);

					-- StarterGui.MyLibrary.Indicators.ContentContainer.ArmorSlider.Value.UIPadding
					GUI["26"] = Instance.new("UIPadding", GUI["25"]);
					GUI["26"]["PaddingTop"] = UDim.new(0, 12);

					-- StarterGui.MyLibrary.Indicators.ContentContainer.ArmorSlider.SliderBack
					GUI["27"] = Instance.new("Frame", GUI["23"]);
					GUI["27"]["BorderSizePixel"] = 0;
					GUI["27"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					GUI["27"]["AnchorPoint"] = Vector2.new(0, 1);
					GUI["27"]["Size"] = UDim2.new(1, 0, 0, 8);
					GUI["27"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					GUI["27"]["Position"] = UDim2.new(0, 0, 1, 0);
					GUI["27"]["Name"] = [[SliderBack]];

					-- StarterGui.MyLibrary.Indicators.ContentContainer.ArmorSlider.SliderBack.UIStroke
					GUI["28"] = Instance.new("UIStroke", GUI["27"]);
					GUI["28"]["Color"] = Color3.fromRGB(27, 27, 27);

					-- StarterGui.MyLibrary.Indicators.ContentContainer.ArmorSlider.SliderBack.Draggable
					GUI["29"] = Instance.new("Frame", GUI["27"]);
					GUI["29"]["BorderSizePixel"] = 0;
					GUI["29"]["BackgroundColor3"] = Library.Theme.Accent;
					GUI["29"]["Size"] = UDim2.new(1, 0, 1, 0);
					GUI["29"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					GUI["29"]["Name"] = [[Draggable]];

					table.insert(Library.ThemeObjects, GUI["29"])

					-- StarterGui.MyLibrary.Indicators.ContentContainer.ArmorSlider.UIPadding
					GUI["2a"] = Instance.new("UIPadding", GUI["23"]);
					GUI["2a"]["PaddingBottom"] = UDim.new(0, 4);
					GUI["2a"]["PaddingLeft"] = UDim.new(0, 7);

					-- StarterGui.MyLibrary.Indicators.ContentContainer.TextFrame
					GUI["33"] = Instance.new("Frame", GUI["1b"]);
					GUI["33"]["BorderSizePixel"] = 0;
					GUI["33"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					GUI["33"]["BackgroundTransparency"] = 1;
					GUI["33"]["LayoutOrder"] = 3;
					GUI["33"]["Size"] = UDim2.new(1, 0, 0, 20);
					GUI["33"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					GUI["33"]["Name"] = [[TextFrame]];

					-- StarterGui.MyLibrary.Indicators.ContentContainer.TextFrame.Text
					GUI["34"] = Instance.new("TextLabel", GUI["33"]);
					GUI["34"]["BorderSizePixel"] = 0;
					GUI["34"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					GUI["34"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					GUI["34"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					GUI["34"]["TextSize"] = 14;
					GUI["34"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
					GUI["34"]["Size"] = UDim2.new(0.5, 0, 1, 0);
					GUI["34"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					GUI["34"]["Text"] = [[Anti Aiming]];
					GUI["34"]["Name"] = [[Text]];
					GUI["34"]["BackgroundTransparency"] = 1;

					-- StarterGui.MyLibrary.Indicators.ContentContainer.TextFrame.Text.UIPadding
					GUI["35"] = Instance.new("UIPadding", GUI["34"]);
					GUI["35"]["PaddingBottom"] = UDim.new(0, 2);
					GUI["35"]["PaddingLeft"] = UDim.new(0, 7);

					-- StarterGui.MyLibrary.Indicators.ContentContainer.TextFrame.Value
					GUI["36"] = Instance.new("TextLabel", GUI["33"]);
					GUI["36"]["BorderSizePixel"] = 0;
					GUI["36"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					GUI["36"]["TextXAlignment"] = Enum.TextXAlignment.Right;
					GUI["36"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					GUI["36"]["TextSize"] = 14;
					GUI["36"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
					GUI["36"]["Size"] = UDim2.new(0.5, 0, 1, 0);
					GUI["36"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					GUI["36"]["Text"] = [[false]];
					GUI["36"]["Name"] = [[Value]];
					GUI["36"]["BackgroundTransparency"] = 1;
					GUI["36"]["Position"] = UDim2.new(0.5, 0, 0, 0);

					-- StarterGui.MyLibrary.Indicators.ContentContainer.TextFrame.Value.UIPadding
					GUI["37"] = Instance.new("UIPadding", GUI["36"]);
					GUI["37"]["PaddingRight"] = UDim.new(0, 7);
					GUI["37"]["PaddingBottom"] = UDim.new(0, 2);
				end

				local function IsUsingAntiAim(Player)
					if (Player.Character.HumanoidRootPart.Velocity.Y < -5 and Player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall) or Player.Character.HumanoidRootPart.Velocity.Y < -50 then
						return true
					elseif Player and (Player.Character.HumanoidRootPart.Velocity.X > 35 or Player.Character.HumanoidRootPart.Velocity.X < -35) then
						return true
					elseif Player and Player.Character.HumanoidRootPart.Velocity.Y > 60 then
						return true
					elseif Player and (Player.Character.HumanoidRootPart.Velocity.Z > 35 or Player.Character.HumanoidRootPart.Velocity.Z < -35) then
						return true
					else
						return false
					end
				end

				HealthConnection = Target.Character:FindFirstChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function()
					GUI["25"].Text = math.floor(Target.Character:FindFirstChild("Humanoid").Health)
					GUI["29"].Size = UDim2.new(Target.Character:FindFirstChild("Humanoid").Health / Target.Character:FindFirstChild("Humanoid").MaxHealth, 0, 1, 0)
				end)

				AntiConnection = runService.PreRender:Connect(function()
					if IsUsingAntiAim(Target) then
						GUI["36"].Text = "true"
					else
						GUI["36"].Text = "false"
					end
				end)
			else
				GUI["20"].Text = "nil"

				if HealthConnection then HealthConnection:Disconnect() end
				if AntiConnection then AntiConnection:Disconnect() end

				for i, v in pairs(GUI["1b"]:GetChildren()) do
					if v.Name ~= "TargetFrame" then
						v:Destroy()
					end
				end
			end
		end

		do -- Dragging
			local gui = GUI["16"]

			local dragging
			local dragInput
			local dragStart
			local startPos

			local function update(input)
				local delta = input.Position - dragStart
				tweenService:Create(gui, newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
			end

			gui.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					dragStart = input.Position
					startPos = gui.Position

					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragging = false
						end
					end)
				end
			end)

			gui.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					dragInput = input
				end
			end)

			uis.InputChanged:Connect(function(input)
				if input == dragInput and dragging then
					update(input)
				end
			end)
		end
	end

	if options.VelocityStats then
		do -- Render
			-- StarterGui.MyLibrary.VelocityStats
			GUI["l2"] = Instance.new("Frame", GUI["1"]);
			GUI["l2"]["BorderSizePixel"] = 0;
			GUI["l2"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
			GUI["l2"]["Size"] = UDim2.new(0, 208, 0, 30);
			GUI["l2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["l2"]["Position"] = UDim2.fromOffset(viewport.X - GUI["l2"].Size.X.Offset - 12, (viewport.Y / 2) - (GUI["l2"].Size.Y.Offset / 2));
			GUI["l2"]["Name"] = [[VelocityStats]];

			-- StarterGui.MyLibrary.VelocityStats.Bar
			GUI["l3"] = Instance.new("Frame", GUI["l2"]);
			GUI["l3"]["BorderSizePixel"] = 0;
			GUI["l3"]["BackgroundColor3"] = Library.Theme.Accent;
			GUI["l3"]["Size"] = UDim2.new(1, 0, 0, 3);
			GUI["l3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["l3"]["Name"] = [[Bar]];

			table.insert(Library.ThemeObjects, GUI["l3"])

			-- StarterGui.MyLibrary.VelocityStats.DropShadowHolder
			GUI["l4"] = Instance.new("Frame", GUI["l2"]);
			GUI["l4"]["ZIndex"] = 0;
			GUI["l4"]["BorderSizePixel"] = 0;
			GUI["l4"]["BackgroundTransparency"] = 1;
			GUI["l4"]["Size"] = UDim2.new(1, 0, 1, 0);
			GUI["l4"]["Name"] = [[DropShadowHolder]];

			-- StarterGui.MyLibrary.VelocityStats.DropShadowHolder.DropShadow
			GUI["l5"] = Instance.new("ImageLabel", GUI["l4"]);
			GUI["l5"]["ZIndex"] = 0;
			GUI["l5"]["BorderSizePixel"] = 0;
			GUI["l5"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
			GUI["l5"]["ScaleType"] = Enum.ScaleType.Slice;
			GUI["l5"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["l5"]["ImageTransparency"] = 0.5;
			GUI["l5"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
			GUI["l5"]["Image"] = [[rbxassetid://6015897843]];
			GUI["l5"]["Size"] = UDim2.new(1, 30, 1, 30);
			GUI["l5"]["Name"] = [[DropShadow]];
			GUI["l5"]["BackgroundTransparency"] = 1;
			GUI["l5"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

			-- StarterGui.MyLibrary.VelocityStats.Text
			GUI["l6"] = Instance.new("TextLabel", GUI["l2"]);
			GUI["l6"]["BorderSizePixel"] = 0;
			GUI["l6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["l6"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
			GUI["l6"]["TextSize"] = 14;
			GUI["l6"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
			GUI["l6"]["Size"] = UDim2.new(1, 0, 1, -3);
			GUI["l6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["l6"]["Text"] = [[Velocity Stats]];
			GUI["l6"]["Name"] = [[Text]];
			GUI["l6"]["BackgroundTransparency"] = 1;
			GUI["l6"]["Position"] = UDim2.new(0, 0, 0, 3);

			-- StarterGui.MyLibrary.VelocityStats.UIStroke
			GUI["l7"] = Instance.new("UIStroke", GUI["l2"]);
			GUI["l7"]["Color"] = Color3.fromRGB(21, 21, 21);

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer
			GUI["l8"] = Instance.new("Frame", GUI["l2"]);
			GUI["l8"]["BorderSizePixel"] = 0;
			GUI["l8"]["BackgroundColor3"] = Library.Theme.InlineContrast;
			GUI["l8"]["Size"] = UDim2.new(1, 0, 0, 0);
			GUI["l8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["l8"]["Position"] = UDim2.new(0, 0, 1, 0);
			GUI["l8"]["AutomaticSize"] = Enum.AutomaticSize.Y;
			GUI["l8"]["Name"] = [[ContentContainer]];
			
			table.insert(Library.InlineObjects, GUI["l8"])

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.UIListLayout
			GUI["l9"] = Instance.new("UIListLayout", GUI["l8"]);
			GUI["l9"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.VelocityStats
			GUI["la"] = Instance.new("Frame", GUI["l8"]);
			GUI["la"]["BorderSizePixel"] = 0;
			GUI["la"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["la"]["BackgroundTransparency"] = 1;
			GUI["la"]["Size"] = UDim2.new(1, 0, 0, 20);
			GUI["la"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["la"]["Name"] = [[VelocityStats]];

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.VelocityStats.Keybind
			GUI["lb"] = Instance.new("TextLabel", GUI["la"]);
			GUI["lb"]["BorderSizePixel"] = 0;
			GUI["lb"]["RichText"] = true;
			GUI["lb"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["lb"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			GUI["lb"]["TextSize"] = 14;
			GUI["lb"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["lb"]["Size"] = UDim2.new(1, 0, 1, 0);
			GUI["lb"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["lb"]["Text"] = [[Velocity | 0, 0, 0]];
			GUI["lb"]["Name"] = [[Keybind]];
			GUI["lb"]["BackgroundTransparency"] = 1;

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.VelocityStats.Keybind.UIPadding
			GUI["lc"] = Instance.new("UIPadding", GUI["lb"]);
			GUI["lc"]["PaddingBottom"] = UDim.new(0, 2);

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.UIStroke
			GUI["ld"] = Instance.new("UIStroke", GUI["l8"]);
			GUI["ld"]["Color"] = Color3.fromRGB(21, 21, 21);

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.PositionStats
			GUI["le"] = Instance.new("Frame", GUI["l8"]);
			GUI["le"]["BorderSizePixel"] = 0;
			GUI["le"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["le"]["BackgroundTransparency"] = 1;
			GUI["le"]["Size"] = UDim2.new(1, 0, 0, 20);
			GUI["le"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["le"]["Name"] = [[PositionStats]];

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.PositionStats.Keybind
			GUI["lf"] = Instance.new("TextLabel", GUI["le"]);
			GUI["lf"]["BorderSizePixel"] = 0;
			GUI["lf"]["RichText"] = true;
			GUI["lf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["lf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			GUI["lf"]["TextSize"] = 14;
			GUI["lf"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["lf"]["Size"] = UDim2.new(1, 0, 1, 0);
			GUI["lf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["lf"]["Text"] = [[Position | 0, 0, 0]];
			GUI["lf"]["Name"] = [[Keybind]];
			GUI["lf"]["BackgroundTransparency"] = 1;

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.PositionStats.Keybind.UIPadding
			GUI["l10"] = Instance.new("UIPadding", GUI["lf"]);
			GUI["l10"]["PaddingBottom"] = UDim.new(0, 2);

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.RotationStats
			GUI["l11"] = Instance.new("Frame", GUI["l8"]);
			GUI["l11"]["BorderSizePixel"] = 0;
			GUI["l11"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["l11"]["BackgroundTransparency"] = 1;
			GUI["l11"]["Size"] = UDim2.new(1, 0, 0, 20);
			GUI["l11"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["l11"]["Name"] = [[RotationStats]];

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.RotationStats.Keybind
			GUI["l12"] = Instance.new("TextLabel", GUI["l11"]);
			GUI["l12"]["BorderSizePixel"] = 0;
			GUI["l12"]["RichText"] = true;
			GUI["l12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["l12"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			GUI["l12"]["TextSize"] = 14;
			GUI["l12"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			GUI["l12"]["Size"] = UDim2.new(1, 0, 1, 0);
			GUI["l12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			GUI["l12"]["Text"] = [[Rotation | 0, 0, 0]];
			GUI["l12"]["Name"] = [[Keybind]];
			GUI["l12"]["BackgroundTransparency"] = 1;

			-- StarterGui.MyLibrary.VelocityStats.ContentContainer.RotationStats.Keybind.UIPadding
			GUI["l13"] = Instance.new("UIPadding", GUI["l12"]);
			GUI["l13"]["PaddingBottom"] = UDim.new(0, 2);
		end

		function GUI:UpdateVelocityStats()
			if players.LocalPlayer and players.LocalPlayer.Character and players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				GUI["lb"].Text = string.format("Velocity | %s, %s, %s", math.round(players.LocalPlayer.Character.HumanoidRootPart.Velocity.X), math.round(players.LocalPlayer.Character.HumanoidRootPart.Velocity.Y), math.round(players.LocalPlayer.Character.HumanoidRootPart.Velocity.Z))
				GUI["lf"].Text = string.format("Position | %s, %s, %s", math.round(players.LocalPlayer.Character.HumanoidRootPart.Position.X), math.round(players.LocalPlayer.Character.HumanoidRootPart.Position.Y), math.round(players.LocalPlayer.Character.HumanoidRootPart.Position.Z))
				GUI["l12"].Text = string.format("Rotation | %s, %s, %s", math.round(players.LocalPlayer.Character.HumanoidRootPart.Rotation.X), math.round(players.LocalPlayer.Character.HumanoidRootPart.Rotation.Y), math.round(players.LocalPlayer.Character.HumanoidRootPart.Rotation.Z))
			end
		end
		--
		if not runService:IsStudio() then
			runService.PostSimulation:Connect(function()
				task.spawn(function()
					if players.LocalPlayer.Character and players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						GUI:UpdateVelocityStats()
					end
				end)
			end)
		end
	end

	function Library:FadeOut()
		originalTransparencies = {}

		if next(originalTransparencies) == nil then
			originalTransparencies[GUI["2"]] = GUI["2"].BackgroundTransparency
			originalTransparencies[GUI["4"]] = GUI["4"].BackgroundTransparency
			originalTransparencies[GUI["5"]] = GUI["5"].ImageTransparency
			--
			for _, UI in pairs(GUI["2"]:GetDescendants()) do
				if UI:IsA("Frame") then
					originalTransparencies[UI] = UI.BackgroundTransparency
				elseif UI:IsA("TextLabel") then
					originalTransparencies[UI] = UI.TextTransparency
				elseif UI:IsA("UIStroke") then
					originalTransparencies[UI] = UI.Transparency
				elseif UI:IsA("ImageLabel") then
					originalTransparencies[UI] = UI.ImageTransparency
				elseif UI:IsA("TextBox") then
					originalTransparencies[UI] = UI.TextTransparency
				elseif UI:IsA("ScrollingFrame") then
					originalTransparencies[UI] = UI.ScrollBarImageTransparency
				end
			end
		end

		for UI, _ in pairs(originalTransparencies) do
			if UI:IsA("Frame") then
				tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
			elseif UI:IsA("TextLabel") or UI:IsA("TextBox") then
				tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
			elseif UI:IsA("UIStroke") then
				tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Transparency = 1}):Play()
			elseif UI:IsA("ImageLabel") then
				tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
			elseif UI:IsA("ScrollingFrame") then
				tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {ScrollBarImageTransparency = 1}):Play()
			end
		end

		task.wait(Library.tweenInfoFadeSpeed + 0.1)
		GUI["2"].Visible = false
	end

	function Library:FadeIn()
		GUI["2"].Visible = true

		for UI, oldTransparency in pairs(originalTransparencies) do
			if UI:IsA("Frame") then
				tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {BackgroundTransparency = oldTransparency}):Play()
			elseif UI:IsA("TextLabel") or UI:IsA("TextBox") then
				tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {TextTransparency = oldTransparency}):Play()
			elseif UI:IsA("UIStroke") then
				tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Transparency = oldTransparency}):Play()
			elseif UI:IsA("ImageLabel") then
				tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {ImageTransparency = oldTransparency}):Play()
			elseif UI:IsA("ScrollingFrame") then
				tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {ScrollBarImageTransparency = oldTransparency}):Play()
			end
		end

		originalTransparencies = {}

		task.wait(Library.tweenInfoFadeSpeed + 0.1)
	end

	function GUI:KeybindListVisibility(State)
		GUI["1c"].Visible = State
	end

	function GUI:WatermarkVisibility(State)
		GUI["f"].Visible = State
	end

	function GUI:IndicatorVisibility(State)
		GUI["16"].Visible = State
	end

	function GUI:VelocityStatsVisibility(State)
		GUI["l2"].Visible = State
	end

	function GUI:MainUIVisibility(State)
		GUI["2"].Visible = State
	end


	uis.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == options.CloseBind and not Debounce then
			Debounce = true
			if isFadedOut then
				Library:FadeIn()
			else
				Library:FadeOut()
			end
			isFadedOut = not isFadedOut
			task.wait(Library.tweenInfoFadeSpeed + 0.1)
			Debounce = false
		end
	end)

	-- StarterGui.MyLibrary.MainBackground.ResizableCorner
	GUI["2mm"] = Instance.new("Frame", GUI["2"]);
	GUI["2mm"]["BorderSizePixel"] = 0;
	GUI["2mm"]["BackgroundTransparency"] = 1;
	GUI["2mm"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["2mm"]["Size"] = UDim2.new(0, 20, 0, 20);
	GUI["2mm"]["Name"] = [[ResizableCorner]];
	GUI["2mm"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["2mm"]["Position"] = UDim2.new(0.975, 0, 0.966, 0);

	local cornerFrame = GUI["2mm"]
	local mainFrame = GUI["2"]
	local outlineGui = GUI["gggg"]

	local isDragging = false
	local Hover = false
	local originalSize = mainFrame.Size
	local originalMousePosition = Vector2.new()
	local minSize = options.MinResize
	local maxSize = options.MaxResize

	local function updateSize(input)
		local currentMousePosition = uis:GetMouseLocation()
		local delta = currentMousePosition - originalMousePosition
		return UDim2.new(0, math.clamp(originalSize.X.Offset + delta.X, minSize.X.Offset, maxSize.X.Offset), 0, math.clamp(originalSize.Y.Offset + delta.Y, minSize.Y.Offset, maxSize.Y.Offset))
	end

	uis.InputBegan:Connect(function(input, gpe)
		if gpe then return end

		if input.UserInputType == Enum.UserInputType.MouseButton1 and Hover then
			isDragging = true
			originalMousePosition = uis:GetMouseLocation()
			mouse.Icon = "rbxassetid://17700660626"
			originalSize = mainFrame.Size
			if Library.performanceDrag then
				outlineGui.Visible = true
			end
			outlineGui.Size = mainFrame.Size
		end
	end)

	uis.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
			outlineGui.Size = updateSize(input)
			if not Library.performanceDrag then
				tweenService:Create(mainFrame, newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Size = outlineGui.Size}):Play()
				tweenService:Create(GUI["4"], newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Size = outlineGui.Size}):Play()
			end
			
			mouse.Icon = "rbxassetid://17700660626"
		end
	end)

	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
			mouse.Icon = ""
			if Library.performanceDrag then
				tweenService:Create(mainFrame, newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Size = outlineGui.Size}):Play()
				tweenService:Create(GUI["4"], newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Size = outlineGui.Size}):Play()
			end
			outlineGui.Visible = false
		end
	end)

	cornerFrame.MouseEnter:Connect(function()
		if not Library:IsMouseOverFrame(cornerFrame) then return end
		Hover = true
		mouse.Icon = "rbxassetid://17700660626"
	end)

	cornerFrame.MouseLeave:Connect(function()
		Hover = false
		mouse.Icon = ""
	end)

	do -- Navigation
		-- StarterGui.MyLibrary.MainBackground.Navigation
		GUI["46"] = Instance.new("Frame", GUI["2"]);
		GUI["46"]["BorderSizePixel"] = 0;
		GUI["46"]["BackgroundColor3"] = Color3.fromRGB(24, 24, 24);
		GUI["46"]["Size"] = UDim2.new(0, 80, 1, -25);
		GUI["46"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["46"]["Position"] = UDim2.new(0, 0, 0, 25);
		GUI["46"]["Name"] = [[Navigation]];

		-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder
		GUI["47"] = Instance.new("ScrollingFrame", GUI["46"]);
		GUI["47"]["Active"] = true;
		GUI["47"]["BorderSizePixel"] = 0;
		GUI["47"]["ScrollBarImageTransparency"] = 1;
		GUI["47"]["ScrollBarThickness"] = 0;
		GUI["47"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["47"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
		GUI["47"]["BackgroundTransparency"] = 1;
		GUI["47"]["Size"] = UDim2.new(1, 0, 1, 0);
		GUI["47"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["47"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["47"]["Name"] = [[ButtonHolder]];
		GUI["47"]["BottomImage"] = "http://www.roblox.com/asset/?id=158362264";
		GUI["47"]["MidImage"] = "http://www.roblox.com/asset/?id=158362264";
		GUI["47"]["TopImage"] = "http://www.roblox.com/asset/?id=158362264";

		-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.UIPadding
		GUI["48"] = Instance.new("UIPadding", GUI["47"]);

		-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.UIListLayout
		GUI["49"] = Instance.new("UIListLayout", GUI["47"]);
		GUI["49"]["Padding"] = UDim.new(0, 1);
		GUI["49"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
	end

	do -- Logic
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			viewport = workspace.CurrentCamera.ViewportSize

			GUI["2"]["Position"] = UDim2.fromOffset((viewport.X / 2) - (GUI["2"].Size.X.Offset / 2), (viewport.Y / 2) - (GUI["2"].Size.Y.Offset / 2))
			GUI["4"]["Position"] = UDim2.fromOffset((viewport.X / 2) - (GUI["2"].Size.X.Offset / 2), (viewport.Y / 2) - (GUI["2"].Size.Y.Offset / 2))
			GUI["gggg"]["Position"] = UDim2.fromOffset((viewport.X / 2) - (GUI["2"].Size.X.Offset / 2), (viewport.Y / 2) - (GUI["2"].Size.Y.Offset / 2))

			GUI["1c"]["Position"] = UDim2.fromOffset(10, (viewport.Y / 2) - (GUI["1c"].Size.Y.Offset / 2))
			GUI["l2"]["Position"] = UDim2.fromOffset(viewport.X - GUI["l2"].Size.X.Offset - 12, (viewport.Y / 2) - (GUI["l2"].Size.Y.Offset / 2))
		end)

		local scrollingFrame = GUI["47"]
		local uilistlayout = GUI["49"]

		local function resizeScrollingFrame()
			local totalHeight = 0
			for _, child in ipairs(scrollingFrame:GetChildren()) do
				if child:IsA("Frame") then
					totalHeight = totalHeight + child.AbsoluteSize.Y + uilistlayout.Padding.Offset
				end
			end
			scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
		end

		uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeScrollingFrame)
		resizeScrollingFrame()

		GUI["58"].MouseEnter:Connect(function()
			if not Library:IsMouseOverFrame(GUI["68"]) then return end
			GUI.Hover = true
		end)

		GUI["58"].MouseLeave:Connect(function()
			GUI.Hover = false
		end)


		uis.InputBegan:Connect(function(input, gpe)
			if gpe then return end

			if input.UserInputType == Enum.UserInputType.MouseButton1 and GUI.Hover then
				GUI:FadeOut()
			end
		end)
	end

	function GUI:CreateTab(options)
		options = Library:Validate({
			Name = "Main",
			Icon = "rbxassetid://16863175349",
			PlayerList = false,
			SkinList = false,
			GunList = false,
			ESPPreview = false,
		}, options or {})

		local Tab = {
			Hover = false,
			Active = false,
			MultiSections = {},
		}

		-- Render
		do
			-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive
			Tab["4e"] = Instance.new("Frame", GUI["47"]);
			Tab["4e"]["BorderSizePixel"] = 0;
			Tab["4e"]["BackgroundColor3"] = Color3.fromRGB(24, 24, 24);
			Tab["4e"]["BackgroundTransparency"] = 0;
			Tab["4e"]["Size"] = UDim2.new(1, 0, 0, 80);
			Tab["4e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["4e"]["Name"] = options.Name;

			-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
			Tab["bf"] = Instance.new("TextButton", Tab["4e"]);
			Tab["bf"]["BorderSizePixel"] = 0;
			Tab["bf"]["TextTransparency"] = 1;
			Tab["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["bf"]["TextSize"] = 14;
			Tab["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Tab["bf"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["bf"]["Size"] = UDim2.new(1, 0, 1, 0);
			Tab["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["bf"]["BackgroundTransparency"] = 1;

			-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.Main
			Tab["4f"] = Instance.new("TextLabel", Tab["4e"]);
			Tab["4f"]["TextWrapped"] = true;
			Tab["4f"]["BorderSizePixel"] = 0;
			Tab["4f"]["TextScaled"] = true;
			Tab["4f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["4f"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Tab["4f"]["TextSize"] = 14;
			Tab["4f"]["TextColor3"] = Color3.fromRGB(124, 124, 124);
			Tab["4f"]["Size"] = UDim2.new(1, 0, 0, 16);
			Tab["4f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["4f"]["Text"] = options["Name"];
			Tab["4f"]["Name"] = [[Main]];
			Tab["4f"]["BackgroundTransparency"] = 1;
			Tab["4f"]["Position"] = UDim2.new(0, 0, 0.5249999761581421, 0);

			-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.Icon
			Tab["50"] = Instance.new("ImageLabel", Tab["4e"]);
			Tab["50"]["BorderSizePixel"] = 0;
			Tab["50"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["50"]["ImageColor3"] = Color3.fromRGB(124, 124, 124);
			Tab["50"]["Image"] = options["Icon"];
			Tab["50"]["Size"] = UDim2.new(0, 23, 0, 23);
			Tab["50"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["50"]["Name"] = [[Icon]];
			Tab["50"]["BackgroundTransparency"] = 1;
			Tab["50"]["Position"] = UDim2.new(0.3499999940395355, 0, 0.16300000250339508, 0);

			-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Active.Bar
			Tab["4d"] = Instance.new("Frame", Tab["4e"]);
			Tab["4d"]["BorderSizePixel"] = 0;
			Tab["4d"]["BackgroundTransparency"] = 1;
			Tab["4d"]["BackgroundColor3"] = Library.Theme.Accent;
			Tab["4d"]["Size"] = UDim2.new(0, 2, 1, 0);
			Tab["4d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["4d"]["Name"] = [[Bar]];

			table.insert(Library.ThemeObjects, Tab["4d"])

			-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab
			Tab["7"] = Instance.new("Frame", GUI["6"]);
			Tab["7"]["BorderSizePixel"] = 0;
			Tab["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["7"]["BackgroundTransparency"] = 1;
			Tab["7"]["Size"] = UDim2.new(1, -12, 1, 2);
			Tab["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["7"]["Position"] = UDim2.new(0, 6, 0, -14);
			Tab["7"]["Name"] = options.Name;
			Tab["7"]["Visible"] = false;
			Tab["7"]["ClipsDescendants"] = true;
		end

		if options.PlayerList == false then
			do -- Columns
				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left
				Tab["8"] = Instance.new("ScrollingFrame", Tab["7"]);
				Tab["8"]["Active"] = true;
				Tab["8"]["BorderSizePixel"] = 0;
				Tab["8"]["ScrollBarImageTransparency"] = 1;
				Tab["8"]["ScrollBarImageColor3"] = Library.Theme.Accent;
				Tab["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Tab["8"]["BackgroundTransparency"] = 1;
				Tab["8"]["Size"] = UDim2.new(0.495, 0, 1, 2);
				Tab["8"]["Position"] = UDim2.new(0, 0, 0, 7);
				Tab["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Tab["8"]["ScrollBarThickness"] = 3;
				Tab["8"]["Name"] = [[Left]];
				Tab["8"]["BottomImage"] = "http://www.roblox.com/asset/?id=158362264";
				Tab["8"]["MidImage"] = "http://www.roblox.com/asset/?id=158362264";
				Tab["8"]["TopImage"] = "http://www.roblox.com/asset/?id=158362264";

				table.insert(Library.ThemeObjects, Tab["8"])

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.UIListLayout
				Tab["9"] = Instance.new("UIListLayout", Tab["8"]);
				Tab["9"]["Padding"] = UDim.new(0, 10);
				Tab["9"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.UIPadding
				Tab["a"] = Instance.new("UIPadding", Tab["8"]);
				Tab["a"]["PaddingRight"] = UDim.new(0, 1);
				Tab["a"]["PaddingBottom"] = UDim.new(0, 1);
				Tab["a"]["PaddingLeft"] = UDim.new(0, 1);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right
				Tab["41"] = Instance.new("ScrollingFrame", Tab["7"]);
				Tab["41"]["Active"] = true;
				Tab["41"]["BorderSizePixel"] = 0;
				Tab["41"]["ScrollBarImageTransparency"] = 1;
				Tab["41"]["ScrollBarImageColor3"] = Library.Theme.Accent;
				Tab["41"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Tab["41"]["BackgroundTransparency"] = 1;
				Tab["41"]["Size"] = UDim2.new(0.495, 0, 1, 2);
				Tab["41"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Tab["41"]["ScrollBarThickness"] = 3;
				Tab["41"]["Position"] = UDim2.new(0.505, 0, 0, 7);
				Tab["41"]["Name"] = [[Right]];
				Tab["41"]["BottomImage"] = "http://www.roblox.com/asset/?id=158362264";
				Tab["41"]["MidImage"] = "http://www.roblox.com/asset/?id=158362264";
				Tab["41"]["TopImage"] = "http://www.roblox.com/asset/?id=158362264";

				table.insert(Library.ThemeObjects, Tab["41"])

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.UIListLayout
				Tab["42"] = Instance.new("UIListLayout", Tab["41"]);
				Tab["42"]["Padding"] = UDim.new(0, 10);
				Tab["42"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.UIPadding
				Tab["43"] = Instance.new("UIPadding", Tab["41"]);
				Tab["43"]["PaddingRight"] = UDim.new(0, 1);
				Tab["43"]["PaddingBottom"] = UDim.new(0, 1);
				Tab["43"]["PaddingLeft"] = UDim.new(0, 1);
			end

			local frameToTrack = GUI["2"]
			local scrollingFrame = Tab["8"]
			local scrollingFrame2 = Tab["41"]

			local function updateScrollingFrameSize()
				local totalHeight = 0
				for _, item in ipairs(scrollingFrame:GetChildren()) do
					if item:IsA("Frame") then
						totalHeight = totalHeight + item.AbsoluteSize.Y + 10
					end
				end
				scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

				local totalHeight2 = 0
				for _, item in ipairs(scrollingFrame2:GetChildren()) do
					if item:IsA("Frame") then
						totalHeight2 = totalHeight2 + item.AbsoluteSize.Y + 10
					end
				end
				scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, totalHeight2)

				scrollingFrame.ScrollBarImageTransparency = scrollingFrame.CanvasSize.Y.Offset <= scrollingFrame.AbsoluteSize.Y and 1 or 0
				scrollingFrame2.ScrollBarImageTransparency = scrollingFrame2.CanvasSize.Y.Offset <= scrollingFrame2.AbsoluteSize.Y and 1 or 0
			end

			frameToTrack:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScrollingFrameSize)

			scrollingFrame.ChildAdded:Connect(updateScrollingFrameSize)
			scrollingFrame.ChildRemoved:Connect(updateScrollingFrameSize)

			scrollingFrame2.ChildAdded:Connect(updateScrollingFrameSize)
			scrollingFrame2.ChildRemoved:Connect(updateScrollingFrameSize)

			updateScrollingFrameSize()



		end
		-- Methods
		function Tab:Activate()
			if not Tab.Active then

				if GUI.CurrentTab ~= nil then
					GUI.CurrentTab:Deactivate()
				end

				Tab.Active = true

				Library:tween(Tab["4e"], {BackgroundColor3 = Color3.fromRGB(27, 27, 27)})
				Library:tween(Tab["4d"], {BackgroundTransparency = 0})
				Library:tween(Tab["50"], {ImageColor3 = Color3.fromRGB(255, 255, 255)})
				Library:tween(Tab["4f"], {TextColor3 = Color3.fromRGB(255, 255, 255)})
				Tab["7"].Visible = true

				GUI.CurrentTab = Tab
				GUI["2"]:SetAttribute("CurrentTab", GUI.CurrentTab["4e"].Name)
			end
		end

		function Tab:Deactivate()
			if Tab.Active then
				Tab.Active = false
				Tab.Hover = false

				Library:tween(Tab["4e"], {BackgroundColor3 = Color3.fromRGB(24, 24, 24)})
				Library:tween(Tab["4d"], {BackgroundTransparency = 1})
				Library:tween(Tab["50"], {ImageColor3 = Color3.fromRGB(124, 124, 124)})
				Library:tween(Tab["4f"], {TextColor3 = Color3.fromRGB(124, 124, 124)})
				Tab["7"].Visible = false
			end
		end

		-- Logic
		do
			Tab["4e"].MouseEnter:Connect(function()
				if not Library:IsMouseOverFrame(Tab["4e"]) then return end
				Tab.Hover = true

				if not Tab.Active then
					Library:tween(Tab["50"], {ImageColor3 = Color3.fromRGB(214, 214, 214)})
					Library:tween(Tab["4f"], {TextColor3 = Color3.fromRGB(214, 214, 214)})
				end
			end)

			Tab["4e"].MouseLeave:Connect(function()
				Tab.Hover = false

				if not Tab.Active then
					Library:tween(Tab["50"], {ImageColor3 = Color3.fromRGB(124, 124, 124)})
					Library:tween(Tab["4f"], {TextColor3 = Color3.fromRGB(124, 124, 124)})
				end
			end)

			Tab["bf"].MouseButton1Click:Connect(function()
				if Tab.Hover and not isFadedOut then
					Tab:Activate()
				end
			end)

			if GUI.CurrentTab == nil then
				Tab:Activate()
			end
		end

		if options.ESPPreview == true then
			local ESPPreviewTab = Tab["4e"].Name
			local UIFadedIn = false
			local Preview = {}

			do -- Render
				-- StarterGui.MyLibrary.ESPPreview
				Preview["2"] = Instance.new("Frame", GUI["2"]);
				Preview["2"]["BorderSizePixel"] = 0;
				Preview["2"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
				Preview["2"]["AnchorPoint"] = Vector2.new(1, 0);
				Preview["2"]["Size"] = UDim2.new(0, 270, 0, 360);
				Preview["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["2"]["Position"] = UDim2.new(1, 280, 0, 0);
				Preview["2"]["Name"] = [[ESPPreview]];
				Preview["2"]["Visible"] = true

				-- StarterGui.MyLibrary.ESPPreview.UIStroke
				Preview["3"] = Instance.new("UIStroke", Preview["2"]);
				Preview["3"]["Color"] = Color3.fromRGB(11, 11, 11);
				Preview["3"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder
				Preview["4"] = Instance.new("Frame", Preview["2"]);
				Preview["4"]["BorderSizePixel"] = 0;
				Preview["4"]["BackgroundColor3"] = Color3.fromRGB(21, 21, 21);
				Preview["4"]["AnchorPoint"] = Vector2.new(1, 0);
				Preview["4"]["BackgroundTransparency"] = 1;
				Preview["4"]["Size"] = UDim2.new(1, 0, 1, -25);
				Preview["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["4"]["Position"] = UDim2.new(1, 0, 0, 25);
				Preview["4"]["Name"] = [[Holder]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Box
				Preview["5"] = Instance.new("Frame", Preview["4"]);
				Preview["5"]["ZIndex"] = 2;
				Preview["5"]["BorderSizePixel"] = 0;
				Preview["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["5"]["BackgroundTransparency"] = 0.800000011920929;
				Preview["5"]["Size"] = UDim2.new(0, 204, 0, 250);
				Preview["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["5"]["Position"] = UDim2.new(0, 33, 0, 30);
				Preview["5"]["Name"] = [[Box]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Box.UIStroke
				Preview["6"] = Instance.new("UIStroke", Preview["5"]);
				Preview["6"]["Color"] = Color3.fromRGB(255, 255, 255);
				Preview["6"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.CornerBox
				Preview["30"] = Instance.new("Frame", Preview["4"]);
				Preview["30"]["BorderSizePixel"] = 0;
				Preview["30"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["30"]["BackgroundTransparency"] = 1;
				Preview["30"]["Size"] = UDim2.new(0, 204, 0, 250);
				Preview["30"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["30"]["Position"] = UDim2.new(0, 33, 0, 30);
				Preview["30"]["Name"] = [[CornerBox]];
				Preview["30"]["ZIndex"] = 2;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Box
				Preview["5g"] = Instance.new("Frame", Preview["30"]);
				Preview["5g"]["BorderSizePixel"] = 0;
				Preview["5g"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["5g"]["BackgroundTransparency"] = 0.8;
				Preview["5g"]["Size"] = UDim2.new(1, -2, 1, -2);
				Preview["5g"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["5g"]["Position"] = UDim2.new(0, 1, 0, 1);
				Preview["5g"]["Name"] = [[Fill]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.CornerBox.LeftTop
				Preview["31"] = Instance.new("Frame", Preview["30"]);
				Preview["31"]["BorderSizePixel"] = 0;
				Preview["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["31"]["Size"] = UDim2.new(0, 1, 0, 70);
				Preview["31"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["31"]["Name"] = [[LeftTop]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.CornerBox.RightBottom
				Preview["32"] = Instance.new("Frame", Preview["30"]);
				Preview["32"]["BorderSizePixel"] = 0;
				Preview["32"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["32"]["Size"] = UDim2.new(0, 1, 0, 70);
				Preview["32"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["32"]["Position"] = UDim2.new(1, 0, 1, -70);
				Preview["32"]["Name"] = [[RightBottom]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.CornerBox.LeftBottom
				Preview["33"] = Instance.new("Frame", Preview["30"]);
				Preview["33"]["BorderSizePixel"] = 0;
				Preview["33"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["33"]["Size"] = UDim2.new(0, 1, 0, 70);
				Preview["33"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["33"]["Position"] = UDim2.new(0, 0, 1, -70);
				Preview["33"]["Name"] = [[LeftBottom]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.CornerBox.RightTop
				Preview["34"] = Instance.new("Frame", Preview["30"]);
				Preview["34"]["BorderSizePixel"] = 0;
				Preview["34"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["34"]["Size"] = UDim2.new(0, 1, 0, 70);
				Preview["34"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["34"]["Position"] = UDim2.new(1, 0, 0, 0);
				Preview["34"]["Name"] = [[RightTop]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.CornerBox.TopLeft
				Preview["35"] = Instance.new("Frame", Preview["30"]);
				Preview["35"]["BorderSizePixel"] = 0;
				Preview["35"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["35"]["Size"] = UDim2.new(0, 70, 0, 1);
				Preview["35"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["35"]["Name"] = [[TopLeft]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.CornerBox.BottomLeft
				Preview["36"] = Instance.new("Frame", Preview["30"]);
				Preview["36"]["BorderSizePixel"] = 0;
				Preview["36"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["36"]["Size"] = UDim2.new(0, 70, 0, 1);
				Preview["36"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["36"]["Position"] = UDim2.new(0, 0, 1, 0);
				Preview["36"]["Name"] = [[BottomLeft]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.CornerBox.BottomRight
				Preview["37"] = Instance.new("Frame", Preview["30"]);
				Preview["37"]["BorderSizePixel"] = 0;
				Preview["37"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["37"]["Size"] = UDim2.new(0, 70, 0, 1);
				Preview["37"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["37"]["Position"] = UDim2.new(1, -70, 1, 0);
				Preview["37"]["Name"] = [[BottomRight]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.CornerBox.TopRight
				Preview["38"] = Instance.new("Frame", Preview["30"]);
				Preview["38"]["BorderSizePixel"] = 0;
				Preview["38"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["38"]["Size"] = UDim2.new(0, 70, 0, 1);
				Preview["38"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["38"]["Position"] = UDim2.new(1, -70, 0, 0);
				Preview["38"]["Name"] = [[TopRight]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Name
				Preview["7"] = Instance.new("Frame", Preview["4"]);
				Preview["7"]["BorderSizePixel"] = 0;
				Preview["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["7"]["BackgroundTransparency"] = 1;
				Preview["7"]["Size"] = UDim2.new(0, 204, 0, 25);
				Preview["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["7"]["Position"] = UDim2.new(0, 33, 0, 5);
				Preview["7"]["Name"] = [[Name]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Name.NameText
				Preview["8"] = Instance.new("TextLabel", Preview["7"]);
				Preview["8"]["BorderSizePixel"] = 0;
				Preview["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["8"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Preview["8"]["TextSize"] = 14;
				Preview["8"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["8"]["Size"] = UDim2.new(1, 0, 1, 0);
				Preview["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["8"]["Text"] = [[Username]];
				Preview["8"]["Name"] = [[NameText]];
				Preview["8"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Name.NameText.UIPadding
				Preview["9"] = Instance.new("UIPadding", Preview["8"]);
				Preview["9"]["PaddingBottom"] = UDim.new(0, 5);

				-- StarterGui.MyLibrary.ESPPreview.Holder.Distance
				Preview["a"] = Instance.new("Frame", Preview["4"]);
				Preview["a"]["BorderSizePixel"] = 0;
				Preview["a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["a"]["BackgroundTransparency"] = 1;
				Preview["a"]["Size"] = UDim2.new(0, 204, 0, 20);
				Preview["a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["a"]["Position"] = UDim2.new(0, 33, 1, -47);
				Preview["a"]["Name"] = [[Distance]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Distance.DistanceText
				Preview["b"] = Instance.new("TextLabel", Preview["a"]);
				Preview["b"]["BorderSizePixel"] = 0;
				Preview["b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["b"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Preview["b"]["TextSize"] = 14;
				Preview["b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["b"]["Size"] = UDim2.new(1, 0, 1, 0);
				Preview["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["b"]["Text"] = [[50st]];
				Preview["b"]["Name"] = [[DistanceText]];
				Preview["b"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Distance.DistanceText.UIPadding
				Preview["c"] = Instance.new("UIPadding", Preview["b"]);


				-- StarterGui.MyLibrary.ESPPreview.Holder.Weapon
				Preview["d"] = Instance.new("Frame", Preview["4"]);
				Preview["d"]["BorderSizePixel"] = 0;
				Preview["d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["d"]["BackgroundTransparency"] = 1;
				Preview["d"]["Size"] = UDim2.new(0, 204, 0, 20);
				Preview["d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["d"]["Position"] = UDim2.new(0, 33, 1, -30);
				Preview["d"]["Name"] = [[Weapon]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Weapon.WeaponText
				Preview["e"] = Instance.new("TextLabel", Preview["d"]);
				Preview["e"]["BorderSizePixel"] = 0;
				Preview["e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["e"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Preview["e"]["TextSize"] = 14;
				Preview["e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["e"]["Size"] = UDim2.new(1, 0, 1, 0);
				Preview["e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["e"]["Text"] = [[Weapon]];
				Preview["e"]["Name"] = [[WeaponText]];
				Preview["e"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Weapon.WeaponText.UIPadding
				Preview["f"] = Instance.new("UIPadding", Preview["e"]);
				Preview["f"]["PaddingBottom"] = UDim.new(0, 5);
				Preview["f"]["PaddingLeft"] = UDim.new(0, 2);

				-- StarterGui.MyLibrary.ESPPreview.Holder.ArmorBar
				Preview["10"] = Instance.new("Frame", Preview["4"]);
				Preview["10"]["BorderSizePixel"] = 0;
				Preview["10"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["10"]["Size"] = UDim2.new(0, 204, 0, 3);
				Preview["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["10"]["Position"] = UDim2.new(0, 33, 1, -50);
				Preview["10"]["Name"] = [[ArmorBar]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.ArmorBar
				Preview["1d0"] = Instance.new("Frame", Preview["10"]);
				Preview["1d0"]["BorderSizePixel"] = 0;
				Preview["1d0"]["AnchorPoint"] = Vector2.new(1, 0);
				Preview["1d0"]["BackgroundColor3"] = Color3.fromRGB(0, 137, 195);
				Preview["1d0"]["Size"] = UDim2.new(1, 0, 1, 0);
				Preview["1d0"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["1d0"]["Position"] = UDim2.new(1, 0, 0, 0);
				Preview["1d0"]["Name"] = [[Bar]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.ArmorBar.UIStroke
				Preview["11"] = Instance.new("UIStroke", Preview["10"]);
				Preview["11"]["Thickness"] = 2;
				Preview["11"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.ArmorBar.ArmorBar
				Preview["12"] = Instance.new("TextLabel", Preview["4"]);
				Preview["12"]["BorderSizePixel"] = 0;
				Preview["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["12"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Preview["12"]["TextSize"] = 14;
				Preview["12"]["TextColor3"] = Color3.fromRGB(0, 137, 195);
				Preview["12"]["Size"] = UDim2.new(0, 20, 0, 20);
				Preview["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["12"]["Text"] = [[100]];
				Preview["12"]["Name"] = [[ArmorBar]];
				Preview["12"]["BackgroundTransparency"] = 1;
				Preview["12"]["Position"] = UDim2.new(1, -30, 1, -60);

				-- StarterGui.MyLibrary.ESPPreview.Holder.ArmorBar.ArmorBar.UIStroke
				Preview["13"] = Instance.new("UIStroke", Preview["12"]);


				-- StarterGui.MyLibrary.ESPPreview.Holder.HealthBar
				Preview["14"] = Instance.new("Frame", Preview["4"]);
				Preview["14"]["BorderSizePixel"] = 0;
				Preview["14"]["AnchorPoint"] = Vector2.new(0, 1);
				Preview["14"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["14"]["Size"] = UDim2.new(0, 3, 0, 250);
				Preview["14"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["14"]["Position"] = UDim2.new(0, 24, 1, -55);
				Preview["14"]["Name"] = [[HealthBar]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.HealthBar
				Preview["1d4"] = Instance.new("Frame", Preview["14"]);
				Preview["1d4"]["BorderSizePixel"] = 0;
				Preview["1d4"]["AnchorPoint"] = Vector2.new(0, 1);
				Preview["1d4"]["BackgroundColor3"] = Color3.fromRGB(0, 255, 0);
				Preview["1d4"]["Size"] = UDim2.new(1, 0, 1, 0);
				Preview["1d4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["1d4"]["Position"] = UDim2.new(0, 0, 1, 0);
				Preview["1d4"]["Name"] = [[Bar]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.HealthBar.UIStroke
				Preview["15"] = Instance.new("UIStroke", Preview["14"]);
				Preview["15"]["Thickness"] = 2;
				Preview["15"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.HealthBar.HealthText
				Preview["16"] = Instance.new("TextLabel", Preview["4"]);
				Preview["16"]["BorderSizePixel"] = 0;
				Preview["16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["16"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Preview["16"]["TextSize"] = 14;
				Preview["16"]["TextColor3"] = Color3.fromRGB(0, 255, 0);
				Preview["16"]["Size"] = UDim2.new(0, 20, 0, 20);
				Preview["16"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["16"]["Text"] = [[100]];
				Preview["16"]["Name"] = [[HealthText]];
				Preview["16"]["BackgroundTransparency"] = 1;
				Preview["16"]["Position"] = UDim2.new(0, 1, 0, 24);

				-- StarterGui.MyLibrary.ESPPreview.Holder.HealthBar.HealthText.UIStroke
				Preview["17"] = Instance.new("UIStroke", Preview["16"]);

				-- StarterGui.MyLibrary.ESPPreview.TopBar.TextLabel.UIPadding
				Preview["2fd"] = Instance.new("UIPadding", Preview["16"]);
				Preview["2fd"]["PaddingLeft"] = UDim.new(0, 0);

				-- StarterGui.MyLibrary.ESPPreview.Holder.HealthBar.HealthText
				Preview["1d6"] = Instance.new("TextLabel", Preview["4"]);
				Preview["1d6"]["BorderSizePixel"] = 0;
				Preview["1d6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["1d6"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Preview["1d6"]["TextSize"] = 14;
				Preview["1d6"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["1d6"]["Size"] = UDim2.new(0, 20, 0, 20);
				Preview["1d6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["1d6"]["Text"] = [[Flags]];
				Preview["1d6"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Preview["1d6"]["Name"] = [[HealthText]];
				Preview["1d6"]["BackgroundTransparency"] = 1;
				Preview["1d6"]["Position"] = UDim2.new(1, -28, 0, 24);

				-- StarterGui.MyLibrary.ESPPreview.Holder.HealthBar.HealthText.UIStroke
				Preview["1d7"] = Instance.new("UIStroke", Preview["1d6"]);


				-- StarterGui.MyLibrary.ESPPreview.Holder.ChamsHolder
				Preview["18"] = Instance.new("Frame", Preview["4"]);
				Preview["18"]["BorderSizePixel"] = 0;
				Preview["18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["18"]["BackgroundTransparency"] = 1;
				Preview["18"]["Size"] = UDim2.new(0, 204, 0, 250);
				Preview["18"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["18"]["Position"] = UDim2.new(0, 33, 0, 30);
				Preview["18"]["Name"] = [[ChamsHolder]];
				Preview["18"]["ZIndex"] = 3;

				-- StarterGui.MyLibrary.ESPPreview.Holder.ChamsHolder.Head
				Preview["19"] = Instance.new("Frame", Preview["18"]);
				Preview["19"]["ZIndex"] = 2;
				Preview["19"]["BorderSizePixel"] = 0;
				Preview["19"]["BackgroundColor3"] = Color3.fromRGB(0, 255, 0);
				Preview["19"]["AnchorPoint"] = Vector2.new(0.5, 0);
				Preview["19"]["BackgroundTransparency"] = 0.5;
				Preview["19"]["Size"] = UDim2.new(0, 50, 0, 50);
				Preview["19"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["19"]["Position"] = UDim2.new(0.5, 0, 0, 18);
				Preview["19"]["Name"] = [[Head]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.Torso.UIStroke
				Preview["1ef"] = Instance.new("UIStroke", Preview["19"]);
				Preview["1ef"]["Thickness"] = 2;
				Preview["1ef"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.ChamsHolder.Torso
				Preview["1a"] = Instance.new("Frame", Preview["18"]);
				Preview["1a"]["BorderSizePixel"] = 0;
				Preview["1a"]["BackgroundColor3"] = Color3.fromRGB(0, 255, 0);
				Preview["1a"]["AnchorPoint"] = Vector2.new(0.5, 0);
				Preview["1a"]["BackgroundTransparency"] = 0.5;
				Preview["1a"]["Size"] = UDim2.new(0, 150, 0, 80);
				Preview["1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["1a"]["Position"] = UDim2.new(0.5, 0, 0, 70);
				Preview["1a"]["Name"] = [[Torso]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.Torso.UIStroke
				Preview["1efd"] = Instance.new("UIStroke", Preview["1a"]);
				Preview["1efd"]["Thickness"] = 2;
				Preview["1efd"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.ChamsHolder.Legs
				Preview["1b"] = Instance.new("Frame", Preview["18"]);
				Preview["1b"]["BorderSizePixel"] = 0;
				Preview["1b"]["BackgroundColor3"] = Color3.fromRGB(0, 255, 0);
				Preview["1b"]["AnchorPoint"] = Vector2.new(0.5, 0);
				Preview["1b"]["BackgroundTransparency"] = 0.5;
				Preview["1b"]["Size"] = UDim2.new(0, 80, 0, 80);
				Preview["1b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["1b"]["Position"] = UDim2.new(0.5, 0, 0, 152);
				Preview["1b"]["Name"] = [[Legs]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.Torso.UIStroke
				Preview["1efs"] = Instance.new("UIStroke", Preview["1b"]);
				Preview["1efs"]["Thickness"] = 2;
				Preview["1efs"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons
				Preview["1c"] = Instance.new("Frame", Preview["4"]);
				Preview["1c"]["BorderSizePixel"] = 0;
				Preview["1c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["1c"]["BackgroundTransparency"] = 1;
				Preview["1c"]["Size"] = UDim2.new(0, 204, 0, 250);
				Preview["1c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["1c"]["Position"] = UDim2.new(0, 33, 0, 30);
				Preview["1c"]["Name"] = [[Skeletons]];
				Preview["1c"]["ZIndex"] = 4;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.Torso
				Preview["1d"] = Instance.new("Frame", Preview["1c"]);
				Preview["1d"]["BorderSizePixel"] = 0;
				Preview["1d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["1d"]["Size"] = UDim2.new(0, 1, 0, 100);
				Preview["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["1d"]["Position"] = UDim2.new(0.5, 0, 0, 55);
				Preview["1d"]["Name"] = [[Torso]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.Torso.UIStroke
				Preview["1e"] = Instance.new("UIStroke", Preview["1d"]);
				Preview["1e"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.Shoulders
				Preview["1f"] = Instance.new("Frame", Preview["1c"]);
				Preview["1f"]["BorderSizePixel"] = 0;
				Preview["1f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["1f"]["Size"] = UDim2.new(0, 120, 0, 1);
				Preview["1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["1f"]["Position"] = UDim2.new(0, 42, 0, 80);
				Preview["1f"]["Name"] = [[Shoulders]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.Shoulders.UIStroke
				Preview["20"] = Instance.new("UIStroke", Preview["1f"]);
				Preview["20"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.LeftArm
				Preview["21"] = Instance.new("Frame", Preview["1c"]);
				Preview["21"]["BorderSizePixel"] = 0;
				Preview["21"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["21"]["Size"] = UDim2.new(0, 1, 0, 60);
				Preview["21"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["21"]["Position"] = UDim2.new(0, 41, 0, 80);
				Preview["21"]["Name"] = [[LeftArm]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.LeftArm.UIStroke
				Preview["22"] = Instance.new("UIStroke", Preview["21"]);
				Preview["22"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.RightArm
				Preview["23"] = Instance.new("Frame", Preview["1c"]);
				Preview["23"]["BorderSizePixel"] = 0;
				Preview["23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["23"]["Size"] = UDim2.new(0, 1, 0, 60);
				Preview["23"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["23"]["Position"] = UDim2.new(0, 161, 0, 80);
				Preview["23"]["Name"] = [[RightArm]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.RightArm.UIStroke
				Preview["24"] = Instance.new("UIStroke", Preview["23"]);
				Preview["24"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.Pelvis
				Preview["25"] = Instance.new("Frame", Preview["1c"]);
				Preview["25"]["BorderSizePixel"] = 0;
				Preview["25"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["25"]["Size"] = UDim2.new(0, 40, 0, 1);
				Preview["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["25"]["Position"] = UDim2.new(0, 82, 0, 155);
				Preview["25"]["Name"] = [[Pelvis]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.Pelvis.UIStroke
				Preview["26"] = Instance.new("UIStroke", Preview["25"]);
				Preview["26"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.LeftLeg
				Preview["27"] = Instance.new("Frame", Preview["1c"]);
				Preview["27"]["BorderSizePixel"] = 0;
				Preview["27"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["27"]["Size"] = UDim2.new(0, 1, 0, 65);
				Preview["27"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["27"]["Position"] = UDim2.new(0, 81, 0, 155);
				Preview["27"]["Name"] = [[LeftLeg]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.LeftLeg.UIStroke
				Preview["28"] = Instance.new("UIStroke", Preview["27"]);
				Preview["28"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.RightLeg
				Preview["29"] = Instance.new("Frame", Preview["1c"]);
				Preview["29"]["BorderSizePixel"] = 0;
				Preview["29"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["29"]["Size"] = UDim2.new(0, 1, 0, 65);
				Preview["29"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["29"]["Position"] = UDim2.new(0, 122, 0, 155);
				Preview["29"]["Name"] = [[RightLeg]];

				-- StarterGui.MyLibrary.ESPPreview.Holder.Skeletons.RightLeg.UIStroke
				Preview["2a"] = Instance.new("UIStroke", Preview["29"]);
				Preview["2a"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

				-- StarterGui.MyLibrary.ESPPreview.DropShadowHolder
				Preview["2b"] = Instance.new("Frame", Preview["2"]);
				Preview["2b"]["ZIndex"] = 0;
				Preview["2b"]["BorderSizePixel"] = 0;
				Preview["2b"]["BackgroundTransparency"] = 1;
				Preview["2b"]["Size"] = UDim2.new(1, 0, 1, 0);
				Preview["2b"]["Name"] = [[DropShadowHolder]];

				-- StarterGui.MyLibrary.ESPPreview.DropShadowHolder.DropShadow
				Preview["2c"] = Instance.new("ImageLabel", Preview["2b"]);
				Preview["2c"]["ZIndex"] = 0;
				Preview["2c"]["BorderSizePixel"] = 0;
				Preview["2c"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
				Preview["2c"]["ScaleType"] = Enum.ScaleType.Slice;
				Preview["2c"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["2c"]["ImageTransparency"] = 0.5;
				Preview["2c"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
				Preview["2c"]["Image"] = [[rbxassetid://6015897843]];
				Preview["2c"]["Size"] = UDim2.new(1, 55, 1, 55);
				Preview["2c"]["Name"] = [[DropShadow]];
				Preview["2c"]["BackgroundTransparency"] = 1;
				Preview["2c"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

				-- StarterGui.MyLibrary.ESPPreview.TopBar
				Preview["2d"] = Instance.new("Frame", Preview["2"]);
				Preview["2d"]["ZIndex"] = 2;
				Preview["2d"]["BorderSizePixel"] = 0;
				Preview["2d"]["BackgroundColor3"] = Color3.fromRGB(25, 25, 25);
				Preview["2d"]["Size"] = UDim2.new(1, 0, 0, 25);
				Preview["2d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["2d"]["Position"] = UDim2.new(-5.1747466756069116e-08, 0, 4.09169338411175e-08, 0);
				Preview["2d"]["Name"] = [[TopBar]];

				-- StarterGui.MyLibrary.ESPPreview.TopBar.TextLabel
				Preview["2e"] = Instance.new("TextLabel", Preview["2d"]);
				Preview["2e"]["BorderSizePixel"] = 0;
				Preview["2e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Preview["2e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Preview["2e"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Preview["2e"]["TextSize"] = 14;
				Preview["2e"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
				Preview["2e"]["Size"] = UDim2.new(1, 0, 0, 25);
				Preview["2e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Preview["2e"]["Text"] = [[ESP Preview]];
				Preview["2e"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.ESPPreview.TopBar.TextLabel.UIPadding
				Preview["2f"] = Instance.new("UIPadding", Preview["2e"]);
				Preview["2f"]["PaddingRight"] = UDim.new(0, 25);
				Preview["2f"]["PaddingBottom"] = UDim.new(0, 2);
				Preview["2f"]["PaddingLeft"] = UDim.new(0, 8);
			end

			local function ColorLerp(Value, MinColor, MaxColor)
				if Value <= 0 then return MaxColor end
				if Value >= 100 then return MinColor end
				--
				return Color3.new(
					MaxColor.R + (MinColor.R - MaxColor.R) * Value,
					MaxColor.G + (MinColor.G - MaxColor.G) * Value,
					MaxColor.B + (MinColor.B - MaxColor.B) * Value
				)
			end

			local function UpdateLayout()
				-- // Bottom
				if Preview["10"].Visible == false then
					Preview["c"].PaddingBottom = UDim.new(0, 10)
					--
					if Preview["a"].Visible == false then
						Preview["f"].PaddingBottom = UDim.new(0, 45)
					else
						Preview["f"].PaddingBottom = UDim.new(0, 15)
					end
				else
					Preview["c"].PaddingBottom = UDim.new(0, 0)
					--
					if Preview["a"].Visible == false then
						Preview["f"].PaddingBottom = UDim.new(0, 35)
					else
						Preview["f"].PaddingBottom = UDim.new(0, 5)
					end
				end
				-- // Left
				if Preview["14"].Visible == false then
					Preview["2fd"].PaddingLeft = UDim.new(0, 15)
				else
					Preview["2fd"].PaddingLeft = UDim.new(0, 0)
				end
			end

			function Library:UpdateBox(Value, State, Type)
				if Type == "2D" then
					if Value == "Visible" then
						Preview["5"].Visible = State
					else
						for i, v in pairs(Preview["30"]:GetDescendants()) do
							if v:IsA("Frame") then
								if Value == "Color" then
									if v.Name ~= "Fill" then
										v.BackgroundColor3 = State
										Preview["6"].Color = State
									end
								else
									v[Value] = State
								end
							end
						end
					end
				else
					for i, v in pairs(Preview["30"]:GetDescendants()) do
						if v:IsA("Frame") then
							if Value == "Color" then
								if v.Name ~= "Fill" then
									v.BackgroundColor3 = State
									Preview["6"].Color = State
								end
							else
								v[Value] = State
							end
						end
					end
				end
			end

			local lastTransparency = 0.8

			function Library:UpdateBoxFill(Value, State, Type)
				local target
				local otherTarget
				
				if Type == "2D" then
					target = Preview["5"]
					otherTarget = Preview["5g"]
				else
					target = Preview["5g"]
					otherTarget = Preview["5"]
				end

				if Value == "Visible" then
					if State then
						target.BackgroundTransparency = lastTransparency
						otherTarget.BackgroundTransparency = lastTransparency
					else
						lastTransparency = target.BackgroundTransparency
						target.BackgroundTransparency = 1
						otherTarget.BackgroundTransparency = 1
					end
				elseif Value == "BackgroundTransparency" then
					lastTransparency = State
					target.BackgroundTransparency = State
					otherTarget.BackgroundTransparency = State
				else
					target[Value] = State
					otherTarget[Value] = State
				end
			end

			function Library:UpdateChams(Value, State, Type)
				if Type == "Inner" then
					for i, v in pairs(Preview["18"]:GetDescendants()) do
						if v:IsA("Frame") then
							v[Value] = State
						end
					end
				else
					for i, v in pairs(Preview["18"]:GetDescendants()) do
						if v:IsA("UIStroke") then
							v[Value] = State
						end
					end
				end
			end

			function Library:UpdateFlags(Value, State)
				Preview["1d6"][Value] = State
			end

			function Library:UpdateName(Value, State)
				if Value == "Visible" then
					Preview["7"][Value] = State
				else
					Preview["8"][Value] = State
				end
			end

			function Library:UpdateDistance(Value, State)
				if Value == "Visible" then
					Preview["a"][Value] = State
				else
					Preview["b"][Value] = State
				end
				--
				UpdateLayout()
			end

			function Library:UpdateWeapon(Value, State)
				if Value == "Visible" then
					Preview["d"][Value] = State
				else
					Preview["e"][Value] = State
				end
				--
				UpdateLayout()
			end

			function Library:UpdateHealth(Value, State, Type)
				if Type == "Bar" then
					if Value == "Visible" then
						Preview["1d4"].Visible = State
						Preview["14"].Visible = State
					else
						Preview["1d4"][Value] = State
					end
					UpdateLayout()
				else
					Preview["16"][Value] = State
					UpdateLayout()
				end
			end

			function Library:UpdateArmor(Value, State, Type)
				if Type == "Bar" then
					if Value == "Visible" then
						Preview["1d0"].Visible = State
						Preview["10"].Visible = State
					else
						Preview["1d0"][Value] = State
					end

					UpdateLayout()
				else
					Preview["12"][Value] = State
					UpdateLayout()
				end
			end

			function Library:UpdateSkeletons(Value, State)
				for i, v in pairs(Preview["1c"]:GetDescendants()) do
					if Value == "BackgroundTransparency" then
						if v:IsA("Frame") then
							v[Value] = State
						elseif v:IsA("UIStroke") then
							v.Transparency = State
						end
					else
						if v:IsA("Frame") then
							v[Value] = State
						end
					end
				end
			end
			
			local HealthFade, ArmorFade = 0, 0

			function Library:VisualHealthBar(State, HealthColor1, HealthColor2, Speed)
				if State and UIFadedIn then
					HealthFade = HealthFade + Speed
					local Smoothened = (math.acos(math.cos(HealthFade * math.pi)) / math.pi)
					local HealthColor = ColorLerp(Smoothened, HealthColor1, HealthColor2)

					Preview["16"].Text = math.round(Smoothened * 100)
					Preview["16"].TextColor3 = HealthColor
					Preview["1d4"].BackgroundColor3 = HealthColor
					Preview["1d4"].Size = UDim2.new(1, 0, Smoothened, 0)
				else
					Preview["16"].Text = "100"
					Preview["16"].TextColor3 = HealthColor1
				end
			end

			function Library:VisualArmorBar(State, ArmorColor1, ArmorColor2, Speed)
				if State and UIFadedIn then
					ArmorFade = ArmorFade + Speed
					local Smoothened = (math.acos(math.cos(ArmorFade * math.pi)) / math.pi)
					local ArmorColor = ColorLerp(Smoothened, ArmorColor1, ArmorColor2)

					Preview["12"].Text = math.round(Smoothened * 200)
					Preview["12"].TextColor3 = ArmorColor
					Preview["1d0"].BackgroundColor3 = ArmorColor
					Preview["1d0"].Size = UDim2.new(Smoothened, 0, 1, 0)
				else
					Preview["12"].Text = "200"
					Preview["12"].TextColor3 = ArmorColor2
				end
			end

			function Library:ResetBars(HealthColor, ArmorColor)
				Preview["16"].Text = "100"
				Preview["16"].TextColor3 = HealthColor
				Preview["1d4"].BackgroundColor3 = HealthColor
				Preview["1d4"].Size = UDim2.new(1, 0, 1, 0)
				
				Preview["12"].Text = "200"
				Preview["12"].TextColor3 = ArmorColor
				Preview["1d0"].BackgroundColor3 = ArmorColor
				Preview["1d0"].Size = UDim2.new(1, 0, 1, 0)
				
				HealthFade = 0
				ArmorFade = 0
			end

			-- // Set all to false for default
			Library:UpdateSkeletons("Visible", false)
			Library:UpdateArmor("Visible", false, "Bar")
			Library:UpdateArmor("Visible", false, "Text")
			Library:UpdateHealth("Visible", false, "Bar")
			Library:UpdateHealth("Visible", false, "Text")
			Library:UpdateWeapon("Visible", false)
			Library:UpdateDistance("Visible", false)
			Library:UpdateName("Visible", false)
			Library:UpdateFlags("Visible", false)
			Library:UpdateChams("Visible", false, "Inner")
			Library:UpdateBox("Visible", false, "2D")

			function Preview:FadeOut()
				if next(originalTransparencies2) == nil then

					originalTransparencies2[Preview["2"]] = Preview["2"].BackgroundTransparency

					for _, UI in pairs(Preview["2"]:GetDescendants()) do
						if UI:IsA("Frame") then
							originalTransparencies2[UI] = UI.BackgroundTransparency
						elseif UI:IsA("TextLabel") then
							originalTransparencies2[UI] = UI.TextTransparency
						elseif UI:IsA("UIStroke") then
							originalTransparencies2[UI] = UI.Transparency
						elseif UI:IsA("ImageLabel") then
							originalTransparencies2[UI] = UI.ImageTransparency
						elseif UI:IsA("TextBox") then
							originalTransparencies2[UI] = UI.TextTransparency
						elseif UI:IsA("ScrollingFrame") then
							originalTransparencies2[UI] = UI.ScrollBarImageTransparency
						end
					end
				end

				for UI, _ in pairs(originalTransparencies2) do
					if UI:IsA("Frame") then
						tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
					elseif UI:IsA("TextLabel") or UI:IsA("TextBox") then
						tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
					elseif UI:IsA("UIStroke") then
						tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Transparency = 1}):Play()
					elseif UI:IsA("ImageLabel") then
						tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
					elseif UI:IsA("ScrollingFrame") then
						tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {ScrollBarImageTransparency = 1}):Play()
					end
				end
			end

			function Preview:FadeIn()
				for UI, oldTransparency in pairs(originalTransparencies2) do
					if UI:IsA("Frame") then
						tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {BackgroundTransparency = oldTransparency}):Play()
					elseif UI:IsA("TextLabel") or UI:IsA("TextBox") then
						tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {TextTransparency = oldTransparency}):Play()
					elseif UI:IsA("UIStroke") then
						tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Transparency = oldTransparency}):Play()
					elseif UI:IsA("ImageLabel") then
						tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {ImageTransparency = oldTransparency}):Play()
					elseif UI:IsA("ScrollingFrame") then
						tweenService:Create(UI, newInfo(Library.tweenInfoFadeSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {ScrollBarImageTransparency = oldTransparency}):Play()
					end
				end
				
				originalTransparencies2 = {}
			end

			GUI["2"]:GetAttributeChangedSignal("CurrentTab"):Connect(function()
				if GUI["2"]:GetAttribute("CurrentTab") ~= nil and GUI["2"]:GetAttribute("CurrentTab") == ESPPreviewTab then
					Preview:FadeIn()
					UIFadedIn = true
				else
					Preview:FadeOut()
					UIFadedIn = false
				end
			end)

			Preview:FadeOut()
		end

		if options.GunList == true then
			local List = {}

			Tab["8"].Size = UDim2.new(0.495, 0, 1, -65)
			Tab["8"].Position = UDim2.new(0, 0, 0, 65)
			Tab["41"].Size = UDim2.new(0.495, 0, 1, -65)
			Tab["41"].Position = UDim2.new(0.505, 0, 0, 65)

			function Tab:CreateGunButton(options)
				options = Library:Validate({
					Name = "Gun",
					Icon = "rbxassetid://17523930681",
				}, options or {})

				local GunButton = {
					Hover = false,
					Active = false
				}

				do -- Render
					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.Section.ContentContainer.DoubleBarrel
					GunButton["dd"] = Instance.new("ImageButton", List["da"]);
					GunButton["dd"]["BorderSizePixel"] = 0;
					GunButton["dd"]["BackgroundColor3"] = Color3.fromRGB(214, 214, 214);
					GunButton["dd"]["ImageColor3"] = Color3.fromRGB(214, 214, 214);
					GunButton["dd"]["Image"] = options.Icon;
					GunButton["dd"]["Size"] = UDim2.new(0, 63, 1, -2);
					GunButton["dd"]["Name"] = options.Name;
					GunButton["dd"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					GunButton["dd"]["BackgroundTransparency"] = 1;
				end

				function GunButton:Activate()
					if not GunButton.Active then

						if Tab.CurrentGun ~= nil then
							Tab.CurrentGun:Deactivate()
						end

						GunButton.Active = true

						Library:tween(GunButton["dd"], {ImageColor3 = Library.Theme.Accent})

						table.insert(Library.ThemeObjects, GunButton["dd"])

						Tab.CurrentGun = GunButton
					end
				end

				function GunButton:Deactivate()
					if GunButton.Active then
						GunButton.Active = false
						GunButton.Hover = false

						table.remove(Library.ThemeObjects, table.find(Library.ThemeObjects, GunButton["dd"]))

						Library:tween(GunButton["dd"], {ImageColor3 = Color3.fromRGB(214, 214, 214)})
					end
				end

				-- Logic
				do
					GunButton["dd"].MouseEnter:Connect(function()
						if not Library:IsMouseOverFrame(GunButton["dd"]) then return end
						GunButton.Hover = true

						if not GunButton.Active then
							Library:tween(GunButton["dd"], {ImageColor3 = Color3.fromRGB(255, 255, 255)})
						end
					end)

					GunButton["dd"].MouseLeave:Connect(function()
						GunButton.Hover = false

						if not GunButton.Active then
							Library:tween(GunButton["dd"], {ImageColor3 = Color3.fromRGB(214, 214, 214)})
						end
					end)

					GunButton["dd"].MouseButton1Click:Connect(function()
						if GunButton.Hover and not isFadedOut then
							GunButton:Activate()
						end
					end)

					if Tab.CurrentGun == nil then
						GunButton:Activate()
					end
				end

				return GunButton
			end


			do -- Render
				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList
				List["d6"] = Instance.new("ScrollingFrame", Tab["7"]);
				List["d6"]["Active"] = true;
				List["d6"]["ScrollingDirection"] = Enum.ScrollingDirection.X;
				List["d6"]["BorderSizePixel"] = 0;
				List["d6"]["ScrollBarImageTransparency"] = 1;
				List["d6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				List["d6"]["BackgroundTransparency"] = 1;
				List["d6"]["Size"] = UDim2.new(1, 0, 0, 60);
				List["d6"]["ClipsDescendants"] = true;
				List["d6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				List["d6"]["ScrollBarThickness"] = 2;
				List["d6"]["Name"] = [[GunList]];
				List["d6"]["BottomImage"] = "http://www.roblox.com/asset/?id=158362264";
				List["d6"]["MidImage"] = "http://www.roblox.com/asset/?id=158362264";
				List["d6"]["TopImage"] = "http://www.roblox.com/asset/?id=158362264";

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.UIPadding
				List["d7"] = Instance.new("UIPadding", List["d6"]);
				List["d7"]["PaddingTop"] = UDim.new(0, 7);
				List["d7"]["PaddingRight"] = UDim.new(0, 1);
				List["d7"]["PaddingBottom"] = UDim.new(0, 1);
				List["d7"]["PaddingLeft"] = UDim.new(0, 1);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.Section
				List["d8"] = Instance.new("Frame", List["d6"]);
				List["d8"]["BorderSizePixel"] = 0;
				List["d8"]["BackgroundColor3"] = Library.Theme.DarkContrast;
				List["d8"]["Size"] = UDim2.new(1, -2, 0, 52);
				List["d8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				List["d8"]["AutomaticSize"] = Enum.AutomaticSize.Y;
				List["d8"]["Name"] = options.Name;
				List["d8"]["ClipsDescendants"] = true;
				
				table.insert(Library.DarkContrastObjects, List["d8"])

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.Section.UIStroke
				List["d9"] = Instance.new("UIStroke", List["d8"]);
				List["d9"]["Color"] = Color3.fromRGB(27, 27, 27);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.Section.ContentContainer
				List["da"] = Instance.new("Frame", List["d8"]);
				List["da"]["BorderSizePixel"] = 0;
				List["da"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				List["da"]["BackgroundTransparency"] = 1;
				List["da"]["Size"] = UDim2.new(1, 0, 0, 20);
				List["da"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				List["da"]["Position"] = UDim2.new(0, 0, 0, 20);
				List["da"]["AutomaticSize"] = Enum.AutomaticSize.Y;
				List["da"]["Name"] = [[ContentContainer]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.Section.ContentContainer.UIListLayout
				List["db"] = Instance.new("UIListLayout", List["da"]);
				List["db"]["FillDirection"] = Enum.FillDirection.Horizontal;
				List["db"]["Padding"] = UDim.new(0, 105);
				List["db"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.Section.ContentContainer.UIPadding
				List["dc"] = Instance.new("UIPadding", List["da"]);
				List["dc"]["PaddingLeft"] = UDim.new(0, 10);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.Section.TopBar
				List["e2"] = Instance.new("Frame", List["d8"]);
				List["e2"]["BorderSizePixel"] = 0;
				List["e2"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 27);
				List["e2"]["Size"] = UDim2.new(1, 0, 0, 15);
				List["e2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				List["e2"]["Name"] = [[TopBar]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.Section.TopBar.Title
				List["e3"] = Instance.new("TextLabel", List["e2"]);
				List["e3"]["BorderSizePixel"] = 0;
				List["e3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				List["e3"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				List["e3"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				List["e3"]["TextSize"] = 14;
				List["e3"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
				List["e3"]["Size"] = UDim2.new(1, 0, 1, 0);
				List["e3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				List["e3"]["Text"] = [[Gun List]];
				List["e3"]["Name"] = [[Title]];
				List["e3"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.Section.TopBar.Title.UIPadding
				List["e4"] = Instance.new("UIPadding", List["e3"]);
				List["e4"]["PaddingLeft"] = UDim.new(0, 5);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList.UIListLayout
				List["e5"] = Instance.new("UIListLayout", List["d6"]);
				List["e5"]["Padding"] = UDim.new(0, 10);
				List["e5"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
			end

		end

		if options.PlayerList == true then

			local PlayerListTab = {
				Hover = false,
				Active = false,
				Scrolling = false,
				CurrentScroll = 0,
				test = false,
				test2 = false,
				CurrentPlayer = nil,
				Spectating = false,
			}

			do -- Render
				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.GunList
				PlayerListTab["5"] = Instance.new("ScrollingFrame", Tab["7"]);
				PlayerListTab["5"]["Active"] = true;
				PlayerListTab["5"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
				PlayerListTab["5"]["BorderSizePixel"] = 0;
				PlayerListTab["5"]["ScrollBarImageTransparency"] = 1;
				PlayerListTab["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["5"]["BackgroundTransparency"] = 1;
				PlayerListTab["5"]["Size"] = UDim2.new(1, -2, 1, 20);
				PlayerListTab["5"]["ClipsDescendants"] = true;
				PlayerListTab["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["5"]["ScrollBarThickness"] = 2;
				PlayerListTab["5"]["Position"] = UDim2.new(0, 1, 0, -12);
				PlayerListTab["5"]["Name"] = [[PlayerTab]];
				PlayerListTab["5"]["BottomImage"] = "http://www.roblox.com/asset/?id=158362264";
				PlayerListTab["5"]["MidImage"] = "http://www.roblox.com/asset/?id=158362264";
				PlayerListTab["5"]["TopImage"] = "http://www.roblox.com/asset/?id=158362264";

				PlayerListTab["5a"] = Instance.new("UIPadding", PlayerListTab["5"]);
				PlayerListTab["5a"]["PaddingTop"] = UDim.new(0, 20);
				PlayerListTab["5a"]["PaddingLeft"] = UDim.new(0, 1);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings
				PlayerListTab["6"] = Instance.new("Frame", PlayerListTab["5"]);
				PlayerListTab["6"]["BorderSizePixel"] = 0;
				PlayerListTab["6"]["BackgroundColor3"] = Library.Theme.DarkContrast;
				PlayerListTab["6"]["Size"] = UDim2.new(1, -1, 0, 80);
				PlayerListTab["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["6"]["Position"] = UDim2.new(0, 0, 0.491, 15);
				PlayerListTab["6"]["AutomaticSize"] = Enum.AutomaticSize.Y;
				PlayerListTab["6"]["Name"] = [[PlayerListSettings]];
				PlayerListTab["6"]["LayoutOrder"] = 2;
				
				table.insert(Library.DarkContrastObjects, PlayerListTab["6"])

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.UIStroke
				PlayerListTab["7"] = Instance.new("UIStroke", PlayerListTab["6"]);
				PlayerListTab["7"]["Color"] = Color3.fromRGB(27, 27, 27);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.TopBar
				PlayerListTab["8"] = Instance.new("Frame", PlayerListTab["6"]);
				PlayerListTab["8"]["BorderSizePixel"] = 0;
				PlayerListTab["8"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 27);
				PlayerListTab["8"]["Size"] = UDim2.new(1, 0, 0, 20);
				PlayerListTab["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["8"]["Name"] = [[TopBar]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.TopBar.Title
				PlayerListTab["9"] = Instance.new("TextLabel", PlayerListTab["8"]);
				PlayerListTab["9"]["BorderSizePixel"] = 0;
				PlayerListTab["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["9"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				PlayerListTab["9"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				PlayerListTab["9"]["TextSize"] = 14;
				PlayerListTab["9"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
				PlayerListTab["9"]["Size"] = UDim2.new(1, 0, 1, 0);
				PlayerListTab["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["9"]["Text"] = [[Player Name - Settings]];
				PlayerListTab["9"]["Name"] = [[Title]];
				PlayerListTab["9"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.TopBar.Title.UIPadding
				PlayerListTab["a"] = Instance.new("UIPadding", PlayerListTab["9"]);
				PlayerListTab["a"]["PaddingLeft"] = UDim.new(0, 5);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer
				PlayerListTab["c"] = Instance.new("Frame", PlayerListTab["6"]);
				PlayerListTab["c"]["BorderSizePixel"] = 0;
				PlayerListTab["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["c"]["BackgroundTransparency"] = 1;
				PlayerListTab["c"]["Size"] = UDim2.new(1, 0, 0.9620190262794495, -20);
				PlayerListTab["c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["c"]["Position"] = UDim2.new(0, 0, 0, 20);
				PlayerListTab["c"]["AutomaticSize"] = Enum.AutomaticSize.Y;
				PlayerListTab["c"]["Name"] = [[ContentContainer]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.UIPadding
				PlayerListTab["d"] = Instance.new("UIPadding", PlayerListTab["c"]);
				PlayerListTab["d"]["PaddingTop"] = UDim.new(0, 10);
				PlayerListTab["d"]["PaddingBottom"] = UDim.new(0, -8);
				PlayerListTab["d"]["PaddingLeft"] = UDim.new(0, 10);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.PlayerImage
				PlayerListTab["e"] = Instance.new("Frame", PlayerListTab["c"]);
				PlayerListTab["e"]["BorderSizePixel"] = 0;
				PlayerListTab["e"]["BackgroundColor3"] = Color3.fromRGB(23, 23, 23);
				PlayerListTab["e"]["Size"] = UDim2.new(0, 85, 0, 85);
				PlayerListTab["e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["e"]["Name"] = [[PlayerImage]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.PlayerImage.UIStroke
				PlayerListTab["f"] = Instance.new("UIStroke", PlayerListTab["e"]);
				PlayerListTab["f"]["Color"] = Color3.fromRGB(27, 27, 27);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.PlayerImage.Image
				PlayerListTab["10"] = Instance.new("ImageLabel", PlayerListTab["e"]);
				PlayerListTab["10"]["BorderSizePixel"] = 0;
				PlayerListTab["10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["10"]["Size"] = UDim2.new(1, 0, 1, 0);
				PlayerListTab["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["10"]["Name"] = [[Image]];
				PlayerListTab["10"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.PlayerImage.LoadingText
				PlayerListTab["11"] = Instance.new("TextLabel", PlayerListTab["e"]);
				PlayerListTab["11"]["BorderSizePixel"] = 0;
				PlayerListTab["11"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["11"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
				PlayerListTab["11"]["TextSize"] = 20;
				PlayerListTab["11"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
				PlayerListTab["11"]["Size"] = UDim2.new(1, 0, 1, 0);
				PlayerListTab["11"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["11"]["Text"] = [[. . ?]];
				PlayerListTab["11"]["Name"] = [[LoadingText]];
				PlayerListTab["11"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.TextHolder
				PlayerListTab["12"] = Instance.new("Frame", PlayerListTab["c"]);
				PlayerListTab["12"]["BorderSizePixel"] = 0;
				PlayerListTab["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["12"]["BackgroundTransparency"] = 1;
				PlayerListTab["12"]["Size"] = UDim2.new(0.5, -95, 0, 85);
				PlayerListTab["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["12"]["Position"] = UDim2.new(0, 95, 0, 0);
				PlayerListTab["12"]["Name"] = [[TextHolder]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.TextHolder.TextLabel
				PlayerListTab["13"] = Instance.new("TextLabel", PlayerListTab["12"]);
				PlayerListTab["13"]["BorderSizePixel"] = 0;
				PlayerListTab["13"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["13"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				PlayerListTab["13"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				PlayerListTab["13"]["TextSize"] = 14;
				PlayerListTab["13"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
				PlayerListTab["13"]["Size"] = UDim2.new(1, 0, 0, 20);
				PlayerListTab["13"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["13"]["Text"] = [[Health : 100/100]];
				PlayerListTab["13"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.TextHolder.TextLabel.UIPadding
				PlayerListTab["14"] = Instance.new("UIPadding", PlayerListTab["13"]);


				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.TextHolder.UIListLayout
				PlayerListTab["15"] = Instance.new("UIListLayout", PlayerListTab["12"]);
				PlayerListTab["15"]["Padding"] = UDim.new(0, 4);
				PlayerListTab["15"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.UIPadding
				PlayerListTab["2c"] = Instance.new("UIPadding", PlayerListTab["12"]);
				PlayerListTab["2c"]["PaddingTop"] = UDim.new(0, 1);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.TextHolder.UserId
				PlayerListTab["16"] = Instance.new("TextLabel", PlayerListTab["12"]);
				PlayerListTab["16"]["BorderSizePixel"] = 0;
				PlayerListTab["16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["16"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				PlayerListTab["16"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				PlayerListTab["16"]["TextSize"] = 14;
				PlayerListTab["16"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
				PlayerListTab["16"]["Size"] = UDim2.new(1, 0, 0, 20);
				PlayerListTab["16"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["16"]["Text"] = "UserID : 1";
				PlayerListTab["16"]["Name"] = [[UserId]];
				PlayerListTab["16"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.TextHolder.UserId.UIPadding
				PlayerListTab["17"] = Instance.new("UIPadding", PlayerListTab["16"]);


				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.TextHolder.TextLabel
				PlayerListTab["18"] = Instance.new("TextLabel", PlayerListTab["12"]);
				PlayerListTab["18"]["BorderSizePixel"] = 0;
				PlayerListTab["18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["18"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				PlayerListTab["18"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				PlayerListTab["18"]["TextSize"] = 14;
				PlayerListTab["18"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
				PlayerListTab["18"]["Size"] = UDim2.new(1, 0, 0, 20);
				PlayerListTab["18"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["18"]["Text"] = "Display Name : Unknown";
				PlayerListTab["18"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.TextHolder.TextLabel.UIPadding
				PlayerListTab["19"] = Instance.new("UIPadding", PlayerListTab["18"]);


				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.TextHolder.TextLabel
				PlayerListTab["1a"] = Instance.new("TextLabel", PlayerListTab["12"]);
				PlayerListTab["1a"]["BorderSizePixel"] = 0;
				PlayerListTab["1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["1a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				PlayerListTab["1a"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				PlayerListTab["1a"]["TextSize"] = 14;
				PlayerListTab["1a"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
				PlayerListTab["1a"]["Size"] = UDim2.new(1, 0, 0, 20);
				PlayerListTab["1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["1a"]["Text"] = "Name : Unknown";
				PlayerListTab["1a"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.TextHolder.TextLabel.UIPadding
				PlayerListTab["1b"] = Instance.new("UIPadding", PlayerListTab["1a"]);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownHolder
				PlayerListTab["1c"] = Instance.new("Frame", PlayerListTab["c"]);
				PlayerListTab["1c"]["BorderSizePixel"] = 0;
				PlayerListTab["1c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["1c"]["AnchorPoint"] = Vector2.new(1, 0);
				PlayerListTab["1c"]["BackgroundTransparency"] = 1;
				PlayerListTab["1c"]["Size"] = UDim2.new(0.5, -10, 0, 85);
				PlayerListTab["1c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["1c"]["Position"] = UDim2.new(1, -10, 0, 0);
				PlayerListTab["1c"]["Name"] = [[DropdownHolder]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownHolder.SpectateButton
				PlayerListTab["34"] = Instance.new("Frame", PlayerListTab["1c"]);
				PlayerListTab["34"]["BorderSizePixel"] = 0;
				PlayerListTab["34"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
				PlayerListTab["34"]["Size"] = UDim2.new(0.5, -10, 0, 18);
				PlayerListTab["34"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["34"]["Position"] = UDim2.new(0, 0, 1, -15);
				PlayerListTab["34"]["Name"] = [[SpectateButton]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownHolder.SpectateButton.Text
				PlayerListTab["35"] = Instance.new("TextLabel", PlayerListTab["34"]);
				PlayerListTab["35"]["TextWrapped"] = true;
				PlayerListTab["35"]["BorderSizePixel"] = 0;
				PlayerListTab["35"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["35"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				PlayerListTab["35"]["TextSize"] = 14;
				PlayerListTab["35"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
				PlayerListTab["35"]["Size"] = UDim2.new(1, 0, 1, -4);
				PlayerListTab["35"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["35"]["Text"] = [[Spectate]];
				PlayerListTab["35"]["Name"] = [[Text]];
				PlayerListTab["35"]["BackgroundTransparency"] = 1;
				PlayerListTab["35"]["Position"] = UDim2.new(0, 0, 0, 2);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownHolder.SpectateButton.UIStroke
				PlayerListTab["36"] = Instance.new("UIStroke", PlayerListTab["34"]);
				PlayerListTab["36"]["Color"] = Color3.fromRGB(27, 27, 27);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownHolder.GotoButton
				PlayerListTab["37"] = Instance.new("Frame", PlayerListTab["1c"]);
				PlayerListTab["37"]["BorderSizePixel"] = 0;
				PlayerListTab["37"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
				PlayerListTab["37"]["Size"] = UDim2.new(0.5, -10, 0, 18);
				PlayerListTab["37"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["37"]["Position"] = UDim2.new(0.5, 0, 1, -15);
				PlayerListTab["37"]["Name"] = [[GotoButton]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownHolder.GotoButton.Text
				PlayerListTab["38"] = Instance.new("TextLabel", PlayerListTab["37"]);
				PlayerListTab["38"]["TextWrapped"] = true;
				PlayerListTab["38"]["BorderSizePixel"] = 0;
				PlayerListTab["38"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["38"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				PlayerListTab["38"]["TextSize"] = 14;
				PlayerListTab["38"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
				PlayerListTab["38"]["Size"] = UDim2.new(1, 0, 1, -4);
				PlayerListTab["38"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["38"]["Text"] = [[Goto]];
				PlayerListTab["38"]["Name"] = [[Text]];
				PlayerListTab["38"]["BackgroundTransparency"] = 1;
				PlayerListTab["38"]["Position"] = UDim2.new(0, 0, 0, 2);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownHolder.GotoButton.UIStroke
				PlayerListTab["39"] = Instance.new("UIStroke", PlayerListTab["37"]);
				PlayerListTab["39"]["Color"] = Color3.fromRGB(27, 27, 27);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownHolder.UIListLayout
				PlayerListTab["3a"] = Instance.new("UIListLayout", PlayerListTab["33"]);
				PlayerListTab["3a"]["VerticalAlignment"] = Enum.VerticalAlignment.Bottom;
				PlayerListTab["3a"]["FillDirection"] = Enum.FillDirection.Horizontal;
				PlayerListTab["3a"]["Padding"] = UDim.new(0, 10);
				PlayerListTab["3a"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownHolder.UIPadding
				PlayerListTab["3b"] = Instance.new("UIPadding", PlayerListTab["33"]);
				PlayerListTab["3b"]["PaddingLeft"] = UDim.new(0, 6);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.UIListLayout
				PlayerListTab["1d"] = Instance.new("UIListLayout", PlayerListTab["5"]);
				PlayerListTab["1d"]["Padding"] = UDim.new(0, 10);
				PlayerListTab["1d"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection
				PlayerListTab["1e"] = Instance.new("Frame", PlayerListTab["5"]);
				PlayerListTab["1e"]["BorderSizePixel"] = 0;
				PlayerListTab["1e"]["BackgroundColor3"] = Library.Theme.DarkContrast;
				PlayerListTab["1e"]["Size"] = UDim2.new(1, -1, 1, -150);
				PlayerListTab["1e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["1e"]["Name"] = [[PlayerListSection]];
				PlayerListTab["1e"]["LayoutOrder"] = 1;
				
				table.insert(Library.DarkContrastObjects, PlayerListTab["1e"])

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.TopBar
				PlayerListTab["1f"] = Instance.new("Frame", PlayerListTab["1e"]);
				PlayerListTab["1f"]["BorderSizePixel"] = 0;
				PlayerListTab["1f"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 27);
				PlayerListTab["1f"]["Size"] = UDim2.new(1, 0, 0, 20);
				PlayerListTab["1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["1f"]["Name"] = [[TopBar]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.TopBar.Title
				PlayerListTab["20"] = Instance.new("TextLabel", PlayerListTab["1f"]);
				PlayerListTab["20"]["BorderSizePixel"] = 0;
				PlayerListTab["20"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["20"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				PlayerListTab["20"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				PlayerListTab["20"]["TextSize"] = 14;
				PlayerListTab["20"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
				PlayerListTab["20"]["Size"] = UDim2.new(1, 0, 1, 0);
				PlayerListTab["20"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["20"]["Text"] = "Player List - 32 Players";
				PlayerListTab["20"]["Name"] = [[Title]];
				PlayerListTab["20"]["BackgroundTransparency"] = 1;
				
				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.TopBar
				PlayerListTab["d1f"] = Instance.new("Frame", PlayerListTab["1f"]);
				PlayerListTab["d1f"]["BorderSizePixel"] = 0;
				PlayerListTab["d1f"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
				PlayerListTab["d1f"]["Size"] = UDim2.new(0.5, -150, 0, 15);
				PlayerListTab["d1f"]["Position"] = UDim2.new(0.5, 145, 0, 2);
				PlayerListTab["d1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["d1f"]["Name"] = [[Search]];
				
				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.UIStroke
				PlayerListTab["2da"] = Instance.new("UIStroke", PlayerListTab["d1f"]);
				PlayerListTab["2da"]["Color"] = Color3.fromRGB(27, 27, 27);
				PlayerListTab["2da"]["Thickness"] = 1;
				PlayerListTab["2da"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
				
				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.TextBox.TextBox
				PlayerListTab["7fe"] = Instance.new("TextBox", PlayerListTab["d1f"]);
				PlayerListTab["7fe"]["PlaceholderColor3"] = Color3.fromRGB(128, 128, 128);
				PlayerListTab["7fe"]["BorderSizePixel"] = 0;
				PlayerListTab["7fe"]["TextSize"] = 14;
				PlayerListTab["7fe"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["7fe"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["7fe"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				PlayerListTab["7fe"]["BackgroundTransparency"] = 1;
				PlayerListTab["7fe"]["PlaceholderText"] = "Search for a player";
				PlayerListTab["7fe"]["Size"] = UDim2.new(1, 0, 1, 0);
				PlayerListTab["7fe"]["Position"] = UDim2.new(0, 0, 0, 0);
				PlayerListTab["7fe"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["7fe"]["Text"] = "";
				PlayerListTab["7fe"]["ClearTextOnFocus"] = false;
				PlayerListTab["7fe"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				
				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.UIPadding
				PlayerListTab["dsf2"] = Instance.new("UIPadding", PlayerListTab["7fe"]);
				PlayerListTab["dsf2"]["PaddingLeft"] = UDim.new(0, 17);
				
				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Image
				PlayerListTab["cf4"] = Instance.new("ImageLabel", PlayerListTab["d1f"]);
				PlayerListTab["cf4"]["BorderSizePixel"] = 0;
				PlayerListTab["cf4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["cf4"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
				PlayerListTab["cf4"]["Image"] = [[rbxassetid://1523549302]];
				PlayerListTab["cf4"]["Size"] = UDim2.new(0, 12, 0, 12);
				PlayerListTab["cf4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["cf4"]["Name"] = [[Image]];
				PlayerListTab["cf4"]["BackgroundTransparency"] = 1;
				PlayerListTab["cf4"]["Position"] = UDim2.new(0, 9, 0.5, 0);
				
				PlayerListTab["7fe"].FocusLost:Connect(function(enterpressed)
					PlayerListTab["7fe"].TextColor3 = Color3.fromRGB(255, 255, 255)
					table.remove(Library.ThemeObjects, table.find(Library.ThemeObjects, PlayerListTab["7fe"]))
				end)

				PlayerListTab["7fe"].Focused:Connect(function()
					PlayerListTab["7fe"].TextColor3 = Library.Theme.Accent
					table.insert(Library.ThemeObjects, PlayerListTab["7fe"])
				end)

				PlayerListTab["7fe"]:GetPropertyChangedSignal("Text"):Connect(function()
					local InputText = string.lower(PlayerListTab["7fe"].Text)
					
					PlayerListTab["7fe"].Text = PlayerListTab["7fe"].Text:sub(1, 20)
					PlayerListTab["cf4"].Visible = PlayerListTab["7fe"].Text == "" and true or false
					PlayerListTab["dsf2"].PaddingLeft = PlayerListTab["7fe"].Text == "" and UDim.new(0, 17) or UDim.new(0, 3)
					
					for _, Frame in pairs(PlayerListTab["24"]:GetChildren()) do
						if Frame:IsA("Frame") then
							Frame.Visible = string.find(string.lower(Frame.Name), InputText) and true or false
						end
					end
				end)

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.TopBar.Title.UIPadding
				PlayerListTab["21"] = Instance.new("UIPadding", PlayerListTab["20"]);
				PlayerListTab["21"]["PaddingLeft"] = UDim.new(0, 5);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList
				PlayerListTab["23"] = Instance.new("Frame", PlayerListTab["1e"]);
				PlayerListTab["23"]["BorderSizePixel"] = 0;
				PlayerListTab["23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["23"]["BackgroundTransparency"] = 1;
				PlayerListTab["23"]["Size"] = UDim2.new(1, 0, 1, -20);
				PlayerListTab["23"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["23"]["Position"] = UDim2.new(0, 0, 0, 20);
				PlayerListTab["23"]["Name"] = [[PlayerList]];
				PlayerListTab["23"]["ClipsDescendants"] = true;

				PlayerListTab["5g"] = Instance.new("UIPadding", PlayerListTab["23"]);
				PlayerListTab["5g"]["PaddingTop"] = UDim.new(0, 1);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.UIStroke
				PlayerListTab["2b"] = Instance.new("UIStroke", PlayerListTab["1e"]);
				PlayerListTab["2b"]["Color"] = Color3.fromRGB(27, 27, 27);


				-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder
				PlayerListTab["24"] = Instance.new("ScrollingFrame", PlayerListTab["23"]);
				PlayerListTab["24"]["Active"] = true;
				PlayerListTab["24"]["BorderSizePixel"] = 0;
				PlayerListTab["24"]["ScrollBarImageTransparency"] = 0;
				PlayerListTab["24"]["ScrollBarThickness"] = 4;
				PlayerListTab["24"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["24"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
				PlayerListTab["24"]["BackgroundTransparency"] = 1;
				PlayerListTab["24"]["Size"] = UDim2.new(1, 0, 1, 0);
				PlayerListTab["24"]["ScrollBarImageColor3"] = Library.Theme.Accent;
				PlayerListTab["24"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["24"]["Position"] = UDim2.new(0, 0, 0, -1);
				PlayerListTab["24"]["Name"] = [[Holder]];
				PlayerListTab["24"]["Visible"] = true;
				PlayerListTab["24"]["ZIndex"] = 100;
				PlayerListTab["24"]["BottomImage"] = "http://www.roblox.com/asset/?id=158362264";
				PlayerListTab["24"]["MidImage"] = "http://www.roblox.com/asset/?id=158362264";
				PlayerListTab["24"]["TopImage"] = "http://www.roblox.com/asset/?id=158362264";

				table.insert(Library.ThemeObjects, PlayerListTab["24"])

				PlayerListTab["5j"] = Instance.new("UIPadding", PlayerListTab["24"]);
				PlayerListTab["5j"]["PaddingTop"] = UDim.new(0, 1);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.UIListLayout
				PlayerListTab["2f"] = Instance.new("UIListLayout", PlayerListTab["24"]);
				PlayerListTab["2f"]["Padding"] = UDim.new(0, 2);
				PlayerListTab["2f"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
			end

			local scrollingFrame = PlayerListTab["24"]
			local uilistlayout = PlayerListTab["2f"]

			local function resizeScrollingFrame()
				local totalHeight = 0
				for _, child in ipairs(scrollingFrame:GetChildren()) do
					if child:IsA("Frame") then
						totalHeight = totalHeight + child.AbsoluteSize.Y + uilistlayout.Padding.Offset
					end
				end
				scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

				local isScrollable = totalHeight > scrollingFrame.AbsoluteSize.Y
				for _, child in ipairs(scrollingFrame:GetChildren()) do
					if child:IsA("Frame") then
						child.Size = isScrollable and UDim2.new(1, -6, 0, 24) or UDim2.new(1, 0, 0, 24)
					end
				end
			end

			uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeScrollingFrame)
			resizeScrollingFrame()

			local scrollingFrame2 = PlayerListTab["5"]
			local uilistlayout2 = PlayerListTab["1d"]

			local function resizeScrollingFrame2()
				local totalHeight = 0
				for _, child in ipairs(scrollingFrame2:GetChildren()) do
					if child:IsA("Frame") then
						totalHeight = totalHeight + child.AbsoluteSize.Y + uilistlayout2.Padding.Offset
					end
				end
				scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
			end

			uilistlayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeScrollingFrame2)
			resizeScrollingFrame2()

			function PlayerListTab:UpdateFlag(Player, Flag)
				if not Player then return end

				for Index, Value in pairs(PlayerListTab["24"]:GetChildren()) do
					if Value.Name == Player.Name then
						local Flags = Value:FindFirstChild("Flags")
						Flags.Text = Flag
					end
				end
			end

			function PlayerListTab:AddFlags(options)
				options = Library:Validate({
					List = {"None", "Priority", "Resolve", "Friend"},
				}, options or {})

				local Flags = {
					Open = false,
					Hover = false,
					MouseDown = false,
					CurrentFlag = "None",
				}


				function Tab:GetFlag(Player)
					return Flags.CurrentFlag
				end

				function Tab:GetColor(Flag)
					if Flag == "Priority" then
						return Color3.fromRGB(255, 255, 0)
					elseif Flag == "Resolve" then
						return Color3.fromRGB(255, 119, 0)
					elseif Flag == "Friend" then
						return Color3.fromRGB(0, 255, 0)
					elseif Flag == "None" then
						return Color3.fromRGB(255, 255, 255)
					elseif Flag == "Local Player" then
						return Color3.fromRGB(255, 0, 255)
					end
				end

				do -- Render
					-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownOpen
					PlayerListTab["59"] = Instance.new("Frame", PlayerListTab["c"]);
					PlayerListTab["59"]["BorderSizePixel"] = 0;
					PlayerListTab["59"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					PlayerListTab["59"]["AnchorPoint"] = Vector2.new(1, 0);
					PlayerListTab["59"]["BackgroundTransparency"] = 1;
					PlayerListTab["59"]["Size"] = UDim2.new(0, 125, 0, 45);
					PlayerListTab["59"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					PlayerListTab["59"]["Position"] = UDim2.new(1, -20, 0, -5);
					PlayerListTab["59"]["Name"] = [[DropdownOpen]];

					-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
					PlayerListTab["bf"] = Instance.new("TextButton", PlayerListTab["59"]);
					PlayerListTab["bf"]["BorderSizePixel"] = 0;
					PlayerListTab["bf"]["TextTransparency"] = 1;
					PlayerListTab["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					PlayerListTab["bf"]["TextSize"] = 14;
					PlayerListTab["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					PlayerListTab["bf"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
					PlayerListTab["bf"]["Size"] = UDim2.new(1, 0, 1, 0);
					PlayerListTab["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					PlayerListTab["bf"]["BackgroundTransparency"] = 1;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownOpen.Options
					PlayerListTab["5a"] = Instance.new("Frame", PlayerListTab["59"]);
					PlayerListTab["5a"]["BorderSizePixel"] = 0;
					PlayerListTab["5a"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					PlayerListTab["5a"]["AnchorPoint"] = Vector2.new(0, 1);
					PlayerListTab["5a"]["Size"] = UDim2.new(1, 0, 0.5, 0);
					PlayerListTab["5a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					PlayerListTab["5a"]["Position"] = UDim2.new(0, 0, 1, 0);
					PlayerListTab["5a"]["Name"] = [[Options]];

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownOpen.Options.UIStroke
					PlayerListTab["5b"] = Instance.new("UIStroke", PlayerListTab["5a"]);
					PlayerListTab["5b"]["Color"] = Color3.fromRGB(27, 27, 27);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownOpen.Options.Option
					PlayerListTab["5c"] = Instance.new("TextLabel", PlayerListTab["5a"]);
					PlayerListTab["5c"]["BorderSizePixel"] = 0;
					PlayerListTab["5c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					PlayerListTab["5c"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					PlayerListTab["5c"]["TextSize"] = 15;
					PlayerListTab["5c"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					PlayerListTab["5c"]["Size"] = UDim2.new(1, 0, 1, 0);
					PlayerListTab["5c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					PlayerListTab["5c"]["Text"] = [[None]];
					PlayerListTab["5c"]["Name"] = [[Option]];
					PlayerListTab["5c"]["BackgroundTransparency"] = 1;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownOpen.Options.Option.UIPadding
					PlayerListTab["5d"] = Instance.new("UIPadding", PlayerListTab["5c"]);
					PlayerListTab["5d"]["PaddingLeft"] = UDim.new(0, 5);

					-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder
					PlayerListTab["5e"] = Instance.new("ScrollingFrame", PlayerListTab["5a"]);
					PlayerListTab["5e"]["Active"] = true;
					PlayerListTab["5e"]["BorderSizePixel"] = 0;
					PlayerListTab["5e"]["ScrollBarImageTransparency"] = 0;
					PlayerListTab["5e"]["ScrollBarThickness"] = 2;
					PlayerListTab["5e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					PlayerListTab["5e"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
					PlayerListTab["5e"]["BackgroundTransparency"] = 1;
					PlayerListTab["5e"]["Size"] = UDim2.new(1, 0, 0, 45);
					PlayerListTab["5e"]["ScrollBarImageColor3"] = Library.Theme.Accent;
					PlayerListTab["5e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					PlayerListTab["5e"]["Position"] = UDim2.new(0, 0, 1, 0);
					PlayerListTab["5e"]["Name"] = [[Background]];
					PlayerListTab["5e"]["Visible"] = false;
					PlayerListTab["5e"]["ZIndex"] = 100;
					PlayerListTab["5e"]["BottomImage"] = "http://www.roblox.com/asset/?id=158362264";
					PlayerListTab["5e"]["MidImage"] = "http://www.roblox.com/asset/?id=158362264";
					PlayerListTab["5e"]["TopImage"] = "http://www.roblox.com/asset/?id=158362264";

					table.insert(Library.ThemeObjects, PlayerListTab["5e"])

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownOpen.Options.Background.UIListLayout
					PlayerListTab["5f"] = Instance.new("UIListLayout", PlayerListTab["5e"]);
					PlayerListTab["5f"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSettings.ContentContainer.DropdownOpen.Text
					PlayerListTab["6b"] = Instance.new("TextLabel", PlayerListTab["59"]);
					PlayerListTab["6b"]["TextWrapped"] = true;
					PlayerListTab["6b"]["BorderSizePixel"] = 0;
					PlayerListTab["6b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					PlayerListTab["6b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					PlayerListTab["6b"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					PlayerListTab["6b"]["TextSize"] = 14;
					PlayerListTab["6b"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					PlayerListTab["6b"]["Size"] = UDim2.new(1, 0, 1, -20);
					PlayerListTab["6b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					PlayerListTab["6b"]["Text"] = [[Player Flag]];
					PlayerListTab["6b"]["Name"] = [[Text]];
					PlayerListTab["6b"]["BackgroundTransparency"] = 1;

				end

				function Flags:Toggle()
					if Flags.Open then
						PlayerListTab["5e"].Visible = false
					else
						PlayerListTab["5e"].Visible = true
					end

					Flags.Open = not Flags.Open
				end

				function Flags:Add(id, value)
					do -- Render
						local Item = {
							Hover = false,
							MouseDown = false,
						}

						if Item[id] ~= nil then
							return
						end

						Item[id] = {
							instance = {},
							value = value
						}

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive
						Item["c7"] = Instance.new("Frame", PlayerListTab["5e"]);
						Item["c7"]["BorderSizePixel"] = 0;
						Item["c7"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
						Item["c7"]["BackgroundTransparency"] = 0;
						Item["c7"]["Size"] = UDim2.new(1, 0, 0, 18);
						Item["c7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["c7"]["Name"] = [[Option]];
						Item["c7"]["ZIndex"] = 8;

						-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
						Item["bf"] = Instance.new("TextButton", Item["c7"]);
						Item["bf"]["BorderSizePixel"] = 0;
						Item["bf"]["TextTransparency"] = 1;
						Item["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						Item["bf"]["TextSize"] = 14;
						Item["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						Item["bf"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
						Item["bf"]["Size"] = UDim2.new(1, 0, 1, 0);
						Item["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["bf"]["BackgroundTransparency"] = 1;

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive.Text.UIPadding
						Item["f3"] = Instance.new("UIPadding", Item["c7"]);
						Item["f3"]["PaddingTop"] = UDim.new(0, -1);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.UIStroke
						Item["f5"] = Instance.new("UIStroke", Item["c7"]);
						Item["f5"]["Color"] = Library.Theme.DarkContrast;
						
						table.insert(Library.DarkContrastObjects, Item["f5"])

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive.Text
						Item["c8"] = Instance.new("TextLabel", Item["c7"]);
						Item["c8"]["BorderSizePixel"] = 0;
						Item["c8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						Item["c8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						Item["c8"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						Item["c8"]["TextSize"] = 14;
						Item["c8"]["TextColor3"] = Color3.fromRGB(150, 150, 150);
						Item["c8"]["Size"] = UDim2.new(1, 0, 0, 18);
						Item["c8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["c8"]["Text"] = value;
						Item["c8"]["Name"] = [[Text]];
						Item["c8"]["BackgroundTransparency"] = 1;

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive.Text.UIPadding
						Item["c9"] = Instance.new("UIPadding", Item["c8"]);
						Item["c9"]["PaddingLeft"] = UDim.new(0, 3);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive.Frame
						Item["ca"] = Instance.new("Frame", Item["c7"]);
						Item["ca"]["BorderSizePixel"] = 0;
						Item["ca"]["BackgroundColor3"] = Library.Theme.Accent;
						Item["ca"]["BackgroundTransparency"] = 1;
						Item["ca"]["Size"] = UDim2.new(0, 1, 1, -6);
						Item["ca"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["ca"]["Position"] = UDim2.new(0, 0, 0, 3);

						table.insert(Library.ThemeObjects, Item["ca"])

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive.UIPadding
						Item["cb"] = Instance.new("UIPadding", Item["c7"]);

						Item["c7"].MouseEnter:Connect(function()
							if not Library:IsMouseOverFrame(Item["c7"]) then return end
							Item.Hover = true
							Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(214, 214, 214)})
						end)

						Item["c7"].MouseLeave:Connect(function()
							Item.Hover = false

							Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(150, 150, 150)})
						end)

						Item["bf"].MouseButton1Down:Connect(function()
							if Item.Hover and not isFadedOut then
								Item.MouseDown = true
								Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(255, 255, 255)})

								Flags.CurrentFlag = value
								PlayerListTab:UpdateFlag(PlayerListTab.CurrentPlayer["25"])
								Flags:Toggle()
								PlayerListTab["5c"].Text = value
							end
						end)

						Item["bf"].MouseButton1Up:Connect(function()
							Item.MouseDown = false

							Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(150, 150, 150)})
						end)
					end
				end

				function Flags:RemoveAll()
					for i, v in pairs(PlayerListTab["5e"]:GetChildren()) do
						if v.Name == "Option" then
							v:Destroy()
						end
					end
				end

				function Tab:UpdateFlagDropdown()
					if tostring(PlayerListTab.CurrentPlayer["25"]) ~= tostring(players.LocalPlayer.Name) then
						Flags:RemoveAll()
						for i, v in pairs(options.List) do
							Flags:Add(i, v)
						end
					else
						Flags:RemoveAll()
						Flags:Add("LocalPlayer", "Local Player")
					end
				end

				PlayerListTab["59"].MouseEnter:Connect(function()
					if not Library:IsMouseOverFrame(PlayerListTab["59"]) then return end
					Flags.Hover = true
				end)

				PlayerListTab["59"].MouseLeave:Connect(function()
					Flags.Hover = false

					if not Flags.MouseDown then
					end
				end)

				PlayerListTab["bf"].MouseButton1Down:Connect(function()
					if Flags.Hover and not isFadedOut then
						Flags.MouseDown = true
						Flags:Toggle()
					end
				end)

				PlayerListTab["bf"].MouseButton1Up:Connect(function()
					Flags.MouseDown = false
				end)

				return Flags
			end

			PlayerListTab:AddFlags()


			PlayerListTab["34"].InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and not isFadedOut then
					if PlayerListTab.CurrentPlayer ~= nil then
						local PlayerToSpectate = PlayerListTab.CurrentPlayer ~= nil and players:FindFirstChild(PlayerListTab.CurrentPlayer["25"].Name)

						if PlayerListTab.Spectating == false then
							PlayerListTab.Spectating = true
							workspace.CurrentCamera.CameraSubject = PlayerToSpectate.Character
						else
							PlayerListTab.Spectating = false
							workspace.CurrentCamera.CameraSubject = players.LocalPlayer.Character
						end
					end
				end
			end)

			PlayerListTab["37"].InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and not isFadedOut then
					if PlayerListTab.CurrentPlayer ~= nil then
						local PlayerToTeleportTo = PlayerListTab.CurrentPlayer ~= nil and players:FindFirstChild(PlayerListTab.CurrentPlayer["25"].Name)

						players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = PlayerToTeleportTo.Character:GetPivot()
						Library:Notify(string.format("Successfully teleported to %s at (%s)", PlayerToTeleportTo.Name, tostring(string.format("%.0f, %.0f, %.0f", PlayerToTeleportTo.Character.HumanoidRootPart.Position.X, PlayerToTeleportTo.Character.HumanoidRootPart.Position.Y, PlayerToTeleportTo.Character.HumanoidRootPart.Position.Z))))
					end
				end
			end)

			do -- Methods
				function PlayerListTab:RemnovePlayer(Player)
					for Index, Value in pairs(PlayerListTab["24"]:GetDescendants()) do
						if Value.Name == Player.Name then
							Value:Destroy()
						end
					end
				end

				function PlayerListTab:UpdateTexts()
					if PlayerListTab.CurrentPlayer ~= nil then
						local TargetPlayer = PlayerListTab.CurrentPlayer ~= nil and players:FindFirstChild(PlayerListTab.CurrentPlayer["25"].Name)
						local Humanoid = TargetPlayer.Character:FindFirstChild("Humanoid")

						PlayerListTab["9"].Text = string.format("[%s] - Settings", TargetPlayer.Name)
						PlayerListTab["16"].Text = string.format("UserID : %s", TargetPlayer.UserId)
						PlayerListTab["18"].Text = string.format("Name : %s", TargetPlayer.Name)
						PlayerListTab["1a"].Text = string.format("Display Name : %s", TargetPlayer.DisplayName)
						PlayerListTab["13"].Text = string.format("Health : %s/%s", math.floor(Humanoid.Health), math.floor(Humanoid.MaxHealth))
						PlayerListTab["11"].Visible = false
						PlayerListTab["10"].Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png", TargetPlayer.UserId)
					else
						PlayerListTab["9"].Text = "[Unknown Player] - Settings"
						PlayerListTab["16"].Text = "User ID: Unknown"
						PlayerListTab["18"].Text = "Name : Unknown"
						PlayerListTab["1a"].Text = "Display Name : Unknown"
						PlayerListTab["11"].Visible = true
						PlayerListTab["10"].Image = ""
					end
				end

				function PlayerListTab:AddPlayer(Player)

					local Item = {
						Hover = false,
						MouseDown = false,
					}

					if Player == players.LocalPlayer then
						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame
						Item["25"] = Instance.new("Frame", PlayerListTab["24"]);
						Item["25"]["BorderSizePixel"] = 0;
						Item["25"]["BackgroundColor3"] = Library.Theme.InlineContrast;
						Item["25"]["Size"] = UDim2.new(1, 0, 0, 24);
						Item["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["25"]["Name"] = Player.Name;
						Item["25"]["LayoutOrder"] = 1;
						
						table.insert(Library.InlineObjects, Item["25"])
						
						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame
						Item["2d5"] = Instance.new("Frame", Item["25"]);
						Item["2d5"]["BorderSizePixel"] = 0;
						Item["2d5"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
						Item["2d5"]["Size"] = UDim2.new(0, 1, 1, 0);
						Item["2d5"]["Position"] = UDim2.new(0.33, 0, 0, 0);
						Item["2d5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["2d5"]["Name"] = "FirstSeperator";
						
						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame
						Item["2f5"] = Instance.new("Frame", Item["25"]);
						Item["2f5"]["BorderSizePixel"] = 0;
						Item["2f5"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
						Item["2f5"]["Size"] = UDim2.new(0, 1, 1, 0);
						Item["2f5"]["Position"] = UDim2.new(0.66, 0, 0, 0);
						Item["2f5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["2f5"]["Name"] = "SecondSeperator";

						-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
						Item["bfj"] = Instance.new("TextButton", Item["25"]);
						Item["bfj"]["BorderSizePixel"] = 0;
						Item["bfj"]["TextTransparency"] = 1;
						Item["bfj"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						Item["bfj"]["TextSize"] = 14;
						Item["bfj"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						Item["bfj"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
						Item["bfj"]["Size"] = UDim2.new(1, 0, 1, 0);
						Item["bfj"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["bfj"]["BackgroundTransparency"] = 1;
						Item["bfj"]["Name"] = "BUTTON";

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.PlayerName
						Item["26"] = Instance.new("TextLabel", Item["25"]);
						Item["26"]["BorderSizePixel"] = 0;
						Item["26"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						Item["26"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						Item["26"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						Item["26"]["TextSize"] = 16;
						Item["26"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
						Item["26"]["Size"] = UDim2.new(0.33000001311302185, 0, 1, 0);
						Item["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["26"]["Text"] = tostring(Player.Name);
						Item["26"]["Name"] = [[PlayerName]];
						Item["26"]["BackgroundTransparency"] = 1;

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.PlayerName.UIPadding
						Item["27"] = Instance.new("UIPadding", Item["26"]);
						Item["27"]["PaddingLeft"] = UDim.new(0, 7);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.Team
						Item["28"] = Instance.new("TextLabel", Item["25"]);
						Item["28"]["BorderSizePixel"] = 0;
						Item["28"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						Item["28"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						Item["28"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						Item["28"]["TextSize"] = 16;
						Item["28"]["TextColor3"] = Player.Team and Player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
						Item["28"]["Size"] = UDim2.new(0.33000001311302185, 0, 1, 0);
						Item["28"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["28"]["Text"] = Player.Team and tostring(Player.Team) or "Neutral";
						Item["28"]["Name"] = [[Team]];
						Item["28"]["BackgroundTransparency"] = 1;
						Item["28"]["Position"] = UDim2.new(0.33000001311302185, 0, 0, 0);
						
						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.PlayerName.UIPadding
						Item["2d7"] = Instance.new("UIPadding", Item["28"]);
						Item["2d7"]["PaddingLeft"] = UDim.new(0, 7);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.Flags
						Item["29"] = Instance.new("TextLabel", Item["25"]);
						Item["29"]["BorderSizePixel"] = 0;
						Item["29"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						Item["29"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						Item["29"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						Item["29"]["TextSize"] = 16;
						Item["29"]["TextColor3"] = Color3.fromRGB(255, 0, 255);
						Item["29"]["Size"] = UDim2.new(0.33000001311302185, 0, 1, 0);
						Item["29"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["29"]["Text"] = "Local Player";
						Item["29"]["Name"] = [[Flags]];
						Item["29"]["BackgroundTransparency"] = 1;
						Item["29"]["Position"] = UDim2.new(0.6600000262260437, 0, 0, 0);
						
						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.PlayerName.UIPadding
						Item["2f7"] = Instance.new("UIPadding", Item["29"]);
						Item["2f7"]["PaddingLeft"] = UDim.new(0, 7);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.UIStroke
						Item["2a"] = Instance.new("UIStroke", Item["25"]);
						Item["2a"]["Color"] = Color3.fromRGB(31, 31, 31);
						Item["2a"]["Thickness"] = 1;
						Item["2a"]["LineJoinMode"] = Enum.LineJoinMode.Miter;
					else
						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame
						Item["25"] = Instance.new("Frame", PlayerListTab["24"]);
						Item["25"]["BorderSizePixel"] = 0;
						Item["25"]["BackgroundColor3"] = Library.Theme.InlineContrast;
						Item["25"]["Size"] = UDim2.new(1, 0, 0, 24);
						Item["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["25"]["Name"] = Player.Name;
						Item["25"]["LayoutOrder"] = 2;
						
						table.insert(Library.InlineObjects, Item["25"])
						
						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame
						Item["2d5"] = Instance.new("Frame", Item["25"]);
						Item["2d5"]["BorderSizePixel"] = 0;
						Item["2d5"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
						Item["2d5"]["Size"] = UDim2.new(0, 1, 1, 0);
						Item["2d5"]["Position"] = UDim2.new(0.33, 0, 0, 0);
						Item["2d5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["2d5"]["Name"] = "FirstSeperator";

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame
						Item["2f5"] = Instance.new("Frame", Item["25"]);
						Item["2f5"]["BorderSizePixel"] = 0;
						Item["2f5"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
						Item["2f5"]["Size"] = UDim2.new(0, 1, 1, 0);
						Item["2f5"]["Position"] = UDim2.new(0.66, 0, 0, 0);
						Item["2f5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["2f5"]["Name"] = "SecondSeperator";

						-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
						Item["bfj"] = Instance.new("TextButton", Item["25"]);
						Item["bfj"]["BorderSizePixel"] = 0;
						Item["bfj"]["TextTransparency"] = 1;
						Item["bfj"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						Item["bfj"]["TextSize"] = 14;
						Item["bfj"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						Item["bfj"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
						Item["bfj"]["Size"] = UDim2.new(1, 0, 1, 0);
						Item["bfj"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["bfj"]["BackgroundTransparency"] = 1;
						Item["bfj"]["Name"] = "BUTTON";

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.PlayerName
						Item["26"] = Instance.new("TextLabel", Item["25"]);
						Item["26"]["BorderSizePixel"] = 0;
						Item["26"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						Item["26"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						Item["26"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						Item["26"]["TextSize"] = 16;
						Item["26"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
						Item["26"]["Size"] = UDim2.new(0.33000001311302185, 0, 1, 0);
						Item["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["26"]["Text"] = Player.Name;
						Item["26"]["Name"] = [[PlayerName]];
						Item["26"]["BackgroundTransparency"] = 1;

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.PlayerName.UIPadding
						Item["27"] = Instance.new("UIPadding", Item["26"]);
						Item["27"]["PaddingLeft"] = UDim.new(0, 10);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.Team
						Item["28"] = Instance.new("TextLabel", Item["25"]);
						Item["28"]["BorderSizePixel"] = 0;
						Item["28"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						Item["28"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						Item["28"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						Item["28"]["TextSize"] = 16;
						Item["28"]["TextColor3"] = Player.Team and Player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
						Item["28"]["Size"] = UDim2.new(0.33000001311302185, 0, 1, 0);
						Item["28"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["28"]["Text"] = Player.Team and tostring(Player.Team) or "Neutral";
						Item["28"]["Name"] = [[Team]];
						Item["28"]["BackgroundTransparency"] = 1;
						Item["28"]["Position"] = UDim2.new(0.33000001311302185, 0, 0, 0);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList.Holder.PlayerFrame.Flags
						Item["29"] = Instance.new("TextLabel", Item["25"]);
						Item["29"]["BorderSizePixel"] = 0;
						Item["29"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						Item["29"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						Item["29"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						Item["29"]["TextSize"] = 16;
						Item["29"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
						Item["29"]["Size"] = UDim2.new(0.33000001311302185, 0, 1, 0);
						Item["29"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["29"]["Text"] = Tab:GetFlag(Player) ~= nil and tostring(Tab:GetFlag(Player)) or "None";
						Item["29"]["Name"] = [[Flags]];
						Item["29"]["BackgroundTransparency"] = 1;
						Item["29"]["Position"] = UDim2.new(0.6600000262260437, 0, 0, 0);
					end

					function PlayerListTab:UpdateFlag(Player)
						if Player ~= players.LocalPlayer then
							for i, v in pairs(Item["25"]:GetChildren()) do
								if v.Name == "Flags" then
									v.Text = Tab:GetFlag(Player) ~= nil and tostring(Tab:GetFlag(Player)) or "None"
									v.TextColor3 = Tab:GetColor(Tab:GetFlag(Player))
								end
							end
						end
					end

					function Item:Activate()
						if not Item.Active then

							if PlayerListTab.CurrentPlayer ~= nil then
								PlayerListTab.CurrentPlayer:Deactivate()
							end

							Item.Active = true

							Library:tween(Item["26"], {TextColor3 = Library.Theme.Accent})
							table.insert(Library.ThemeObjects, Item["26"])

							PlayerListTab.CurrentPlayer = Item
							Tab:UpdateFlagDropdown()

							PlayerListTab:UpdateTexts()
						end
					end

					function Item:Deactivate()
						if Item.Active then
							Item.Active = false
							Item.Hover = false

							table.remove(Library.ThemeObjects, table.find(Library.ThemeObjects, Item["26"]))

							Library:tween(Item["26"], {TextColor3 = Color3.fromRGB(214, 214, 214)})
						end
					end

					Item["25"].MouseEnter:Connect(function()
						if not Library:IsMouseOverFrame(Item["25"]) then return end
						Item.Hover = true
						if not Item.Active then
							Library:tween(Item["26"], {TextColor3 = Color3.fromRGB(255, 255, 255)})
						end
					end)

					Item["25"].MouseLeave:Connect(function()
						Item.Hover = false

						if not Item.Active then
							Library:tween(Item["26"], {TextColor3 = Color3.fromRGB(214, 214, 214)})
						end
					end)

					Item["bfj"].MouseButton1Click:Connect(function()
						if Item.Hover and not isFadedOut then
							Item:Activate()
						end
					end)
				end

				function PlayerListTab:PlayerNumber()
					if #players:GetPlayers() == 1 then
						PlayerListTab["20"].Text = string.format("Player List - %s Player", #players:GetPlayers())
					else
						PlayerListTab["20"].Text = string.format("Player List - %s Players", #players:GetPlayers())
					end
				end
			end

			-- Logic
			do
				PlayerListTab:PlayerNumber()
				--
				for _, Player in pairs(players:GetPlayers()) do
					PlayerListTab:AddPlayer(Player)
				end

				players.PlayerAdded:Connect(function(Player)
					PlayerListTab:AddPlayer(Player)
					PlayerListTab:PlayerNumber()
				end)

				players.PlayerRemoving:Connect(function(Player)
					PlayerListTab:RemnovePlayer(Player)
					PlayerListTab:PlayerNumber()
				end)

				PlayerListTab:UpdateTexts()
			end

			return PlayerListTab
		end

		if options.SkinList == true then

			local SkinList = {
				CurrentGun = nil,
				CurrentSkin = nil,
			}

			do -- Methods
				function SkinList:GunsList()
					local GunListTab = {
						Hover = false,
						Active = false,
						Scrolling = false,
						CurrentScroll = 0,
						test = false,
						test2 = false,
						AmountOfGuns = 0,
					}

					do -- Render
						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab
						GunListTab["1d"] = Instance.new("Frame", Tab["7"]);
						GunListTab["1d"]["BorderSizePixel"] = 0;
						GunListTab["1d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						GunListTab["1d"]["BackgroundTransparency"] = 1;
						GunListTab["1d"]["Size"] = UDim2.new(1, -2, 1, 14);
						GunListTab["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						GunListTab["1d"]["Position"] = UDim2.new(0, 1, 0, -14);
						GunListTab["1d"]["Name"] = [[GunsTab]];
						GunListTab["1d"]["ClipsDescendants"] = true;
						GunListTab["1d"]["ZIndex"] = 2;

						GunListTab["1i"] = Instance.new("UIPadding", GunListTab["1d"]);
						GunListTab["1i"]["PaddingTop"] = UDim.new(0, 20);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.UIListLayout
						GunListTab["1e"] = Instance.new("UIListLayout", GunListTab["1d"]);
						GunListTab["1e"]["Padding"] = UDim.new(0, 10);
						GunListTab["1e"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection
						GunListTab["1f"] = Instance.new("Frame", GunListTab["1d"]);
						GunListTab["1f"]["BorderSizePixel"] = 0;
						GunListTab["1f"]["BackgroundColor3"] = Library.Theme.DarkContrast;
						GunListTab["1f"]["LayoutOrder"] = 1;
						GunListTab["1f"]["Size"] = UDim2.new(1, 0, 1.0072979927062988, 0);
						GunListTab["1f"]["ClipsDescendants"] = true;
						GunListTab["1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						GunListTab["1f"]["Name"] = [[SkinListSection]];
						
						table.insert(Library.DarkContrastObjects, GunListTab["1f"])

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.TopBar
						GunListTab["20"] = Instance.new("Frame", GunListTab["1f"]);
						GunListTab["20"]["BorderSizePixel"] = 0;
						GunListTab["20"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 27);
						GunListTab["20"]["Size"] = UDim2.new(1, 0, 0, 20);
						GunListTab["20"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						GunListTab["20"]["Name"] = [[TopBar]];

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.TopBar.Title
						GunListTab["21"] = Instance.new("TextLabel", GunListTab["20"]);
						GunListTab["21"]["BorderSizePixel"] = 0;
						GunListTab["21"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						GunListTab["21"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						GunListTab["21"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						GunListTab["21"]["TextSize"] = 14;
						GunListTab["21"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
						GunListTab["21"]["Size"] = UDim2.new(1, 0, 1, 0);
						GunListTab["21"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						GunListTab["21"]["Text"] = [[Gun List - Unknown]];
						GunListTab["21"]["Name"] = [[Title]];
						GunListTab["21"]["BackgroundTransparency"] = 1;

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.TopBar.Title.UIPadding
						GunListTab["22"] = Instance.new("UIPadding", GunListTab["21"]);
						GunListTab["22"]["PaddingLeft"] = UDim.new(0, 5);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList
						GunListTab["23"] = Instance.new("Frame", GunListTab["1f"]);
						GunListTab["23"]["BorderSizePixel"] = 0;
						GunListTab["23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						GunListTab["23"]["BackgroundTransparency"] = 1;
						GunListTab["23"]["Size"] = UDim2.new(1, 0, 1, -20);
						GunListTab["23"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						GunListTab["23"]["Position"] = UDim2.new(0, 0, 0, 20);
						GunListTab["23"]["Name"] = [[SkinList]];

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder
						GunListTab["24"] = Instance.new("Frame", GunListTab["23"]);
						GunListTab["24"]["BorderSizePixel"] = 0;
						GunListTab["24"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						GunListTab["24"]["BackgroundTransparency"] = 1;
						GunListTab["24"]["Size"] = UDim2.new(1, 0, 1, 0);
						GunListTab["24"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						GunListTab["24"]["Name"] = [[Holder]];

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.UIPadding
						GunListTab["2e"] = Instance.new("UIPadding", GunListTab["24"]);
						GunListTab["2e"]["PaddingTop"] = UDim.new(0, 5);
						GunListTab["2e"]["PaddingLeft"] = UDim.new(0, -7);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.UIGridLayout
						GunListTab["2f"] = Instance.new("UIGridLayout", GunListTab["24"]);
						GunListTab["2f"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
						GunListTab["2f"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
						GunListTab["2f"]["FillDirectionMaxCells"] = 5;
						GunListTab["2f"]["CellSize"] = UDim2.new(0, 120, 0, 120);
						GunListTab["2f"]["CellPadding"] = UDim2.new(0, 10, 0, 10);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.UIStroke
						GunListTab["30"] = Instance.new("UIStroke", GunListTab["1f"]);
						GunListTab["30"]["Color"] = Color3.fromRGB(27, 27, 27);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.ScrollBarBack
						GunListTab["31"] = Instance.new("Frame", GunListTab["1f"]);
						GunListTab["31"]["BorderSizePixel"] = 0;
						GunListTab["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						GunListTab["31"]["AnchorPoint"] = Vector2.new(1, 0);
						GunListTab["31"]["BackgroundTransparency"] = 1;
						GunListTab["31"]["Size"] = UDim2.new(0, 6, 1, -19);
						GunListTab["31"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						GunListTab["31"]["Position"] = UDim2.new(1, -1, 0, 19);
						GunListTab["31"]["Name"] = [[ScrollBarBack]];

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.ScrollBarBack.ScrollBar
						GunListTab["32"] = Instance.new("Frame", GunListTab["31"]);
						GunListTab["32"]["BorderSizePixel"] = 0;
						GunListTab["32"]["BackgroundColor3"] = Library.Theme.Accent;
						GunListTab["32"]["Size"] = UDim2.new(1, 0, 0.5, 0);
						GunListTab["32"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						GunListTab["32"]["Name"] = [[ScrollBar]];

						table.insert(Library.ThemeObjects, GunListTab["32"])
					end

					do -- Methods
						function GunListTab:UpdateTexts()
							GunListTab["21"].Text = string.format("Gun List - %s Guns", tostring(GunListTab.AmountOfGuns))
						end

						function GunListTab:RemoveGun(gun)
							for Index, Value in pairs(GunListTab["24"]:GetDescendants()) do
								if Value.Name == gun.Name then
									Value:Destroy()
								end
							end
						end

						function GunListTab:AddGun(name, icon)
							local Item = {
								Hover = false,
								MouseDown = false,
							}

							GunListTab.AmountOfGuns += 1

							do -- Render
								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame
								Item["25"] = Instance.new("Frame", GunListTab["24"]);
								Item["25"]["BorderSizePixel"] = 0;
								Item["25"]["BackgroundColor3"] = Color3.fromRGB(16, 16, 16);
								Item["25"]["Size"] = UDim2.new(0, 100, 0, 100);
								Item["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								Item["25"]["Name"] = name;

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.SkinName
								Item["26"] = Instance.new("TextLabel", Item["25"]);
								Item["26"]["BorderSizePixel"] = 0;
								Item["26"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
								Item["26"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
								Item["26"]["TextSize"] = 16;
								Item["26"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
								Item["26"]["AnchorPoint"] = Vector2.new(0, 1);
								Item["26"]["Size"] = UDim2.new(1, 0, 0, 20);
								Item["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								Item["26"]["Text"] = name ~= nil and name or "N/A";
								Item["26"]["Name"] = [[SkinName]];
								Item["26"]["BackgroundTransparency"] = 1;
								Item["26"]["Position"] = UDim2.new(0, 0, 1, 0);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.SkinName.UIPadding
								Item["27"] = Instance.new("UIPadding", Item["26"]);
								Item["27"]["PaddingBottom"] = UDim.new(0, 15);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.UIStroke
								Item["28"] = Instance.new("UIStroke", Item["25"]);
								Item["28"]["Color"] = Color3.fromRGB(31, 31, 31);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.GunName
								Item["29"] = Instance.new("TextLabel", Item["25"]);
								Item["29"]["BorderSizePixel"] = 0;
								Item["29"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
								Item["29"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								Item["29"]["TextSize"] = 13;
								Item["29"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
								Item["29"]["TextTransparency"] = 1;
								Item["29"]["AnchorPoint"] = Vector2.new(0, 1);
								Item["29"]["Size"] = UDim2.new(1, 0, 0, 20);
								Item["29"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								Item["29"]["Text"] = [[N/A]];
								Item["29"]["Name"] = [[GunName]];
								Item["29"]["BackgroundTransparency"] = 1;
								Item["29"]["Position"] = UDim2.new(0, 0, 1, -15);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.GunName.UIPadding
								Item["2a"] = Instance.new("UIPadding", Item["29"]);
								Item["2a"]["PaddingBottom"] = UDim.new(0, 5);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.ImageHolder
								Item["2b"] = Instance.new("Frame", Item["25"]);
								Item["2b"]["BorderSizePixel"] = 0;
								Item["2b"]["BackgroundColor3"] = Color3.fromRGB(21, 21, 21);
								Item["2b"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
								Item["2b"]["Size"] = UDim2.new(1, -15, 1, -40);
								Item["2b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								Item["2b"]["Position"] = UDim2.new(0.5, 0, 0.5, -15);
								Item["2b"]["Name"] = [[ImageHolder]];

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.ImageHolder.Image
								Item["2c"] = Instance.new("ImageLabel", Item["2b"]);
								Item["2c"]["BorderSizePixel"] = 0;
								Item["2c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
								Item["2c"]["AnchorPoint"] = Vector2.new(0.5, 0);
								Item["2c"]["Size"] = UDim2.new(1, 0, 1, 0);
								Item["2c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								Item["2c"]["Name"] = [[Image]];
								Item["2c"]["Image"] = icon ~= nil and icon or "";
								Item["2c"]["BackgroundTransparency"] = 1;
								Item["2c"]["Position"] = UDim2.new(0.5, 0, 0, 0);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.ImageHolder.UIStroke
								Item["2d"] = Instance.new("UIStroke", Item["2b"]);
								Item["2d"]["Color"] = Color3.fromRGB(27, 27, 27);
							end

							do -- Methods
								function Item:Activate()
									if not Item.Active then

										if SkinList.CurrentGun ~= nil then
											SkinList.CurrentGun:Deactivate()
										end

										Item.Active = true

										SkinList.CurrentGun = Item
										task.delay(0.1, function()
											if SkinList.CurrentGun ~= nil then
												SkinList.CurrentGun["25"].Parent.Parent.Parent.Parent.Visible = false
											end
										end)
									end
								end

								function Item:Deactivate()
									if Item.Active then
										Item.Active = false
										Item.Hover = false
									end
								end
							end

							Item["25"].MouseEnter:Connect(function()
								if not Library:IsMouseOverFrame(Item["25"]) then return end
								Item.Hover = true
								if not Item.Active then
									Library:tween(Item["28"], {Color = Color3.fromRGB(55, 55, 55)})
									Library:tween(Item["2d"], {Color = Color3.fromRGB(40, 40, 40)})
								end
							end)

							Item["25"].MouseLeave:Connect(function()
								Item.Hover = false

								if not Item.Active then
									Library:tween(Item["28"], {Color = Color3.fromRGB(30, 30, 30)})
									Library:tween(Item["2d"], {Color = Color3.fromRGB(30, 30, 30)})
								end
							end)

							uis.InputBegan:Connect(function(input, gpe)
								if gpe then return end

								if input.UserInputType == Enum.UserInputType.MouseButton1 and Item.Hover and not isFadedOut then
									Item:Activate()
								end
							end)

							uis.InputEnded:Connect(function(input, gpe)
								if gpe then return end

								if input.UserInputType == Enum.UserInputType.MouseButton1 and not isFadedOut then
									Item.MouseDown = false

									if Item.Hover then
										Library:tween(Item["28"], {Color = Color3.fromRGB(55, 55, 55)})
										Library:tween(Item["2d"], {Color = Color3.fromRGB(40, 40, 40)})
									else
										Library:tween(Item["28"], {Color = Color3.fromRGB(30, 30, 30)})
										Library:tween(Item["2d"], {Color = Color3.fromRGB(30, 30, 30)})
									end
								end
							end)

							GunListTab:UpdateTexts()
						end

						do -- Logic
							GunListTab["23"].MouseEnter:Connect(function()
								if not Library:IsMouseOverFrame(GunListTab["23"]) then return end
								GunListTab.test = true
								game:GetService("ContextActionService"):BindAction("disable_mouse_input", function()
									return Enum.ContextActionResult.Sink
								end, false, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3, Enum.UserInputType.MouseWheel)
							end)

							GunListTab["23"].MouseLeave:Connect(function()
								GunListTab.test = false
								game:GetService("ContextActionService"):UnbindAction("disable_mouse_input")
							end)

							GunListTab["31"].MouseEnter:Connect(function()
								if not Library:IsMouseOverFrame(GunListTab["31"]) then return end
								GunListTab.test2 = true
							end)

							GunListTab["31"].MouseLeave:Connect(function()
								GunListTab.test2 = false
							end)

							do
								local tile_size = 24
								local max_players = 40.6
								local max_bars = math.floor((GunListTab["23"].AbsoluteSize.Y + 94) / (tile_size + 4))
								max_players = max_players - max_bars

								local function scroll(amount)
									GunListTab.CurrentScroll = math.clamp(amount, 0, max_players)

									if GunListTab.CurrentScroll > 0 then
										GunListTab["24"].Position = UDim2.new(0, 0, 0, GunListTab.CurrentScroll * -tile_size - ((GunListTab.CurrentScroll) * 4) + 12)
									else
										GunListTab["24"].Position = UDim2.new(0, 0, 0, 0)
									end

									GunListTab["32"].Position = UDim2.new(0, 0, (1 / (max_players + 19)) * GunListTab.CurrentScroll)
								end

								local function update_scroll(input)
									local sizeY = math.clamp((input.Position.Y - GunListTab["31"].AbsolutePosition.Y - game:GetService("GuiService"):GetGuiInset().Y) / GunListTab["31"].AbsoluteSize.Y, 0, 1)
									local value = math.round(math.clamp(max_players * sizeY, 0, max_players))

									scroll(value)
								end

								uis.InputBegan:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 and not isFadedOut then
										if GunListTab.test2 then
											GunListTab.Scrolling = true
											update_scroll{Position = uis:GetMouseLocation() - Vector2.new(0, 36)}
										end
									end
								end)

								uis.InputChanged:Connect(function(input)
									if GunListTab.Scrolling and input.UserInputType == Enum.UserInputType.MouseMovement then
										update_scroll(input)
									end
								end)

								uis.InputEnded:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 then
										GunListTab.Scrolling = false
									end
								end)

								GunListTab["23"].InputChanged:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseWheel then
										if input.Position.Z > 0 then
											scroll(GunListTab.CurrentScroll - 1)
										else
											scroll(GunListTab.CurrentScroll + 1)
										end
									end
								end)
							end
						end
					end

					return GunListTab
				end

				function SkinList:SkinsList()
					local SkinListTab = {
						Hover = false,
						Active = false,
						Scrolling = false,
						CurrentScroll = 0,
						test = false,
						test2 = false,
						CurrentSkin = nil,
						AmountOfSkins = 0,
					}

					do -- Render
						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab
						SkinListTab["1d"] = Instance.new("Frame", Tab["7"]);
						SkinListTab["1d"]["BorderSizePixel"] = 0;
						SkinListTab["1d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						SkinListTab["1d"]["BackgroundTransparency"] = 1;
						SkinListTab["1d"]["Size"] = UDim2.new(1, -2, 1, 14);
						SkinListTab["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						SkinListTab["1d"]["Position"] = UDim2.new(0, 1, 0, -14);
						SkinListTab["1d"]["ClipsDescendants"] = true;
						SkinListTab["1d"]["Name"] = [[SkinsTab]];

						SkinListTab["1i"] = Instance.new("UIPadding", SkinListTab["1d"]);
						SkinListTab["1i"]["PaddingTop"] = UDim.new(0, 20);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.UIListLayout
						SkinListTab["1e"] = Instance.new("UIListLayout", SkinListTab["1d"]);
						SkinListTab["1e"]["Padding"] = UDim.new(0, 10);
						SkinListTab["1e"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection
						SkinListTab["1f"] = Instance.new("Frame", SkinListTab["1d"]);
						SkinListTab["1f"]["BorderSizePixel"] = 0;
						SkinListTab["1f"]["BackgroundColor3"] = Library.Theme.DarkContrast;
						SkinListTab["1f"]["LayoutOrder"] = 1;
						SkinListTab["1f"]["Size"] = UDim2.new(1, 0, 1.0072979927062988, 0);
						SkinListTab["1f"]["ClipsDescendants"] = true;
						SkinListTab["1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						SkinListTab["1f"]["Name"] = [[SkinListSection]];
						
						table.insert(Library.DarkContrastObjects, SkinListTab["1f"])

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.TopBar
						SkinListTab["20"] = Instance.new("Frame", SkinListTab["1f"]);
						SkinListTab["20"]["BorderSizePixel"] = 0;
						SkinListTab["20"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 27);
						SkinListTab["20"]["Size"] = UDim2.new(1, 0, 0, 20);
						SkinListTab["20"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						SkinListTab["20"]["Name"] = [[TopBar]];

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.TopBar.Title
						SkinListTab["21"] = Instance.new("TextLabel", SkinListTab["20"]);
						SkinListTab["21"]["BorderSizePixel"] = 0;
						SkinListTab["21"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						SkinListTab["21"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						SkinListTab["21"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						SkinListTab["21"]["TextSize"] = 14;
						SkinListTab["21"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
						SkinListTab["21"]["Size"] = UDim2.new(1, 0, 1, 0);
						SkinListTab["21"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						SkinListTab["21"]["Text"] = [[Unknown Skin List - Unknown]];
						SkinListTab["21"]["Name"] = [[Title]];
						SkinListTab["21"]["BackgroundTransparency"] = 1;

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.TopBar.Title.UIPadding
						SkinListTab["22"] = Instance.new("UIPadding", SkinListTab["21"]);
						SkinListTab["22"]["PaddingLeft"] = UDim.new(0, 5);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList
						SkinListTab["23"] = Instance.new("Frame", SkinListTab["1f"]);
						SkinListTab["23"]["BorderSizePixel"] = 0;
						SkinListTab["23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						SkinListTab["23"]["BackgroundTransparency"] = 1;
						SkinListTab["23"]["Size"] = UDim2.new(1, 0, 1, -20);
						SkinListTab["23"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						SkinListTab["23"]["Position"] = UDim2.new(0, 0, 0, 20);
						SkinListTab["23"]["Name"] = [[SkinList]];

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder
						SkinListTab["24"] = Instance.new("Frame", SkinListTab["23"]);
						SkinListTab["24"]["BorderSizePixel"] = 0;
						SkinListTab["24"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						SkinListTab["24"]["BackgroundTransparency"] = 1;
						SkinListTab["24"]["Size"] = UDim2.new(1, 0, 1, 0);
						SkinListTab["24"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						SkinListTab["24"]["Name"] = [[Holder]];

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.UIPadding
						SkinListTab["2e"] = Instance.new("UIPadding", SkinListTab["24"]);
						SkinListTab["2e"]["PaddingTop"] = UDim.new(0, 5);
						SkinListTab["2e"]["PaddingLeft"] = UDim.new(0, -7);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.UIGridLayout
						SkinListTab["2f"] = Instance.new("UIGridLayout", SkinListTab["24"]);
						SkinListTab["2f"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
						SkinListTab["2f"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
						SkinListTab["2f"]["FillDirectionMaxCells"] = 5;
						SkinListTab["2f"]["CellSize"] = UDim2.new(0, 120, 0, 120);
						SkinListTab["2f"]["CellPadding"] = UDim2.new(0, 10, 0, 10);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.UIStroke
						SkinListTab["30"] = Instance.new("UIStroke", SkinListTab["1f"]);
						SkinListTab["30"]["Color"] = Color3.fromRGB(27, 27, 27);

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.ScrollBarBack
						SkinListTab["31"] = Instance.new("Frame", SkinListTab["1f"]);
						SkinListTab["31"]["BorderSizePixel"] = 0;
						SkinListTab["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						SkinListTab["31"]["AnchorPoint"] = Vector2.new(1, 0);
						SkinListTab["31"]["BackgroundTransparency"] = 1;
						SkinListTab["31"]["Size"] = UDim2.new(0, 6, 1, -19);
						SkinListTab["31"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						SkinListTab["31"]["Position"] = UDim2.new(1, -1, 0, 19);
						SkinListTab["31"]["Name"] = [[ScrollBarBack]];

						-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.ScrollBarBack.ScrollBar
						SkinListTab["32"] = Instance.new("Frame", SkinListTab["31"]);
						SkinListTab["32"]["BorderSizePixel"] = 0;
						SkinListTab["32"]["BackgroundColor3"] = Library.Theme.Accent;
						SkinListTab["32"]["Size"] = UDim2.new(1, 0, 0.5, 0);
						SkinListTab["32"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						SkinListTab["32"]["Name"] = [[ScrollBar]];

						table.insert(Library.ThemeObjects, SkinListTab["32"])
					end

					do -- Methods
						function SkinListTab:UpdateFrame()

						end

						function SkinListTab:RemoveGun(gun)
							for Index, Value in pairs(SkinListTab["24"]:GetDescendants()) do
								if Value.Name == gun.Name then
									Value:Destroy()
								end
							end
						end

						function SkinListTab:AddSkin(name, icon)
							local Item = {
								Hover = false,
								MouseDown = false,
							}

							SkinListTab.AmountOfSkins += 1

							do -- Render
								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame
								Item["25"] = Instance.new("Frame", SkinListTab["24"]);
								Item["25"]["BorderSizePixel"] = 0;
								Item["25"]["BackgroundColor3"] = Color3.fromRGB(16, 16, 16);
								Item["25"]["Size"] = UDim2.new(0, 100, 0, 100);
								Item["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								Item["25"]["Name"] = [[SkinFrame]];
								Item["25"]["Visible"] = true;
								Item["25"]["ZIndex"] = 1;

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.SkinName
								Item["26"] = Instance.new("TextLabel", Item["25"]);
								Item["26"]["BorderSizePixel"] = 0;
								Item["26"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
								Item["26"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
								Item["26"]["TextSize"] = 16;
								Item["26"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
								Item["26"]["AnchorPoint"] = Vector2.new(0, 1);
								Item["26"]["Size"] = UDim2.new(1, 0, 0, 20);
								Item["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								Item["26"]["Text"] = name ~= nil and name or "N/A";
								Item["26"]["Name"] = [[SkinName]];
								Item["26"]["BackgroundTransparency"] = 1;
								Item["26"]["Position"] = UDim2.new(0, 0, 1, 0);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.SkinName.UIPadding
								Item["27"] = Instance.new("UIPadding", Item["26"]);
								Item["27"]["PaddingBottom"] = UDim.new(0, 15);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.UIStroke
								Item["28"] = Instance.new("UIStroke", Item["25"]);
								Item["28"]["Color"] = Color3.fromRGB(31, 31, 31);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.GunName
								Item["29"] = Instance.new("TextLabel", Item["25"]);
								Item["29"]["BorderSizePixel"] = 0;
								Item["29"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
								Item["29"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								Item["29"]["TextSize"] = 13;
								Item["29"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
								Item["29"]["TextTransparency"] = 1;
								Item["29"]["AnchorPoint"] = Vector2.new(0, 1);
								Item["29"]["Size"] = UDim2.new(1, 0, 0, 20);
								Item["29"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								Item["29"]["Text"] = [[N/A]];
								Item["29"]["Name"] = [[GunName]];
								Item["29"]["BackgroundTransparency"] = 1;
								Item["29"]["Position"] = UDim2.new(0, 0, 1, -15);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.GunName.UIPadding
								Item["2a"] = Instance.new("UIPadding", Item["29"]);
								Item["2a"]["PaddingBottom"] = UDim.new(0, 5);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.ImageHolder
								Item["2b"] = Instance.new("Frame", Item["25"]);
								Item["2b"]["BorderSizePixel"] = 0;
								Item["2b"]["BackgroundColor3"] = Color3.fromRGB(21, 21, 21);
								Item["2b"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
								Item["2b"]["Size"] = UDim2.new(1, -15, 1, -40);
								Item["2b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								Item["2b"]["Position"] = UDim2.new(0.5, 0, 0.5, -15);
								Item["2b"]["Name"] = [[ImageHolder]];

								if icon ~= nil then
									icon.Parent = Item["2b"]
								end

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.ImageHolder.Image
								Item["2c"] = Instance.new("ImageLabel", Item["2b"]);
								Item["2c"]["BorderSizePixel"] = 0;
								Item["2c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
								Item["2c"]["AnchorPoint"] = Vector2.new(0.5, 0);
								Item["2c"]["Size"] = UDim2.new(1, 0, 1, 0);
								Item["2c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								Item["2c"]["Name"] = [[Image]];
								Item["2c"]["Image"] = "";
								Item["2c"]["BackgroundTransparency"] = 1;
								Item["2c"]["Position"] = UDim2.new(0.5, 0, 0, 0);

								-- StarterGui.MyLibrary.MainBackground.ContentContainer.SkinsTab.SkinListSection.SkinList.Holder.SkinFrame.ImageHolder.UIStroke
								Item["2d"] = Instance.new("UIStroke", Item["2b"]);
								Item["2d"]["Color"] = Color3.fromRGB(27, 27, 27);
							end

							do -- Methods
								function Item:Activate()
									if not Item.Active then

										if SkinListTab.CurrentSkin ~= nil then
											SkinListTab.CurrentSkin:Deactivate()
										end

										Item.Active = true

										SkinListTab.CurrentSkin = Item
									end
								end

								function Item:Deactivate()
									if Item.Active then
										Item.Active = false
										Item.Hover = false
									end
								end
							end

							Item["25"].MouseEnter:Connect(function()
								if not Library:IsMouseOverFrame(Item["25"]) then return end
								Item.Hover = true
								if not Item.Active then
									Library:tween(Item["28"], {Color = Color3.fromRGB(55, 55, 55)})
									Library:tween(Item["2d"], {Color = Color3.fromRGB(40, 40, 40)})
								end
							end)

							Item["25"].MouseLeave:Connect(function()
								Item.Hover = false

								if not Item.Active then
									Library:tween(Item["28"], {Color = Color3.fromRGB(30, 30, 30)})
									Library:tween(Item["2d"], {Color = Color3.fromRGB(30, 30, 30)})
								end
							end)

							uis.InputBegan:Connect(function(input, gpe)
								if gpe then return end

								if input.UserInputType == Enum.UserInputType.MouseButton1 and Item.Hover and not isFadedOut then
									Item:Activate()
								end
							end)

							uis.InputEnded:Connect(function(input, gpe)
								if gpe then return end

								if input.UserInputType == Enum.UserInputType.MouseButton1 and not isFadedOut then
									Item.MouseDown = false

									if Item.Hover then
										Library:tween(Item["28"], {Color = Color3.fromRGB(55, 55, 55)})
										Library:tween(Item["2d"], {Color = Color3.fromRGB(40, 40, 40)})
									else
										Library:tween(Item["28"], {Color = Color3.fromRGB(30, 30, 30)})
										Library:tween(Item["2d"], {Color = Color3.fromRGB(30, 30, 30)})
									end
								end
							end)

							SkinListTab:UpdateFrame()
						end

						do -- Logic
							SkinListTab["23"].MouseEnter:Connect(function()
								if not Library:IsMouseOverFrame(SkinListTab["23"]) then return end
								SkinListTab.test = true
								game:GetService("ContextActionService"):BindAction("disable_mouse_input", function()
									return Enum.ContextActionResult.Sink
								end, false, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3, Enum.UserInputType.MouseWheel)
							end)

							SkinListTab["23"].MouseLeave:Connect(function()
								SkinListTab.test = false
								game:GetService("ContextActionService"):UnbindAction("disable_mouse_input")
							end)

							SkinListTab["31"].MouseEnter:Connect(function()
								if not Library:IsMouseOverFrame(SkinListTab["31"]) then return end
								SkinListTab.test2 = true
							end)

							SkinListTab["31"].MouseLeave:Connect(function()
								SkinListTab.test2 = false
							end)

							do
								local tile_size = 24
								local max_players = 40.6
								local max_bars = math.floor((SkinListTab["23"].AbsoluteSize.Y + 94) / (tile_size + 4))
								max_players = max_players - max_bars

								local function scroll(amount)
									SkinListTab.CurrentScroll = math.clamp(amount, 0, max_players)

									if SkinListTab.CurrentScroll > 0 then
										SkinListTab["24"].Position = UDim2.new(0, 0, 0, SkinListTab.CurrentScroll * -tile_size - ((SkinListTab.CurrentScroll) * 4) + 12)
									else
										SkinListTab["24"].Position = UDim2.new(0, 0, 0, 0)
									end

									SkinListTab["32"].Position = UDim2.new(0, 0, (1 / (max_players + 19)) * SkinListTab.CurrentScroll)
								end

								local function update_scroll(input)
									local sizeY = math.clamp((input.Position.Y - SkinListTab["31"].AbsolutePosition.Y - game:GetService("GuiService"):GetGuiInset().Y) / SkinListTab["31"].AbsoluteSize.Y, 0, 1)
									local value = math.round(math.clamp(max_players * sizeY, 0, max_players))

									scroll(value)
								end

								uis.InputBegan:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 and not isFadedOut then
										if SkinListTab.test2 then
											SkinListTab.Scrolling = true
											update_scroll{Position = uis:GetMouseLocation() - Vector2.new(0, 36)}
										end
									end
								end)

								uis.InputChanged:Connect(function(input)
									if SkinListTab.Scrolling and input.UserInputType == Enum.UserInputType.MouseMovement then
										update_scroll(input)
									end
								end)

								uis.InputEnded:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 and not isFadedOut then
										SkinListTab.Scrolling = false
									end
								end)

								SkinListTab["23"].InputChanged:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseWheel then
										if input.Position.Z > 0 then
											scroll(SkinListTab.CurrentScroll - 1)
										else
											scroll(SkinListTab.CurrentScroll + 1)
										end
									end
								end)
							end
						end
					end

					return SkinListTab
				end
			end

			local GunList = SkinList:GunsList()

			local regex = '%[(.-)%]';

			for i, v in next, guns:GetChildren() do
				if v:IsA('Frame') and v.Name ~= 'GunEntry' and v.Name ~= 'Trading' and v.Name ~= '[Mask]' and v.Name ~= "[Vehicle]"then
					local extracted_name = v.Name:match(regex);

					if extracted_name then
						local image = v:FindFirstChild("Container").Preview.Image
						GunList:AddGun(extracted_name, image)
					end;
				end; 
			end

			return SkinList
		end

		function Tab:Section(options)
			options = Library:Validate({
				Name = "Preview Section",
				Side = "Left"
			}, options or {})

			local Section = {}

			do -- Section
				zindexcount -= 1
				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeSection.Left.Section
				Section["9"] = Instance.new("Frame", Tab["7"]);
				Section["9"]["BorderSizePixel"] = 0;
				Section["9"]["BackgroundColor3"] = Library.Theme.DarkContrast;
				Section["9"]["Size"] = UDim2.new(1, -7, 0, 30);
				Section["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Section["9"]["Name"] = [[Section]];
				Section["9"]["AutomaticSize"] = Enum.AutomaticSize.Y;
				Section["9"]["ZIndex"] = zindexcount;
				
				table.insert(Library.DarkContrastObjects, Section["9"])

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeSection.Left.Section.UIStroke
				Section["a"] = Instance.new("UIStroke", Section["9"]);
				Section["a"]["Color"] = Color3.fromRGB(27, 27, 27);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeSection.Left.Section.TopBar
				Section["b"] = Instance.new("Frame", Section["9"]);
				Section["b"]["BorderSizePixel"] = 0;
				Section["b"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 27);
				Section["b"]["Size"] = UDim2.new(1, 0, 0, 20);
				Section["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Section["b"]["Name"] = [[TopBar]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeSection.Left.Section.TopBar.Title
				Section["c"] = Instance.new("TextLabel", Section["b"]);
				Section["c"]["BorderSizePixel"] = 0;
				Section["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Section["c"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Section["c"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Section["c"]["TextSize"] = 14;
				Section["c"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
				Section["c"]["Size"] = UDim2.new(1, 0, 1, 0);
				Section["c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Section["c"]["Text"] = options.Name;
				Section["c"]["Name"] = [[Title]];
				Section["c"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeSection.Left.Section.TopBar.Title.UIPadding
				Section["d"] = Instance.new("UIPadding", Section["c"]);
				Section["d"]["PaddingLeft"] = UDim.new(0, 5);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeSection.Left.Section.ContentContainer
				Section["f"] = Instance.new("Frame", Section["9"]);
				Section["f"]["BorderSizePixel"] = 0;
				Section["f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Section["f"]["BackgroundTransparency"] = 1;
				Section["f"]["Size"] = UDim2.new(1, 0, 1, -20);
				Section["f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Section["f"]["Position"] = UDim2.new(0, 0, 0, 20);
				Section["f"]["Name"] = [[ContentContainer]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.UIListLayout
				Section["13"] = Instance.new("UIListLayout", Section["f"]);
				Section["13"]["Padding"] = UDim.new(0, 7);
				Section["13"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.UIPadding
				Section["14"] = Instance.new("UIPadding", Section["f"]);
				Section["14"]["PaddingTop"] = UDim.new(0, 5);
				Section["14"]["PaddingLeft"] = UDim.new(0, 10);
				Section["14"]["PaddingBottom"] = UDim.new(0, 7);
			end

			local column = options.Side == "Left" and Tab["8"] or Tab["41"]

			Section["9"].Parent = column
			
			return setmetatable(Section, Library.Sections)
		end
		
		function Tab:MultiSection(options)
			options = Library:Validate({
				Side = "Left",
				Sections = {},
				Callback = function() end,
			}, options or {})

			local MultiSection = {
				Open = false,
				CurrentSection = nil,
			}
			
			do -- MultiSection
				zindexcount -= 1
				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeMultiSection.Left.MultiSection
				MultiSection["9"] = Instance.new("Frame", Tab["7"]);
				MultiSection["9"]["BorderSizePixel"] = 0;
				MultiSection["9"]["BackgroundColor3"] = Library.Theme.DarkContrast;
				MultiSection["9"]["Size"] = UDim2.new(1, -7, 0, 30);
				MultiSection["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				MultiSection["9"]["Name"] = [[MultiSection]];
				MultiSection["9"]["AutomaticSize"] = Enum.AutomaticSize.Y;
				MultiSection["9"]["ZIndex"] = zindexcount;

				table.insert(Library.DarkContrastObjects, MultiSection["9"])

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeMultiSection.Left.MultiSection.UIStroke
				MultiSection["a"] = Instance.new("UIStroke", MultiSection["9"]);
				MultiSection["a"]["Color"] = Color3.fromRGB(27, 27, 27);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeMultiSection.Left.MultiSection.TopBar
				MultiSection["b"] = Instance.new("Frame", MultiSection["9"]);
				MultiSection["b"]["BorderSizePixel"] = 0;
				MultiSection["b"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 27);
				MultiSection["b"]["Size"] = UDim2.new(1, 0, 0, 20);
				MultiSection["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				MultiSection["b"]["Name"] = [[TopBar]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeMultiSection.Left.MultiSection.TopBar.Title.UIPadding
				MultiSection["d"] = Instance.new("UIPadding", MultiSection["c"]);
				MultiSection["d"]["PaddingLeft"] = UDim.new(0, 5);
			end
			
			for Index, Value in pairs(options.Sections) do
				
				local Options = {
					Active = false,
					Hover = false,
				}

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeOptions.Left.Options
				Options["9d"] = Instance.new("Frame", MultiSection["b"]);
				Options["9d"]["BorderSizePixel"] = 0;
				Options["9d"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
				Options["9d"]["Size"] = Index == 1 and UDim2.new(0.5, 0, 1, 0) or UDim2.new(1 / Index, 0, 1, 0);
				Options["9d"]["Position"] = Index == 1 and UDim2.new(0, 0, 0, 0) or UDim2.new(1 / Index, 0, 0, 0);
				Options["9d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Options["9d"]["Name"] = Value;

				-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
				Options["bfj"] = Instance.new("TextButton", Options["9d"]);
				Options["bfj"]["BorderSizePixel"] = 0;
				Options["bfj"]["TextTransparency"] = 1;
				Options["bfj"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Options["bfj"]["TextSize"] = 14;
				Options["bfj"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Options["bfj"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
				Options["bfj"]["Size"] = UDim2.new(1, 0, 1, 0);
				Options["bfj"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Options["bfj"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeOptions.Left.Options.UIStroke
				Options["da"] = Instance.new("UIStroke", Options["9d"]);
				Options["da"]["Color"] = Color3.fromRGB(27, 27, 27);

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeOptions.Left.Options.TopBar.Title
				Options["c"] = Instance.new("TextLabel", Options["9d"]);
				Options["c"]["BorderSizePixel"] = 0;
				Options["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Options["c"]["TextXAlignment"] = Enum.TextXAlignment.Center;
				Options["c"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Options["c"]["TextSize"] = 14;
				Options["c"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
				Options["c"]["Size"] = UDim2.new(1, 0, 1, 0);
				Options["c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Options["c"]["Text"] = Value;
				Options["c"]["Name"] = [[Title]];
				Options["c"]["BackgroundTransparency"] = 1;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.HomeOptions.Left.Options.ContentContainer
				MultiSection["f"] = Instance.new("Frame", Options["9"]);
				MultiSection["f"]["BorderSizePixel"] = 0;
				MultiSection["f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				MultiSection["f"]["BackgroundTransparency"] = 1;
				MultiSection["f"]["Size"] = UDim2.new(1, 0, 1, -20);
				MultiSection["f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				MultiSection["f"]["Position"] = UDim2.new(0, 0, 0, 20);
				MultiSection["f"]["Name"] = [[ContentContainer]];
				MultiSection["f"]["Visible"] = false

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Options.ContentContainer.UIListLayout
				Options["13"] = Instance.new("UIListLayout", MultiSection["f"]);
				Options["13"]["Padding"] = UDim.new(0, 7);
				Options["13"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Options.ContentContainer.UIPadding
				Options["14"] = Instance.new("UIPadding", MultiSection["f"]);
				Options["14"]["PaddingTop"] = UDim.new(0, 5);
				Options["14"]["PaddingLeft"] = UDim.new(0, 10);
				Options["14"]["PaddingBottom"] = UDim.new(0, 7);

				function Options:Activate()
					if not Options.Active then

						if MultiSection.CurrentSection ~= nil then
							MultiSection.CurrentSection:Deactivate()
						end

						Library:tween(Options["9d"], {BackgroundColor3 = Color3.fromRGB(27, 27, 27)})

						Options.Active = true
						MultiSection["f"].Visible = true
						options.Callback(Value)

						MultiSection.CurrentSection = Options
					end
				end

				function Options:Deactivate()
					if Options.Active then
						Options.Active = false
						Options.Hover = false
						
						MultiSection["f"].Visible = false

						Library:tween(Options["9d"], {BackgroundColor3 = Color3.fromRGB(20, 20, 20)})
					end
				end

				function Options:Toggle()
					if Options.Active then
						Options:Deactivate()
					else
						Options:Activate()
					end
				end
				
				if MultiSection.CurrentSection == nil then
					Options:Activate()
				end

				Options["bfj"].MouseButton1Click:Connect(function()
					Options:Toggle()
				end)
			end
			
			local column = options.Side == "Left" and Tab["8"] or Tab["41"]

			MultiSection["9"].Parent = column
			
			return setmetatable(MultiSection, Library.Sections)
		end

			function Section:Button(options)
				options = Library:Validate({
					Name = "Preview Button",
					ToolTip = false,
					ToolTipText = "Button Tool Tip",
					Callback = function() end
				}, options or {})


				local Button = {
					Hover = false,
					MouseDown = false,
					Section = self,
				}

				do -- Render
					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Button
					Button["12"] = Instance.new("Frame", Button.Section["f"]);
					Button["12"]["BorderSizePixel"] = 0;
					Button["12"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					Button["12"]["Size"] = UDim2.new(1, -10, 0, 18);
					Button["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Button["12"]["Position"] = UDim2.new(0, 5, 0, 0);
					Button["12"]["Name"] = [[Button]];

					-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
					Button["bfj"] = Instance.new("TextButton", Button["12"]);
					Button["bfj"]["BorderSizePixel"] = 0;
					Button["bfj"]["TextTransparency"] = 1;
					Button["bfj"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Button["bfj"]["TextSize"] = 14;
					Button["bfj"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Button["bfj"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
					Button["bfj"]["Size"] = UDim2.new(1, 0, 1, 0);
					Button["bfj"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Button["bfj"]["BackgroundTransparency"] = 1;
					Button["bfj"]["Name"] = "BUTTON";

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Button.Text
					Button["13"] = Instance.new("TextLabel", Button["12"]);
					Button["13"]["TextWrapped"] = true;
					Button["13"]["BorderSizePixel"] = 0;
					Button["13"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Button["13"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Button["13"]["TextSize"] = 14;
					Button["13"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					Button["13"]["Size"] = UDim2.new(1, 0, 1, -4);
					Button["13"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Button["13"]["Text"] = options.Name;
					Button["13"]["Name"] = [[Text]];
					Button["13"]["BackgroundTransparency"] = 1;
					Button["13"]["Position"] = UDim2.new(0, 0, 0, 2);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Button.UIStroke
					Button["14"] = Instance.new("UIStroke", Button["12"]);
					Button["14"]["Color"] = Color3.fromRGB(27, 27, 27);
				end

				do -- Methods
					function Button:SetText(text)
						Button["13"].Text = text
						options.Name = text
					end

					function Button:SetCallback(fn)
						options.Callback = fn
					end
				end

				do -- Logic
					Button["12"].MouseEnter:Connect(function()
						if not Library:IsMouseOverFrame(Button["12"]) then return end
						Button.Hover = true

						Library:tween(Button["14"], {Color = Color3.fromRGB(50, 50, 50)})
						Library:tween(Button["12"], {BackgroundColor3 = Color3.fromRGB(17, 17, 17)})
						
						if options.ToolTip then
							GUI["ggxxgg"].Visible = true
							Library:UpdateToolTip(options.ToolTipText)

							uis.InputChanged:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseMovement then
									Library:UpdateToolTipPosition()
								end
							end)

							Library:UpdateToolTipPosition()
						end
					end)

					Button["12"].MouseLeave:Connect(function()
						Button.Hover = false

						if not Button.MouseDown then
							Library:tween(Button["14"], {Color = Color3.fromRGB(27, 27, 27)})
							Library:tween(Button["12"], {BackgroundColor3 = Color3.fromRGB(13, 13, 13)})
						end
						
						GUI["ggxxgg"].Visible = false
					end)

					Button["bfj"].MouseButton1Down:Connect(function()
						if Button.Hover then
							Button.MouseDown = true
							Library:tween(Button["14"], {Color = Color3.fromRGB(80, 80, 80)})
							Library:tween(Button["12"], {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})

							options.Callback()
						end
					end)

					Button["bfj"].MouseButton1Up:Connect(function()
						Button.MouseDown = false

						if Button.Hover then
							Library:tween(Button["14"], {Color = Color3.fromRGB(50, 50, 50)})
							Library:tween(Button["12"], {BackgroundColor3 = Color3.fromRGB(17, 17, 17)})
						else
							Library:tween(Button["14"], {Color = Color3.fromRGB(27, 27, 27)})
							Library:tween(Button["12"], {BackgroundColor3 = Color3.fromRGB(13, 13, 13)})
						end
					end)
				end

				return Button

			end

			function Section:Label(options)
				options = Library:Validate({
					Message = "Preview Label",
					ToolTip = false,
					ToolTipText = "Label Tool Tip",
					Side = "Left"
				}, options or {})

				local Label = {
					ColorPickers = {},
					Section = self,
				}

				do -- Render
					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Label
					Label["41"] = Instance.new("Frame", Label.Section["f"]);
					Label["41"]["BorderSizePixel"] = 0;
					Label["41"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					Label["41"]["BackgroundTransparency"] = 1;
					Label["41"]["Size"] = UDim2.new(1, -10, 0, 12);
					Label["41"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Label["41"]["Position"] = UDim2.new(0, 0, 0, 119);
					Label["41"]["Name"] = [[Label]];
					Label["41"]["ZIndex"] = (zindexcount - 10) + 1;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Label.Text
					Label["42"] = Instance.new("TextLabel", Label["41"]);
					Label["42"]["TextWrapped"] = true;
					Label["42"]["BorderSizePixel"] = 0;
					Label["42"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Label["42"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					Label["42"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Label["42"]["TextSize"] = 14;
					Label["42"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					Label["42"]["Size"] = UDim2.new(1, 0, 1, 0);
					Label["42"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Label["42"]["Name"] = [[Text]];
					Label["42"]["Text"] = options.Message;
					Label["42"]["BackgroundTransparency"] = 1;
					Label["42"]["TextXAlignment"] = Enum.TextXAlignment[options.Side];
				end

				do -- Methods
					function Label:SetText(text)
						options.Message = text
						Label:_Update()
					end

					function Label:_Update()
						Label["42"].Text = options.Message

						Label["42"].Size = UDim2.new(Label["42"].Size.X.Scale, Label["42"].Size.X.Offset, 0, math.huge)
						Label["42"].Size = UDim2.new(Label["42"].Size.X.Scale, Label["42"].Size.X.Offset, 0, Label["42"].TextBounds.Y)
						Label["41"].Size = UDim2.new(Label["41"].Size.X.Scale, Label["41"].Size.X.Offset, 0, Label["42"].TextBounds.Y + 4)
					end

					function Label:ColorPicker(options)
						options = Library:Validate({
							Name = "Preview Color Picker",
							Default = Color3.fromRGB(255, 0, 0),
							Flag = Library.NewFlag(),
							Alpha = 1,
							AlphaBar = true,
							Callback = function() end,
						}, options or {})

						if not options.Default then
							Library.Flags[options.Default] = {Color = options.Default, Alpha = options.Alpha}
							options.Callback(options.Default, options.Alpha)
						end

						local function rgbToHsv(r, g, b)
							r, g, b = r / 255, g / 255, b / 255
							local max, min = math.max(r, g, b), math.min(r, g, b)
							local h, s, v
							v = max
							local d = max - min
							if max == 0 then
								s = 0
							else
								s = d / max
							end
							if max == min then
								h = 0
							else
								if max == r then
									h = (g - b) / d + (g < b and 6 or 0)
								elseif max == g then
									h = (b - r) / d + 2
								elseif max == b then
									h = (r - g) / d + 4
								end
								h = h / 6
							end
							return h, s, v
						end

						local function HSVtoRGB(h, s, v)
							local r, g, b

							local i = math.floor(h * 6)
							local f = h * 6 - i
							local p = v * (1 - s)
							local q = v * (1 - f * s)
							local t = v * (1 - (1 - f) * s)

							i = i % 6

							if i == 0 then r, g, b = v, t, p
							elseif i == 1 then r, g, b = q, v, p
							elseif i == 2 then r, g, b = p, v, t
							elseif i == 3 then r, g, b = p, q, v
							elseif i == 4 then r, g, b = t, p, v
							elseif i == 5 then r, g, b = v, p, q
							end

							return Color3.new(r, g, b)
						end

						local color = options.Default
						local r, g, b = color.R * 255, color.G * 255, color.B * 255
						local h, s, v = rgbToHsv(r, g, b)

						local ColorPicker = {
							Hover = false,
							MouseDown = false,
							MainFrameHover = false,
							Color = options.Default,
							Saturation = {s, v},
							Alpha = options.Alpha,
							Hue = h,
						}

						function ColorPicker:GetFlag()
							return options.Flag
						end

						function ColorPicker:GetTitle()
							return options.Name
						end

						local Count = GetDictionaryLength(Label.ColorPickers)

						do -- Render
							ColorPicker["36"] = Instance.new("Frame", Label["41"]);
							ColorPicker["36"]["BorderSizePixel"] = 0;
							ColorPicker["36"]["BackgroundColor3"] = ColorPicker.Color;
							ColorPicker["36"]["AnchorPoint"] = Vector2.new(0, 0.5);
							ColorPicker["36"]["Size"] = UDim2.new(0, 30, 0, 13);
							ColorPicker["36"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							ColorPicker["36"]["Position"] = UDim2.new(1, -30 - (Count - 1) * 35, 0.5, 0);
							ColorPicker["36"]["Name"] = "Colorpicker";
							ColorPicker["36"]["BackgroundTransparency"] = 1 - ColorPicker.Alpha;
							ColorPicker["36"]["ZIndex"] = 100 - Count;

							table.insert(Label.ColorPickers, ColorPicker["36"])

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Image
							ColorPicker["55"] = Instance.new("ImageLabel", ColorPicker["36"]);
							ColorPicker["55"]["BorderSizePixel"] = 0;
							ColorPicker["55"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							ColorPicker["55"]["Image"] = [[rbxassetid://17712772030]];
							ColorPicker["55"]["Size"] = UDim2.new(1, 0, 1, 0);
							ColorPicker["55"]["ImageTransparency"] = ColorPicker.Alpha;
							ColorPicker["55"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							ColorPicker["55"]["Name"] = [[TRANSPARENCY]];
							ColorPicker["55"]["BackgroundTransparency"] = 1;

							-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
							ColorPicker["bfj"] = Instance.new("TextButton", ColorPicker["36"]);
							ColorPicker["bfj"]["BorderSizePixel"] = 0;
							ColorPicker["bfj"]["TextTransparency"] = 1;
							ColorPicker["bfj"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							ColorPicker["bfj"]["TextSize"] = 14;
							ColorPicker["bfj"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							ColorPicker["bfj"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
							ColorPicker["bfj"]["Size"] = UDim2.new(1, 0, 1, 0);
							ColorPicker["bfj"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							ColorPicker["bfj"]["BackgroundTransparency"] = 1;
							ColorPicker["bfj"]["Name"] = "BUTTON";

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.UIStroke
							ColorPicker["37"] = Instance.new("UIStroke", ColorPicker["36"]);
							ColorPicker["37"]["Color"] = Color3.fromRGB(28, 28, 28);
							ColorPicker["37"]["Name"] = "UISTROKE";
						end

						do -- Methods
							function ColorPicker:AddFrame()

								do -- Render
									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame
									ColorPicker["38"] = Instance.new("Frame", ColorPicker["36"]);
									ColorPicker["38"]["BorderSizePixel"] = 0;
									ColorPicker["38"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
									ColorPicker["38"]["Size"] = options.AlphaBar and UDim2.new(0, 150, 0, 140) or UDim2.new(0, 150, 0, 125);
									ColorPicker["38"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["38"]["Position"] = UDim2.new(1, -185, 0, 0);
									ColorPicker["38"]["Name"] = "MainFrame";

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.UIStroke
									ColorPicker["39"] = Instance.new("UIStroke", ColorPicker["38"]);
									ColorPicker["39"]["Color"] = Color3.fromRGB(28, 28, 28);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.Title
									ColorPicker["3a"] = Instance.new("TextLabel", ColorPicker["38"]);
									ColorPicker["3a"]["BorderSizePixel"] = 0;
									ColorPicker["3a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["3a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
									ColorPicker["3a"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									ColorPicker["3a"]["TextSize"] = 14;
									ColorPicker["3a"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
									ColorPicker["3a"]["Size"] = UDim2.new(1, 0, 0, 20);
									ColorPicker["3a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["3a"]["Text"] = ColorPicker:GetTitle();
									ColorPicker["3a"]["Name"] = [[Title]];
									ColorPicker["3a"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.Title.UIPadding
									ColorPicker["3b"] = Instance.new("UIPadding", ColorPicker["3a"]);
									ColorPicker["3b"]["PaddingLeft"] = UDim.new(0, 5);

									-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
									ColorPicker["3c"] = Instance.new("TextButton", ColorPicker["38"]);
									ColorPicker["3c"]["BorderSizePixel"] = 0;
									ColorPicker["3c"]["TextTransparency"] = 1;
									ColorPicker["3c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["3c"]["TextSize"] = 14;
									ColorPicker["3c"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									ColorPicker["3c"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["3c"]["Size"] = UDim2.new(0, 125, 0, 100);
									ColorPicker["3c"]["Position"] = UDim2.new(0, 5, 0, 20);
									ColorPicker["3c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["3c"]["BackgroundTransparency"] = 1;
									ColorPicker["3c"]["Name"] = [[ColorFrame]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Square
									ColorPicker["3e"] = Instance.new("Frame", ColorPicker["3c"]);
									ColorPicker["3e"]["ZIndex"] = 7;
									ColorPicker["3e"]["BorderSizePixel"] = 0;
									ColorPicker["3e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["3e"]["Size"] = UDim2.new(0, 3, 0, 3);
									ColorPicker["3e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["3e"]["Position"] = UDim2.new(1, -3, 0, 0);
									ColorPicker["3e"]["Name"] = [[Square]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Square.UIStroke
									ColorPicker["3f"] = Instance.new("UIStroke", ColorPicker["3e"]);
									ColorPicker["3f"]["Color"] = Color3.fromRGB(21, 21, 21);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Image
									ColorPicker["40"] = Instance.new("ImageLabel", ColorPicker["3c"]);
									ColorPicker["40"]["BorderSizePixel"] = 0;
									ColorPicker["40"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["40"]["Image"] = [[rbxassetid://8180999986]];
									ColorPicker["40"]["Size"] = UDim2.new(1, 0, 1, 0);
									ColorPicker["40"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["40"]["Name"] = [[Image]];
									ColorPicker["40"]["Rotation"] = 180;
									ColorPicker["40"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Image.UIGradient
									ColorPicker["41"] = Instance.new("UIGradient", ColorPicker["40"]);
									ColorPicker["41"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(255, 0, 5)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 255, 255))};

									-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
									ColorPicker["42"] = Instance.new("TextButton", ColorPicker["38"]);
									ColorPicker["42"]["BorderSizePixel"] = 0;
									ColorPicker["42"]["TextTransparency"] = 1;
									ColorPicker["42"]["BackgroundColor3"] = Color3.fromRGB(17, 17, 17);
									ColorPicker["42"]["TextSize"] = 14;
									ColorPicker["42"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									ColorPicker["42"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["42"]["Size"] = UDim2.new(0, 125, 0, 10);
									ColorPicker["42"]["Position"] = UDim2.new(0, 5, 1, -14);
									ColorPicker["42"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["42"]["BackgroundTransparency"] = 1;
									ColorPicker["42"]["Name"] = [[HexBox]];
									ColorPicker["42"]["Visible"] = options.AlphaBar and true or false;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Image
									ColorPicker["44"] = Instance.new("ImageLabel", ColorPicker["42"]);
									ColorPicker["44"]["BorderSizePixel"] = 0;
									ColorPicker["44"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["44"]["Image"] = [[http://www.roblox.com/asset/?id=17716156120]];
									ColorPicker["44"]["Size"] = UDim2.new(1, 0, 1, 0);
									ColorPicker["44"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["44"]["Name"] = [[Image]];
									ColorPicker["44"]["BackgroundTransparency"] = 1;
										
									-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
									ColorPicker["45"] = Instance.new("TextButton", ColorPicker["38"]);
									ColorPicker["45"]["BorderSizePixel"] = 0;
									ColorPicker["45"]["TextTransparency"] = 1;
									ColorPicker["45"]["BackgroundColor3"] = Color3.fromRGB(17, 17, 17);
									ColorPicker["45"]["TextSize"] = 14;
									ColorPicker["45"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									ColorPicker["45"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["45"]["Size"] = UDim2.new(0, 10, 0, 100);
									ColorPicker["45"]["Position"] = UDim2.new(1, -15, 0, 20);
									ColorPicker["45"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["45"]["BackgroundTransparency"] = 1;
									ColorPicker["45"]["Name"] = [[HueFrame]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.HueFrame.Bar
									ColorPicker["47"] = Instance.new("Frame", ColorPicker["45"]);
									ColorPicker["47"]["ZIndex"] = 2;
									ColorPicker["47"]["BorderSizePixel"] = 0;
									ColorPicker["47"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["47"]["Size"] = UDim2.new(1, 2, 0, 2);
									ColorPicker["47"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["47"]["Position"] = UDim2.new(0, -1, 0, 0);
									ColorPicker["47"]["Name"] = [[Bar]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.HueFrame.Bar
									ColorPicker["k7"] = Instance.new("Frame", ColorPicker["44"]);
									ColorPicker["k7"]["ZIndex"] = 2;
									ColorPicker["k7"]["BorderSizePixel"] = 0;
									ColorPicker["k7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["k7"]["Size"] = UDim2.new(0, 2, 1, 2);
									ColorPicker["k7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["k7"]["Position"] = UDim2.new(1, 0, 0, -2);
									ColorPicker["k7"]["Name"] = [[Bar]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.HueFrame.Bar.UIStroke
									ColorPicker["k8"] = Instance.new("UIStroke", ColorPicker["k7"]);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.HueFrame.Bar.UIStroke
									ColorPicker["48"] = Instance.new("UIStroke", ColorPicker["47"]);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.HueFrame.Image
									ColorPicker["49"] = Instance.new("ImageLabel", ColorPicker["45"]);
									ColorPicker["49"]["BorderSizePixel"] = 0;
									ColorPicker["49"]["ScaleType"] = Enum.ScaleType.Crop;
									ColorPicker["49"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["49"]["Image"] = [[rbxassetid://8180989234]];
									ColorPicker["49"]["Size"] = UDim2.new(1, 0, 1, 0);
									ColorPicker["49"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["49"]["Name"] = [[Image]];
									ColorPicker["49"]["BackgroundTransparency"] = 1;
								end

								do -- Methods
									local function UpdateColor()
										ColorPicker.Color = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Saturation[1], ColorPicker.Saturation[2])

										ColorPicker["36"].BackgroundColor3 = ColorPicker.Color
										ColorPicker["36"].BackgroundTransparency = 1 - ColorPicker.Alpha
										ColorPicker["44"].BackgroundColor3 = ColorPicker.Color
										ColorPicker["55"].ImageTransparency = ColorPicker.Alpha
										ColorPicker["41"].Color =  ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromHSV(ColorPicker.Hue, 1, 1)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 255, 255))};

										ColorPicker["3e"].Position = UDim2.fromScale(math.clamp(ColorPicker.Saturation[1], 0, 0.95), math.clamp(1 - ColorPicker.Saturation[2], 0, 0.95))
										ColorPicker["k7"].Position = UDim2.fromScale(math.clamp(ColorPicker.Alpha, 0, 0.98), 0)
										ColorPicker["47"].Position = UDim2.fromScale(0, math.clamp(ColorPicker.Hue, 0, 0.98))

										options.Callback(ColorPicker.Color, ColorPicker.Alpha)
										Library.Flags[ColorPicker:GetFlag()] = {Color = ColorPicker.Color, Alpha = ColorPicker.Alpha}
									end

									function ColorPicker:Update()
										UpdateColor()
									end

									function ColorPicker:GetValue(): Color3
										return ColorPicker.Color
									end

									function ColorPicker:UpdateHue(Percentage: number)
										local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
										ColorPicker.Hue = Percentage
										ColorPicker:Update()
									end

									function ColorPicker:UpdateAlpha(Percentage: number)
										local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
										ColorPicker.Alpha = Percentage
										ColorPicker:Update()
									end

									function ColorPicker:UpdateSaturation(PercentageX: number, PercentageY: number)
										local PercentageX = typeof(PercentageX == "number") and math.clamp(PercentageX, 0, 1) or 0
										local PercentageY = typeof(PercentageY == "number") and math.clamp(PercentageY, 0, 1) or 0
										ColorPicker.Saturation[1] = PercentageX
										ColorPicker.Saturation[2] = 1 - PercentageY
										ColorPicker:Update()
									end
								end

								do -- Logic
									ColorPicker["38"].MouseEnter:Connect(function()
										if not Library:IsMouseOverFrame(ColorPicker["38"]) then return end
										ColorPicker.MainFrameHover = true
									end)

									ColorPicker["38"].MouseLeave:Connect(function()
										ColorPicker.MainFrameHover = false
									end)

									ColorPicker["3c"].InputBegan:Connect(function(Input: InputObject, Process: boolean)
										if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) and not isFadedOut then
											Dragging = {Gui = ColorPicker["3c"], True = true}
											local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
											local Percentage = (InputPosition - ColorPicker["3c"].AbsolutePosition) / ColorPicker["3c"].AbsoluteSize
											ColorPicker:UpdateSaturation(Percentage.X, Percentage.Y)
										end
									end)

									ColorPicker["42"].InputBegan:Connect(function(Input: InputObject, Process: boolean)
										if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) then
											Dragging = {Gui = ColorPicker["42"], True = true}
											local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
											local GuiPosition = ColorPicker["42"].AbsolutePosition.X
											local GuiSize = ColorPicker["42"].AbsoluteSize.X
											local Percentage = ((InputPosition.X - GuiPosition) / GuiSize)
											ColorPicker:UpdateAlpha(Percentage)
										end
									end)

									ColorPicker["45"].InputBegan:Connect(function(Input: InputObject, Process: boolean)
										if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) and not isFadedOut then
											Dragging = {Gui = ColorPicker["45"], True = true}
											local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
											local Percentage = (InputPosition - ColorPicker["45"].AbsolutePosition) / ColorPicker["45"].AbsoluteSize
											ColorPicker:UpdateHue(Percentage.Y)
										end
									end)

									uis.InputChanged:Connect(function(Input: InputObject, Process: boolean)
										if (Dragging.Gui ~= ColorPicker["3c"] and Dragging.Gui ~= ColorPicker["45"] and Dragging.Gui ~= ColorPicker["42"]) then return end
										if not (uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) or isFadedOut then
											Dragging = {Gui = nil, True = false}
											return
										end

										local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
										if (Input.UserInputType == Enum.UserInputType.MouseMovement) then
											if Dragging.Gui == ColorPicker["3c"] then
												local Percentage = (InputPosition - ColorPicker["3c"].AbsolutePosition) / ColorPicker["3c"].AbsoluteSize
												ColorPicker:UpdateSaturation(Percentage.X, Percentage.Y)
											end
											if Dragging.Gui == ColorPicker["42"] then
												local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
												local GuiPosition = ColorPicker["42"].AbsolutePosition.X
												local GuiSize = ColorPicker["42"].AbsoluteSize.X
												local Percentage = ((InputPosition.X - GuiPosition) / GuiSize)
												ColorPicker:UpdateAlpha(Percentage)
											end
											if Dragging.Gui == ColorPicker["45"] then
												local Percentage = (InputPosition - ColorPicker["45"].AbsolutePosition) / ColorPicker["45"].AbsoluteSize
												ColorPicker:UpdateHue(Percentage.Y)
											end
										end
									end)
								end

								ColorPicker:Update()
							end

							function ColorPicker:RemoveFrame()
								for i, v in pairs(ColorPicker["36"]:GetDescendants()) do
									if v.Name ~= "UISTROKE" and v.Name ~= "BUTTON" and v.Name ~= "TRANSPARENCY" then
										v:Destroy()
									end
								end
							end

							function ColorPicker:FindFrame()
								for i, v in pairs(ColorPicker["36"]:GetDescendants()) do
									if v.Name == "MainFrame" then
										return true
									end
								end
							end
						end

						do -- Logic
							ColorPicker["36"].MouseEnter:Connect(function()
								if not Library:IsMouseOverFrame(ColorPicker["36"]) then return end
								ColorPicker.Hover = true

								Library:tween(ColorPicker["37"], {Color = Color3.fromRGB(55, 55, 55)})
							end)

							ColorPicker["36"].MouseLeave:Connect(function()
								ColorPicker.Hover = false

								Library:tween(ColorPicker["37"], {Color = Color3.fromRGB(28, 28, 28)})
							end)

							local function ColorToggle()
								ColorPicker.Toggle = not ColorPicker.Toggle
								Label["41"].ZIndex = ColorPicker:FindFrame() and 2 or zindexcount2 + 500

								if ColorPicker.Toggle then
									ColorPicker:AddFrame()
								else
									ColorPicker:RemoveFrame()
								end
							end

							ColorPicker["bfj"].MouseButton1Click:Connect(function()
								if not isFadedOut then
									ColorToggle()
								end
							end)
						end


						options.Callback(ColorPicker.Color, ColorPicker.Alpha)
						Library.Flags[options.Flag] = {Color = options.Default, Alpha = options.Alpha}

						return ColorPicker
					end
				end
				
				Label["41"].MouseEnter:Connect(function()
					if options.ToolTip then
						GUI["ggxxgg"].Visible = true
						Library:UpdateToolTip(options.ToolTipText)

						uis.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement then
								Library:UpdateToolTipPosition()
							end
						end)

						Library:UpdateToolTipPosition()
					end
				end)
				
				Label["41"].MouseLeave:Connect(function()
					GUI["ggxxgg"].Visible = false
				end)

				Label:_Update()
				return Label
			end

			function Section:Seperator(options)
				options = Library:Validate({
					Thickness = 5,
					Color = Color3.fromRGB(14, 14, 14),
				}, options or {})

				local Seperator = {
					Section = self,
				}

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle
				Seperator["35"] = Instance.new("Frame", Seperator.Section["f"]);
				Seperator["35"]["BorderSizePixel"] = 0;
				Seperator["35"]["BackgroundColor3"] = options.Color;
				Seperator["35"]["BackgroundTransparency"] = 0;
				Seperator["35"]["Size"] = UDim2.new(1, -10, 0, options.Thickness);
				Seperator["35"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Seperator["35"]["Position"] = UDim2.new(0, 0, 0, 0);
				Seperator["35"]["Name"] = [[Seperator]];

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.checkmarkHolder.UIStroke
				Seperator["39"] = Instance.new("UIStroke", Seperator["35"]);
				Seperator["39"]["Color"] = Color3.fromRGB(27, 27, 27);
			end

			function Section:Toggle(options)
				options = Library:Validate({
					Default = false,
					Name = "Preview Toggle",
					ToolTip = false,
					ToolTipText = "Toggle Tool Tip",
					Flag = Library.NewFlag(),
					Callback = function() end
				}, options or {})

				if not options.Default then
					Library.Flags[options.Default] = options.Default
					options.Callback(options.Default)
				end

				local Toggle = {
					Hover = false,
					MouseDown = false,
					State = false,
					ColorPickers = {},
					Section = self,
				}

				function Toggle:GetName()
					return options.Name
				end

				do -- Render
					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle
					Toggle["35"] = Instance.new("Frame", Toggle.Section["f"]);
					Toggle["35"]["BorderSizePixel"] = 0;
					Toggle["35"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					Toggle["35"]["BackgroundTransparency"] = 1;
					Toggle["35"]["Size"] = UDim2.new(1, -10, 0, 12);
					Toggle["35"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Toggle["35"]["Position"] = UDim2.new(0, 0, 0, 94);
					Toggle["35"]["Name"] = [[Toggle]];
					Toggle["35"]["ZIndex"] = 1000;

					-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
					Toggle["bf"] = Instance.new("TextButton", Toggle["35"]);
					Toggle["bf"]["BorderSizePixel"] = 0;
					Toggle["bf"]["TextTransparency"] = 1;
					Toggle["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Toggle["bf"]["TextSize"] = 14;
					Toggle["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Toggle["bf"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
					Toggle["bf"]["Size"] = UDim2.new(1, 0, 1, 0);
					Toggle["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Toggle["bf"]["BackgroundTransparency"] = 1;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Text
					Toggle["36"] = Instance.new("TextLabel", Toggle["35"]);
					Toggle["36"]["TextWrapped"] = true;
					Toggle["36"]["BorderSizePixel"] = 0;
					Toggle["36"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Toggle["36"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					Toggle["36"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Toggle["36"]["TextSize"] = 14;
					Toggle["36"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					Toggle["36"]["Size"] = UDim2.new(1, 0, 1, -4);
					Toggle["36"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Toggle["36"]["Text"] = options.Name;
					Toggle["36"]["Name"] = [[Text]];
					Toggle["36"]["BackgroundTransparency"] = 1;
					Toggle["36"]["Position"] = UDim2.new(0, 0, 0, 2);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Text.UIPadding
					Toggle["37"] = Instance.new("UIPadding", Toggle["36"]);
					Toggle["37"]["PaddingLeft"] = UDim.new(0, 17);
					
					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.checkmarkHolder
					Toggle["3f8"] = Instance.new("Frame", Toggle["35"]);
					Toggle["3f8"]["BorderSizePixel"] = 0;
					Toggle["3f8"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					Toggle["3f8"]["Size"] = UDim2.new(0, 9, 0, 9);
					Toggle["3f8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Toggle["3f8"]["Position"] = UDim2.new(0, 0, 0, 2);
					Toggle["3f8"]["Name"] = [[ToggleHolder]];

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.checkmarkHolder
					Toggle["38"] = Instance.new("Frame", Toggle["3f8"]);
					Toggle["38"]["BorderSizePixel"] = 0;
					Toggle["38"]["BackgroundColor3"] = Color3.fromRGB(0, 255, 0);
					Toggle["38"]["Size"] = UDim2.new(1, 0, 1, 0);
					Toggle["38"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Toggle["38"]["Position"] = UDim2.new(0, 0, 0, 0);
					Toggle["38"]["Name"] = [[Toggle]];
					Toggle["38"]["BackgroundTransparency"] = 1;
					
					table.insert(Library.ThemeObjects, Toggle["38"])

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.checkmarkHolder.UIStroke
					Toggle["39"] = Instance.new("UIStroke", Toggle["38"]);
					Toggle["39"]["Color"] = Color3.fromRGB(27, 27, 27);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle
					Toggle["3a"] = Instance.new("Frame", Toggle["f"]);
					Toggle["3a"]["BorderSizePixel"] = 0;
					Toggle["3a"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					Toggle["3a"]["BackgroundTransparency"] = 1;
					Toggle["3a"]["Size"] = UDim2.new(1, -10, 0, 12);
					Toggle["3a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Toggle["3a"]["Position"] = UDim2.new(0, 0, 0, 119);
					Toggle["3a"]["Name"] = [[Toggle]];

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Text
					Toggle["3b"] = Instance.new("TextLabel", Toggle["3a"]);
					Toggle["3b"]["TextWrapped"] = true;
					Toggle["3b"]["BorderSizePixel"] = 0;
					Toggle["3b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Toggle["3b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					Toggle["3b"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Toggle["3b"]["TextSize"] = 14;
					Toggle["3b"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					Toggle["3b"]["Size"] = UDim2.new(1, 0, 1, -4);
					Toggle["3b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Toggle["3b"]["Text"] = [[Toggle]];
					Toggle["3b"]["Name"] = [[Text]];
					Toggle["3b"]["BackgroundTransparency"] = 1;
					Toggle["3b"]["Position"] = UDim2.new(0, 0, 0, 2);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Text.UIPadding
					Toggle["3c"] = Instance.new("UIPadding", Toggle["3b"]);
					Toggle["3c"]["PaddingLeft"] = UDim.new(0, 17);
				end

				function Toggle:GetFlag()
					return options.Flag
				end

				function Toggle:GetState()
					return Toggle.State
				end

				function Toggle:GetCallback(b)
					options.Callback(b)
				end

				do -- Methods
					function Toggle:Keybind(options)
						options = Library:Validate({
							Default = Enum.KeyCode.W,
							Mode = "Toggle",
							HideFromList = false,
							Blacklisted = {},
							Flag = Library.NewFlag(),
							Callback = function() end,
						}, options or {})

						Toggle.Keybind = true

						local Keybind = {
							Hover = false,
							MouseDown = false,
							Keybind = options.Default ~= nil and options.Default or "None",
							RegKeybind = nil,
							State = false,
							Toggle = false,
							Mode = options.Mode,
							CurrentModeFrame = nil,
						}
						
						assert(typeof(options.Blacklisted) == "table", "Failed to use blacklisted, (table expected got " .. typeof(options.Blacklisted) .. ")")

						do -- Render
							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Keybind
							Keybind["36"] = Instance.new("Frame", Toggle["35"]);
							Keybind["36"]["BorderSizePixel"] = 0;
							Keybind["36"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
							Keybind["36"]["Size"] = UDim2.new(0, 30, 0, 13);
							Keybind["36"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Keybind["36"]["Position"] = UDim2.new(1, -30, 0, 0);
							Keybind["36"]["Name"] = [[Keybind]];

							-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
							Keybind["bfz"] = Instance.new("TextButton", Keybind["36"]);
							Keybind["bfz"]["BorderSizePixel"] = 0;
							Keybind["bfz"]["TextTransparency"] = 1;
							Keybind["bfz"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							Keybind["bfz"]["TextSize"] = 14;
							Keybind["bfz"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							Keybind["bfz"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
							Keybind["bfz"]["Size"] = UDim2.new(1, 0, 1, 0);
							Keybind["bfz"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Keybind["bfz"]["BackgroundTransparency"] = 1;

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Keybind.UIPadding
							Keybind["37"] = Instance.new("UIPadding", Keybind["36"]);


							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Keybind.TextLabel
							Keybind["38"] = Instance.new("TextLabel", Keybind["36"]);
							Keybind["38"]["BorderSizePixel"] = 0;
							Keybind["38"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							Keybind["38"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							Keybind["38"]["TextSize"] = 14;
							Keybind["38"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
							Keybind["38"]["Size"] = UDim2.new(1, 0, 1, 0);
							Keybind["38"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Keybind["38"]["Text"] = "None";
							Keybind["38"]["BackgroundTransparency"] = 1;

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Keybind.UIStroke
							Keybind["39"] = Instance.new("UIStroke", Keybind["36"]);
							Keybind["39"]["Color"] = Color3.fromRGB(27, 27, 27);
						end

						do -- Methods
							function Toggle:RemoveFrame()
								for i, v in pairs(Keybind["36"]:GetDescendants()) do
									if v.Name == "MainModeChanger" then
										v:Destroy()
									end
								end
							end

							function Toggle:AddFrame()
								do -- Render
									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame
									Keybind["57"] = Instance.new("Frame", Keybind["36"]);
									Keybind["57"]["BorderSizePixel"] = 0;
									Keybind["57"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
									Keybind["57"]["Size"] = UDim2.new(0, 45, 0, 45);
									Keybind["57"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["57"]["Position"] = UDim2.new(0, -45, 0, 0);
									Keybind["57"]["AutomaticSize"] = Enum.AutomaticSize.Y;
									Keybind["57"]["Name"] = [[MainModeChanger]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.Always
									Keybind["58"] = Instance.new("Frame", Keybind["57"]);
									Keybind["58"]["BorderSizePixel"] = 0;
									Keybind["58"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
									Keybind["58"]["Size"] = UDim2.new(1, 0, 0, 15);
									Keybind["58"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["58"]["Name"] = [[Always]];

									-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
									Keybind["bf1"] = Instance.new("TextButton", Keybind["58"]);
									Keybind["bf1"]["BorderSizePixel"] = 0;
									Keybind["bf1"]["TextTransparency"] = 1;
									Keybind["bf1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									Keybind["bf1"]["TextSize"] = 14;
									Keybind["bf1"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									Keybind["bf1"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["bf1"]["Size"] = UDim2.new(1, 0, 1, 0);
									Keybind["bf1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["bf1"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.Always.UIStroke
									Keybind["59"] = Instance.new("UIStroke", Keybind["58"]);
									Keybind["59"]["Color"] = Color3.fromRGB(27, 27, 27);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.Always.Text
									Keybind["5a"] = Instance.new("TextLabel", Keybind["58"]);
									Keybind["5a"]["BorderSizePixel"] = 0;
									Keybind["5a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									Keybind["5a"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									Keybind["5a"]["TextSize"] = 12;
									Keybind["5a"]["TextColor3"] = Keybind.Mode == "Always" and Library.Theme.Accent or Color3.fromRGB(215, 215, 215);
									Keybind["5a"]["Size"] = UDim2.new(1, 0, 1, 0);
									Keybind["5a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["5a"]["Text"] = [[Always]];
									Keybind["5a"]["Name"] = [[Text]];
									Keybind["5a"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.UIListLayout
									Keybind["5b"] = Instance.new("UIListLayout", Keybind["57"]);
									Keybind["5b"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.Toggle
									Keybind["5c"] = Instance.new("Frame", Keybind["57"]);
									Keybind["5c"]["BorderSizePixel"] = 0;
									Keybind["5c"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
									Keybind["5c"]["Size"] = UDim2.new(1, 0, 0, 15);
									Keybind["5c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["5c"]["Name"] = [[Toggle]];

									-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
									Keybind["bf2"] = Instance.new("TextButton", Keybind["5c"]);
									Keybind["bf2"]["BorderSizePixel"] = 0;
									Keybind["bf2"]["TextTransparency"] = 1;
									Keybind["bf2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									Keybind["bf2"]["TextSize"] = 14;
									Keybind["bf2"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									Keybind["bf2"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["bf2"]["Size"] = UDim2.new(1, 0, 1, 0);
									Keybind["bf2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["bf2"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.Toggle.UIStroke
									Keybind["5d"] = Instance.new("UIStroke", Keybind["5c"]);
									Keybind["5d"]["Color"] = Color3.fromRGB(27, 27, 27);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.Toggle.Text
									Keybind["5e"] = Instance.new("TextLabel", Keybind["5c"]);
									Keybind["5e"]["BorderSizePixel"] = 0;
									Keybind["5e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									Keybind["5e"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									Keybind["5e"]["TextSize"] = 12;
									Keybind["5e"]["TextColor3"] = Keybind.Mode == "Toggle" and Library.Theme.Accent or Color3.fromRGB(215, 215, 215);
									Keybind["5e"]["Size"] = UDim2.new(1, 0, 1, 0);
									Keybind["5e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["5e"]["Text"] = [[Toggle]];
									Keybind["5e"]["Name"] = [[Text]];
									Keybind["5e"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.OnHold
									Keybind["5f"] = Instance.new("Frame", Keybind["57"]);
									Keybind["5f"]["BorderSizePixel"] = 0;
									Keybind["5f"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
									Keybind["5f"]["Size"] = UDim2.new(1, 0, 0, 15);
									Keybind["5f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["5f"]["Name"] = [[OnHold]];

									-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
									Keybind["bf3"] = Instance.new("TextButton", Keybind["5f"]);
									Keybind["bf3"]["BorderSizePixel"] = 0;
									Keybind["bf3"]["TextTransparency"] = 1;
									Keybind["bf3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									Keybind["bf3"]["TextSize"] = 14;
									Keybind["bf3"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									Keybind["bf3"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["bf3"]["Size"] = UDim2.new(1, 0, 1, 0);
									Keybind["bf3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["bf3"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.OnHold.UIStroke
									Keybind["60"] = Instance.new("UIStroke", Keybind["5f"]);
									Keybind["60"]["Color"] = Color3.fromRGB(27, 27, 27);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.OnHold.Text
									Keybind["61"] = Instance.new("TextLabel", Keybind["5f"]);
									Keybind["61"]["BorderSizePixel"] = 0;
									Keybind["61"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									Keybind["61"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									Keybind["61"]["TextSize"] = 12;
									Keybind["61"]["TextColor3"] = Keybind.Mode == "On Hold" and Library.Theme.Accent or Color3.fromRGB(215, 215, 215);
									Keybind["61"]["Size"] = UDim2.new(1, 0, 1, 0);
									Keybind["61"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["61"]["Text"] = [[On Hold]];
									Keybind["61"]["Name"] = [[Text]];
									Keybind["61"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.OffHold
									Keybind["62"] = Instance.new("Frame", Keybind["57"]);
									Keybind["62"]["BorderSizePixel"] = 0;
									Keybind["62"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
									Keybind["62"]["Size"] = UDim2.new(1, 0, 0, 15);
									Keybind["62"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["62"]["Name"] = [[OffHold]];

									-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
									Keybind["bf4"] = Instance.new("TextButton", Keybind["62"]);
									Keybind["bf4"]["BorderSizePixel"] = 0;
									Keybind["bf4"]["TextTransparency"] = 1;
									Keybind["bf4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									Keybind["bf4"]["TextSize"] = 14;
									Keybind["bf4"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									Keybind["bf4"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["bf4"]["Size"] = UDim2.new(1, 0, 1, 0);
									Keybind["bf4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["bf4"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.OffHold.UIStroke
									Keybind["63"] = Instance.new("UIStroke", Keybind["62"]);
									Keybind["63"]["Color"] = Color3.fromRGB(27, 27, 27);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.OffHold.Text
									Keybind["64"] = Instance.new("TextLabel", Keybind["62"]);
									Keybind["64"]["BorderSizePixel"] = 0;
									Keybind["64"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									Keybind["64"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									Keybind["64"]["TextSize"] = 12;
									Keybind["64"]["TextColor3"] = Keybind.Mode == "Off Hold" and Library.Theme.Accent or Color3.fromRGB(215, 215, 215);
									Keybind["64"]["Size"] = UDim2.new(1, 0, 1, 0);
									Keybind["64"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									Keybind["64"]["Text"] = [[Off Hold]];
									Keybind["64"]["Name"] = [[Text]];
									Keybind["64"]["BackgroundTransparency"] = 1;
								end

								Keybind["57"].Position = UDim2.new(0, -Keybind["57"].AbsoluteSize.X, 0, Keybind["36"].AbsoluteSize.Y - 13)

								local function resetOtherTextColors(currentButton)
									local buttons = {"5a", "5e", "61", "64"}
									for _, key in ipairs(buttons) do
										if Keybind[key] ~= currentButton then
											Library:tween(Keybind[key], {TextColor3 = Color3.fromRGB(215, 215, 215)})
											
											for i, obj in ipairs(Library.ThemeObjects) do
												if obj == Keybind[key] then
													table.remove(Library.ThemeObjects, i)
													break
												end
											end
										end
									end
								end

								Keybind["bf1"].MouseButton1Click:Connect(function()
									if not isFadedOut and (not Dragging.Gui and not Dragging.True) then
										Keybind.Mode = "Always"
										resetOtherTextColors(Keybind["5a"])
										GUI:AddKeybind(Toggle:GetName(), Toggle:GetKeybind(), Keybind.Mode)
										Library:tween(Keybind["5a"], {TextColor3 = Library.Theme.Accent})
										table.insert(Library.ThemeObjects, Keybind["5a"])
									end
								end)

								Keybind["bf2"].MouseButton1Click:Connect(function()
									if not isFadedOut and (not Dragging.Gui and not Dragging.True) then
										Keybind.Mode = "Toggle"
										resetOtherTextColors(Keybind["5e"])
										if Keybind.State then
											GUI:AddKeybind(Toggle:GetName(), Toggle:GetKeybind(), Keybind.Mode)
										else
											GUI:RemoveKeybind(Toggle:GetName())
										end
										Library:tween(Keybind["5e"], {TextColor3 = Library.Theme.Accent})
										table.insert(Library.ThemeObjects, Keybind["5e"])
									end
								end)

								Keybind["bf3"].MouseButton1Click:Connect(function()
									if not isFadedOut and (not Dragging.Gui and not Dragging.True) then
										Keybind.Mode = "On Hold"
										resetOtherTextColors(Keybind["61"])
										GUI:RemoveKeybind(Toggle:GetName())
										Library:tween(Keybind["61"], {TextColor3 = Library.Theme.Accent})
										table.insert(Library.ThemeObjects, Keybind["61"])
									end
								end)

								Keybind["bf4"].MouseButton1Click:Connect(function()
									if not isFadedOut and (not Dragging.Gui and not Dragging.True) then
										Keybind.Mode = "Off Hold"
										resetOtherTextColors(Keybind["64"])
										GUI:AddKeybind(Toggle:GetName(), Toggle:GetKeybind(), Keybind.Mode)
										Library:tween(Keybind["64"], {TextColor3 = Library.Theme.Accent})
										table.insert(Library.ThemeObjects, Keybind["64"])
									end
								end)
							end
						end

						local function KeybindToggle()
							Toggle.Toggle = not Toggle.Toggle

							if Toggle.Toggle then
								Toggle:AddFrame()
								Toggle["35"].ZIndex = zindexcount2 + 500
							else
								Toggle:RemoveFrame()
								Toggle["35"].ZIndex = 2
							end
						end

						Keybind["bfz"].MouseButton2Click:Connect(function()
							if Keybind.Hover and not isFadedOut and (not Dragging.Gui and not Dragging.True) then
								KeybindToggle()
							end
						end)

						function Toggle:SetMode(Mode)
							Keybind.Mode = Mode
						end

						function Toggle:GetMode()
							return Keybind.Mode
						end

						function Toggle:GetKeybind()
							return Keybind.Keybind
						end

						function Keybind:Active()
							return Keybind.State
						end

						function Keybind:Set(State)
							Keybind.State = State
						end

						local function set(key)

							if typeof(key) == "EnumItem" then
								Keybind.RegKeybind = key
							elseif typeof(key) == "string" then
								Keybind.RegKeybind = Enum.KeyCode[key]
							end

							if typeof(key) == "string" then
								if key:find("KEY") then
									key = Enum.KeyCode[key:gsub("KEY_", "")]
								elseif key:find("INPUT") then
									key = Enum.UserInputType[key:gsub("INPUT_", "")]
								end
							end

							local isValidKey = false
							local key_str = ""
							
							if table.find(options.Blacklisted, key) then
								key = nil
							end

							if key then
								if keys[key] or uis:GetStringForKeyCode(key) ~= "" then
									isValidKey = true
									key_str = keys[key] or uis:GetStringForKeyCode(key)
								end
							end

							if isValidKey then
								Keybind.Keybind = key_str
								options.Callback(key)
								Library.Flags[options.Flag] = key
								Toggle["36"].Size = UDim2.new(1, -Keybind["36"].AbsoluteSize.X + 20, 1, -4)
								Keybind["38"].Text = key_str
								Keybind["36"].Size = UDim2.new(0, Keybind["38"].TextBounds.X + 25, 0, 13)
								Keybind["36"].Position = UDim2.new(1, -(Keybind["38"].TextBounds.X + 25), 0, 0)
							else
								Keybind.Keybind = "None"
								Toggle["36"].Size = UDim2.new(1, -Keybind["36"].AbsoluteSize.X - 30, 1, -4)
								Keybind["38"].Text = Keybind.Keybind
								Keybind["36"].Size = UDim2.new(0, Keybind["38"].TextBounds.X + 25, 0, 13)
								Keybind["36"].Position = UDim2.new(1, -(Keybind["38"].TextBounds.X + 25), 0, 0)
							end
						end

						set(options.Default)

						Keybind["36"].MouseEnter:Connect(function()
							if not Library:IsMouseOverFrame(Keybind["36"]) then return end
							Keybind.Hover = true
						end)

						Keybind["36"].MouseLeave:Connect(function()
							Keybind.Hover = false
						end)

						local binding

						Keybind["bfz"].MouseButton1Click:Connect(function()
							if Keybind.Hover and not isFadedOut and (not Dragging.Gui and not Dragging.True) then

								if binding then
									binding:Disconnect()
								end

								Keybind["38"].Text = "..."

								binding = uis.InputBegan:Connect(function(input)
									set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
									binding:Disconnect()
									task.wait()
									binding = nil
								end)
							end
						end)

						uis.InputBegan:Connect(function(input, gpe)
							if gpe then return end

							if (input.UserInputType == Enum.UserInputType.Keyboard and Keybind.Keybind ~= "None" and input.KeyCode == Keybind.RegKeybind) or
								(input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.Keybind == "MB1") or
								(input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.Keybind == "MB2") or
								(input.UserInputType == Enum.UserInputType.MouseButton3 and Keybind.Keybind == "MB3") then
								if Keybind.Mode == "Always" then
									Keybind:Toggle(true)
								else
									Keybind:Toggle()
								end
							end
						end)

						uis.InputEnded:Connect(function(input, gpe)
							if gpe then return end

							if Keybind.Mode == "On Hold" or Keybind.Mode == "Off Hold" then
								if (input.UserInputType == Enum.UserInputType.Keyboard and Keybind.Keybind ~= "None" and input.KeyCode == Keybind.RegKeybind) or
									(input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.Keybind == "MB1") or
									(input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.Keybind == "MB2") or
									(input.UserInputType == Enum.UserInputType.MouseButton3 and Keybind.Keybind == "MB3") then
									Keybind:Toggle()
								end
							end
						end)

						function Keybind:Toggle(b)
							if Toggle:GetState() then
								if b == nil then
									Keybind.State = not Keybind.State
								else
									Keybind.State = b
								end

								if Keybind.Mode ~= "On Hold" then
									if not options.HideFromList then
										if Keybind.State then
											GUI:AddKeybind(Toggle:GetName(), Toggle:GetKeybind(), Keybind.Mode)
										else
											GUI:RemoveKeybind(Toggle:GetName())
										end
									end

									Library.Flags[Toggle:GetFlag()] = Keybind.State
									Toggle:GetCallback(Keybind.State)
								else
									if not options.HideFromList then
										if not Keybind.State then
											GUI:AddKeybind(Toggle:GetName(), Toggle:GetKeybind(), Keybind.Mode)
										else
											GUI:RemoveKeybind(Toggle:GetName())
										end
									end

									Library.Flags[Toggle:GetFlag()] = not Keybind.State
									Toggle:GetCallback(not Keybind.State)
								end
							end
						end

						return Keybind
					end

					function Toggle:ColorPicker(options)
						options = Library:Validate({
							Name = "Preview Color Picker",
							Default = Color3.fromRGB(255, 0, 0),
							Alpha = 1,
							AlphaBar = true,
							Flag = Library.NewFlag(),
							Callback = function() end,
						}, options or {})

						if not options.Default then
							Library.Flags[options.Default] = {Color = options.Default, Alpha = options.Alpha}
							options.Callback(options.Default, options.Alpha)
						end

						local function rgbToHsv(r, g, b)
							r, g, b = r / 255, g / 255, b / 255
							local max, min = math.max(r, g, b), math.min(r, g, b)
							local h, s, v
							v = max
							local d = max - min
							if max == 0 then
								s = 0
							else
								s = d / max
							end
							if max == min then
								h = 0
							else
								if max == r then
									h = (g - b) / d + (g < b and 6 or 0)
								elseif max == g then
									h = (b - r) / d + 2
								elseif max == b then
									h = (r - g) / d + 4
								end
								h = h / 6
							end
							return h, s, v
						end

						local function HSVtoRGB(h, s, v)
							local r, g, b

							local i = math.floor(h * 6)
							local f = h * 6 - i
							local p = v * (1 - s)
							local q = v * (1 - f * s)
							local t = v * (1 - (1 - f) * s)

							i = i % 6

							if i == 0 then r, g, b = v, t, p
							elseif i == 1 then r, g, b = q, v, p
							elseif i == 2 then r, g, b = p, v, t
							elseif i == 3 then r, g, b = p, q, v
							elseif i == 4 then r, g, b = t, p, v
							elseif i == 5 then r, g, b = v, p, q
							end

							return Color3.new(r, g, b)
						end

						local color = options.Default
						local r, g, b = color.R * 255, color.G * 255, color.B * 255
						local h, s, v = rgbToHsv(r, g, b)

						local ColorPicker = {
							Hover = false,
							MouseDown = false,
							MainFrameHover = false,
							Color = options.Default,
							Saturation = {s, v},
							Alpha = options.Alpha,
							Hue = h,
						}

						function ColorPicker:GetFlag()
							return options.Flag
						end

						function ColorPicker:GetTitle()
							return options.Name
						end

						local Count = GetDictionaryLength(Toggle.ColorPickers)

						do -- Render
							ColorPicker["36"] = Instance.new("Frame", Toggle["35"]);
							ColorPicker["36"]["BorderSizePixel"] = 0;
							ColorPicker["36"]["BackgroundColor3"] = ColorPicker.Color;
							ColorPicker["36"]["AnchorPoint"] = Vector2.new(0, 0.5);
							ColorPicker["36"]["Size"] = UDim2.new(0, 30, 0, 13);
							ColorPicker["36"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							ColorPicker["36"]["Position"] = UDim2.new(1, -30 - (Count - 1) * 35, 0.5, 0);
							ColorPicker["36"]["Name"] = "Colorpicker";
							ColorPicker["36"]["BackgroundTransparency"] = 1 - ColorPicker.Alpha;
							ColorPicker["36"]["ZIndex"] = 100 - Count;

							table.insert(Toggle.ColorPickers, ColorPicker["36"])

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Image
							ColorPicker["55"] = Instance.new("ImageLabel", ColorPicker["36"]);
							ColorPicker["55"]["BorderSizePixel"] = 0;
							ColorPicker["55"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							ColorPicker["55"]["Image"] = [[rbxassetid://17712772030]];
							ColorPicker["55"]["Size"] = UDim2.new(1, 0, 1, 0);
							ColorPicker["55"]["ImageTransparency"] = ColorPicker.Alpha;
							ColorPicker["55"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							ColorPicker["55"]["Name"] = [[TRANSPARENCY]];
							ColorPicker["55"]["BackgroundTransparency"] = 1;

							-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
							ColorPicker["bfj"] = Instance.new("TextButton", ColorPicker["36"]);
							ColorPicker["bfj"]["BorderSizePixel"] = 0;
							ColorPicker["bfj"]["TextTransparency"] = 1;
							ColorPicker["bfj"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							ColorPicker["bfj"]["TextSize"] = 14;
							ColorPicker["bfj"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							ColorPicker["bfj"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
							ColorPicker["bfj"]["Size"] = UDim2.new(1, 0, 1, 0);
							ColorPicker["bfj"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							ColorPicker["bfj"]["BackgroundTransparency"] = 1;
							ColorPicker["bfj"]["Name"] = "BUTTON";

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.UIStroke
							ColorPicker["37"] = Instance.new("UIStroke", ColorPicker["36"]);
							ColorPicker["37"]["Color"] = Color3.fromRGB(28, 28, 28);
							ColorPicker["37"]["Name"] = "UISTROKE";
						end

						do -- Methods
							function ColorPicker:RemoveFrame()
								for i, v in pairs(ColorPicker["36"]:GetDescendants()) do
									if v.Name ~= "UISTROKE" and v.Name ~= "BUTTON" and v.Name ~= "TRANSPARENCY" then
										v:Destroy()
									end
								end
							end

							function ColorPicker:FindFrame()
								for i, v in pairs(ColorPicker["36"]:GetDescendants()) do
									if v.Name == "MainFrame" then
										return true
									end
								end
							end

							function ColorPicker:AddFrame()

								do -- Render
									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame
									ColorPicker["38"] = Instance.new("Frame", ColorPicker["36"]);
									ColorPicker["38"]["BorderSizePixel"] = 0;
									ColorPicker["38"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
									ColorPicker["38"]["Size"] = options.AlphaBar and UDim2.new(0, 150, 0, 140) or UDim2.new(0, 150, 0, 125);
									ColorPicker["38"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["38"]["Position"] = UDim2.new(1, -185, 0, 0);
									ColorPicker["38"]["Name"] = "MainFrame";

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.UIStroke
									ColorPicker["39"] = Instance.new("UIStroke", ColorPicker["38"]);
									ColorPicker["39"]["Color"] = Color3.fromRGB(28, 28, 28);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.Title
									ColorPicker["3a"] = Instance.new("TextLabel", ColorPicker["38"]);
									ColorPicker["3a"]["BorderSizePixel"] = 0;
									ColorPicker["3a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["3a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
									ColorPicker["3a"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									ColorPicker["3a"]["TextSize"] = 14;
									ColorPicker["3a"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
									ColorPicker["3a"]["Size"] = UDim2.new(1, 0, 0, 20);
									ColorPicker["3a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["3a"]["Text"] = ColorPicker:GetTitle();
									ColorPicker["3a"]["Name"] = [[Title]];
									ColorPicker["3a"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.Title.UIPadding
									ColorPicker["3b"] = Instance.new("UIPadding", ColorPicker["3a"]);
									ColorPicker["3b"]["PaddingLeft"] = UDim.new(0, 5);
									
									-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
									ColorPicker["3c"] = Instance.new("TextButton", ColorPicker["38"]);
									ColorPicker["3c"]["BorderSizePixel"] = 0;
									ColorPicker["3c"]["TextTransparency"] = 1;
									ColorPicker["3c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["3c"]["TextSize"] = 14;
									ColorPicker["3c"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									ColorPicker["3c"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["3c"]["Size"] = UDim2.new(0, 125, 0, 100);
									ColorPicker["3c"]["Position"] = UDim2.new(0, 5, 0, 20);
									ColorPicker["3c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["3c"]["BackgroundTransparency"] = 1;
									ColorPicker["3c"]["Name"] = [[ColorFrame]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.UIStroke
									ColorPicker["3d"] = Instance.new("UIStroke", ColorPicker["3c"]);
									ColorPicker["3d"]["Color"] = Color3.fromRGB(21, 21, 21);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Square
									ColorPicker["3e"] = Instance.new("Frame", ColorPicker["3c"]);
									ColorPicker["3e"]["ZIndex"] = 7;
									ColorPicker["3e"]["BorderSizePixel"] = 0;
									ColorPicker["3e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["3e"]["Size"] = UDim2.new(0, 3, 0, 3);
									ColorPicker["3e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["3e"]["Position"] = UDim2.new(1, -3, 0, 0);
									ColorPicker["3e"]["Name"] = [[Square]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Square.UIStroke
									ColorPicker["3f"] = Instance.new("UIStroke", ColorPicker["3e"]);
									ColorPicker["3f"]["Color"] = Color3.fromRGB(21, 21, 21);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Image
									ColorPicker["40"] = Instance.new("ImageLabel", ColorPicker["3c"]);
									ColorPicker["40"]["BorderSizePixel"] = 0;
									ColorPicker["40"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["40"]["Image"] = [[rbxassetid://8180999986]];
									ColorPicker["40"]["Size"] = UDim2.new(1, 0, 1, 0);
									ColorPicker["40"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["40"]["Name"] = [[Image]];
									ColorPicker["40"]["Rotation"] = 180;
									ColorPicker["40"]["BackgroundTransparency"] = 1;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Image.UIGradient
									ColorPicker["41"] = Instance.new("UIGradient", ColorPicker["40"]);
									ColorPicker["41"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(255, 0, 5)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 255, 255))};
									
									-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
									ColorPicker["42"] = Instance.new("TextButton", ColorPicker["38"]);
									ColorPicker["42"]["BorderSizePixel"] = 0;
									ColorPicker["42"]["TextTransparency"] = 1;
									ColorPicker["42"]["BackgroundColor3"] = Color3.fromRGB(17, 17, 17);
									ColorPicker["42"]["TextSize"] = 14;
									ColorPicker["42"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									ColorPicker["42"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["42"]["Size"] = UDim2.new(0, 125, 0, 10);
									ColorPicker["42"]["Position"] = UDim2.new(0, 5, 1, -14);
									ColorPicker["42"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["42"]["BackgroundTransparency"] = 1;
									ColorPicker["42"]["Name"] = [[HexBox]];
									ColorPicker["42"]["Visible"] = options.AlphaBar and true or false;

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.ColorFrame.Image
									ColorPicker["44"] = Instance.new("ImageLabel", ColorPicker["42"]);
									ColorPicker["44"]["BorderSizePixel"] = 0;
									ColorPicker["44"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["44"]["Image"] = [[http://www.roblox.com/asset/?id=17716156120]];
									ColorPicker["44"]["Size"] = UDim2.new(1, 0, 1, 0);
									ColorPicker["44"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["44"]["Name"] = [[Image]];
									ColorPicker["44"]["BackgroundTransparency"] = 1;
									
									-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
									ColorPicker["45"] = Instance.new("TextButton", ColorPicker["38"]);
									ColorPicker["45"]["BorderSizePixel"] = 0;
									ColorPicker["45"]["TextTransparency"] = 1;
									ColorPicker["45"]["BackgroundColor3"] = Color3.fromRGB(17, 17, 17);
									ColorPicker["45"]["TextSize"] = 14;
									ColorPicker["45"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									ColorPicker["45"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["45"]["Size"] = UDim2.new(0, 10, 0, 100);
									ColorPicker["45"]["Position"] = UDim2.new(1, -15, 0, 20);
									ColorPicker["45"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["45"]["BackgroundTransparency"] = 1;
									ColorPicker["45"]["Name"] = [[HueFrame]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.HueFrame.Bar
									ColorPicker["47"] = Instance.new("Frame", ColorPicker["45"]);
									ColorPicker["47"]["ZIndex"] = 2;
									ColorPicker["47"]["BorderSizePixel"] = 0;
									ColorPicker["47"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["47"]["Size"] = UDim2.new(1, 2, 0, 2);
									ColorPicker["47"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["47"]["Position"] = UDim2.new(0, 1, 0, 0);
									ColorPicker["47"]["Name"] = [[Bar]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.HueFrame.Bar.UIStroke
									ColorPicker["48"] = Instance.new("UIStroke", ColorPicker["47"]);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.HueFrame.Bar
									ColorPicker["d7"] = Instance.new("Frame", ColorPicker["44"]);
									ColorPicker["d7"]["ZIndex"] = 2;
									ColorPicker["d7"]["BorderSizePixel"] = 0;
									ColorPicker["d7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["d7"]["Size"] = UDim2.new(0, 2, 1, 2);
									ColorPicker["d7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["d7"]["Position"] = UDim2.new(1, 0, 0, -2);
									ColorPicker["d7"]["Name"] = [[Bar]];

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.HueFrame.Bar.UIStroke
									ColorPicker["d8"] = Instance.new("UIStroke", ColorPicker["d7"]);

									-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Toggle.Colorpicker.MainFrame.HueFrame.Image
									ColorPicker["49"] = Instance.new("ImageLabel", ColorPicker["45"]);
									ColorPicker["49"]["BorderSizePixel"] = 0;
									ColorPicker["49"]["ScaleType"] = Enum.ScaleType.Crop;
									ColorPicker["49"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
									ColorPicker["49"]["Image"] = [[rbxassetid://8180989234]];
									ColorPicker["49"]["Size"] = UDim2.new(1, 0, 1, 0);
									ColorPicker["49"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
									ColorPicker["49"]["Name"] = [[Image]];
									ColorPicker["49"]["BackgroundTransparency"] = 1;
								end

								do
									local function UpdateSaturation(PercentageX: number, PercentageY: number)
										local PercentageX = typeof(PercentageX == "number") and math.clamp(PercentageX, 0, 1) or 0
										local PercentageY = typeof(PercentageY == "number") and math.clamp(PercentageY, 0, 1) or 0
										ColorPicker.Saturation[1] = PercentageX
										ColorPicker.Saturation[2] = 1 - PercentageY
										ColorPicker:Update()
									end
								end

								do -- Methods
									local function UpdateColor()
										ColorPicker.Color = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Saturation[1], ColorPicker.Saturation[2])

										ColorPicker["36"].BackgroundColor3 = ColorPicker.Color
										ColorPicker["36"].BackgroundTransparency = 1 - ColorPicker.Alpha
										ColorPicker["44"].BackgroundColor3 = ColorPicker.Color
										ColorPicker["55"].ImageTransparency = ColorPicker.Alpha
										ColorPicker["41"].Color =  ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromHSV(ColorPicker.Hue, 1, 1)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 255, 255))};

										ColorPicker["3e"].Position = UDim2.fromScale(math.clamp(ColorPicker.Saturation[1], 0, 0.95), math.clamp(1 - ColorPicker.Saturation[2], 0, 0.95))
										ColorPicker["d7"].Position = UDim2.fromScale(math.clamp(ColorPicker.Alpha, 0, 0.98), 0)
										ColorPicker["47"].Position = UDim2.fromScale(0, math.clamp(ColorPicker.Hue, 0, 0.98))

										options.Callback(ColorPicker.Color, ColorPicker.Alpha)
										Library.Flags[ColorPicker:GetFlag()] = {Color = ColorPicker.Color, Alpha = ColorPicker.Alpha}
									end

									function ColorPicker:Update()
										UpdateColor()
									end

									function ColorPicker:GetValue(): Color3
										return ColorPicker.Color
									end

									function ColorPicker:UpdateHue(Percentage: number)
										local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
										ColorPicker.Hue = Percentage
										ColorPicker:Update()
									end

									function ColorPicker:UpdateAlpha(Percentage: number)
										local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
										ColorPicker.Alpha = Percentage
										ColorPicker:Update()
									end

									function ColorPicker:UpdateSaturation(PercentageX: number, PercentageY: number)
										local PercentageX = typeof(PercentageX == "number") and math.clamp(PercentageX, 0, 1) or 0
										local PercentageY = typeof(PercentageY == "number") and math.clamp(PercentageY, 0, 1) or 0
										ColorPicker.Saturation[1] = PercentageX
										ColorPicker.Saturation[2] = 1 - PercentageY
										ColorPicker:Update()
									end
								end

								do -- Logic
									ColorPicker["38"].MouseEnter:Connect(function()
										if not Library:IsMouseOverFrame(ColorPicker["38"]) then return end
										ColorPicker.MainFrameHover = true
									end)

									ColorPicker["38"].MouseLeave:Connect(function()
										ColorPicker.MainFrameHover = false
									end)
									
									ColorPicker["3c"].InputBegan:Connect(function(Input: InputObject, Process: boolean)
										if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) and not isFadedOut then
											Dragging = {Gui = ColorPicker["3c"], True = true}
											local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
											local Percentage = (InputPosition - ColorPicker["3c"].AbsolutePosition) / ColorPicker["3c"].AbsoluteSize
											ColorPicker:UpdateSaturation(Percentage.X, Percentage.Y)
										end
									end)

									ColorPicker["42"].InputBegan:Connect(function(Input: InputObject, Process: boolean)
										if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) then
											Dragging = {Gui = ColorPicker["42"], True = true}
											local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
											local GuiPosition = ColorPicker["42"].AbsolutePosition.X
											local GuiSize = ColorPicker["42"].AbsoluteSize.X
											local Percentage = ((InputPosition.X - GuiPosition) / GuiSize)
											ColorPicker:UpdateAlpha(Percentage)
										end
									end)

									ColorPicker["45"].InputBegan:Connect(function(Input: InputObject, Process: boolean)
										if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) and not isFadedOut then
											Dragging = {Gui = ColorPicker["45"], True = true}
											local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
											local Percentage = (InputPosition - ColorPicker["45"].AbsolutePosition) / ColorPicker["45"].AbsoluteSize
											ColorPicker:UpdateHue(Percentage.Y)
										end
									end)

									uis.InputChanged:Connect(function(Input: InputObject, Process: boolean)
										if (Dragging.Gui ~= ColorPicker["3c"] and Dragging.Gui ~= ColorPicker["45"] and Dragging.Gui ~= ColorPicker["42"]) then return end
										if not (uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) or isFadedOut then
											Dragging = {Gui = nil, True = false}
											return
										end

										local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
										if (Input.UserInputType == Enum.UserInputType.MouseMovement) then
											if Dragging.Gui == ColorPicker["3c"] then
												local Percentage = (InputPosition - ColorPicker["3c"].AbsolutePosition) / ColorPicker["3c"].AbsoluteSize
												ColorPicker:UpdateSaturation(Percentage.X, Percentage.Y)
											end
											if Dragging.Gui == ColorPicker["42"] then
												local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
												local GuiPosition = ColorPicker["42"].AbsolutePosition.X
												local GuiSize = ColorPicker["42"].AbsoluteSize.X
												local Percentage = ((InputPosition.X - GuiPosition) / GuiSize)
												ColorPicker:UpdateAlpha(Percentage)
											end
											if Dragging.Gui == ColorPicker["45"] then
												local Percentage = (InputPosition - ColorPicker["45"].AbsolutePosition) / ColorPicker["45"].AbsoluteSize
												ColorPicker:UpdateHue(Percentage.Y)
											end
										end
									end)
								end

								ColorPicker:Update()
							end
						end

						do -- Logic
							ColorPicker["36"].MouseEnter:Connect(function()
								if not Library:IsMouseOverFrame(ColorPicker["36"]) then return end
								ColorPicker.Hover = true

								Library:tween(ColorPicker["37"], {Color = Color3.fromRGB(55, 55, 55)})
							end)

							ColorPicker["36"].MouseLeave:Connect(function()
								ColorPicker.Hover = false

								Library:tween(ColorPicker["37"], {Color = Color3.fromRGB(28, 28, 28)})
							end)

							local function ColorToggle()
								ColorPicker.Toggle = not ColorPicker.Toggle

								if ColorPicker.Toggle then
									ColorPicker:AddFrame()
									Toggle["35"].ZIndex = zindexcount2 + 500
								else
									ColorPicker:RemoveFrame()
									Toggle["35"].ZIndex = 2
								end
							end

							ColorPicker["bfj"].MouseButton1Click:Connect(function()
								if not isFadedOut then
									ColorToggle()
								end
							end)
						end


						options.Callback(ColorPicker.Color, ColorPicker.Alpha)
						Library.Flags[options.Flag] = {Color = options.Default, Alpha = options.Alpha}

						return ColorPicker
					end

					function Toggle:ToggleGui(b)
						if b == nil then
							Toggle.State = not Toggle.State
						else
							Toggle.State = b
						end

						if Toggle.State then
							Library:tween(Toggle["38"], {BackgroundTransparency = 0})
						else
							Library:tween(Toggle["38"], {BackgroundTransparency = 1})
							GUI:RemoveKeybind(options.Name)
						end

						Library.Flags[options.Flag] = Toggle.State
						options.Callback(Toggle.State)
					end
				end

				if options.Default == true then
					Toggle:ToggleGui(true)
				end

				do -- Logic
					Toggle["36"].MouseEnter:Connect(function()
						if not Library:IsMouseOverFrame(Toggle["36"]) then return end
						Toggle.Hover = true

						Library:tween(Toggle["39"], {Color = Color3.fromRGB(55, 55, 55)})

						if options.ToolTip then
							GUI["ggxxgg"].Visible = true
							Library:UpdateToolTip(options.ToolTipText)

							uis.InputChanged:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseMovement then
									Library:UpdateToolTipPosition()
								end
							end)

							Library:UpdateToolTipPosition()
						end
					end)

					Toggle["36"].MouseLeave:Connect(function()
						Toggle.Hover = false

						GUI["ggxxgg"].Visible = false

						if not Toggle.MouseDown then
							Library:tween(Toggle["39"], {Color = Color3.fromRGB(27, 27, 27)})
						end
					end)

					Toggle["bf"].MouseButton1Down:Connect(function()
						if Toggle.Hover and not isFadedOut and (not Dragging.Gui and not Dragging.True) then
							Toggle.MouseDown = true
							Library:tween(Toggle["39"], {Color = Color3.fromRGB(80, 80, 80)})
							Toggle:ToggleGui()
						end
					end)

					Toggle["bf"].MouseButton1Up:Connect(function()
						Toggle.MouseDown = false

						if Toggle.Hover then
							Library:tween(Toggle["39"], {Color = Color3.fromRGB(55, 55, 55)})
						else
							Library:tween(Toggle["39"], {Color = Color3.fromRGB(27, 27, 27)})
						end
					end)
				end

				return Toggle
			end

			function Section:Slider(options)
				options = Library:Validate({
					Name = "Preview Slider",
					Min = 0,
					Max = 100,
					Default = 1,
					Decimal = 1,
					ToolTip = false,
					ToolTipText = "Slider Tool Tip",
					Flag = Library.NewFlag(),
					Callback = function() end
				}, options or {})

				local Slider = {
					Hover = false,
					MouseDown = false,
					Connection = nil,
					CurrentValue = -9999,
					Section = self,
				}

				do -- Render
					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Slider
					Slider["17"] = Instance.new("Frame", Slider.Section["f"]);
					Slider["17"]["BorderSizePixel"] = 0;
					Slider["17"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					Slider["17"]["BackgroundTransparency"] = 1;
					Slider["17"]["Size"] = UDim2.new(1, -10, 0, 25);
					Slider["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Slider["17"]["Position"] = UDim2.new(0, 0, 0, 25);
					Slider["17"]["Name"] = [[Slider]];

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Slider.Text
					Slider["18"] = Instance.new("TextLabel", Slider["17"]);
					Slider["18"]["TextWrapped"] = true;
					Slider["18"]["BorderSizePixel"] = 0;
					Slider["18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Slider["18"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					Slider["18"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Slider["18"]["TextSize"] = 14;
					Slider["18"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					Slider["18"]["Size"] = UDim2.new(0.5, 0, 1, -10);
					Slider["18"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Slider["18"]["Text"] = options.Name;
					Slider["18"]["Name"] = [[Text]];
					Slider["18"]["BackgroundTransparency"] = 1;
					Slider["18"]["Position"] = UDim2.new(0, 0, 0, -1);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Slider.Value
					Slider["19"] = Instance.new("TextLabel", Slider["17"]);
					Slider["19"]["TextWrapped"] = true;
					Slider["19"]["BorderSizePixel"] = 0;
					Slider["19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Slider["19"]["TextXAlignment"] = Enum.TextXAlignment.Right;
					Slider["19"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Slider["19"]["TextSize"] = 14;
					Slider["19"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					Slider["19"]["Size"] = UDim2.new(0.5, 0, 1, -5);
					Slider["19"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Slider["19"]["Text"] = [[100]];
					Slider["19"]["Name"] = [[Value]];
					Slider["19"]["BackgroundTransparency"] = 1;
					Slider["19"]["Position"] = UDim2.new(0.5, 0, 0, -6);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Slider.Value.UIPadding
					Slider["1a"] = Instance.new("UIPadding", Slider["19"]);
					Slider["1a"]["PaddingTop"] = UDim.new(0, 8);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Slider.SliderBack
					Slider["1b"] = Instance.new("Frame", Slider["17"]);
					Slider["1b"]["BorderSizePixel"] = 0;
					Slider["1b"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					Slider["1b"]["AnchorPoint"] = Vector2.new(0, 1);
					Slider["1b"]["Size"] = UDim2.new(1, 0, 0, 8);
					Slider["1b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Slider["1b"]["Position"] = UDim2.new(0, 0, 1, 0);
					Slider["1b"]["Name"] = [[SliderBack]];

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Slider.SliderBack.UIStroke
					Slider["1c"] = Instance.new("UIStroke", Slider["1b"]);
					Slider["1c"]["Color"] = Color3.fromRGB(27, 27, 27);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Left.Section.ContentContainer.Slider.SliderBack.Draggable
					Slider["1d"] = Instance.new("Frame", Slider["1b"]);
					Slider["1d"]["BorderSizePixel"] = 0;
					Slider["1d"]["BackgroundColor3"] = Library.Theme.Accent;
					Slider["1d"]["Size"] = UDim2.new(0.5, 0, 1, 0);
					Slider["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Slider["1d"]["Name"] = [[Draggable]];

					table.insert(Library.ThemeObjects, Slider["1d"])

					-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
					Slider["bf"] = Instance.new("TextButton", Slider["1b"]);
					Slider["bf"]["BorderSizePixel"] = 0;
					Slider["bf"]["TextTransparency"] = 1;
					Slider["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Slider["bf"]["TextSize"] = 14;
					Slider["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Slider["bf"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
					Slider["bf"]["Size"] = UDim2.new(1, 0, 1, 0);
					Slider["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Slider["bf"]["BackgroundTransparency"] = 1;
				end

				local function get(value)
					return ("%.14g"):format(value)
				end

				local function set(value)
					value = math.clamp(options.Decimal * math.round(tonumber(value) / options.Decimal), options.Min, options.Max)
					Slider["19"].Text = tostring(get(value))

					if value ~= Slider.CurrentValue then
						Slider.CurrentValue = value
						local tween = tweenService:Create(Slider["1d"], newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new((value - options.Min) / (options.Max - options.Min), 0, 1, 0)})
						tween:Play()
					end

					Library.Flags[options.Flag] = get(value)
					options.Callback(get(value))
				end

				set(options.Default)

				local function slide(input)
					local sizeX = (input.Position.X - Slider["1b"].AbsolutePosition.X) / Slider["1b"].AbsoluteSize.X
					local value = math.clamp((options.Max - options.Min) * sizeX + options.Min, options.Min, options.Max)

					set(value)
				end

				do -- Logic
					Slider["1b"].MouseEnter:Connect(function()
						if not Library:IsMouseOverFrame(Slider["1b"]) then return end
						Slider.Hover = true
						
						if options.ToolTip then
							GUI["ggxxgg"].Visible = true
							Library:UpdateToolTip(options.ToolTipText)

							uis.InputChanged:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseMovement then
									Library:UpdateToolTipPosition()
								end
							end)

							Library:UpdateToolTipPosition()
						end
					end)

					Slider["1b"].MouseLeave:Connect(function()
						Slider.Hover = false
						
						GUI["ggxxgg"].Visible = false
					end)

					Slider["bf"].MouseButton1Down:Connect(function()
						if Slider.Hover and not isFadedOut and (not Dragging.Gui and not Dragging.True) then
							Dragging = {Gui = Slider["1b"], True = true}
							Slider.MouseDown = true
							slide{Position = uis:GetMouseLocation()}
						end
					end)

					uis.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							Slider.MouseDown = false
						end
					end)

					uis.InputChanged:Connect(function(input)
						if Dragging.Gui ~= Slider["1b"] then return end
						
						if not (uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) or isFadedOut then
							Dragging = {Gui = nil, True = false}
							return
						end
						
						if Slider.MouseDown and input.UserInputType == Enum.UserInputType.MouseMovement then
							slide(input)
						end
					end)
				end

				return Slider
			end

			function Section:TextBox(options)
				options = Library:Validate({
					Default = "",
					PlaceHolder = "Preview TextBox",
					Max = 32,
					NumbersOnly = false,
					ClearOnFocus = false,
					CheckIfPressedEnter = false,
					ToolTip = false,
					ToolTipText = "Toggle Tool Tip",
					Flag = Library.NewFlag(),
					Callback = function() end
				}, options or {})

				local TextBox = {
					Hover = false,
					Section = self,
				}

				if not options.Default then
					Library.Flags[options.Default] = options.Default
					options.Callback(options.Default)
				end

				do -- Render
					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.TextBox
					TextBox["7c"] = Instance.new("Frame", TextBox.Section["f"]);
					TextBox["7c"]["BorderSizePixel"] = 0;
					TextBox["7c"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					TextBox["7c"]["Size"] = UDim2.new(1, -10, 0, 18);
					TextBox["7c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					TextBox["7c"]["Position"] = UDim2.new(0, 5, 0, 0);
					TextBox["7c"]["Name"] = [[TextBox]];

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.TextBox.UIStroke
					TextBox["7d"] = Instance.new("UIStroke", TextBox["7c"]);
					TextBox["7d"]["Color"] = Color3.fromRGB(27, 27, 27);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.TextBox.TextBox
					TextBox["7e"] = Instance.new("TextBox", TextBox["7c"]);
					TextBox["7e"]["PlaceholderColor3"] = Color3.fromRGB(141, 141, 141);
					TextBox["7e"]["BorderSizePixel"] = 0;
					TextBox["7e"]["TextSize"] = 14;
					TextBox["7e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					TextBox["7e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
					TextBox["7e"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					TextBox["7e"]["BackgroundTransparency"] = 1;
					TextBox["7e"]["PlaceholderText"] = options.PlaceHolder;
					TextBox["7e"]["Size"] = UDim2.new(1, 0, 1, 0);
					TextBox["7e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					TextBox["7e"]["Text"] = options.Default;
					TextBox["7e"]["ClearTextOnFocus"] = options.ClearOnFocus;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.TextBox.TextBox.UIPadding
					TextBox["7f"] = Instance.new("UIPadding", TextBox["7e"]);
					TextBox["7f"]["PaddingBottom"] = UDim.new(0, 2);

					-- StarterGui.MyLibrary.Indicators
					TextBox["80"] = Instance.new("Frame", TextBox["1"]);
					TextBox["80"]["BorderSizePixel"] = 0;
					TextBox["80"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
					TextBox["80"]["Size"] = UDim2.new(0, 240, 0, 30);
					TextBox["80"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					TextBox["80"]["Position"] = UDim2.new(0, 10, 0.3720000088214874, 0);
					TextBox["80"]["Visible"] = false;
					TextBox["80"]["Name"] = [[Indicators]];
				end

				if options.Default then
					Library.Flags[options.Flag] = TextBox["7e"].Text
					options.Callback(TextBox["7e"].Text)
				end

				do -- Logic
					TextBox["7c"].MouseEnter:Connect(function()
						if not Library:IsMouseOverFrame(TextBox["7c"]) then return end
						TextBox.Hover = true

						Library:tween(TextBox["7d"], {Color = Color3.fromRGB(50, 50, 50)})
						Library:tween(TextBox["7c"], {BackgroundColor3 = Color3.fromRGB(17, 17, 17)})
						
						if options.ToolTip then
							GUI["ggxxgg"].Visible = true
							Library:UpdateToolTip(options.ToolTipText)

							uis.InputChanged:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseMovement then
									Library:UpdateToolTipPosition()
								end
							end)

							Library:UpdateToolTipPosition()
						end
					end)

					TextBox["7c"].MouseLeave:Connect(function()
						TextBox.Hover = false

						Library:tween(TextBox["7d"], {Color = Color3.fromRGB(27, 27, 27)})
						Library:tween(TextBox["7c"], {BackgroundColor3 = Color3.fromRGB(13, 13, 13)})
						
						GUI["ggxxgg"].Visible = false
					end)

					TextBox["7e"]:GetPropertyChangedSignal("Text"):Connect(function()
						TextBox["7e"].Text = TextBox["7e"].Text:sub(1, options.Max)
						--
						if options.NumbersOnly then
							TextBox["7e"].Text = TextBox["7e"].Text:gsub('[^%d%.%-]+', '')
						end
					end)

					TextBox["7e"].FocusLost:Connect(function(enterpressed)
						if options.CheckIfPressedEnter and not enterpressed then return end
						
						Library.Flags[options.Flag] = TextBox["7e"].Text
						options.Callback(TextBox["7e"].Text)
						TextBox["7e"].TextColor3 = Color3.fromRGB(255, 255, 255)
						table.remove(Library.ThemeObjects, table.find(Library.ThemeObjects, TextBox["7e"]))
					end)
					
					TextBox["7e"].Focused:Connect(function()
						TextBox["7e"].TextColor3 = Library.Theme.Accent
						table.insert(Library.ThemeObjects, TextBox["7e"])
					end)
				end

				return TextBox
			end

			function Section:Dropdown(options)
				options = Library:Validate({
					Default = "None",
					Name = "Preview Dropdown",
					Content = {},
					ToolTip = false,
					ToolTipText = "Toggle Tool Tip",
					Flag = Library.NewFlag(),
					Callback = function() end
				}, options or {})

				local Dropdown = {
					Items = {
						["id"] = {}
					},
					Open = false,
					MouseDown = false,
					Hover = false,
					CurrentItem = nil,
					Section = self,
				}

				if not options.Default then
					Library.Flags[options.Default] = options.Default
					options.Callback(options.Default)
				end

				if options.Default ~= "None" and table.find(options.Content, options.Default) then
					Library.Flags[options.Flag] = options.Default
					options.Callback(options.Default)
				end

				do -- Render
					zindexcount2 -= 1

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen
					Dropdown["be"] = Instance.new("Frame", Dropdown.Section["f"]);
					Dropdown["be"]["BorderSizePixel"] = 0;
					Dropdown["be"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					Dropdown["be"]["BackgroundTransparency"] = 1;
					Dropdown["be"]["Size"] = UDim2.new(1, -10, 0, 35);
					Dropdown["be"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Dropdown["be"]["Position"] = UDim2.new(0, 0, 0, 57);
					Dropdown["be"]["Name"] = [[DropdownOpen]];
					Dropdown["be"]["ZIndex"] = zindexcount2 + 100;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Text
					Dropdown["bf"] = Instance.new("TextLabel", Dropdown["be"]);
					Dropdown["bf"]["TextWrapped"] = true;
					Dropdown["bf"]["BorderSizePixel"] = 0;
					Dropdown["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Dropdown["bf"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					Dropdown["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Dropdown["bf"]["TextSize"] = 14;
					Dropdown["bf"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					Dropdown["bf"]["Size"] = UDim2.new(1, 0, 1, -20);
					Dropdown["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Dropdown["bf"]["Text"] = options.Name;
					Dropdown["bf"]["Name"] = [[Text]];
					Dropdown["bf"]["BackgroundTransparency"] = 1;
					Dropdown["bf"]["Position"] = UDim2.new(0, 0, 0, 2);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options
					Dropdown["c0"] = Instance.new("Frame", Dropdown["be"]);
					Dropdown["c0"]["BorderSizePixel"] = 0;
					Dropdown["c0"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					Dropdown["c0"]["Size"] = UDim2.new(1, 0, 1, -20);
					Dropdown["c0"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Dropdown["c0"]["Position"] = UDim2.new(0, 0, 0, 22);
					Dropdown["c0"]["Name"] = [[Options]];

					-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
					Dropdown["bf"] = Instance.new("TextButton", Dropdown["c0"]);
					Dropdown["bf"]["BorderSizePixel"] = 0;
					Dropdown["bf"]["TextTransparency"] = 1;
					Dropdown["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Dropdown["bf"]["TextSize"] = 14;
					Dropdown["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Dropdown["bf"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
					Dropdown["bf"]["Size"] = UDim2.new(1, 0, 1, 0);
					Dropdown["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Dropdown["bf"]["BackgroundTransparency"] = 1;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.UIStroke
					Dropdown["c1"] = Instance.new("UIStroke", Dropdown["c0"]);
					Dropdown["c1"]["Color"] = Color3.fromRGB(27, 27, 27);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Option
					Dropdown["c2"] = Instance.new("TextLabel", Dropdown["c0"]);
					Dropdown["c2"]["BorderSizePixel"] = 0;
					Dropdown["c2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Dropdown["c2"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					Dropdown["c2"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Dropdown["c2"]["TextSize"] = 13;
					Dropdown["c2"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					Dropdown["c2"]["Size"] = UDim2.new(1, 0, 1, 0);
					Dropdown["c2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Dropdown["c2"]["Text"] = options.Default ~= "None" and table.find(options.Content, options.Default) and options.Default or "None";
					Dropdown["c2"]["Name"] = [[Option]];
					Dropdown["c2"]["BackgroundTransparency"] = 1;
					Dropdown["c2"]["ZIndex"] = 7;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Option.UIPadding
					Dropdown["c3"] = Instance.new("UIPadding", Dropdown["c2"]);
					Dropdown["c3"]["PaddingLeft"] = UDim.new(0, 5);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Image
					Dropdown["c4"] = Instance.new("ImageLabel", Dropdown["c0"]);
					Dropdown["c4"]["BorderSizePixel"] = 0;
					Dropdown["c4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Dropdown["c4"]["ImageColor3"] = Library.Theme.Accent;
					Dropdown["c4"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
					Dropdown["c4"]["Image"] = [[rbxassetid://16863837958]];
					Dropdown["c4"]["Size"] = UDim2.new(0, 8, 0, 8);
					Dropdown["c4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Dropdown["c4"]["Name"] = [[Image]];
					Dropdown["c4"]["BackgroundTransparency"] = 1;
					Dropdown["c4"]["Position"] = UDim2.new(1, -8, 0.5, 0);

					table.insert(Library.ThemeObjects, Dropdown["c4"])

					-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder
					Dropdown["c5"] = Instance.new("ScrollingFrame", Dropdown["c0"]);
					Dropdown["c5"]["Active"] = true;
					Dropdown["c5"]["BorderSizePixel"] = 0;
					Dropdown["c5"]["ScrollBarImageTransparency"] = 0;
					Dropdown["c5"]["ScrollBarThickness"] = 2;
					Dropdown["c5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Dropdown["c5"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
					Dropdown["c5"]["BackgroundTransparency"] = 1;
					Dropdown["c5"]["Size"] = UDim2.new(1, 0, 0, 75);
					Dropdown["c5"]["ScrollBarImageColor3"] = Library.Theme.Accent;
					Dropdown["c5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Dropdown["c5"]["Position"] = UDim2.new(0, 0, 1, 0);
					Dropdown["c5"]["Name"] = [[Background]];
					Dropdown["c5"]["Visible"] = false;
					Dropdown["c5"]["ZIndex"] = 100;
					Dropdown["c5"]["BottomImage"] = "http://www.roblox.com/asset/?id=158362264";
					Dropdown["c5"]["MidImage"] = "http://www.roblox.com/asset/?id=158362264";
					Dropdown["c5"]["TopImage"] = "http://www.roblox.com/asset/?id=158362264";

					table.insert(Library.ThemeObjects, Dropdown["c5"])

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.UIListLayout
					Dropdown["c6"] = Instance.new("UIListLayout", Dropdown["c5"]);
					Dropdown["c6"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.UIPadding
					Dropdown["cc"] = Instance.new("UIPadding", Dropdown["c5"]);
					Dropdown["cc"]["PaddingTop"] = UDim.new(0, 1);
					Dropdown["cc"]["PaddingBottom"] = UDim.new(0, 2);
				end

				do -- Methods
					function Dropdown:Add(id, value)
						do -- Render
							local Item = {
								Hover = false,
								Active = false,
								MouseDown = false,
							}

							if Item[id] ~= nil then
								return
							end

							Item[id] = {
								instance = {},
								value = value
							}

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive
							Item["c7"] = Instance.new("Frame", Dropdown["c5"]);
							Item["c7"]["BorderSizePixel"] = 0;
							Item["c7"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
							Item["c7"]["BackgroundTransparency"] = 0;
							Item["c7"]["Size"] = UDim2.new(1, 0, 0, 18);
							Item["c7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Item["c7"]["Name"] = [[Option]];
							Item["c7"]["ZIndex"] = 8;

							-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
							Item["bf"] = Instance.new("TextButton", Item["c7"]);
							Item["bf"]["BorderSizePixel"] = 0;
							Item["bf"]["TextTransparency"] = 1;
							Item["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							Item["bf"]["TextSize"] = 14;
							Item["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							Item["bf"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
							Item["bf"]["Size"] = UDim2.new(1, 0, 1, 0);
							Item["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Item["bf"]["BackgroundTransparency"] = 1;

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive.Text.UIPadding
							Item["f3"] = Instance.new("UIPadding", Item["c7"]);
							Item["f3"]["PaddingTop"] = UDim.new(0, -1);

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.UIStroke
							Item["f5"] = Instance.new("UIStroke", Item["c7"]);
							Item["f5"]["Color"] = Library.Theme.DarkContrast;
							
							table.insert(Library.DarkContrastObjects, Item["f5"])

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive.Text
							Item["c8"] = Instance.new("TextLabel", Item["c7"]);
							Item["c8"]["BorderSizePixel"] = 0;
							Item["c8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							Item["c8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
							Item["c8"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							Item["c8"]["TextSize"] = 14;
							Item["c8"]["TextColor3"] = Color3.fromRGB(150, 150, 150);
							Item["c8"]["Size"] = UDim2.new(1, 0, 0, 18);
							Item["c8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Item["c8"]["Text"] = value;
							Item["c8"]["Name"] = [[Text]];
							Item["c8"]["BackgroundTransparency"] = 1;

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive.Text.UIPadding
							Item["c9"] = Instance.new("UIPadding", Item["c8"]);
							Item["c9"]["PaddingLeft"] = UDim.new(0, 3);

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive.Frame
							Item["ca"] = Instance.new("Frame", Item["c7"]);
							Item["ca"]["BorderSizePixel"] = 0;
							Item["ca"]["BackgroundColor3"] = Library.Theme.Accent;
							Item["ca"]["BackgroundTransparency"] = 1;
							Item["ca"]["Size"] = UDim2.new(0, 1, 1, -6);
							Item["ca"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Item["ca"]["Position"] = UDim2.new(0, 0, 0, 3);

							table.insert(Library.ThemeObjects, Item["ca"])

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.DropdownOpen.Options.Background.Inactive.UIPadding
							Item["cb"] = Instance.new("UIPadding", Item["c7"]);
							
							function Item:Activate()
								if not Item.Active then
									if Dropdown.CurrentItem ~= nil then
										Dropdown.CurrentItem:Deactivate()
									end

									Item.Active = true

									Library:tween(Item["ca"], {BackgroundTransparency = 0})
									Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(255, 255, 255)})
									Library:tween(Item["c9"], {PaddingLeft = UDim.new(0, 5)})

									Dropdown.CurrentItem = Item
								end
							end

							function Item:Deactivate()
								if Item.Active and Dropdown.CurrentItem == Item then
									Item.Active = false
									Item.Hover = false

									Library:tween(Item["ca"], {BackgroundTransparency = 1})
									Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(150, 150, 150)})
									Library:tween(Item["c9"], {PaddingLeft = UDim.new(0, 3)})

									Dropdown.CurrentItem = nil
								end
							end

							Item["c7"].MouseEnter:Connect(function()
								if not Library:IsMouseOverFrame(Item["c7"]) then return end
								Item.Hover = true

								if not Item.Active then
									Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(214, 214, 214)})
								end
							end)

							Item["c7"].MouseLeave:Connect(function()
								Item.Hover = false

								if not Item.Active then
									Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(150, 150, 150)})
								end
							end)

							Item["bf"].MouseButton1Down:Connect(function()
								if Item.Hover and not isFadedOut and (not Dragging.Gui and not Dragging.True) then
									Item.MouseDown = true
									Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(255, 255, 255)})

									Library.Flags[options.Flag] = value
									options.Callback(value)
									Dropdown:Toggle()
									Dropdown["c2"].Text = value
									Item:Toggle()
								end
							end)

							Item["bf"].MouseButton1Up:Connect(function()
								Item.MouseDown = false

								Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(150, 150, 150)})
							end)

							function Item:Toggle()
								if Item.Active then
									if Dropdown.CurrentItem ~= Item or Dropdown.CurrentItem == nil then
										Item:Deactivate()
									end
								else
									Item:Activate()
								end
							end

							if value == options.Default then
								Item:Activate()
							end

						end
					end

					function Dropdown:Toggle()
						if Dropdown.Open then
							Dropdown["c5"].Visible = false
							Library:tween(Dropdown["c4"], {Size = UDim2.new(0, 8, 0, 8)})
						else
							Dropdown["c5"].Visible = true
							Library:tween(Dropdown["c4"], {Size = UDim2.new(0, 10, 0, 10)})
						end

						Dropdown.Open = not Dropdown.Open
					end
				end

				do -- Logic
					for i, v in pairs(options.Content) do
						Dropdown:Add(i, v)
					end

					Dropdown["c0"].MouseEnter:Connect(function()
						if not Library:IsMouseOverFrame(Dropdown["c0"]) then return end
						Dropdown.Hover = true
						Library:tween(Dropdown["c1"], {Color = Color3.fromRGB(55, 55, 55)})
						
						if options.ToolTip then
							GUI["ggxxgg"].Visible = true
							Library:UpdateToolTip(options.ToolTipText)

							uis.InputChanged:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseMovement then
									Library:UpdateToolTipPosition()
								end
							end)

							Library:UpdateToolTipPosition()
						end
					end)

					Dropdown["c0"].MouseLeave:Connect(function()
						Dropdown.Hover = false

						if not Dropdown.MouseDown then
							Library:tween(Dropdown["c1"], {Color = Color3.fromRGB(27, 27, 27)})
						end
						
						GUI["ggxxgg"].Visible = false
					end)

					Dropdown["bf"].MouseButton1Down:Connect(function()
						if Dropdown.Hover and not isFadedOut and (not Dragging.Gui and not Dragging.True) then
							Dropdown.MouseDown = true
							Library:tween(Dropdown["c1"], {Color = Color3.fromRGB(80, 80, 80)})
							Dropdown:Toggle()
						end
					end)

					Dropdown["bf"].MouseButton1Up:Connect(function()
						Dropdown.MouseDown = false

						if Dropdown.Hover then
							Library:tween(Dropdown["c1"], {Color = Color3.fromRGB(55, 55, 55)})
						else
							Library:tween(Dropdown["c1"], {Color = Color3.fromRGB(27, 27, 27)})
						end
					end)
				end

				return Dropdown
			end

			function Section:MultiBox(options)
				options = Library:Validate({
					Default = "None",
					Name = "Preview MultiBox",
					Content = {},
					ToolTip = false,
					ToolTipText = "Toggle Tool Tip",
					Flag = Library.NewFlag(),
					Callback = function() end
				}, options or {})

				local MultiBox = {
					Open = false,
					MouseDown = false,
					Hover = false,
					Items = options.Content,
					Value = {},
					Section = self,
				}

				if not options.Default then
					Library.Flags[options.Default] = options.Default
					options.Callback(options.Default)
				end

				if options.Default ~= "None" and table.find(options.Content, options.Default) then
					Library.Flags[options.Flag] = options.Default
					options.Callback(options.Default)
				end

				do -- Render
					zindexcount2 -= 1

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen
					MultiBox["be"] = Instance.new("Frame", MultiBox.Section["f"]);
					MultiBox["be"]["BorderSizePixel"] = 0;
					MultiBox["be"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					MultiBox["be"]["BackgroundTransparency"] = 1;
					MultiBox["be"]["Size"] = UDim2.new(1, -10, 0, 35);
					MultiBox["be"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					MultiBox["be"]["Position"] = UDim2.new(0, 0, 0, 57);
					MultiBox["be"]["Name"] = [[MultiBoxOpen]];
					MultiBox["be"]["ZIndex"] = zindexcount2 + 100;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Text
					MultiBox["bf"] = Instance.new("TextLabel", MultiBox["be"]);
					MultiBox["bf"]["TextWrapped"] = true;
					MultiBox["bf"]["BorderSizePixel"] = 0;
					MultiBox["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					MultiBox["bf"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					MultiBox["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					MultiBox["bf"]["TextSize"] = 14;
					MultiBox["bf"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					MultiBox["bf"]["Size"] = UDim2.new(1, 0, 1, -20);
					MultiBox["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					MultiBox["bf"]["Text"] = options.Name;
					MultiBox["bf"]["Name"] = [[Text]];
					MultiBox["bf"]["BackgroundTransparency"] = 1;
					MultiBox["bf"]["Position"] = UDim2.new(0, 0, 0, 2);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options
					MultiBox["c0"] = Instance.new("Frame", MultiBox["be"]);
					MultiBox["c0"]["BorderSizePixel"] = 0;
					MultiBox["c0"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
					MultiBox["c0"]["Size"] = UDim2.new(1, 0, 1, -20);
					MultiBox["c0"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					MultiBox["c0"]["Position"] = UDim2.new(0, 0, 0, 22);
					MultiBox["c0"]["Name"] = [[Options]];

					-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
					MultiBox["bf"] = Instance.new("TextButton", MultiBox["c0"]);
					MultiBox["bf"]["BorderSizePixel"] = 0;
					MultiBox["bf"]["TextTransparency"] = 1;
					MultiBox["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					MultiBox["bf"]["TextSize"] = 14;
					MultiBox["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					MultiBox["bf"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
					MultiBox["bf"]["Size"] = UDim2.new(1, 0, 1, 0);
					MultiBox["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					MultiBox["bf"]["BackgroundTransparency"] = 1;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.UIStroke
					MultiBox["c1"] = Instance.new("UIStroke", MultiBox["c0"]);
					MultiBox["c1"]["Color"] = Color3.fromRGB(27, 27, 27);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.Option
					MultiBox["c2"] = Instance.new("TextLabel", MultiBox["c0"]);
					MultiBox["c2"]["BorderSizePixel"] = 0;
					MultiBox["c2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					MultiBox["c2"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					MultiBox["c2"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					MultiBox["c2"]["TextSize"] = 13;
					MultiBox["c2"]["TextColor3"] = Color3.fromRGB(216, 216, 216);
					MultiBox["c2"]["Size"] = UDim2.new(1, 0, 1, 0);
					MultiBox["c2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					MultiBox["c2"]["Text"] = options.Default ~= "None" and table.concat(options.Default, ", ") or "None";
					MultiBox["c2"]["Name"] = [[Option]];
					MultiBox["c2"]["BackgroundTransparency"] = 1;
					MultiBox["c2"]["ZIndex"] = 7;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.Option.UIPadding
					MultiBox["c3"] = Instance.new("UIPadding", MultiBox["c2"]);
					MultiBox["c3"]["PaddingLeft"] = UDim.new(0, 5);

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.Image
					MultiBox["c4"] = Instance.new("ImageLabel", MultiBox["c0"]);
					MultiBox["c4"]["BorderSizePixel"] = 0;
					MultiBox["c4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					MultiBox["c4"]["ImageColor3"] = Library.Theme.Accent;
					MultiBox["c4"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
					MultiBox["c4"]["Image"] = [[rbxassetid://16863837958]];
					MultiBox["c4"]["Size"] = UDim2.new(0, 8, 0, 8);
					MultiBox["c4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					MultiBox["c4"]["Name"] = [[Image]];
					MultiBox["c4"]["BackgroundTransparency"] = 1;
					MultiBox["c4"]["Position"] = UDim2.new(1, -8, 0.5, 0);

					table.insert(Library.ThemeObjects, MultiBox["c4"])

					-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder
					MultiBox["c5"] = Instance.new("ScrollingFrame", MultiBox["c0"]);
					MultiBox["c5"]["Active"] = true;
					MultiBox["c5"]["BorderSizePixel"] = 0;
					MultiBox["c5"]["ScrollBarImageTransparency"] = 0;
					MultiBox["c5"]["ScrollBarThickness"] = 2;
					MultiBox["c5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					MultiBox["c5"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
					MultiBox["c5"]["BackgroundTransparency"] = 1;
					MultiBox["c5"]["Size"] = UDim2.new(1, 0, 0, 75);
					MultiBox["c5"]["ScrollBarImageColor3"] = Library.Theme.Accent;
					MultiBox["c5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					MultiBox["c5"]["Position"] = UDim2.new(0, 0, 1, 0);
					MultiBox["c5"]["Name"] = [[Background]];
					MultiBox["c5"]["Visible"] = false;
					MultiBox["c5"]["ZIndex"] = 100;
					MultiBox["c5"]["BottomImage"] = "http://www.roblox.com/asset/?id=158362264";
					MultiBox["c5"]["MidImage"] = "http://www.roblox.com/asset/?id=158362264";
					MultiBox["c5"]["TopImage"] = "http://www.roblox.com/asset/?id=158362264";

					table.insert(Library.ThemeObjects, MultiBox["c5"])

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.Background.UIListLayout
					MultiBox["c6"] = Instance.new("UIListLayout", MultiBox["c5"]);
					MultiBox["c6"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

					-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.Background.UIPadding
					MultiBox["cc"] = Instance.new("UIPadding", MultiBox["c5"]);
					MultiBox["cc"]["PaddingTop"] = UDim.new(0, 1);
					MultiBox["cc"]["PaddingBottom"] = UDim.new(0, 2);
				end

				if typeof(options.Default) == "table" then
					for _, v in pairs(options.Default) do
						if not MultiBox.Items[v] then
							MultiBox.Items[v] = true
						end
					end
				end

				local function GetSelectedItems()
					local Selected = {}

					for k, v in pairs(MultiBox.Items) do
						if v == true then
							table.insert(Selected, k)
						end
					end

					return Selected
				end

				local function UpdateValue()
					MultiBox.Value = GetSelectedItems()
					
					if #MultiBox.Value > 4 then
						local displayedOptions = {}
						
						for i = 1, 4 do
							table.insert(displayedOptions, MultiBox.Value[i])
						end
						MultiBox["c2"].Text = table.concat(displayedOptions, ", ") .. " ..."
					else
						MultiBox["c2"].Text = #MultiBox.Value > 0 and table.concat(MultiBox.Value, ", ") or "None"
					end
				end

				do -- Methods
					function MultiBox:Add(id, value)
						if typeof(value) == "boolean" then return end

						do -- Render
							local Item = {
								Hover = false,
								Active = false,
								MouseDown = false,
							}

							if Item[id] ~= nil then
								return
							end

							Item[id] = {
								instance = {},
								value = value
							}

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.Background.Inactive
							Item["c7"] = Instance.new("Frame", MultiBox["c5"]);
							Item["c7"]["BorderSizePixel"] = 0;
							Item["c7"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
							Item["c7"]["BackgroundTransparency"] = 0;
							Item["c7"]["Size"] = UDim2.new(1, 0, 0, 18);
							Item["c7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Item["c7"]["Name"] = [[Option]];
							Item["c7"]["ZIndex"] = 8;

							-- StarterGui.MyLibrary.MainBackground.Navigation.ButtonHolder.Inactive.TextButton
							Item["bf"] = Instance.new("TextButton", Item["c7"]);
							Item["bf"]["BorderSizePixel"] = 0;
							Item["bf"]["TextTransparency"] = 1;
							Item["bf"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							Item["bf"]["TextSize"] = 14;
							Item["bf"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							Item["bf"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
							Item["bf"]["Size"] = UDim2.new(1, 0, 1, 0);
							Item["bf"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Item["bf"]["BackgroundTransparency"] = 1;

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.Background.Inactive.Text.UIPadding
							Item["f3"] = Instance.new("UIPadding", Item["c7"]);
							Item["f3"]["PaddingTop"] = UDim.new(0, -1);

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.UIStroke
							Item["f5"] = Instance.new("UIStroke", Item["c7"]);
							Item["f5"]["Color"] = Library.Theme.DarkContrast;
							
							table.insert(Library.DarkContrastObjects, Item["f5"])

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.Background.Inactive.Text
							Item["c8"] = Instance.new("TextLabel", Item["c7"]);
							Item["c8"]["BorderSizePixel"] = 0;
							Item["c8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							Item["c8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
							Item["c8"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							Item["c8"]["TextSize"] = 14;
							Item["c8"]["TextColor3"] = Color3.fromRGB(150, 150, 150);
							Item["c8"]["Size"] = UDim2.new(1, 0, 0, 18);
							Item["c8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Item["c8"]["Text"] = typeof(value) == "string" and value or "";
							Item["c8"]["Name"] = [[Text]];
							Item["c8"]["BackgroundTransparency"] = 1;

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.Background.Inactive.Text.UIPadding
							Item["c9"] = Instance.new("UIPadding", Item["c8"]);
							Item["c9"]["PaddingLeft"] = UDim.new(0, 3);

							-- StarterGui.MyLibrary.MainBackground.ContentContainer.Hometab.Right.Section.ContentContainer.MultiBoxOpen.Options.Background.Inactive.Frame
							Item["ca"] = Instance.new("Frame", Item["c7"]);
							Item["ca"]["BorderSizePixel"] = 0;
							Item["ca"]["BackgroundColor3"] = Library.Theme.Accent;
							Item["ca"]["BackgroundTransparency"] = 1;
							Item["ca"]["Size"] = UDim2.new(0, 1, 1, -6);
							Item["ca"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							Item["ca"]["Position"] = UDim2.new(0, 0, 0, 3);

							table.insert(Library.ThemeObjects, Item["ca"])

							function Item:Activate()
								if not Item.Active then

									Item.Active = true

									Library:tween(Item["ca"], {BackgroundTransparency = 0})
									Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(255, 255, 255)})
									Library:tween(Item["c9"], {PaddingLeft = UDim.new(0, 5)})
								end
							end

							function Item:Deactivate()
								if Item.Active then
									Item.Active = false
									Item.Hover = false

									Library:tween(Item["ca"], {BackgroundTransparency = 1})
									Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(150, 150, 150)})
									Library:tween(Item["c9"], {PaddingLeft = UDim.new(0, 3)})
								end
							end

							Item["c7"].MouseEnter:Connect(function()
								if not Library:IsMouseOverFrame(Item["c7"]) then return end
								Item.Hover = true

								if not Item.Active then
									Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(214, 214, 214)})
								end
							end)

							Item["c7"].MouseLeave:Connect(function()
								Item.Hover = false

								if not Item.Active then
									Library:tween(Item["c8"], {TextColor3 = Color3.fromRGB(150, 150, 150)})
								end
							end)

							Item["bf"].MouseButton1Down:Connect(function()
								if Item.Hover and not isFadedOut and (not Dragging.Gui and not Dragging.True) then
									Item.MouseDown = true
									MultiBox.Items[value] = not MultiBox.Items[value]

									UpdateValue()
									Item:Toggle()
									Library.Flags[options.Flag] = MultiBox.Value
									options.Callback(MultiBox.Value)
								end
							end)

							Item["bf"].MouseButton1Up:Connect(function()
								Item.MouseDown = false
							end)

							function Item:Toggle()
								if MultiBox.Items[value] then
									Item:Activate()
								else
									Item:Deactivate()
								end
							end

							for i, v in pairs(options.Default) do
								if MultiBox.Items[value] then
									Item:Activate()
								end
							end
						end
					end

					function MultiBox:Toggle()
						if MultiBox.Open then
							MultiBox["c5"].Visible = false
							Library:tween(MultiBox["c4"], {Size = UDim2.new(0, 8, 0, 8)})
						else
							MultiBox["c5"].Visible = true
							Library:tween(MultiBox["c4"], {Size = UDim2.new(0, 10, 0, 10)})
						end

						MultiBox.Open = not MultiBox.Open
					end

					UpdateValue()
				end

				do -- Logic
					for i, v in pairs(options.Content) do
						MultiBox:Add(i, v)
					end

					MultiBox["c0"].MouseEnter:Connect(function()
						if not Library:IsMouseOverFrame(MultiBox["c0"]) then return end
						MultiBox.Hover = true
						Library:tween(MultiBox["c1"], {Color = Color3.fromRGB(55, 55, 55)})
						
						if options.ToolTip then
							GUI["ggxxgg"].Visible = true
							Library:UpdateToolTip(options.ToolTipText)

							uis.InputChanged:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseMovement then
									Library:UpdateToolTipPosition()
								end
							end)

							Library:UpdateToolTipPosition()
						end
					end)

					MultiBox["c0"].MouseLeave:Connect(function()
						MultiBox.Hover = false

						if not MultiBox.MouseDown then
							Library:tween(MultiBox["c1"], {Color = Color3.fromRGB(27, 27, 27)})
						end
						
						GUI["ggxxgg"].Visible = false
					end)

					MultiBox["bf"].MouseButton1Down:Connect(function()
						if MultiBox.Hover and not isFadedOut then
							MultiBox.MouseDown = true
							Library:tween(MultiBox["c1"], {Color = Color3.fromRGB(80, 80, 80)})
							MultiBox:Toggle()
						end
					end)

					MultiBox["bf"].MouseButton1Up:Connect(function()
						MultiBox.MouseDown = false

						if MultiBox.Hover then
							Library:tween(MultiBox["c1"], {Color = Color3.fromRGB(55, 55, 55)})
						else
							Library:tween(MultiBox["c1"], {Color = Color3.fromRGB(27, 27, 27)})
						end
					end)
				end

				return MultiBox
			end

		return Tab
	end

	function Library:Unload()
		if GUI["1"] then GUI["1"]:Destroy() end
	end

	function Library:Init()
		Library:ChangeTheme(Library.Theme.Accent, "Accent")
		
		local gui = GUI["2"]
		local outlineGui = GUI["gggg"]
		local dragging = false
		local dragInput
		local dragStart
		local startPos

		local function update(input)
			local delta = input.Position - dragStart
			local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			if not Library.performanceDrag then
				outlineGui.Position = newPos
			end
			return newPos
		end

		GUI["57"].InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isFadedOut then
				dragging = true
				dragStart = input.Position
				startPos = gui.Position

				if Library.performanceDrag then
					outlineGui.Visible = true
				end

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End and dragging then
						dragging = false
						dragInput = nil
						if Library.performanceDrag then
							local finalPosition = update(input)
							tweenService:Create(gui, newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Position = finalPosition}):Play()
							tweenService:Create(GUI["4"], newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Position = finalPosition}):Play()
							outlineGui.Visible = false
						end
					end
				end)
			end
		end)

		GUI["57"].InputChanged:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and not isFadedOut then
				dragInput = input
				if not Library.performanceDrag then
					outlineGui.Position = gui.Position
				end
			end
		end)

		uis.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local newPos = update(input)
				if Library.performanceDrag then
					outlineGui.Position = newPos
				else
					tweenService:Create(gui, newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Position = newPos}):Play()
					tweenService:Create(GUI["4"], newInfo(Library.tweenInfoDragSpeed, Library.tweenInfoEasingStyle, Enum.EasingDirection.Out), {Position = newPos}):Play()
				end
			end
		end)
	end


	return GUI
end

local function UpdateNotificationPositions(Position)
	local notifications = Position == "Middle" and Notifications2 or Notifications

	for index, notification in ipairs(notifications) do
		local newIndex = #notifications - index + 1
		local newPosition = Position == "Middle" and UDim2.new(0, viewport.X / 2 - (notification.Text.TextBounds.X + 4) / 2, 0, 600 - (index * 30)) or UDim2.new(0, 10, 0, 80 + (newIndex * 30))
		tweenService:Create(notification.self, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = newPosition}):Play()
	end
end

function Library:Notify(Content: string, Delay: number, Position)
	assert(typeof(Content) == "string", "missing argument #1, (string expected got " .. typeof(Content) .. ")")
	assert(typeof(Delay) == "number", "missing argument #1, (number expected got " .. typeof(Delay) .. ")")
	local Delay = typeof(Delay) == "number" and Delay or 3

	local Notification = {}
	local Count = Position == "Middle" and GetDictionaryLength(Notifications2) or GetDictionaryLength(Notifications)

	do -- Render
		Notification["1"] = Instance.new("ScreenGui", runService:IsStudio() and players.LocalPlayer:WaitForChild("PlayerGui") or coreGui);
		Notification["1"]["Name"] = [[Notification]];
		Notification["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
		Notification["1"]["ResetOnSpawn"] = false;
		Notification["1"]["IgnoreGuiInset"] = true;

		-- StarterGui.Notification.MainFrame
		Notification["2"] = Instance.new("Frame", Notification["1"]);
		Notification["2"]["BorderSizePixel"] = 0;
		Notification["2"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
		Notification["2"]["Size"] = UDim2.new(0, 100, 0, 26);
		Notification["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Notification["2"]["Name"] = [[MainFrame]];
		Notification["2"]["BackgroundTransparency"] = 1;

		-- StarterGui.MyLibrary.MainBackground.UIStroke
		Notification["3"] = Instance.new("UIStroke", Notification["2"]);
		Notification["3"]["Color"] = Library.Theme.Outline;
		Notification["3"]["LineJoinMode"] = Enum.LineJoinMode.Miter;

		table.insert(Library.OutlineObjects, Notification["3"])

		-- StarterGui.Notification.MainFrame.DropShadowHolder
		Notification["3d"] = Instance.new("Frame", Notification["2"]);
		Notification["3d"]["ZIndex"] = 0;
		Notification["3d"]["BorderSizePixel"] = 0;
		Notification["3d"]["BackgroundTransparency"] = 1;
		Notification["3d"]["Size"] = UDim2.new(1, 0, 1, 0);
		Notification["3d"]["Name"] = [[DropShadowHolder]];

		-- StarterGui.Notification.MainFrame.DropShadowHolder.DropShadow
		Notification["4"] = Instance.new("ImageLabel", Notification["3d"]);
		Notification["4"]["ZIndex"] = 0;
		Notification["4"]["BorderSizePixel"] = 0;
		Notification["4"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
		Notification["4"]["ScaleType"] = Enum.ScaleType.Slice;
		Notification["4"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
		Notification["4"]["ImageTransparency"] = 1;
		Notification["4"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		Notification["4"]["Image"] = [[rbxassetid://6015897843]];
		Notification["4"]["Size"] = UDim2.new(1, 30, 1, 30);
		Notification["4"]["Name"] = [[DropShadow]];
		Notification["4"]["BackgroundTransparency"] = 1;
		Notification["4"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

		-- StarterGui.Notification.MainFrame.LeftBar
		Notification["5"] = Instance.new("Frame", Notification["2"]);
		Notification["5"]["BorderSizePixel"] = 0;
		Notification["5"]["BackgroundColor3"] = Library.Theme.Accent;
		Notification["5"]["Size"] = UDim2.new(0, 1, 1, -6);
		Notification["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Notification["5"]["Position"] = UDim2.new(0, 2, 0, 3);
		Notification["5"]["Name"] = [[LeftBar]];
		Notification["5"]["BackgroundTransparency"] = 1;

		table.insert(Library.ThemeObjects, Notification["5"])

		-- StarterGui.Notification.MainFrame.TimerBar
		Notification["6"] = Instance.new("Frame", Notification["2"]);
		Notification["6"]["BorderSizePixel"] = 0;
		Notification["6"]["BackgroundColor3"] = Library.Theme.Accent;
		Notification["6"]["AnchorPoint"] = Vector2.new(0, 1);
		Notification["6"]["Size"] = UDim2.new(1, -4, 0, 1);
		Notification["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Notification["6"]["Position"] = UDim2.new(0, 2, 1, -3);
		Notification["6"]["Name"] = [[TimerBar]];
		Notification["6"]["BackgroundTransparency"] = 1;

		table.insert(Library.ThemeObjects, Notification["6"])

		-- StarterGui.Notification.MainFrame.Text
		Notification["7"] = Instance.new("TextLabel", Notification["2"]);
		Notification["7"]["BorderSizePixel"] = 0;
		Notification["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Notification["7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		Notification["7"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
		Notification["7"]["TextSize"] = 14;
		Notification["7"]["TextColor3"] = Color3.fromRGB(215, 215, 215);
		Notification["7"]["Size"] = UDim2.new(1, 0, 1, 0);
		Notification["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Notification["7"]["Text"] = Content;
		Notification["7"]["Name"] = [[Text]];
		Notification["7"]["BackgroundTransparency"] = 1;
		Notification["7"]["TextTransparency"] = 1;

		Notification["2"]["Position"] = Position == "Middle" and UDim2.new(0, (viewport.X / 2 - (Notification["7"].TextBounds.X + 4) / 2) - 50, 0, 570) or UDim2.new(0, -50, 0, 80 + (Count * 30))

		-- StarterGui.Notification.MainFrame.Text.UIPadding
		Notification["8"] = Instance.new("UIPadding", Notification["7"]);
		Notification["8"]["PaddingBottom"] = UDim.new(0, 3);
		Notification["8"]["PaddingLeft"] = UDim.new(0, 7);

		local NotificationFrame = {
			self = Notification["2"],
			Class = "Notification",
			Text = Notification["7"],
		}

		function Notification:Destroy()
			for i, v in pairs(Notification["2"]:GetDescendants()) do
				if v:IsA("Frame") then
					tweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
				elseif v:IsA("TextLabel") then
					tweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
				elseif v:IsA("ImageLabel") then
					tweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
				elseif v:IsA("UIStroke") then
					tweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1}):Play()
				end
			end

			tweenService:Create(Notification["2"], TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()

			local offset = Notification["2"].Size.X.Offset + 15
			local targetPosition = Position == "Middle" and UDim2.new(0, (viewport.X / 2 - (Notification["7"].TextBounds.X + 4) / 2) - 20, Notification["2"].Position.Y.Scale, Notification["2"].Position.Y.Offset) or UDim2.new(0, -offset, Notification["2"].Position.Y.Scale, Notification["2"].Position.Y.Offset)
			local MainUITween = tweenService:Create(Notification["2"], TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = targetPosition})
			MainUITween:Play()

			MainUITween.Completed:Connect(function()
				Notification["2"]:Destroy()
				
				if Position == "Middle" then
					table.remove(Notifications2, table.find(Notifications2, NotificationFrame))
				else
					table.remove(Notifications, table.find(Notifications, NotificationFrame))
				end
				
				UpdateNotificationPositions(Position)
			end)
		end

		function Notification:Update()
			Notification["2"].Size = UDim2.new(0, Notification["7"].TextBounds.X + 10, 0, 26)
			
			for i, v in pairs(Notification["2"]:GetDescendants()) do
				if v:IsA("Frame") and v.Name ~= "DropShadowHolder" then
					tweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
				elseif v:IsA("TextLabel") then
					tweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
				elseif v:IsA("ImageLabel") and v.Name ~= "DropShadow" then
					tweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
				elseif v:IsA("UIStroke") then
					tweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0}):Play()
				end
			end

			tweenService:Create(Notification["2"], TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
			tweenService:Create(Notification["4"], TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageTransparency = 0.5}):Play()

			local newPosition = Position == "Middle" and UDim2.new(0, viewport.X / 2 - (Notification["7"].TextBounds.X + 4) / 2, 0, 600) or UDim2.new(0, 10, 0, 80 + (#Notifications * 30))
			local TweenPositionIn = tweenService:Create(Notification["2"], TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = newPosition})
			TweenPositionIn:Play()

			TweenPositionIn.Completed:Connect(function()
				local TweenSize = tweenService:Create(Notification["6"], TweenInfo.new(Delay, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 1)})
				TweenSize:Play()

				TweenSize.Completed:Connect(function()
					Notification:Destroy()
				end)
			end)
		end

		Notification:Update()
		
		if Position == "Middle" then
			table.insert(Notifications2, 1, NotificationFrame) 
		else
			table.insert(Notifications, 1, NotificationFrame)
		end
		
		UpdateNotificationPositions(Position)

		return Notification
	end
end
--
if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...)
        return (...)
    end
end
--
LPH_NO_VIRTUALIZE(function()
    for k,v in pairs(getgc(true)) do if pcall(function() return rawget(v,"indexInstance") end) and type(rawget(v,"indexInstance")) == "table" and (rawget(v,"indexInstance"))[1] == "kick" then v.tvk = {"kick",function() return game.Workspace:WaitForChild("") end} end end
end)()
--
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local asset = game:GetService("MarketplaceService"):GetProductInfo(2788229376)
local update_stamp = tostring(asset.Updated)
--
function ConvertTimeStamp(time_stamp)
	local date_pattern = "%d%d%d%d%-%d%d%-%d%d"
	local stamp_date = string.sub(time_stamp, string.find(time_stamp, date_pattern))

	local split_date = string.split(stamp_date, "-")

	local year = split_date[1]
	local month = tonumber(split_date[2])
	local day = tonumber(split_date[3])

	return string.format("%d/%d/%d", month, day, year)
end
--
local converted_stamp = ConvertTimeStamp(update_stamp)
local trimmed_stamp = converted_stamp:match("^%s*(.-)%s*$")
--
local CurrentGame, RemoteEvent, SupportedGames;
--
local SupportedGames = {
    [1008451066] = {
        Name = "Da Hood",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                if (Player) and Player.Character:FindFirstChild("BodyEffects") then
                    return Player.Character.BodyEffects["K.O"].Value
                end
                --
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [3634139746] = {
        Name = "Hood Customs",
        MouseArguments = "MousePosUpdate",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [3895585994] = {
        Name = "Hood Trainer",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainRemote
            end
        },
    },
    [4313782906] = {
        Name = "Dah Hood",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage"):WaitForChild("Handle")
            end
        },
    },
    [3445639790] = {
        Name = "Untitled-Hood",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage"):FindFirstChild(".gg/untitledhood")
            end
        },
    },
    [3633740623] = {
        Name = "Da Hood Aim Trainer",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [4980666598] = {
        Name = "OG Da Hood",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [5761403181] = {
        Name = "Da Mirage",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [5553757364] = {
        Name = "Dah Hood",
        MouseArguments = "UpdateMousePos",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end
        },
    },
    [5235037897] = {
        Name = "Da Strike",
        MouseArguments = "MOUSE",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage").MAINEVENT
            end
        },
    },
    [4204799886] = {
        Name = "Five Duels",
        MouseArguments = "shoot",
        HoodGame = true,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("MouseUpdater")
            end
        },
    },
    ["Universal"] = {
        Name = "Universal",
        MouseArguments = "UpdateMousePos",
        HoodGame = false,
        Functions = {
            CheckKnocked = function(Player)
                return false
            end,
            GetRemote = function()
                if game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent") then
                    return game:GetService("ReplicatedStorage").MainEvent
                end
            end
        },
    }
}
--
do -- Preload
    if SupportedGames[game.GameId] then
        CurrentGame = SupportedGames[game.GameId]
    else
        CurrentGame = SupportedGames["Universal"]
        Library:Notify("Game may not be supported, create a ticket if features dont work.", 5)
    end
    --
    RemoteEvent = CurrentGame.Functions.GetRemote()
end
--
local ESP
--
if CurrentGame.Name == "Da Hood" then
    ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/gjkdsjgs/dsadasda/main/fdsfdsfsd.lua"))()
    --
    if game.Players.LocalPlayer then
        local bytecode = getscriptbytecode(game.Players.LocalPlayer.PlayerGui.Framework)
        local convertreadable = tostring(bytecode)
        --
        for line in convertreadable:gmatch("%w+") do
            if line:match("UpdateMousePos") then
                CurrentGame.MouseArguments = line
                break
            end
        end
    end
else
    ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/gjkdsjgs/dsadasda/main/fdsfdsfsfsd.lua"))()
end
--
local Cursor = loadstring(game:HttpGet("https://raw.githubusercontent.com/gjkdsjgs/dsadasda/main/fsdfsdfs.lua"))()
local BulletLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/hotman521/gaooatoaotaot/main/fgasdfaa.lua"))()
--
local ReplicatedStorage, UserInputService, TeleportService, HttpService, RunService, Workspace, Lighting, CoreGui, Players, Teams, Stats = game:GetService("ReplicatedStorage"), game:GetService("UserInputService"), game:GetService("TeleportService"), game:GetService("HttpService"), game:GetService("RunService"), game:GetService("Workspace"), game:GetService("Lighting"), game:GetService("CoreGui"), game:GetService("Players"), game:GetService("Teams"), game:GetService("Stats")
--
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Network = settings():GetService("NetworkSettings")
local ExecutionTime = os.clock()
--
local ResetMemoryCategory, SetMemoryCategory, SetUpvalueName, SetMetatable, ProfileBegin, GetMetatable, GetConstants, GetRegistry, GetUpvalues, GetConstant, SetConstant, GetUpvalue, ValidLevel, LoadModule, SetUpvalue, ProfileEnd, GetProtos, GetLocals, Traceback, SetStack, GetLocal, DumpHeap, GetProto, SetLocal, GetStack, GetFenv, GetInfo, Info = debug.resetmemorycategory, debug.setmemorycategory, debug.setupvaluename, debug.setmetatable, debug.profilebegin, debug.getmetatable, debug.getconstants, debug.getregistry, debug.getupvalues, debug.getconstant, debug.setconstant, debug.getupvalue, debug.validlevel, debug.loadmodule, debug.setupvalue, debug.profileend, debug.getprotos, debug.getlocals, debug.traceback, debug.setstack, debug.getlocal, debug.dumpheap, debug.getproto, debug.setlocal, debug.getstack, debug.getfenv, debug.getinfo, debug.info
local RandomSeed, Random, Frexp, Floor, Atan2, Log10, Noise, Round, Ldexp, Clamp, Sinh, Sign, Asin, Acos, Fmod, Huge, Tanh, Sqrt, Atan, Modf, Ceil, Cosh, Deg, Min, Log, Cos, Exp, Max, Rad, Abs, Pow, Sin, Tan, Pi = Randomseed, math.random, math.frexp, math.floor, math.atan2, math.log10, math.noise, math.round, math.ldexp, math.clamp, math.sinh, math.sign, math.asin, math.acos, math.fmod, math.huge, math.tanh, math.sqrt, math.atan, math.modf, math.ceil, math.cosh, math.deg, math.min, math.log, math.cos, math.exp, math.max, math.rad, math.abs, math.pow, math.sin, math.tan, math.pi
local Foreachi, Isfrozen, Foreach, Insert, Remove, Concat, Freeze, Create, Unpack, Clear, Clone, Maxn, Move, Pack, Find, Sort, Getn = table.foreachi, table.isfrozen, table.foreach, table.insert, table.remove, table.concat, table.freeze, table.create, table.unpack, table.clear, table.clone, table.maxn, table.move, table.pack, table.find, table.sort, table.getn
local PackSize, Reverse, SUnpack, Gmatch, Format, Lower, Split, Match, Upper, Byte, Char, Pack, Gsub, SFind, Rep, Sub, Len = string.packsize, string.reverse, string.unpack, string.gmatch, string.format, string.lower, string.split, string.match, string.upper, string.byte, string.char, string.pack, string.gsub, string.find, string.rep, string.sub, string.len
local Countlz, Rrotate, Replace, Lrotate, Countrz, Arshift, Extract, Lshift, Rshift, Btest, Band, Bnot, Bxor, Bor = bit32.countlz, bit32.rrotate, bit32.replace, bit32.lrotate, bit32.countrz, bit32.arshift, bit32.extract, bit32.lshift, bit32.rshift, bit32.btest, bit32.band, bit32.bnot, bit32.bxor, bit32.bor
local NfcNormalize, NfdNormalize, CharPattern, CodePoint, Graphemes, Offset, Codes, Char, Len = utf8.nfcnormalize, utf8.nfdnormalize, utf8.charpattern, utf8.codepoint, utf8.graphemes, utf8.offset, utf8.codes, utf8.char, utf8.len
local Isyieldable, Running, Status, Create, Resume, Close, Yield, Wrap = coroutine.isyieldable, coroutine.running, coroutine.status, coroutine.create, coroutine.resume, coroutine.close, coroutine.yield, coroutine.wrap
local Desynchronize, Synchronize, Cancel, Delay, Defer, Spawn, Wait = task.desynchronize, task.synchronize, task.cancel, task.delay, task.defer, task.spawn, task.wait
--
local Client = Players.LocalPlayer
local ClientCharacter = Client.Character
local Mouse = Client:GetMouse()
--
local LuckyHub, Visuals, Movement, Utility, Desync, Visualisation, Math = {
    Configs = {},
    Connections = {},
    SoundEffects = {
        ["Skeet"] = "5633695679",
        ["Neverlose"] = "6534948092",
        ["Rust"] = "1255040462",
        ["Minecraft"] = "4018616850",
    },
    Locals = {
        Target = nil,
        AimAssistTarget = nil,
        HitPart = nil,
        AimAssistHitPart = nil,
        AimPoint = nil,
        AimAssistAimPoint = nil,
        Position = nil,
        ToolConnection = {nil, nil},
        UniversalTarget = nil,
        UniversalHitPart = nil,
        TriggerTarget = nil,
        TriggerTick = tick(),
        LastStutter = tick(),
        PreviousGun = nil,
        PreviousAmmo = 999,
        PreviousTargetHealth = 100,
        Spectating = false,
        AimviewerTarget = nil,
        Client = {},
        Tool = {},
        PlayerHealth = {},
        OriginalVelocity = {},
        AimOffset = nil,
    },
    Folders = {
        ["Part Chams"] = Instance.new("Folder", Workspace),
    },
    Shared = {
        Build = "Buyer",
        Version = "Public",
        FPS = 0,
        Ping = 0,
        Safe = true,
    },
}, {
    Bases = {},
    Base = {},
}, {
    Velocity = 0,
    State = {},
    LastPosition = CFrame.new(),
    FakeLagTick = 0,
    SleepNet = false,
    DesyncVelocityAmount = 1,
    DesyncVelocityDirection = false,
    TargetPosition = nil,
    StrafeCalculation = 0,
}, {
}, {
    SmoothValue = 0,
    Rotate = Vector3.new(720, 360, 720),
    Rotate2 = Vector3.new(),
    Real = {
        CFrame = nil,
        Velocity = nil,
        RotVelocity = nil
    },
    Fake = {
        CFrame = CFrame.new(),
        Velocity = Vector3.new(),
        RotVelocity = Vector3.new()
    },
    Sent = CFrame.new()
}, {
    Character = nil,
    Texture = 5,
    LastUpdate = {}
}, {
}
--
do -- Folders
    if not isfolder("LuckyHub") then
        makefolder("LuckyHub")
    end
    --
    if not isfolder("LuckyHub/Configs") then
        makefolder("LuckyHub/Configs")
    end
    --
    if not isfolder("LuckyHub/Configs/Public") then
        makefolder("LuckyHub/Configs/Public")
    end
    --
    if not isfolder("LuckyHub/Configs/Private") then
        makefolder("LuckyHub/Configs/Private")
    end
end
--
if Client and ClientCharacter then
	if trimmed_stamp ~= "6/12/2024" then
		Client:Kick("Da Hood has updated please ping me to update the script.")
	end
end
--
for Index, Player in pairs(Players:GetPlayers()) do
    if Player ~= Client then
        ESP.NewPlayer(Player)
    end
end
--
Players.PlayerAdded:Connect(function(Player)
    ESP.NewPlayer(Player)
end)
--
Players.PlayerRemoving:Connect(function(Player)
    ESP.RemovePlayer(Player)
end)
--
if CurrentGame.Name == "Hood Customs" then
    for _, Connection in next, getconnections(Workspace.CurrentCamera.Changed) do
        Wait()
        Connection:Disable()
    end

    for _, Connection in next, getconnections(Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame")) do
        Wait()
        Connection:Disable()
    end

    LuckyHub.Locals.AimOffset = Vector3.new(25, 100, 25)
else
    LuckyHub.Locals.AimOffset = Vector3.new(0, 0, 0)
end
--
do -- Saving
    LuckyHub.Locals.FieldOfView = Workspace.CurrentCamera.FieldOfView
    LuckyHub.Locals.Lighting = {}
    --
    for Index, Value in pairs({"Ambient", "OutdoorAmbient", "Brightness", "ClockTime", "ColorShift_Bottom", "ColorShift_Top", "ExposureCompensation", "FogColor", "FogEnd", "FogStart"}) do
        LuckyHub.Locals.Lighting[Value] = Lighting[Value]
    end
    --
    LuckyHub.Locals.FieldOfView = Workspace.CurrentCamera.FieldOfView
end
--
local function getObject(assetId)
    local success, result = pcall(function()
        return game:GetObjects("rbxassetid://"..assetId)[1]
    end)
    if success then
        return result
    else
        return nil
    end
end

local assets = {
    { id = "17374709291", name = "SlashEffect" },
    { id = "17374621998", name = "LightningEffect" },
    { id = "17374631656", name = "SolarEffect" },
    { id = "17374691160", name = "GalaxyEffect" },
    { id = "17386949039", name = "WaterEffect" },
}

for _, asset in ipairs(assets) do
    local object = getObject(asset.id)
    if object then
        object.Parent = ReplicatedStorage
        object.Name = asset.name
        if object:FindFirstChild("Attachment") then
            _G[asset.name] = object.Attachment
        end
    end
end
--
do -- Circles
    for Index = 1, 4 do
        local Circle = Index == 1 and "SilentAimFOV" or Index == 2 and "AimAssistFOV" or Index == 3 and "UniversalAimAssistFOV" or "TriggerBotFOV"
        --
        Visuals[Circle .. "Circle"] = Drawing.new("Circle")
        Visuals[Circle .. "Circle"].Filled = false
        Visuals[Circle .. "Circle"].Thickness = 1
        Visuals[Circle .. "Circle"].ZIndex = 60
        Visuals[Circle .. "Circle"].Visible = false
        --
        Visuals[Circle .. "Outline"] = Drawing.new("Circle")
        Visuals[Circle .. "Outline"].Thickness = 4
        Visuals[Circle .. "Outline"].Filled = false
        Visuals[Circle .. "Outline"].ZIndex = 59
        Visuals[Circle .. "Outline"].Visible = false
    end
end
--
local TracerLine = Drawing.new("Line")
TracerLine.Transparency = 0.5
TracerLine.Thickness = 2
TracerLine.Color = Color3.fromRGB(0, 255, 0)
--
local PredictionDot = Drawing.new("Circle")
local PredictionLine = Drawing.new("Line")
--
        function Movement:Update()
            local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Client)
            --
            if Library.Flags["MovementCFrame"] then
                if LuckyHub:ClientAlive(Client, Object, Humanoid) then
                    RootPart.CFrame = RootPart.CFrame + Humanoid.MoveDirection * Library.Flags["MovementCFrameAmount"] / 25
                end
            end
            --
            if Library.Flags["MovementBhop"] then
                if LuckyHub:ClientAlive(Client, Object, Humanoid) then
                    Humanoid.Jump = true
                end
            end
            --
            if LuckyHub:ClientAlive(Client, Object, Humanoid) then
                if Library.Flags["MovementNoJumpCooldown"] then
                    Humanoid.UseJumpPower = false
                else
                    Humanoid.UseJumpPower = true
                end
            end
            --
            if LuckyHub:ClientAlive(Client, Object, Humanoid) then
                if Library.Flags["MovementNoSlowdown"] then
                    local SlowdownEffects = {
                        "NoWalkSpeed",
                        "NoJumping",
                        "ReduceWalk"
                    }
                    for _, effect in next, SlowdownEffects do
                        if ClientCharacter.BodyEffects.Movement:FindFirstChild(effect) then
                            ClientCharacter.BodyEffects.Movement:FindFirstChild(effect):Destroy()
                        end
                    end
                    if ClientCharacter.BodyEffects.Reload.Value == true then
                        ClientCharacter.BodyEffects.Reload.Value = false
                    end
                end
            end
            --
            if Library.Flags["MovementFly"] then
                local FlyNum = Library.Flags["MovementFlySpeed"]
                --
                local Travel = Vector3.new(0, 0, 0)
                local LookVector = workspace.CurrentCamera.CFrame.LookVector
                --
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    Travel += LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    Travel -= LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    Travel += Vector3.new(-LookVector.Z, 0, LookVector.X)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    Travel += Vector3.new(LookVector.Z, 0, -LookVector.X)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    Travel += Vector3.new(0, 1, 0)
                end
                --
                if Travel.Unit.X == Travel.Unit.X then
                    RootPart.Anchored = false
                    RootPart.Velocity = Travel.Unit * FlyNum
                else
                    RootPart.Velocity = Vector3.new(0, 0, 0)
                    RootPart.Anchored = true
                end
            else
                if RootPart.Anchored then
                    RootPart.Anchored = false
                end
            end
        end
--
        function Visuals:Refresh()
            if Library.Flags["VisualsAmbience"] then
                Lighting.Ambient = Library.Flags["VisualsAmbienceIndoor"]
                Lighting.OutdoorAmbient = Library.Flags["VisualsAmbienceOutdoor"]
            else
                Lighting.Ambient = LuckyHub.Locals.Lighting["Ambient"]
                Lighting.OutdoorAmbient = LuckyHub.Locals.Lighting["OutdoorAmbient"]
            end
            --
            if Library.Flags["VisualsFog"] then
                Lighting.FogColor = Library.Flags["VisualsFogColor"]
                Lighting.FogEnd = Library.Flags["VisualsFogEnd"]
                Lighting.FogStart = Library.Flags["VisualsFogStart"]
            else
                Lighting.FogColor = LuckyHub.Locals.Lighting["FogColor"]
                Lighting.FogEnd = LuckyHub.Locals.Lighting["FogEnd"]
                Lighting.FogStart = LuckyHub.Locals.Lighting["FogStart"]
            end
            --
            if Library.Flags["VisualsShadows"] then
                Lighting.GlobalShadows = false
            else
                Lighting.GlobalShadows = true
            end
        end
        --
        function Visuals:ToolRefresh()
            local tool = ClientCharacter:FindFirstChildOfClass("Tool")
            --
            if not tool then return end
            --
            if Library.Flags["WeaponVisualsEnabled"] then
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("MeshPart") then
                        LuckyHub.Locals.Tool[v] = {
                            TextureID = v.TextureID,
                            Color = v.Color,
                            Material = v.Material,
                            Transparency = v.Transparency,
                        }
                        v.TextureID = ""
                        v.Material = Enum.Material[Library.Flags["WeaponVisualsMaterial"]]
                        v.Color = Library.Flags["WeaponVisualsColor"]
                        v.Transparency = Library.Flags["WeaponVisualsTransparency"]
                    end
                end
            else
                for meshpart, values in pairs(LuckyHub.Locals.Tool) do
                    if meshpart:IsA("MeshPart") and meshpart:IsDescendantOf(tool) then
                        meshpart.TextureID = values.TextureID
                        meshpart.Color = values.Color
                        meshpart.Material = values.Material
                        meshpart.Transparency = values.Transparency
                    end
                end
            end
        end
        --
        function Visuals:ClientRefresh()
            if Library.Flags["ClientPlayerChams"] then
                for i, v in pairs(ClientCharacter:GetChildren()) do
                    if v:IsA("BasePart") then
                        LuckyHub.Locals.Client[v] = {
                            Color = v.Color,
                            Material = v.Material
                        }
                        v.Color = Library.Flags["ClientPlayerChamsColor"]
                        v.Material = "ForceField"
                    end
                end
                --
                for _, part in ipairs(ClientCharacter:GetDescendants()) do
                    if part:IsA("Accessory") then
                        for _, accPart in ipairs(part:GetDescendants()) do
                            if accPart:IsA("BasePart") then
                                LuckyHub.Locals.Client[accPart] = {
                                    Color = accPart.Color,
                                    Material = accPart.Material
                                }
                                accPart.Color = Library.Flags["ClientPlayerChamsColor"]
                                accPart.Material = "ForceField"
                            end
                        end
                    end
                end
            else
                for part, values in pairs(LuckyHub.Locals.Client) do
                    if part:IsA("BasePart") then
                        part.Color = values.Color
                        part.Material = values.Material
                    end
                end
            end
        end
        --
        function Visuals:InGameRefresh()
            if Client:FindFirstChild("PlayerGui") and Client.PlayerGui:FindFirstChild("MainScreenGui") and Client.PlayerGui.MainScreenGui:FindFirstChild("Bar") then
                local Bar = Client.PlayerGui.MainScreenGui:FindFirstChild("Bar")
                --
                local Energy = Bar:FindFirstChild("Energy")
                local Health = Bar:FindFirstChild("HP")
                local Armor = Bar:FindFirstChild("Armor")
                --
                local OldEnergy = Color3.fromRGB(182, 182, 9)
                local OldHealth = Color3.fromRGB(36, 182, 3)
                local OldArmor = Color3.fromRGB(0, 136, 194)
                local OldFireArmor = Color3.fromRGB(253, 121, 33)
                --
                if Library.Flags["InGameUIVisuals"] then
                    Energy.bar.BackgroundColor3 = Library.Flags["InGameEnergyColor"]
                    Health.bar.BackgroundColor3 = Library.Flags["InGameHealthColor"]
                    Armor.bar.BackgroundColor3 = Library.Flags["InGameArmorColor"]
                    Armor.firebar.BackgroundColor3 = Library.Flags["InGameFireArmorColor"]
                else
                    Energy.bar.BackgroundColor3 = OldEnergy
                    Health.bar.BackgroundColor3 = OldHealth
                    Armor.bar.BackgroundColor3 = OldArmor
                    Armor.firebar.BackgroundColor3 = OldFireArmor
                end
            end
        end
--
        do -- Utility
            function Utility:MousePosition()
                return UserInputService:GetMouseLocation()
            end
            --
            function Utility:ThreadFunction(Func, Name, ...)
                local Func = Name and function()
                    local Passed, Statement = pcall(Func)
                    --
                    if not Passed and not LuckyHub.Shared.Safe then
                        warn("LuckyHub:\n", "              " .. Name .. ":", Statement)
                    end
                end or Func
                local Thread = Create(Func)
                --
                Resume(Thread, ...)
                return Thread
            end
            --
            function Utility:Instance(InstanceType, InstanceProperties)
                local Object = Instance.new(InstanceType)
                --
                for Index, Value in pairs(InstanceProperties) do
                    Object[Index] = Value
                end
                --
                return Object
            end
            --
            function Utility:RemoveInstance(Object)
                Object:Remove()
            end
            --
            function Utility:GetConfig()
                local Config = ""
                for Index, Value in pairs(Library.Flags) do
                    if
                        Index ~= "ConfigConfig_List"
                        and Index ~= "ConfigConfig_Load"
                        and Index ~= "ConfigConfig_Save"
                    then
                        local Value2 = Value
                        local Final = ""
                        --
                        if typeof(Value2) == "Color3" then
                            local hue, sat, val = Value2:ToHSV()
                            --
                            Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, 1)
                        elseif typeof(Value2) == "table" and Value2.Color and Value2.Transparency then
                            local hue, sat, val = Value2.Color:ToHSV()
                            --
                            Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, Value2.Transparency)
                        elseif typeof(Value2) == "table" and Value.Mode then
                            local Values = Value.current
                            --
                            Final = ("key(%s,%s,%s)"):format(Values[1] or "nil", Values[2] or "nil", Value.Mode)
                        elseif Value2 ~= nil then
                            if typeof(Value2) == "boolean" then
                                Value2 = ("bool(%s)"):format(tostring(Value2))
                            elseif typeof(Value2) == "table" then
                                local New = "table("
                                --
                                for Index2, Value3 in pairs(Value2) do
                                    New = New .. Value3 .. ","
                                end
                                --
                                if New:sub(#New) == "," then
                                    New = New:sub(0, #New - 1)
                                end
                                --
                                Value2 = New .. ")"
                            elseif typeof(Value2) == "string" then
                                Value2 = ("string(%s)"):format(Value2)
                            elseif typeof(Value2) == "number" then
                                Value2 = ("number(%s)"):format(Value2)
                            end
                            --
                            Final = Value2
                        end
                        --
                        Config = tostring(Config .. tostring(Index) .. ": " .. tostring(Final) .. "\n")
                        
                    end
                end
                --
                return Config
            end
            --
            function Utility:LoadConfig(Config)
                for i = 1, 10 do 
                    local Table = string.split(Config, "\n")
                    local Table2 = {}
                    for Index, Value in pairs(Table) do
                        local Table3 = string.split(Value, ":")
                        --
                        if Table3[1] ~= "ConfigConfig_List" and #Table3 >= 2 then
                            local Value = Table3[2]:sub(2, #Table3[2])
                            --
                            if Value:sub(1, 3) == "rgb" then
                                local Table4 = string.split(Value:sub(5, #Value - 1), ",")
                                --
                                Value = Table4
                            elseif Value:sub(1, 3) == "key" then
                                local Table4 = string.split(Value:sub(5, #Value - 1), ",")
                                --
                                if Table4[1] == "nil" and Table4[2] == "nil" then
                                    Table4[1] = nil
                                    Table4[2] = nil
                                end
                                --
                                Value = Table4
                            elseif Value:sub(1, 4) == "bool" then
                                local Bool = Value:sub(6, #Value - 1)
                                --
                                Value = Bool == "true"
                            elseif Value:sub(1, 5) == "table" then
                                local Table4 = string.split(Value:sub(7, #Value - 1), ",")
                                --
                                Value = Table4
                            elseif Value:sub(1, 6) == "string" then
                                local String = Value:sub(8, #Value - 1)
                                --
                                Value = String
                            elseif Value:sub(1, 6) == "number" then
                                local Number = tonumber(Value:sub(8, #Value - 1))
                                --
                                Value = Number
                            end
                            --
                            Table2[Table3[1]] = Value
                        end
                    end 
                    --
                    for i, v in pairs(Table2) do
                        if Flags[i] then
                            if typeof(Flags[i]) == "table" then
                                Flags[i]:Set(v)
                            else
                                Flags[i](v)
                            end
                        end
                    end
                end
            end
        end
--
        do -- Math
            function Math:RoundVector(Vector)
                return Vector2.new(Round(Vector.X), Round(Vector.Y))
            end
        end
--
        do -- Functions
            function LuckyHub:GetCharacter(Player)
                return Player.Character
            end
            --
            function LuckyHub:GetHumanoid(Player, Character)
                return Character:FindFirstChildOfClass("Humanoid")
            end
            --
            function LuckyHub:GetRootPart(Player, Character, Humanoid)
                return Humanoid.RootPart
            end
            --
            function LuckyHub:GetHealth(Player, Character, Humanoid)
                if Humanoid then
                    return Clamp(Humanoid.Health, 0, Humanoid.MaxHealth), Humanoid.MaxHealth
                end
            end
            --
            function LuckyHub:ClientAlive(Player, Character, Humanoid)
                local Health, MaxHealth = LuckyHub:GetHealth(Player, Character, Humanoid)
                --
                return (Health > 0)
            end
            --
            function LuckyHub:ValidateClient(Player)
                local Object = LuckyHub:GetCharacter(Player)
                local Humanoid = (Object and LuckyHub:GetHumanoid(Player, Object))
                local RootPart = (Humanoid and LuckyHub:GetRootPart(Player, Object, Humanoid))
                --
                return Object, Humanoid, RootPart
            end
            --
            function LuckyHub:GetOrigin(Origin)
                if Origin == "Head" then
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Client)
                    local Head = Object:FindFirstChild("Head")
                    --
                    if Head and Head:IsA("RootPart") then
                        return Head.CFrame.Position
                    end
                elseif Origin == "Torso" then
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Client)
                    --
                    if RootPart then
                        return RootPart.CFrame.Position
                    end
                end
                --
                return Workspace.CurrentCamera.CFrame.Position
            end
            --
            function LuckyHub:GetIgnore(Unpacked)
                return
            end
            --
            function LuckyHub:RayCast(Part, Origin, Ignore, Distance)
                local Ignore = Ignore or {}
                local Distance = Distance or 2000
                --
                local Cast = Ray.new(Origin, (Part.Position - Origin).Unit * Distance)
                local Hit = Workspace:FindPartOnRayWithIgnoreList(Cast, Ignore)
                if Hit and Hit:IsDescendantOf(Part.Parent) then
                    return true, Hit
                else
                    return false, Hit
                end
                return false, nil
            end
            --
            function LuckyHub:CheckFriend(Player)
                if Player:IsFriendsWith(Client.UserId) then
                    return false;
                else
                    return true;
                end
            end
            --
            function LuckyHub:GetTeam(Player)
                return Player.Team ~= nil and Player.Team
            end
            --
            function LuckyHub:CheckTeam(Player1, Player2)
                return (LuckyHub:GetTeam(Player1) ~= LuckyHub:GetTeam(Player2))
            end
            --
            function LuckyHub:GetLatency()
                return (Stats.PerformanceStats.Ping:GetValue() / 1000)
            end
            --
            function LuckyHub:CheckCrew(Player)
                local a = Client:WaitForChild("DataFolder"):FindFirstChild("Crew", true)
                local b = Player:WaitForChild("DataFolder"):FindFirstChild("Crew", true)
                --
                if a and b then
                    if (a.Value ~= "" and b.Value ~= "") and (a.Value == b.Value) then
                        return false;
                    end
                else
                    return true
                end
            end
            --
            function LuckyHub:UpdateFOV()
                local MousePosition = Utility:MousePosition()
                --
                do -- Universal
                    if not (Visuals.TriggerBotFOVCircle) or not (Visuals.SilentAimFOVCircle) or not (Visuals.SilentAimFOVOutline) or not (Visuals.UniversalAimAssistFOVCircle) or not (Visuals.AimAssistFOVCircle) or not (TracerLine) then
                        return
                    end
                    --
                    Visuals.TriggerBotFOVCircle.Visible = Library.Flags["UniversalDeadzoneFOVEnabled"] and true or false
                    Visuals.TriggerBotFOVCircle.Radius = Library.Flags["UniversalAimAssistDeadzone"] * 3
                    Visuals.TriggerBotFOVCircle.NumSides = 1000
                    Visuals.TriggerBotFOVCircle.Transparency = Library.Flags["UniversalDeadzoneFOVTransparency"]
                    Visuals.TriggerBotFOVCircle.Color = Library.Flags["UniversalDeadzoneColor"]
                    Visuals.TriggerBotFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    --
                    Visuals.TriggerBotFOVCircle.Visible = Library.Flags["UniversalDeadzoneFOVEnabled"] and true or false
                    Visuals.TriggerBotFOVCircle.Radius = Library.Flags["UniversalAimAssistDeadzone"] * 3 - 1.5
                    Visuals.TriggerBotFOVCircle.NumSides = 1000
                    Visuals.TriggerBotFOVCircle.Transparency = 1
                    Visuals.TriggerBotFOVCircle.Color = Color3.fromRGB(0, 0, 0)
                    Visuals.TriggerBotFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    --
                    Visuals.UniversalAimAssistFOVCircle.Visible = Library.Flags["UniversalAimAssistFOVEnabled"] and Library.Flags["UniversalAimAssistUseFOV"] and true or false
                    Visuals.UniversalAimAssistFOVCircle.Radius = Library.Flags["UniversalAimAssistFieldOfView"] * 3
                    Visuals.UniversalAimAssistFOVCircle.NumSides = 1000
                    Visuals.UniversalAimAssistFOVCircle.Transparency = Library.Flags["UniversalAimAssistFOVTransparency"]
                    Visuals.UniversalAimAssistFOVCircle.Color = Library.Flags["UniversalAimAssistColor"]
                    Visuals.UniversalAimAssistFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    --
                    Visuals.UniversalAimAssistFOVOutline.Visible = Library.Flags["UniversalAimAssistFOVEnabled"] and Library.Flags["UniversalAimAssistUseFOV"] and true or false
                    Visuals.UniversalAimAssistFOVOutline.Radius = Library.Flags["UniversalAimAssistFieldOfView"] * 3 - 1.5
                    Visuals.UniversalAimAssistFOVOutline.NumSides = 1000
                    Visuals.UniversalAimAssistFOVOutline.Transparency = 1
                    Visuals.UniversalAimAssistFOVOutline.Color = Color3.fromRGB(0, 0, 0)
                    Visuals.UniversalAimAssistFOVOutline.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                end
                --
                Visuals.SilentAimFOVCircle.Visible = Library.Flags["SilentAimFOVEnabled"] and Library.Flags["SilentAimUseFOV"] and true or false
                Visuals.SilentAimFOVCircle.Radius = Library.Flags["SilentAimFieldOfView"] * 3
                Visuals.SilentAimFOVCircle.Filled = Library.Flags["SilentAimFOVFilled"]
                Visuals.SilentAimFOVCircle.NumSides = 1000
                Visuals.SilentAimFOVCircle.Transparency = Library.Flags["SilentAimFieldOfViewTransparency"]
                Visuals.SilentAimFOVCircle.Color = Library.Flags["SilentAimColor"]
                --
                if Library.Flags["SilentAimFOVType"] == "Mouse" then
                    Visuals.SilentAimFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    Visuals.SilentAimFOVOutline.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                else
                    if LuckyHub.Locals.Target ~= nil and LuckyHub.Locals.AimPoint ~= nil then
                        local Position = workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.AimPoint)
                        --
                        Visuals.SilentAimFOVCircle.Position = Vector2.new(Position.X, Position.Y)
                        Visuals.SilentAimFOVOutline.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    else
                        Visuals.SilentAimFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                        Visuals.SilentAimFOVOutline.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                    end
                end
                --
                Visuals.SilentAimFOVOutline.Visible = Library.Flags["SilentAimFOVEnabled"] and Library.Flags["SilentAimUseFOV"] and true or false
                Visuals.SilentAimFOVOutline.Radius = Library.Flags["SilentAimFieldOfView"] * 3 - 1.5
                Visuals.SilentAimFOVOutline.Filled = false
                Visuals.SilentAimFOVOutline.NumSides = 1000
                Visuals.SilentAimFOVOutline.Transparency = 1
                Visuals.SilentAimFOVOutline.Color = Color3.fromRGB(0, 0, 0)
                --
                TracerLine.Visible = Library.Flags["TracerEnabled"] and true or false
                TracerLine.Transparency = Library.Flags["TracerTransparency"]
                TracerLine.Thickness = Library.Flags["TracerThickness"]
                TracerLine.Color = Library.Flags["TracerColor"]
                TracerLine.From = Vector2.new(MousePosition.X, MousePosition.Y)
                if LuckyHub.Locals.Target ~= nil and LuckyHub.Locals.AimPoint ~= nil then
                    local Position, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.AimPoint)
                    --
                    if OnScreen and Library.Flags["SilentAimEnabled"] then
                        TracerLine.To = Vector2.new(Position.X, Position.Y)
                    else
                        TracerLine.Visible = false
                    end
                else
                    TracerLine.Visible = false
                end
                --
                Visuals.AimAssistFOVCircle.Visible = Library.Flags["AimAssistFOVEnabled"] and Library.Flags["AimAssistUseFOV"] and true or false
                Visuals.AimAssistFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                Visuals.AimAssistFOVCircle.Radius = Library.Flags["AimAssistFieldOfView"] * 3
                Visuals.AimAssistFOVCircle.Filled = Library.Flags["AimAssistFOVFilled"]
                Visuals.AimAssistFOVCircle.NumSides = 1000
                Visuals.AimAssistFOVCircle.Transparency = Library.Flags["AimAssistFieldOfViewTransparency"]
                Visuals.AimAssistFOVCircle.Color = Library.Flags["AimAssistColor"]
                --
                Visuals.AimAssistFOVOutline.Visible = Library.Flags["AimAssistFOVEnabled"] and Library.Flags["AimAssistUseFOV"] and true or false
                Visuals.AimAssistFOVOutline.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                Visuals.AimAssistFOVOutline.Radius = Library.Flags["AimAssistFieldOfView"] * 3 - 1.5
                Visuals.AimAssistFOVOutline.Filled = false
                Visuals.AimAssistFOVOutline.NumSides = 1000
                Visuals.AimAssistFOVOutline.Transparency = 1
                Visuals.AimAssistFOVOutline.Color = Color3.fromRGB(0, 0, 0)
            end
            --
            function LuckyHub:FilterObject(Object)
                if string.find(Object.Name, "Gun") then
                    return
                end
                if Object:IsA("Part") or Object:IsA("MeshPart") then
                    return true
                end
            end
            --
            function LuckyHub:GetBodyParts(Character, RootPart, Indexes)
                local Parts = {}
                local Hitboxes = {"Head", "Torso", "Arms", "Legs"}
                --
                for Index, Part in pairs(Character:GetChildren()) do
                    if Part:IsA("BasePart") and Part ~= RootPart then
                        if Find(Hitboxes, "Head") and Part.Name:lower():find("head") then
                            Parts[Indexes and Part.Name or #Parts + 1] = Part
                        elseif Find(Hitboxes, "Torso") and Part.Name:lower():find("torso") then
                            Parts[Indexes and Part.Name or #Parts + 1] = Part
                        elseif Find(Hitboxes, "Arms") and Part.Name:lower():find("arm") then
                            Parts[Indexes and Part.Name or #Parts + 1] = Part
                        elseif Find(Hitboxes, "Legs") and Part.Name:lower():find("leg") then
                            Parts[Indexes and Part.Name or #Parts + 1] = Part
                        elseif (Find(Hitboxes, "Arms") and Part.Name:lower():find("hand")) or (Find(Hitboxes, "Legs ") and Part.Name:lower():find("foot")) then
                            Parts[Indexes and Part.Name or #Parts + 1] = Part
                        end
                    end
                end
                --
                return Parts
            end
            --
            function LuckyHub:GetTarget()
                local Target, Closest = nil, Huge
                local MousePosition = Utility:MousePosition()
                --
                for _, Player in ipairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Player)
                    --
                    if not (Object and Humanoid and RootPart) then continue end
                    --
                    if not Library.Flags["SilentAimEnabled"] then continue end
                    if Library.Flags["WallCheck"] and not LuckyHub:RayCast(RootPart, LuckyHub:GetOrigin(Origin), {LuckyHub:GetCharacter(Client), LuckyHub:GetIgnore(true)}) then continue end
                    if Library.Flags["AliveCheck"] and not LuckyHub:ClientAlive(Player, Object, Humanoid) then continue end
                    if Library.Flags["ForceFieldCheck"] and Object:FindFirstChildOfClass("ForceField") then continue end
                    if Library.Flags["KnockedCheck"] and Player.Character:FindFirstChild("BodyEffects") and Player.Character.BodyEffects["K.O"].Value or Player.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil then continue end
                    if Library.Flags["FriendCheck"] and  not LuckyHub:CheckFriend(Player) or Library:GetPlayerFlag(Player) == "Friend" then continue end
                    if Library.Flags["CrewCheck"] and not LuckyHub:CheckCrew(Player) then continue end
                    --
                    local Position, OnScreen = Workspace.CurrentCamera:WorldToScreenPoint(RootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                    --
                    if Library.Flags["SilentAimUseFOV"] and not (Distance <= Visuals.SilentAimFOVCircle.Radius) then continue end
                    --
                    if (Distance < Closest) and OnScreen then
                        Target = Player
                        Closest = Distance
                    end
                end
                LuckyHub.Locals.Target = Target
            end
            --
            function LuckyHub:GetAimAssistTarget()
                local Target, Closest = nil, Huge
                local MousePosition = Utility:MousePosition()
                --
                for _, Player in ipairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Player)
                    --
                    if not (Object and Humanoid and RootPart) then continue end
                    --
                    if not Library.Flags["AimAssistEnabled"] then continue end
                    if Library.Flags["AimAssistSafeMode"] and (UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter or not LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid"))) then continue end
                    if Library.Flags["WallCheck"] and not LuckyHub:RayCast(RootPart, LuckyHub:GetOrigin(Origin), {LuckyHub:GetCharacter(Client), LuckyHub:GetIgnore(true)}) then continue end
                    if Library.Flags["AliveCheck"] and not LuckyHub:ClientAlive(Player, Object, Humanoid) then continue end
                    if Library.Flags["ForceFieldCheck"] and Object:FindFirstChildOfClass("ForceField") then continue end
                    if Library.Flags["KnockedCheck"] and Player.Character:FindFirstChild("BodyEffects") and Player.Character.BodyEffects["K.O"].Value or Player.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil then continue end
                    if Library.Flags["FriendCheck"] and not LuckyHub:CheckFriend(Player) or Library:GetPlayerFlag(Player) == "Friend" then continue end
                    if Library.Flags["CrewCheck"] and not LuckyHub:CheckCrew(Player) then continue end
                    --
                    local Position, OnScreen = Workspace.CurrentCamera:WorldToScreenPoint(RootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                    --
                    if Library.Flags["AimAssistUseFOV"] and not (Distance <= Visuals.AimAssistFOVCircle.Radius) then continue end
                    --
                    if (Distance < Closest) and OnScreen then
                        Target = Player
                        Closest = Distance
                    end
                end
                LuckyHub.Locals.AimAssistTarget = Target
            end
            --
            function LuckyHub:GetClosestPart(Character)
                local BodyPart, ClosestDistance = nil, Huge
                --
                if (Character and Character:GetChildren()) then
                    for Index, Value in pairs(Character:GetChildren()) do
                        if Value:IsA("BasePart") then
                            local Position = Workspace.CurrentCamera:WorldToScreenPoint(Value.Position)
                            local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    
                            if Distance < ClosestDistance then
                                ClosestDistance = Distance
                                BodyPart = Value
                            end
                        end
                    end
                end
                return BodyPart
            end
            --
            function LuckyHub:GetClosestPoint(Part)
                local Transform = Part.CFrame:PointToObjectSpace(Mouse.Hit.Position)
                local HalfSize = Part.Size * 0.5
                --
                local ClosestPoint = Part.CFrame:PointToWorldSpace(Vector3.new(
                    math.clamp(Transform.x, -HalfSize.x, HalfSize.x),
                    math.clamp(Transform.y, -HalfSize.y, HalfSize.y),
                    math.clamp(Transform.z, -HalfSize.z, HalfSize.z)
                ))
                --
                return ClosestPoint
            end
            --
            function LuckyHub:IsUsingAntiAim(Player)
                if Player and Player.Character then
                    if Player.Character:FindFirstChild("HumanoidRootPart") then
                        if (Player.Character.HumanoidRootPart.Velocity.Y < -5 and Player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall) or Player.Character.HumanoidRootPart.Velocity.Y < -50 then
                            return true
                        elseif Player and (Player.Character.HumanoidRootPart.Velocity.X > 35 or Player.Character.HumanoidRootPart.Velocity.X < -35) then
                            return true
                        elseif Player and Player.Character.HumanoidRootPart.Velocity.Y > 60 then
                            return true
                        elseif Player and (Player.Character.HumanoidRootPart.Velocity.Z > 35 or Player.Character.HumanoidRootPart.Velocity.Z < -35) then
                            return true
                        elseif Player and (Player.Character.HumanoidRootPart.Velocity.X == 0 and Player.Character.HumanoidRootPart.Velocity.Y == 0 and Player.Character.HumanoidRootPart.Velocity.Z == 0) then
                            return true
                        else
                            return false
                        end
                    end
                end
            end
            --
            function LuckyHub:GetUniversalAimAssistTarget()
                local Target, Closest = nil, Huge
                local MousePosition = Utility:MousePosition()
                --
                for _, Player in ipairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Player)
                    --
                    if not (Object and Humanoid and RootPart) then continue end
                    --
                    if not Library.Flags["UniversalAimAssistEnabled"] then continue end
                    if Library.Flags["UniversalWallCheck"] and not LuckyHub:RayCast(RootPart, LuckyHub:GetOrigin(Library.Flags["UniversalAimAssistOrigin"]), {LuckyHub:GetCharacter(Client), LuckyHub:GetIgnore(true)}) then continue end
                    if Library.Flags["UniversalAliveCheck"] and not LuckyHub:ClientAlive(Player, Object, Humanoid) then continue end
                    if Library.Flags["UniversalForceFieldCheck"] and Object:FindFirstChildOfClass("ForceField") then continue end
                    if Library.Flags["UniversalTeamCheck"] and not LuckyHub:CheckTeam(Client, Player) then continue end
                    if Library.Flags["UniversalFriendCheck"] and not LuckyHub:CheckFriend(Player) or Library:GetPlayerFlag(Player) == "Friend" then continue end
                    --
                    local Position, OnScreen = Workspace.CurrentCamera:WorldToScreenPoint(RootPart.Position)
                    local ClientPosition = Workspace.CurrentCamera:WorldToScreenPoint(ClientCharacter.HumanoidRootPart.Position)
                    local Distance
                    if Library.Flags["UniversalAimAssistHitScan"] == "Mouse" then
                        Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                    else
                        Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(ClientPosition.X, ClientPosition.Y)).Magnitude
                    end
                    --
                    if Library.Flags["UniversalAimAssistUseFOV"] and not (Distance <= Visuals.UniversalAimAssistFOVCircle.Radius) then continue end
                    --
                    if (Distance < Closest) and OnScreen then
                        Target = Player
                        Closest = Distance
                    end
                end
                LuckyHub.Locals.UniversalTarget = Target
            end
            --
            function LuckyHub:GetTriggerBotTarget()
                local Targets = {}
                --
                local MouseLocation = Utility:MousePosition()
                --
                for Index, Player in ipairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Player)
                    --
                    if not (Object and Humanoid and RootPart) then continue end
                    --
                    if not Library.Flags["UniversalTriggerBotEnabled"] then continue end
                    if Library.Flags["UniversalWallCheck"] and not LuckyHub:RayCast(RootPart, LuckyHub:GetOrigin(Library.Flags["UniversalTriggerBotOrigin"]), {LuckyHub:GetCharacter(Client), LuckyHub:GetIgnore(true)}) then continue end
                    if Library.Flags["UniversalAliveCheck"] and not LuckyHub:ClientAlive(Player, Object, Humanoid) then continue end
                    if Library.Flags["UniversalForceFieldCheck"] and Object:FindFirstChildOfClass("ForceField") then continue end
                    if Library.Flags["UniversalTeamCheck"] and not LuckyHub:CheckTeam(Client, Player) then continue end
                    if Library.Flags["UniversalFriendCheck"] and not LuckyHub:CheckFriend(Player) or Library:GetPlayerFlag(Player) == "Friend" then continue end

                    for Index2, Part in pairs(LuckyHub:GetBodyParts(Object, RootPart, false)) do
                        Targets[#Targets + 1] = Part
                    end
                end
                --
                local PointRay = Workspace.CurrentCamera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y, 0)
                local Hit, Position, Normal, Material = Workspace:FindPartOnRayWithWhitelist(Ray.new(PointRay.Origin, PointRay.Direction * 1000), Targets, false, false)
                --
                if Hit then
                    LuckyHub.Locals.TriggerTarget = {
                        Part = Hit,
                        Position = Position,
                        Material = Material
                    }
                else
                    LuckyHub.Locals.TriggerTarget = nil
                end
            end
            --
            function LuckyHub:UniversalAimAssist()
                if LuckyHub.Locals.UniversalTarget and LuckyHub.Locals.UniversalTarget.Character then
                    if Library.Flags["UniversalAimAssistClosestPart"] then
                        LuckyHub.Locals.UniversalHitPart = tostring(LuckyHub:GetClosestPart(LuckyHub.Locals.UniversalTarget.Character))
                    else
                        LuckyHub.Locals.UniversalHitPart = Library.Flags["UniversalAimAssistHitPart"]
                    end
                    --
                    local MouseLocation = Utility:MousePosition()
                    local Position = Workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.UniversalTarget.Character[LuckyHub.Locals.UniversalHitPart].CFrame.Position + (LuckyHub.Locals.UniversalTarget.Character[LuckyHub.Locals.UniversalHitPart].Velocity * Library.Flags["UniversalAimAssistPredictionAmount"]))
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MouseLocation.X, MouseLocation.Y)).Magnitude
                    --
                    if ((tick() - LuckyHub.Locals.LastStutter) >= (Library.Flags["UniversalAimAssistStutter"] / 1000)) and (Distance >= Visuals.TriggerBotFOVCircle.Radius) then
                        LuckyHub.Locals.LastStutter = tick()
                        --
                        local MovePosition = Vector2.new(Position.X, Position.Y)
                        local MoveVector =  (MovePosition - MouseLocation)
                        local Smoothness = Vector2.new((Library.Flags["UniversalAimAssistXSmoothingAmount"] / 2), (Library.Flags["UniversalAimAssistYSmoothingAmount"] / 2))
                        --
                        local FinalVector = Vector2.new(MoveVector.X / Smoothness.X, MoveVector.Y / Smoothness.Y)
                        --
                        mousemoverel(FinalVector.X, FinalVector.Y)
                    end
                end
            end
            --
            function LuckyHub:TriggerBot()
                if LuckyHub.Locals.TriggerTarget then
                    local Tick = tick()
                    --
                    if ((Tick - LuckyHub.Locals.TriggerTick) >= (Library.Flags["UniversalTriggerBotInterval"] / 1000)) then
                        LuckyHub.Locals.TriggerTick = Tick
                        --
                        Delay(Library.Flags["UniversalTriggerBotDelay"] / 1000, function()
                            mouse1press()
                            task.Wait(0.05)
                            mouse1release()
                        end)
                    end
                end
            end
            --
            function LuckyHub:VelocityRecalculation(Mode)
                if Mode == "Silent Aim" then
                    if LuckyHub.Locals.Target and LuckyHub.Locals.Target.Character then
                        local Root = LuckyHub.Locals.Target.Character.HumanoidRootPart
                        local Character = LuckyHub.Locals.Target.Character
                        --
                        local CurrentPosition = Root.Position
                        local CurrentTime = tick() 
                        --
                        Wait()
                        --
                        local NewPosition = Root.Position
                        local NewTime = tick()
                        --
                        local DistanceTraveled = (NewPosition - CurrentPosition) 
                        --
                        local TimeInterval = NewTime - CurrentTime
                        local Velocity = DistanceTraveled / TimeInterval
                        CurrentPosition = NewPosition
                        CurrentTime = NewTime
                        --
                        return LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Position + Velocity * Library.Flags["SilentAimPredictionAmount"]
                    end
                else
                    if LuckyHub.Locals.AimAssistTarget and LuckyHub.Locals.AimAssistTarget.Character then
                        local Root = LuckyHub.Locals.AimAssistTarget.Character.HumanoidRootPart
                        local Character = LuckyHub.Locals.AimAssistTarget.Character
                        --
                        local CurrentPosition = Root.Position
                        local CurrentTime = tick() 
                        --
                        Wait()
                        --
                        local NewPosition = Root.Position
                        local NewTime = tick()
                        --
                        local DistanceTraveled = (NewPosition - CurrentPosition) 
                        --
                        local TimeInterval = NewTime - CurrentTime
                        local Velocity = DistanceTraveled / TimeInterval
                        CurrentPosition = NewPosition
                        CurrentTime = NewTime
                        --
                        return LuckyHub.Locals.Position + Velocity * Library.Flags["AimAssistPredictionAmount"]
                    end
                end
            end
            --
            function LuckyHub:MoveDirection(Mode)
                if Mode == "Silent Aim" then
                    if LuckyHub.Locals.Target and LuckyHub.Locals.Target.Character and LuckyHub.Locals.Position then
                        return LuckyHub.Locals.Position + ((LuckyHub.Locals.Target.Character.Humanoid.MoveDirection * LuckyHub.Locals.Target.Character.Humanoid.WalkSpeed) * Library.Flags["SilentAimPredictionAmount"])
                    end
                else
                    if LuckyHub.Locals.AimAssistTarget and LuckyHub.Locals.AimAssistTarget.Character then
                        return LuckyHub.Locals.AimAssistTarget.Character[LuckyHub.Locals.AimAssistHitPart].Position + ((LuckyHub.Locals.AimAssistTarget.Character.Humanoid.MoveDirection * LuckyHub.Locals.AimAssistTarget.Character.Humanoid.WalkSpeed) * Library.Flags["AimAssistPredictionAmount"])
                    end
                end
            end
            --
            function LuckyHub:AutoPrediction()
                if Library.Flags["SilentAimPredictionType"] == "Auto" then
                    local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                    local split = Split(pingvalue, '(')
                    local ping = tonumber(split[1])
                    --
                    local prediction = (0.0006025 * ping) + 0.07892
                    --
                    Library.Flags["SilentAimPredictionAmount"] = prediction
                end
            end
            --
            function LuckyHub:CalculateAimpoint()
                if LuckyHub.Locals.Target and LuckyHub.Locals.Target.Character then
                    local MousePosition = Utility:MousePosition()
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(LuckyHub.Locals.Target)
                    local Position, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                    --
                    if Library.Flags["SilentAimUseFOV"] and not (Distance <= Visuals.SilentAimFOVCircle.Radius) then
                        Visuals.SilentAimFOVCircle.Position = Vector2.new(MousePosition.X, MousePosition.Y)
                        Cursor.mode = "mouse"
                        return
                    end
                    --
                    if (Library.Flags["AliveCheck"] and not LuckyHub:ClientAlive(LuckyHub.Locals.Target, Object, Humanoid)) then
                        return
                    end
                    --
                    if (Library.Flags["KnockedCheck"] and Object:FindFirstChild("BodyEffects") and Object.BodyEffects["K.O"].Value or Object:FindFirstChild("GRABBING_CONSTRAINT") ~= nil) then
                        return
                    end
                    --
                    if (Library.Flags["CrewCheck"] and not LuckyHub:CheckCrew(LuckyHub.Locals.Target)) then
                        return
                    end
                    --
                    if Library.Flags["TargetMode"] == "FOV" then
                        if Library.Flags["SilentAimEnabled"] == false then return end
                    end
                    --
                    if Library.Flags["SilentAimClosestPart"] and Library.Flags["SilentAimClosestPartMode"] == "Nearest Part" then
                        LuckyHub.Locals.HitPart = tostring(LuckyHub:GetClosestPart(LuckyHub.Locals.Target.Character))
                        LuckyHub.Locals.Position = LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Position
                    elseif Library.Flags["SilentAimClosestPart"] and Library.Flags["SilentAimClosestPartMode"] == "Nearest Point" then
                        LuckyHub.Locals.HitPart = tostring(LuckyHub:GetClosestPart(LuckyHub.Locals.Target.Character))
                        LuckyHub.Locals.Position = LuckyHub:GetClosestPoint(LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart])
                    else
                        LuckyHub.Locals.HitPart = Library.Flags["SilentAimHitPart"]
                        LuckyHub.Locals.Position = LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Position
                    end
                    --
                    if Library.Flags["ResolverEnabled"] or LuckyHub:IsUsingAntiAim(LuckyHub.Locals.Target) or Library:GetPlayerFlag(LuckyHub.Locals.Target) == "Resolve" then
                        LuckyHub.Locals.AimPoint = Library.Flags["ResolverMethod"] == "Move Direction" and LuckyHub:MoveDirection("Silent Aim") or Library.Flags["ResolverMethod"] == "Velocity Recalculation" and LuckyHub:VelocityRecalculation("Silent Aim")
                    else
                        if Library.Flags["SilentAimNoGroundShots"] then
                            LuckyHub.Locals.AimPoint = (LuckyHub.Locals.Position) + Vector3.new(LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.X, (LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.Y * 0.5), LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.Z) * Library.Flags["SilentAimPredictionAmount"]
                        else
                            LuckyHub.Locals.AimPoint = (LuckyHub.Locals.Position) + LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity * Library.Flags["SilentAimPredictionAmount"]
                        end
                    end
                    --
                    if Library.Flags["CursorMethod"] == "Sticky" and OnScreen then
                        Cursor.mode = 'custom'
                        Cursor.position = Vector2.new(Position.X, Position.Y)
                    else
                        Cursor.mode = "mouse"
                    end
                else
                    Cursor.mode = "mouse"
                end
            end
            --
            function LuckyHub:AimAssist()
                if LuckyHub.Locals.AimAssistTarget and LuckyHub.Locals.AimAssistTarget.Character then
                    local MousePosition = Utility:MousePosition()
                    local Object, Humanoid, RootPart = LuckyHub:ValidateClient(LuckyHub.Locals.AimAssistTarget)
                    local Position = Workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                    --
                    if Library.Flags["AimAssistUseFOV"] and not (Distance <= Visuals.AimAssistFOVCircle.Radius) then
                        TracerLine.Visible = false
                        return
                    end
                    --
                    if Library.Flags["AimAssistSafeMode"] and (UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter or not LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid"))) then
                        return
                    end
                    --
                    if (Library.Flags["WallCheck"] and not LuckyHub:RayCast(LuckyHub:GetClosestPart(Object), LuckyHub:GetOrigin("Camera"), {LuckyHub:GetCharacter(Client), LuckyHub:GetIgnore(true)})) then
                        return
                    end
                    --
                    if (Library.Flags["AliveCheck"] and not LuckyHub:ClientAlive(LuckyHub.Locals.AimAssistTarget, Object, Humanoid)) then
                        return
                    end
                    --
                    if (Library.Flags["KnockedCheck"] and Object:FindFirstChild("BodyEffects") and Object.BodyEffects["K.O"].Value or Object:FindFirstChild("GRABBING_CONSTRAINT") ~= nil) then
                        return
                    end
                    --
                    if (Library.Flags["CrewCheck"] and not LuckyHub:CheckCrew(LuckyHub.Locals.AimAssistTarget)) then
                        return
                    end
                    --
                    if Library.Flags["TargetMode"] == "FOV" then
                        if Library.Flags["AimAssistEnabled"] == false then return end
                    end
                    --
                    if Library.Flags["ResolverEnabled"] or LuckyHub:IsUsingAntiAim(LuckyHub.Locals.AimAssistTarget) or Library:GetPlayerFlag(LuckyHub.Locals.AimAssistTarget) == "Resolve" then
                        LuckyHub.Locals.AimAssistAimPoint = Library.Flags["ResolverMethod"] == "Move Direction" and LuckyHub:MoveDirection("Aim Assist") or Library.Flags["ResolverMethod"] == "Velocity Recalculation" and LuckyHub:VelocityRecalculation("Aim Assist")
                    else
                        if Library.Flags["AimAssistClosestPart"] then
                            LuckyHub.Locals.AimAssistHitPart = tostring(LuckyHub:GetClosestPart(LuckyHub.Locals.AimAssistTarget.Character))
                        else
                            LuckyHub.Locals.AimAssistHitPart = Library.Flags["AimAssistHitPart"]
                        end
                        --
                        LuckyHub.Locals.AimAssistAimPoint = LuckyHub.Locals.AimAssistTarget.Character[LuckyHub.Locals.AimAssistHitPart].Position + LuckyHub.Locals.AimAssistTarget.Character[LuckyHub.Locals.AimAssistHitPart].Velocity * Library.Flags["AimAssistPredictionAmount"]
                    end
                    --
                    local Main = CFrame.new(workspace.CurrentCamera.CFrame.p, LuckyHub.Locals.AimAssistAimPoint)
                    --
                    if not Library.Flags["SilentAimOnly"] then
                        if Library.Flags["AimAssistSmoothing"] then
                            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main, Library.Flags["AimAssistSmoothingAmount"], Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
                        else
                            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main, 1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
                        end
                    end
                end
            end
            --
            function LuckyHub:GetTool() 
                if ClientCharacter and ClientCharacter:FindFirstChildWhichIsA("Tool") then 
                    return ClientCharacter:FindFirstChildWhichIsA("Tool") 
                end 
            end
            --
            function LuckyHub:CreateBeam(Origin, End, Color1)
                local BeamPart = Instance.new("Part", Workspace)
                BeamPart.Name = "BeamPart"
                BeamPart.Transparency = 1
                --
                local Part = Instance.new("Part", BeamPart)
                Part.Size = Vector3.new(1, 1, 1)
                Part.Transparency = 1
                Part.CanCollide = false
                Part.CFrame = typeof(Origin) == "CFrame" and Origin or CFrame.new(Origin)
                Part.Anchored = true
                local Attachment = Instance.new("Attachment", Part)
                local Part2 = Instance.new("Part", BeamPart)
                Part2.Size = Vector3.new(1, 1, 1)
                Part2.Transparency = 1
                Part2.CanCollide = false
                Part2.CFrame = typeof(End) == "CFrame" and End or CFrame.new(End)
                Part2.Anchored = true
                Part2.Color = Color3.fromRGB(255, 255, 255)
                local Attachment2 = Instance.new("Attachment", Part2)
                local Beam = Instance.new("Beam", Part)
                Beam.FaceCamera = true
                Beam.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color1),
                    ColorSequenceKeypoint.new(1, Color1),
                }
                Beam.Attachment0 = Attachment
                Beam.Attachment1 = Attachment2
                Beam.LightEmission = 6
                Beam.LightInfluence = 1
                Beam.Width0 = 1
                Beam.Width1 = 1
                Beam.Texture = "rbxassetid://7136858729"
                Beam.LightEmission = 1
                Beam.LightInfluence = 1
                Beam.TextureMode = Enum.TextureMode.Wrap
                Beam.TextureLength = 3
                Beam.TextureSpeed = 3
                --
                Delay(1.5, function()
                    for i = 0, 1, 0.05 do
                        Wait()
                        Beam.Transparency = NumberSequence.new(i)
                    end
                    --
                    Beam:Destroy()
                    Part:Destroy()
                    Part2:Destroy()
                    BeamPart:Destroy()
                end)
            end
            --
            function LuckyHub:CreateDrawingBeam(Origin, End, Color1)
                local Line = BulletLibrary:New3DLine()
                Line.Visible = true
                Line.Transparency = 1
                Line.Thickness = 2
                Line.Color = Library.Flags["BulletTracerColor"]
                Line.From = (typeof(Origin) == "CFrame" and Origin or CFrame.new(Origin)).Position
                Line.To = (typeof(End) == "CFrame" and End or CFrame.new(End)).Position
                --
                Delay(1.5, function()
                    for i = 0, 1, 0.05 do
                        Wait()
                        Line.Transparency = 1 - i
                    end
                    --
                    Line:Remove()
                end)
            end
            --
            function LuckyHub:TranslateBeam(Beam)
                local Part = Beam
                --
                if Part ~= nil then
                    local Attachments = Part:GetChildren()
                    if Attachments ~= nil and Attachments[1] ~= nil and Attachments[2] ~= nil then
                        local Origin = Attachments[1].WorldCFrame
                        local End = Attachments[2].WorldCFrame
                        --
                        if Library.Flags["BulletTracerType"] == "Beam" then
                            LuckyHub:CreateBeam(Origin, End, Library.Flags["BulletTracerColor"])
                        else
                            LuckyHub:CreateDrawingBeam(Origin, End, Library.Flags["BulletTracerColor"])
                        end
                        Part.Parent = nil
                    end
                end
            end
            --
            function LuckyHub:RotateCursor()
                if LuckyHub:GetTool() and LuckyHub:GetTool():FindFirstChild("Ammo") then
                    Client.PlayerGui.MainScreenGui.Aim.Visible = Library.Flags["InGameCrosshairVisible"]
                    --
                    if Library.Flags["InGameCrosshairSpin"] and Library.Flags["InGameCrosshairVisible"] then 
                        Client.PlayerGui.MainScreenGui.Aim.Rotation += Library.Flags["InGameCrosshairSpinSpeed"]
                    end
                end
            end
            --
            function LuckyHub:DrawVisualizations()
                if LuckyHub.Locals.Target ~= nil and Library.Flags["PredVisualizersEnabled"] and Library.Flags["SilentAimEnabled"] then
                    local Position, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.AimPoint)
                    local HitPartPosition = workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Position)
                    local SelectedPartPosition, OnScreen2 = workspace.CurrentCamera:WorldToViewportPoint(LuckyHub.Locals.Target.Character[Library.Flags["PredVisualizerHitPart"]].Position)
                    --
                    if Library.Flags["PredVisualizersDot"] then
                        PredictionDot.Visible = Library.Flags["PredVisualizersHitPoint"] and OnScreen or OnScreen2
                        PredictionDot.Position = Library.Flags["PredVisualizersHitPoint"] and Vector2.new(Position.X, Position.Y) or Vector2.new(SelectedPartPosition.X, SelectedPartPosition.Y)
                        PredictionDot.Radius = 4
                        PredictionDot.Filled = true
                        PredictionDot.Color = Library.Flags["PredVisualizerColor"]
                        PredictionDot.Thickness = 1
                        PredictionDot.NumSides = 1000
                    else
                        PredictionDot.Visible = false
                    end
                    --
                    if Library.Flags["PredVisualizersLine"] then
                        PredictionLine.Visible = Library.Flags["PredVisualizersHitPoint"] and OnScreen or OnScreen2
                        PredictionLine.From = Library.Flags["PredVisualizersHitPoint"] and Vector2.new(HitPartPosition.X, HitPartPosition.Y) or Vector2.new(SelectedPartPosition.X, SelectedPartPosition.Y)
                        PredictionLine.To = Library.Flags["PredVisualizersHitPoint"] and Vector2.new(Position.X, Position.Y) or Vector2.new(SelectedPartPosition.X, SelectedPartPosition.Y)
                        PredictionLine.Color = Library.Flags["PredVisualizerColor"]
                        PredictionLine.Thickness = 2
                        PredictionLine.Transparency = 1
                    else
                        PredictionLine.Visible = false
                    end
                    --
                    if Library.Flags["PredVisualizersChams"] then
                        if Workspace:FindFirstChild("ServerChams") ~= nil then
                            for _, part in next, Workspace:FindFirstChild("ServerChams"):GetChildren() do
                                part.Color = Library.Flags["PredVisualizerColor"]
                                part.Transparency = 0
                                if LuckyHub:IsUsingAntiAim(LuckyHub.Locals.Target) then
                                    part.CFrame = LuckyHub.Locals.Target.Character:FindFirstChild(part.Name).CFrame + ((LuckyHub.Locals.Target.Character.Humanoid.MoveDirection * LuckyHub.Locals.Target.Character.Humanoid.WalkSpeed) * Library.Flags["SilentAimPredictionAmount"])
                                else
                                    part.CFrame = LuckyHub.Locals.Target.Character:FindFirstChild(part.Name).CFrame + (Library.Flags["PredVisualizersHitPoint"] and Vector3.new(LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.X, (LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.Y * 0.5), LuckyHub.Locals.Target.Character[LuckyHub.Locals.HitPart].Velocity.Z) * Library.Flags["SilentAimPredictionAmount"] or Vector3.new(LuckyHub.Locals.Target.Character[Library.Flags["PredVisualizerHitPart"]].Velocity.X, (LuckyHub.Locals.Target.Character[Library.Flags["PredVisualizerHitPart"]].Velocity.Y * 0.5), LuckyHub.Locals.Target.Character[Library.Flags["PredVisualizerHitPart"]].Velocity.Z) * Library.Flags["SilentAimPredictionAmount"])
                                end
                                part.Material = Enum.Material[Library.Flags["PredVisualizerChamsMaterial"]]
                            end
                        else
                            local fold = Instance.new("Folder", Workspace)
                            fold.Name = "ServerChams"
                            for _, part in next, LuckyHub.Locals.Target.Character:GetChildren() do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                    local pee = Instance.new("Part", fold)
                                    pee.Name = part.Name
                                    pee.Size = part.Size
                                    pee.Parent = fold
                                    pee.CanCollide = false
                                    pee.Transparency = 0
                                    pee.Anchored = true
                                    pee.Color = Library.Flags["PredVisualizerColor"]
                                    pee.Material = Enum.Material[Library.Flags["PredVisualizerChamsMaterial"]]
                                end
                            end
                        end
                    else
                        if Workspace:FindFirstChild("ServerChams") ~= nil then
                            for _, part in next, Workspace:FindFirstChild("ServerChams"):GetChildren() do
                                part.Transparency = 1
                            end
                        end
                    end
                else
                    if Workspace:FindFirstChild("ServerChams") ~= nil then
                        for _, part in next, Workspace:FindFirstChild("ServerChams"):GetChildren() do
                            part.Transparency = 1
                        end
                    end
                    PredictionLine.Visible = false
                    PredictionDot.Visible = false
                end
            end
        end
--
        do -- Visualisation
            function Visualisation:CreateVisual(Character)
                local Clone = Utility:Instance("Model", {
                    Name = "Visualisation",
                    Parent = Workspace
                })
                --
                local Head = Character:FindFirstChild("Head")
                --
                local PartsTable = {}
                --
                for Index, Value in pairs(Character:GetChildren()) do
                    if Value:IsA("BasePart") and (Value.Name == "Head" or Value.Name:find("Arm") or Value.Name:find("Torso") or Value.Name:find("Leg") or Value.Name:find("Hand") or Value.Name:find("Foot")) then
                        local Part = Utility:Instance("Part", {
                            Name = Value.Name,
                            Color = Color3.fromRGB(0, 255, 0),
                            Size = Value.Size * 1.025,
                            CFrame = Value.CFrame,
                            CanCollide = false,
                            Transparency = 0,
                            Anchored = true,
                            Material = "SmoothPlastic",
                            BackSurface = "Smooth",
                            BottomSurface = "Smooth",
                            FrontSurface = "Smooth",
                            LeftSurface = "Smooth",
                            RightSurface = "Smooth",
                            TopSurface = "Smooth",
                            Shape = (Value.Name == "Head" and "Cylinder" or "Block"),
                            Parent = Clone
                        })
                        --
                        for Index, Value in pairs({"Back", "Bottom", "Front", "Left", "Right", "Top"}) do
                            local Texture = Utility:Instance("Texture", {
                                Color3 = Color3.fromRGB(0, 255, 0),
                                OffsetStudsU = 0,
                                OffsetStudsV = 0,
                                StudsPerTileU = 12.5,
                                StudsPerTileV = 12.5,
                                Transparency = 0.5,
                                Face = Value,
                                Parent = Part
                            })
                        end
                        --
                        PartsTable[Value] = Part
                    end
                end
                --
                Visualisation.Character = PartsTable
            end
            --
            function Visualisation:DestroyVisual()
                if Visualisation.Character ~= nil then
                    for Index, Value in pairs(Visualisation.Character) do
                        Value:Destroy()
                    end
                end
            end
            --
            function Visualisation:Update(FakeLagging)
                local Object, Humanoid, RootPart = LuckyHub:ValidateClient(Client)
                --
                if RootPart then
                    if Visualisation.Character then
                        local VisualisationColor, VisualisationTransparency = Library.Flags["DesyncVisualizationColor"], 0
                        local VisualisationTransparency2 = Clamp(VisualisationTransparency + 0.25, 0, 1)
                        local ServerPosition = true
                        local VisualisationMaterial = Library.Flags["DesyncVisualizationMaterial"]
                        --
                        if FakeLagging then
                            for Index, Perform in pairs(Visualisation.LastUpdate) do
                                if ServerPosition then Delay(LuckyHub:GetLatency() * 1.75, Perform) else Perform() end
                            end
                        else
                            Visualisation.LastUpdate = {}
                            --
                            for Index, Value in pairs(Visualisation.Character) do
                                if Index then
                                    local OldCFrame = Index.CFrame
                                    --
                                    Value.Material = (VisualisationMaterial == "ForceField" and "ForceField" or VisualisationMaterial == "Plastic" and "SmoothPlastic" or VisualisationMaterial == "Neon" and "Neon" or VisualisationMaterial)
                                    Value.Color = VisualisationColor
                                    Value.Transparency = VisualisationTransparency
                                    --
                                    for Index2, Value2 in pairs(Value:GetChildren()) do
                                        if Value2:IsA("Texture") then
                                            if VisualisationMaterial == "Animated" then
                                                Value2.Color3 = VisualisationColor
                                                Value2.Transparency = VisualisationTransparency2
                                                Value2.Texture = Format("rbxasset://textures/water/normal_%02d.dds", Visualisation.Texture)
                                            else
                                                Value2.Transparency = 1
                                            end
                                        end
                                    end
                                    --
                                    local Perform = function()
                                        local Radius = (Index.Name == "Head" and ((Index.Size.X * (Value:FindFirstChildOfClass("WrapTarget") and 0.45 or 0.275)) + 0.1))
                                        --
                                        Value.Size = Index.Name == "Head" and Vector3.new(Index.Size.Y, Radius * 2, Radius * 2) or (Index.Size * 0.99)
                                        Value.CFrame = OldCFrame * CFrame.Angles(0, 0, Index.Name == "Head" and Rad(90) or 0)
                                    end
                                    --
                                    Visualisation.LastUpdate[Value] = Perform
                                    --
                                    if ServerPosition then Delay(LuckyHub:GetLatency() * 1.75, Perform) else Perform() end
                                else
                                    Value:Remove()
                                end
                            end
                        end
                        --
                        Visualisation.Texture = Visualisation.Texture + 1
                        --
                        if Visualisation.Texture > 25 then
                            Visualisation.Texture = 1
                        end
                    end
                end
            end
        end
        --
        AimviewerBeam = Instance.new("Beam")
        AimviewerBeam.Segments = 1
        AimviewerBeam.Width0 = 0.3
        AimviewerBeam.Width1 = 0.3
        AimviewerBeam.FaceCamera = true
        --
        AimviewerAttachment1 = Instance.new("Attachment")
        AimviewerAttachment2 = Instance.new("Attachment")
        --
        AimviewerBeam.Attachment0 = AimviewerAttachment1
        AimviewerBeam.Attachment1 = AimviewerAttachment2
        AimviewerBeam.Parent = Workspace.Terrain
        AimviewerAttachment1.Parent = Workspace.Terrain
        AimviewerAttachment2.Parent = Workspace.Terrain
        --
        function LuckyHub:DrawAimviewers()
            if LuckyHub.Locals.AimviewerTarget ~= nil then
                local player = LuckyHub.Locals.AimviewerTarget
                --
                if LuckyHub:ClientAlive(player, player.Character, player.Character:FindFirstChild("Humanoid")) and player.Character:FindFirstChildOfClass("Tool") then 
                    AimviewerBeam.Enabled = Library.Flags["AimviewerEnabled"]
                    AimviewerAttachment1.Position = player.Character:FindFirstChild("Head").Position
                    AimviewerAttachment2.Position = player.Character.BodyEffects.MousePos.Value
                    AimviewerBeam.Color = ColorSequence.new(Library.Flags["AimviewerColor"])
                else
                    AimviewerBeam.Enabled = false
                end
            end
        end
        --
        function LuckyHub:AutoBuy(weapon, method)
            if LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) then
                for _, obj in next, Workspace.Ignored.Shop:GetChildren() do
                    local objname = obj.Name:gsub(" ", "")
                    if method == "Gun" then
                        if weapon == "Double" then
                            if obj.Name == "[Double-Barrel SG] - $1485" then
                                ClientCharacter.HumanoidRootPart.CFrame = obj:FindFirstChild("Head").CFrame
                                Wait(0.2)
                                fireclickdetector(obj:FindFirstChild("ClickDetector"))
                            end
                        else
                            if SFind(obj.Name, weapon) and not SFind(obj.Name, "Ammo") then
                                ClientCharacter.HumanoidRootPart.CFrame = obj:FindFirstChild("Head").CFrame
                                Wait(0.2)
                                fireclickdetector(obj:FindFirstChild("ClickDetector"))
                            end
                        end
                    else
                        if weapon == "Double" then
                            if obj.Name == "18 [Double-Barrel SG Ammo] - $64" then
                                ClientCharacter.HumanoidRootPart.CFrame = obj:FindFirstChild("Head").CFrame
                                Wait(0.2)
                                fireclickdetector(obj:FindFirstChild("ClickDetector"))
                            end
                        else
                            if SFind(obj.Name, weapon) and SFind(obj.Name, "Ammo") then
                                ClientCharacter.HumanoidRootPart.CFrame = obj:FindFirstChild("Head").CFrame
                                Wait(0.2)
                                fireclickdetector(obj:FindFirstChild("ClickDetector"))
                            end
                        end
                    end
                end
            end
        end
        --
        function LuckyHub:HitEffect(Type, Character)
            local function Weld(x,y)
                local W = Instance.new("Weld")
                W.Part0 = x
                W.Part1 = y
                local CJ = CFrame.new(x.Position)
                local C0 = x.CFrame:inverse()*CJ
                local C1 = y.CFrame:inverse()*CJ
                W.C0 = C0
                W.C1 = C1
                W.Parent = x
            end
            -- 
            if Type == "Slash" then
                local Effect = _G.SlashEffect:Clone() 
                Effect.Parent = Character.HumanoidRootPart
                --	
                for i,v in pairs(Effect:GetChildren()) do
                    if v:IsA("ParticleEmitter") then
                        v.Rate = 0
                        if v.Color ~= Color3.fromRGB(0, 0, 0) then
                            v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Library.Flags["HitDetectionEffectColor"]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
                        end
                        v:Emit()
                    end
                end 
                -- 	
                Delay(2, function()
                    Effect:Destroy()
                end)
            elseif Type == "Solar" then
                local Effect = _G.SolarEffect:Clone() 
                Effect.Parent = Character.HumanoidRootPart
                --	
                for i,v in pairs(Effect:GetChildren()) do
                    v.Rate = 0
                    if v.Color ~= Color3.fromRGB(0, 0, 0) then
                        v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Library.Flags["HitDetectionEffectColor"]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
                    end
                    v:Emit()
                end 
                -- 	
                Delay(2, function()
                    Effect:Destroy()
                end)
            elseif Type == "Lightning" then
                local Effect = _G.LightningEffect:Clone() 
                Effect.Parent = Character.HumanoidRootPart
                --	
                for i,v in pairs(Effect:GetChildren()) do
                    v.Rate = 0
                    if v.Color ~= Color3.fromRGB(133, 134, 134) then
                        v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Library.Flags["HitDetectionEffectColor"]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
                    end
                    v:Emit()
                end 
                -- 	
                Delay(2, function()
                    Effect:Destroy()
                end)
            elseif Type == "Galaxy" then
                local Effect = _G.GalaxyEffect:Clone() 
                Effect.Parent = Character.HumanoidRootPart
                --	
                for i,v in pairs(Effect:GetChildren()) do
                    v.Rate = 0
                    v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Library.Flags["HitDetectionEffectColor"]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
                    v:Emit()
                end 
                -- 	
                Delay(2, function()
                    Effect:Destroy()
                end)
            elseif Type == "Water" then
                local Effect = _G.WaterEffect:Clone() 
                Effect.Parent = Character.HumanoidRootPart
                --	
                for i,v in pairs(Effect:GetChildren()) do
                    v.Rate = 0
                    v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Library.Flags["HitDetectionEffectColor"]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
                    v:Emit()
                end 
                -- 	
                Delay(2, function()
                    Effect:Destroy()
                end)
            end 
        end
        --
        function LuckyHub:HitNotification(Message, Delay)
            Library:Notify(Message, Delay)
        end
        -- 
        function LuckyHub:HitSound(Id)
            local Sound = Instance.new("Sound", Workspace); local PitchSound = Instance.new("PitchShiftSoundEffect", Sound)
            -- 
            Sound.SoundId = "rbxassetid://".. Id ..""
            Sound.Volume = 3
            PitchSound.Octave = 1
            Sound:Play()
            Sound.Ended:Connect(function()
                Sound:Destroy()
                PitchSound:Destroy()
            end)	
        end
        --
        function LuckyHub:CreateClone(Player, Color, Material, Parent)
            for i,v in pairs(Player.Character:GetChildren()) do 
                if v:IsA("MeshPart") and v.Name ~= "HumanoidRootPart" then 
                    if v.Name == "UpperTorso" or v.Name == "LowerTorso" then 
                        local ClonedPart = Instance.new("Part")
                        ClonedPart.Anchored = true 
                        ClonedPart.CanCollide = false 
                        ClonedPart.Position = v.Position
                        ClonedPart.Parent = Parent
                        ClonedPart.Material = Enum.Material[Material]
                        ClonedPart.Transparency = 0 
                        ClonedPart.Color = Color
                        ClonedPart.Size = v.Size + Vector3.new(0.01,0.01,0.01)
                        ClonedPart.Name = v.Name
                        ClonedPart.Rotation = v.Rotation
                        ClonedPart.Shape = "Block"
                    else 
                        local ClonedPart = Instance.new("MeshPart")
                        ClonedPart.Anchored = true 
                        ClonedPart.CanCollide = false 
                        ClonedPart.Position = v.Position
                        ClonedPart.Parent = Parent
                        ClonedPart.Material = Enum.Material[Material]
                        ClonedPart.Transparency = 0 
                        ClonedPart.Color = Color
                        ClonedPart.Size = v.Size + Vector3.new(0.01,0.01,0.01)
                        ClonedPart.Name = v.Name
                        ClonedPart.Rotation = v.Rotation
                        ClonedPart.MeshId = v.MeshId
                    end 
                end
            end
        end
        --
        function LuckyHub:UpdateHealth()
            if Library.Flags["HitDetectionEnabled"] then
                for _, Player in pairs(Players:GetPlayers()) do
                    if Player.Character and Player.Character.Humanoid then
                        LuckyHub.Locals.PlayerHealth[Player.Name] = Player.Character.Humanoid.Health
                    end
                end
            end
        end
        --
        function LuckyHub:GetClosestPlayerDamage(Position, MaxRadius)
            local Radius = MaxRadius
            local ClosestPlayer

            for PlayerName, Health in pairs(LuckyHub.Locals.PlayerHealth) do
                local Player = Players:FindFirstChild(PlayerName)
                if Player and Player.Character then
                    local PlayerPosition = Player.Character.PrimaryPart.Position
                    local Distance = (Position - PlayerPosition).Magnitude
                    local CurrentHealth = Player.Character.Humanoid.Health
                    --
                    if (Distance < Radius) and (CurrentHealth < Health) then
                        Radius = Distance
                        ClosestPlayer = Player
                    end
                end
            end
            return ClosestPlayer, Radius
        end
        --
        function LuckyHub:HitDetection()
            local Gun = LuckyHub:GetTool()
            local Connection = LuckyHub["Connections"]["On-Hit-Raycast"]
            --
            if Gun ~= LuckyHub.Locals.PreviousGun and Connection then
                LuckyHub.Locals.PreviousGun = Gun
                LuckyHub.Locals.PreviousAmmo = 999
                Connection:Disconnect()
                LuckyHub["Connections"]["On-Hit-Raycast"] = nil
            end
            --
            if not LuckyHub["Connections"]["On-Hit-Raycast"] and Gun and Gun.Ammo.Value then
                LuckyHub["Connections"]["On-Hit-Raycast"] = Gun.Ammo:GetPropertyChangedSignal("Value"):Connect(function()
                    local NewAmmo = Gun.Ammo.Value
                    if (NewAmmo < LuckyHub.Locals.PreviousAmmo) and LuckyHub.Locals.PreviousAmmo then
                        local ChildAdded
                        local ChildrenAdded = 0
                        ChildAdded = Workspace.Ignored.Siren.Radius.DescendantAdded:Connect(function(Object)
                            if Object.Name == "BULLET_RAYS" then
                                ChildrenAdded += 1
                                if (Find({"[Double-Barrel SG]", "[TacticalShotgun]", "[Shotgun]"}, Gun.Name) and ChildrenAdded <= 5) or (ChildrenAdded == 1) then
                                    local GunBeam = Object:WaitForChild("GunBeam")
                                    local StartPos, EndPos = Object.Position, GunBeam.Attachment1.WorldPosition
                                    --
                                    if StartPos and EndPos then
                                        if Library.Flags["BulletTracers"] then
                                            GunBeam:Destroy()
                                            --
                                            if Library.Flags["BulletTracerType"] == "Beam" then
                                                LuckyHub:CreateBeam(StartPos, EndPos, Library.Flags["BulletTracerColor"])
                                            else
                                                LuckyHub:CreateDrawingBeam(StartPos, EndPos, Library.Flags["BulletTracerColor"])
                                            end
                                        end
                                        --
                                        if Library.Flags["BulletImpacts"] then
                                            local Impact = Instance.new("Part")
                                            Impact.Anchored = true
                                            Impact.CanCollide = false 
                                            Impact.Parent = Workspace
                                            Impact.Material = "Neon"
                                            Impact.Shape = Enum.PartType.Block 
                                            Impact.Transparency = 0
                                            Impact.Color = Library.Flags["BulletImpactsColor"]
                                            Impact.Size = Vector3.new(0.4, 0.4, 0.4)
                                            Impact.CFrame = CFrame.new(EndPos)
                                            --
                                            Delay(1.5, function()
                                                for i = 0, 1, 0.05 do
                                                    Wait()
                                                    Impact.Transparency = NumberSequence.new(i)
                                                end
                                                --
                                                Impact:Destroy()
                                            end)
                                        end
                                        --
                                        if Library.Flags["HitDetectionEnabled"] then
                                            local Player, Distance = LuckyHub:GetClosestPlayerDamage(EndPos, 20)
                                            --
                                            if Player then
                                                --
                                                if Library.Flags["HitDetectionNotifications"] then
                                                    local Health = Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Humanoid").Health
                                                    local Damage = (LuckyHub.Locals.PlayerHealth[Player.Name] - Health)
                                                    --
                                                    LuckyHub:HitNotification(("Hit %s for %s damage (%s health remaning)"):format(tostring(Player.Name), tostring(math.floor(Damage)), tostring(math.floor(Health))), 2)
                                                end
                                                --
                                                if Library.Flags["HitDetectionEffectType"] ~= "None" then
                                                    if Library.Flags["HitDetectionEffectType"] == "Clone" then
                                                        local Folder = Instance.new("Folder", Workspace)
                                                        --
                                                        LuckyHub:CreateClone(Player, Library.Flags["HitDetectionEffectColor"], Library.Flags["HitDetectionEffectMaterial"], Folder)
                                                        --
                                                        Delay(2, function()
                                                            Folder:Destroy()
                                                        end)
                                                    else
                                                        LuckyHub:HitEffect(Library.Flags["HitDetectionEffectType"], Player.Character)
                                                    end
                                                end
                                                --
                                                if Library.Flags["HitDetectionSoundType"] ~= "None" then
                                                    LuckyHub:HitSound(LuckyHub.SoundEffects[Library.Flags["HitDetectionSoundType"]])
                                                end
                                            end
                                        end
                                    end
                                    --
                                    ChildAdded:Disconnect()
                                end
                            else
                                ChildAdded:Disconnect()
                            end
                        end)
                    end
                    LuckyHub.Locals.PreviousAmmo = NewAmmo
                end)
            end
            --  
        end
--
local ChangingTitle = {
    "",
    "",
    "L",
    "Lu",
    "Luc",
    "Luck",
    "Lucky",
    "LuckyH",
    "LuckyHu",
    "LuckyHub",
    "LuckyHub",
    "LuckyHub",
    "LuckyHu",
    "LuckyH",
    "Lucky",
    "Luck",
    "Luc",
    "Lu",
    "L",
    "",
    "",
}
--
local Main = Library:Window({Name = "LuckyHub", Side = "Center", Icon = "rbxassetid://16863027979", Size = UDim2.new(0, 850, 0, 677), Theme = Color3.fromRGB(0, 255, 0), KeybindList = true, Watermark = true, Indicators = true, VelocityStats = true})
--
local MainTab = Main:CreateTab({Name = "Main", Icon = "rbxassetid://16863175349"})
local UniversalTab = Main:CreateTab({Name = "Universal", Icon = "rbxassetid://16866569883"})
local ESPTab = Main:CreateTab({Name = "ESP", Icon = "rbxassetid://16993859634"})
local VisualsTab = Main:CreateTab({Name = "Visuals", Icon = "rbxassetid://16863266011"})
local MiscTab = Main:CreateTab({Name = "Misc", Icon = "rbxassetid://16864702418"})
local SkinsTab = Main:CreateTab({Name = "Skins", Icon = "rbxassetid://16866165737"})
local PlayersTab = Main:CreateTab({Name = "Players", Icon = "rbxassetid://16863267075", PlayerList = true})
local SettingsTab = Main:CreateTab({Name = "Settings", Icon = "rbxassetid://16863267906"})
--
do -- Main Tab
    local SilentAimSection = MainTab:Section({Name = "Silent Aim", Side = "Left"})
    local FOVSection = MainTab:Section({Name = "FOV Settings", Side = "Left"})
    local AimAssistSection = MainTab:Section({Name = "Aim Assist", Side = "Right"})
    local ChecksSection = MainTab:Section({Name = "Checks", Side = "Right"})
    local ExtraSection = MainTab:Section({Name = "Extra", Side = "Right"})
    --
    do -- Silent Aim
        local SilentAimToggle = SilentAimSection:Toggle({Name = "Silent Aim Enabled", Flag = "SilentAimEnabled"})
        SilentAimToggle:Keybind({Default = "Q"})
        --
        function LuckyHub:GetOldMode2()
            return SilentAimToggle:GetMode()
        end
        --
        function LuckyHub:SetSilentAimMode(Mode)
            SilentAimToggle:SetMode(Mode)
        end
        --
        SilentAimSection:Toggle({Name = "Anti Curve", Default = true, Flag = "SilentAimAntiCurve"})
        --
        SilentAimSection:Toggle({Name = "No Ground Shots", Default = true, Flag = "SilentAimNoGroundShots"})
        --
        SilentAimSection:Toggle({Name = "Use FOV", Default = true, Flag = "SilentAimUseFOV"})
        --
        SilentAimSection:Slider({Name = "Field Of View", Flag = "SilentAimFieldOfView", Min = 1, Max = 300, Default = 50, Decimal = 0.1})
        --
        SilentAimSection:Dropdown({Name = "Predicition Type", Flag = "SilentAimPredictionType", Content = {"Custom", "Auto"}, Default = "Custom"})
        --
        SilentAimSection:TextBox({Default = "0.135", PlaceHolder = "Prediction Amount", NumbersOnly = true, Max = 15, Flag = "SilentAimPredictionAmount"})
        --
        SilentAimSection:Toggle({Name = "Closest Part", Flag = "SilentAimClosestPart"})
        --
        SilentAimSection:Dropdown({Name = "Closest Part Mode", Flag = "SilentAimClosestPartMode", Content = {"Nearest Part", "Nearest Point"}, Default = "Nearest Part"})
        --
        SilentAimSection:Dropdown({Name = "Hit Part", Flag = "SilentAimHitPart", Content = {"Head", "HumanoidRootPart", "LowerTorso", "UpperTorso", "RightUpperLeg", "LeftUpperLeg", "RightLowerLeg", "LeftLowerLeg", "RightFoot", "LeftFoot", "LeftUpperArm", "RightUpperArm", "RightLowerArm", "LeftLowerArm", "LeftHand", "RightHand"}, Default = "HumanoidRootPart"})
    end
    --
    do -- Aim Assist
        local AimAssistToggle = AimAssistSection:Toggle({Name = "Aim Assist Enabled", Flag = "AimAssistEnabled"})
        AimAssistToggle:Keybind({Default = "C", Flag = "KeybindTest"})
        --
        function LuckyHub:GetAimAssistKeybind()
            return AimAssistToggle:GetKeybind()
        end
        --
        function LuckyHub:GetOldMode()
            return AimAssistToggle:GetMode()
        end
        --
        function LuckyHub:SetAimAssistMode(Mode)
            AimAssistToggle:SetMode(Mode)
        end
        --
        AimAssistSection:Toggle({Name = "Safe Mode", Default = true, Flag = "AimAssistSafeMode"})
        --
        AimAssistSection:Toggle({Name = "Smoothing", Default = true, Flag = "AimAssistSmoothing"})
        --
        AimAssistSection:Slider({Name = "Smoothing Amount", Flag = "AimAssistSmoothingAmount", Min = 0.001, Max = 1, Default = 0.1, Decimal = 0.001})
        --
        AimAssistSection:Toggle({Name = "Use FOV", Default = true, Flag = "AimAssistUseFOV"})
        --
        AimAssistSection:Slider({Name = "Field Of View", Flag = "AimAssistFieldOfView", Min = 1, Max = 300, Default = 75, Decimal = 0.1})
        --
        AimAssistSection:TextBox({Default = "0.115", PlaceHolder = "Prediction Amount", NumbersOnly = true, Max = 15, Flag = "AimAssistPredictionAmount"})
        --
        AimAssistSection:Toggle({Name = "Closest Part", Flag = "AimAssistClosestPart"})
        --
        AimAssistSection:Dropdown({Name = "Hit Part", Flag = "AimAssistHitPart", Content = {"Head", "HumanoidRootPart", "LowerTorso", "UpperTorso", "RightUpperLeg", "LeftUpperLeg", "RightLowerLeg", "LeftLowerLeg", "RightFoot", "LeftFoot", "LeftUpperArm", "RightUpperArm", "RightLowerArm", "LeftLowerArm", "LeftHand", "RightHand"}, Default = "HumanoidRootPart"})
    end
    --
    do -- FOV
        local SilentAimFOV = FOVSection:Toggle({Name = "Silent Aim FOV", Flag = "SilentAimFOVEnabled", Default = false})
        SilentAimFOV:ColorPicker({Name = "Silent Aim FOV Color", Flag = "SilentAimColor", Default = Color3.fromRGB(0, 255, 0)})
        --
        FOVSection:Toggle({Name = "Silent Aim FOV Filled", Flag = "SilentAimFOVFilled", Default = false})
        --
        FOVSection:Dropdown({Name = "Silent Aim FOV Type", Flag = "SilentAimFOVType", Content = {"Mouse", "Sticky"}, Default = "Mouse"})
        --
        FOVSection:Slider({Name = "Silent Aim FOV Transparency", Flag = "SilentAimFieldOfViewTransparency", Min = 0, Max = 1, Default = 1, Decimal = 0.01})
        --
        local AimAssistFOV = FOVSection:Toggle({Name = "Aim Assist FOV", Flag = "AimAssistFOVEnabled", Default = false})
        AimAssistFOV:ColorPicker({Name = "Aim Assist FOV Color", Flag = "AimAssistColor", Default = Color3.fromRGB(255, 255, 255)})
        --
        FOVSection:Toggle({Name = "Aim Assist FOV Filled", Flag = "AimAssistFOVFilled", Default = false})
        --
        FOVSection:Slider({Name = "Aim Assist FOV Transparency", Flag = "AimAssistFieldOfViewTransparency", Min = 0, Max = 1, Default = 0.5, Decimal = 0.01})
        --
        local Tracer = FOVSection:Toggle({Name = "Tracer", Flag = "TracerEnabled", Default = false})
        Tracer:ColorPicker({Name = "Tracer Color", Flag = "TracerColor", Default = Color3.fromRGB(255, 255, 255)})
        --
        FOVSection:Slider({Name = "Tracer Transparency", Flag = "TracerTransparency", Min = 0, Max = 1, Default = 1, Decimal = 0.01})
        --
        FOVSection:Slider({Name = "Tracer Thickness", Flag = "TracerThickness", Min = 0.1, Max = 5, Default = 1.5, Decimal = 0.1})
    end
    --
    do -- Checks
        ChecksSection:Toggle({Name = "Wall Check", Default = true, Flag = "WallCheck"})
        --
        ChecksSection:Toggle({Name = "Alive Check", Default = true, Flag = "AliveCheck"})
        --
        ChecksSection:Toggle({Name = "ForceField Check", Flag = "ForceFieldCheck"})
        --
        ChecksSection:Toggle({Name = "Knocked Check", Flag = "KnockedCheck"})
        --
        ChecksSection:Toggle({Name = "Crew Check", Flag = "CrewCheck"})
        --
        ChecksSection:Toggle({Name = "Friend Check", Flag = "FriendCheck"})
    end
    --
    do -- Extra
        ExtraSection:Toggle({Name = "Resolver", Flag = "ResolverEnabled"})
        --
        ExtraSection:Dropdown({Name = "Resolver Method", Flag = "ResolverMethod", Content = {"Move Direction", "Velocity Recalculation"}, Default = "Move Direction"})
        --
        local OldMode = LuckyHub:GetOldMode()
        local OldMode2 = LuckyHub:GetOldMode2()
        --
        ExtraSection:Dropdown({Name = "Target Mode", Flag = "TargetMode", Content = {"FOV", "Target"}, Default = "FOV", Callback = function(State)
            if State == "Target" then
                LuckyHub:SetAimAssistMode("Always")
                LuckyHub:SetSilentAimMode("Always")
            else
                LuckyHub:SetAimAssistMode(OldMode)
                LuckyHub:SetSilentAimMode(OldMode2)
            end
        end})
        --
        ExtraSection:Toggle({Name = "Silent Aim Only", Default = false, Flag = "SilentAimOnly"})
        --
        ExtraSection:Toggle({Name = "Notifications", Default = true, Flag = "NotificationsEnabled"})
    end
end
--
do -- Universal
    local UniversalAimAssist = UniversalTab:Section({Name = "Aim Assist", Side = "Left"})
    local UniversalFOVSettings = UniversalTab:Section({Name = "FOV Settings", Side = "Left"})
    local UniversalTriggerBot = UniversalTab:Section({Name = "Trigger Bot", Side = "Right"})
    local UniversalChecks = UniversalTab:Section({Name = "Checks", Side = "Right"})
    --
    do -- Aim Assist
        local UniversalAimAssistToggle = UniversalAimAssist:Toggle({Name = "Aim Assist Enabled", Flag = "UniversalAimAssistEnabled"})
        UniversalAimAssistToggle:Keybind({Default = "E"})
        --
        UniversalAimAssist:Toggle({Name = "Use FOV", Default = true, Flag = "UniversalAimAssistUseFOV"})
        --
        UniversalAimAssist:Slider({Name = "Field Of View", Flag = "UniversalAimAssistFieldOfView", Min = 1, Max = 300, Default = 50, Decimal = 0.1})
        --
        UniversalAimAssist:Slider({Name = "Horizontal Smoothing Amount", Flag = "UniversalAimAssistXSmoothingAmount", Min = 5, Max = 100, Default = 10, Decimal = 0.01})
        --
        UniversalAimAssist:Slider({Name = "Vertical Smoothing Amount", Flag = "UniversalAimAssistYSmoothingAmount", Min = 5, Max = 100, Default = 10, Decimal = 0.01})
        --
        UniversalAimAssist:TextBox({Default = "0.115", NumbersOnly = true, PlaceHolder = "Prediction Amount", Max = 15, Flag = "UniversalAimAssistPredictionAmount"})
        --
        UniversalAimAssist:Toggle({Name = "Closest Part", Flag = "UniversalAimAssistClosestPart"})
        --
        UniversalAimAssist:Dropdown({Name = "Hit Part", Flag = "UniversalAimAssistHitPart", Content = {"Head", "HumanoidRootPart"}, Default = "HumanoidRootPart"})
        --
        UniversalAimAssist:Dropdown({Name = "Target Priority", Flag = "UniversalAimAssistHitScan", Content = {"Mouse", "Distance"}, Default = "Mouse"})
        --
        UniversalAimAssist:Dropdown({Name = "Hit Scan Priority", Flag = "UniversalAimAssistOrigin", Content = {"Camera", "Head", "Torso"}, Default = "Camera"})
        --
        UniversalAimAssist:Slider({Name = "Deadzone", Flag = "UniversalAimAssistDeadzone", Min = 0, Max = 100, Default = 10, Decimal = 0.01})
        --
        UniversalAimAssist:Slider({Name = "Stutter", Flag = "UniversalAimAssistStutter", Min = 1, Max = 100, Default = 20, Decimal = 0.01})
    end
    --
    do -- FOV Settings
        local UniversalAimAssistFOV = UniversalFOVSettings:Toggle({Name = "Aim Assist FOV", Flag = "UniversalAimAssistFOVEnabled", Default = false})
        UniversalAimAssistFOV:ColorPicker({Name = "Aim Assist FOV Color", Flag = "UniversalAimAssistColor", Default = Color3.fromRGB(255, 255, 255)})
        --
        UniversalFOVSettings:Slider({Name = "Aim Assist FOV Transparency", Flag = "UniversalAimAssistFOVTransparency", Min = 0, Max = 1, Default = 1, Decimal = 0.01})
        --
        local UniversalDeadzoneFOV = UniversalFOVSettings:Toggle({Name = "Deadzone FOV", Flag = "UniversalDeadzoneFOVEnabled", Default = false})
        UniversalDeadzoneFOV:ColorPicker({Name = "Deadzone FOV Color", Flag = "UniversalDeadzoneColor", Default = Color3.fromRGB(0, 255, 0)})
        --
        UniversalFOVSettings:Slider({Name = "Deadzone FOV Transparency", Flag = "UniversalDeadzoneFOVTransparency", Min = 0, Max = 1, Default = 0.5, Decimal = 0.01})
    end
    --
    do -- Trigger Bot
        local UniversalTriggerBotToggle = UniversalTriggerBot:Toggle({Name = "Trigger Bot Enabled", Flag = "UniversalTriggerBotEnabled"})
        UniversalTriggerBotToggle:Keybind({Default = "T"})
        --
        UniversalTriggerBot:Slider({Name = "Delay", Flag = "UniversalTriggerBotDelay", Min = 0, Max = 1000, Default = 10, Decimal = 1})
        --
        UniversalTriggerBot:Slider({Name = "Interval", Flag = "UniversalTriggerBotInterval", Min = 0, Max = 1000, Default = 50, Decimal = 1})
        --
        UniversalTriggerBot:Dropdown({Name = "Hit Scan Priority", Flag = "UniversalTriggerBotOrigin", Content = {"Camera", "Head", "Torso"}, Default = "Camera"})
    end
    --
    do -- Checks
        UniversalChecks:Toggle({Name = "Wall Check", Default = true, Flag = "UniversalWallCheck"})
        --
        UniversalChecks:Toggle({Name = "Alive Check", Default = true, Flag = "UniversalAliveCheck"})
        --
        UniversalChecks:Toggle({Name = "ForceField Check", Flag = "UniversalForceFieldCheck"})
        --
        UniversalChecks:Toggle({Name = "Team Check", Flag = "UniversalTeamCheck"})
        --
        UniversalChecks:Toggle({Name = "Friend Check", Flag = "UniversalFriendCheck"})
    end
end
--
do -- ESP
    local PlayersVisualSection = ESPTab:Section({Name = "Players", Side = "Left"})
    local PlayersSettingsSection = ESPTab:Section({Name = "Players Settings", Side = "Right"})
    local PlayersColorSection = ESPTab:Section({Name = "Player Colors", Side = "Right"})
    --
    do -- Players
        local ESPEnabled = PlayersVisualSection:Toggle({Name = "ESP Enabled", Callback = function(State)
            ESP.Enabled = State
        end})
        ESPEnabled:Keybind({Default = "H"})
        --
        PlayersVisualSection:Toggle({Name = "Dynamic Box", Default = false, Callback = function(State)
            ESP.BoxDynamic = State
        end})
        --
        local BoxSettings = PlayersVisualSection:Toggle({Name = "Box", Default = true, Callback = function(State)
            ESP.BoxEnabled = State
        end})
        BoxSettings:ColorPicker({Name = "Box Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(State)
            ESP.BoxColor = State
        end})
        --
        PlayersVisualSection:Dropdown({Name = "Box Type", Content = {"Corner", "2D"}, Default = "Corner", Callback = function(State)
            if State == "Corner" then
                ESP.BoxCorners = true
            else
                ESP.BoxCorners = false
            end
        end})
        --
        local BoxFillSettings = PlayersVisualSection:Toggle({Name = "Box Fill", Default = true, Callback = function(State)
            ESP.BoxFill = State
        end})
        BoxFillSettings:ColorPicker({Name = "Box Fill Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(State)
            ESP.BoxFillColor = State
        end})
        --
        PlayersVisualSection:Slider({Name = "Box Fill Transparency", Min = 0, Max = 1, Default = 0.25, Decimal = 0.01, Callback = function(State)
            ESP.BoxFillTransparency = tonumber(State)
        end})
        --
        PlayersVisualSection:Toggle({Name = "Name", Default = true, Callback = function(State)
            ESP.TextLayout.name.enabled = State
        end})
        --
        PlayersVisualSection:Toggle({Name = "Tool", Default = true, Callback = function(State)
            ESP.TextLayout.tool.enabled = State
        end})
        --
        PlayersVisualSection:Toggle({Name = "Distance", Default = true, Callback = function(State)
            ESP.TextLayout.distance.enabled = State
        end})
        --
        PlayersVisualSection:Toggle({Name = "Health Bar", Default = true, Callback = function(State)
            ESP.BarLayout.health.enabled = State
        end})
        --
        PlayersVisualSection:Toggle({Name = "Health Number", Default = true, Callback = function(State)
            ESP.TextLayout.health.enabled = State
        end})
        --
        local HealthBarColorFull = PlayersVisualSection:Label({Message = "Health Bar Full"})
        HealthBarColorFull:ColorPicker({Name = "Full Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            ESP.BarLayout.health.color_full = State
        end})
        --
        local HealthBarColorEmpty = PlayersVisualSection:Label({Message = "Health Bar Empty"})
        HealthBarColorEmpty:ColorPicker({Name = "Empty Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(State)
            ESP.BarLayout.health.color_empty = State
        end})
        --
        if CurrentGame.Name == "Da Hood" then
            PlayersVisualSection:Toggle({Name = "Armor Bar", Default = true, Callback = function(State)
                ESP.BarLayout.armor.enabled = State
            end})
            --
            PlayersVisualSection:Toggle({Name = "Armor Number", Default = true, Callback = function(State)
                ESP.TextLayout.armor.enabled = State
            end})
            --
            local ArmorBarColorFull = PlayersVisualSection:Label({Message = "Armor Bar Full"})
            ArmorBarColorFull:ColorPicker({Name = "Full Color", Default = Color3.fromRGB(0, 136, 194), Callback = function(State)
                ESP.BarLayout.armor.color_full = State
            end})
            --
            local ArmorBarColorEmpty = PlayersVisualSection:Label({Message = "Armor Bar Empty"})
            ArmorBarColorEmpty:ColorPicker({Name = "Empty Color", Default = Color3.fromRGB(0, 136, 194), Callback = function(State)
                ESP.BarLayout.armor.color_empty = State
            end})
        end
        --
        PlayersVisualSection:Toggle({Name = "Flags", Default = true, Callback = function(State)
            ESP.TextLayout.flags.enabled = State
        end})
        --
        local OutOfViewArrows = PlayersVisualSection:Toggle({Name = "Out Of View Arrows", Default = true, Callback = function(State)
            ESP.OutOfViewArrows = State
        end})
        OutOfViewArrows:ColorPicker({Name = "Out Of View Arrows Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            ESP.OutOfViewArrowColor = State
        end})
        --
        PlayersVisualSection:Slider({Name = "Out Of View Arrows Transparency", Min = 0, Max = 1, Default = 0.75, Decimal = 0.01, Callback = function(State)
            ESP.OutOfViewArrowTransparency = tonumber(State)
        end})
        --
        PlayersVisualSection:Toggle({Name = "Out Of View Arrows Filled", Default = true, Callback = function(State)
            ESP.OutOfViewArrowFilled = State
        end})
        --
        local SkeletonSettings = PlayersVisualSection:Toggle({Name = "Skeletons", Callback = function(State)
            ESP.SkeletonEnabled = State
        end})
        SkeletonSettings:ColorPicker({Name = "Skeletons Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(State)
            ESP.SkeletonColor = State
        end})
        --
        PlayersVisualSection:Toggle({Name = "Chams", Callback = function(State)
            ESP.ChamsEnabled = State
        end})
        --
        local ChamsInnerSettings = PlayersVisualSection:Label({Message = "Chams Inner Color"})
        ChamsInnerSettings:ColorPicker({Name = "Inner Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            ESP.ChamsInnerColor = State
        end})
        --
        local ChamsOutterSettings = PlayersVisualSection:Label({Message = "Chams Outer Color"})
        ChamsOutterSettings:ColorPicker({Name = "Outer Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(State)
            ESP.ChamsOuterColor = State
        end})
        --
        PlayersVisualSection:Slider({Name = "Chams Inner Transparency", Min = 0, Max = 1, Default = 0.7, Decimal = 0.01, Callback = function(State)
            ESP.ChamsInnerTransparency = tonumber(State)
        end})
        --
        PlayersVisualSection:Slider({Name = "Chams Outer Transparency", Min = 0, Max = 1, Default = 0.2, Decimal = 0.01, Callback = function(State)
            ESP.ChamsOuterTransparency = tonumber(State)
        end})
    end
    --
    do -- Player Colors
        local ESPHighlightTarget = PlayersColorSection:Toggle({Name = "Highlight Target", Flag = "ESPHighlightTargetEnabled", Default = true, Callback = function(State)
            ESP.HighlightTarget = State
        end})
        ESPHighlightTarget:ColorPicker({Name = "Target Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(State)
            ESP.PriorityColor = State
        end})
        --
        local ESPHighlightTarget = PlayersColorSection:Toggle({Name = "Highlight Friends", Flag = "ESPHighlightFriendsEnabled", Default = true, Callback = function(State)
            ESP.HighlightFriends = State
        end})
        ESPHighlightTarget:ColorPicker({Name = "Friends Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            ESP.FriendsColor = State
        end})
    end
    --
    do -- Player Settings
        PlayersSettingsSection:Toggle({Name = "Local Player", Default = false, Callback = function(State)
            if State then
                ESP.NewPlayer(Client, "LocalPlayer")
            else
                ESP.RemovePlayer(Client)
            end
        end})
        --
        PlayersSettingsSection:Toggle({Name = "Target Only", Flag = "ESPTargetOnly", Default = true, Callback = function(State)
            ESP.TargetOnly = State
        end})
        --
        PlayersSettingsSection:Toggle({Name = "Max Distance", Default = true, Callback = function(State)
            ESP.MaxDistance = State
        end})
        --
        PlayersSettingsSection:Slider({Name = "Max Distance Amount", Min = 50, Max = 2500, Default = 250, Decimal = 1, Callback = function(State)
            ESP.MaxDistanceAmount = tonumber(State)
        end})
        --
        local TextColorSettings = PlayersSettingsSection:Label({Message = "Text Color"})
        TextColorSettings:ColorPicker({Name = "Text Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(State)
            ESP.TextColor = State
        end})
        --
        PlayersSettingsSection:Toggle({Name = "Use Display Name", Default = true, Callback = function(State)
            ESP.UseDisplay = State
        end})
        --
        PlayersSettingsSection:Toggle({Name = "Alive Check", Default = true, Callback = function(State)
            ESP.AliveCheck = State
        end})
        --
        if CurrentGame.Name == "Da Hood" then
            PlayersSettingsSection:Toggle({Name = "Knocked Check", Default = true, Callback = function(State)
                ESP.KnockedCheck = State
            end})
        end
        --
        if CurrentGame.Name ~= "Da Hood" then
            PlayersSettingsSection:Toggle({Name = "Team Check", Default = false, Callback = function(State)
                ESP.TeamCheck = State
            end})
        end
        --
        PlayersSettingsSection:Toggle({Name = "Visible Only", Default = false, Callback = function(State)
            ESP.VisibleOnly = State
        end})
        --
        PlayersSettingsSection:Toggle({Name = "Wall Check", Default = false, Callback = function(State)
            ESP.WallCheck = State
        end})
        --
        local ESPVisibleColor = PlayersSettingsSection:Label({Message = "Visible Color"})
        ESPVisibleColor:ColorPicker({Name = "Visible Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            ESP.VisibleColor = State
        end})
        --
        local ESPNonVisibleColor = PlayersSettingsSection:Label({Message = "Non Visible Color"})
        ESPNonVisibleColor:ColorPicker({Name = "Non Visible Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(State)
            ESP.NonVisibleColor = State
        end})
    end
end
--
do -- Visuals
    local CursorVisualSection = VisualsTab:Section({Name = "Cursor", Side = "Left"})
    local WorldVisualSection = VisualsTab:Section({Name = "World", Side = "Right"})
    local PredVisualizerSection = VisualsTab:Section({Name = "Prediction Visualizer", Side = "Right"})
    --
    do -- World
        WorldVisualSection:Toggle({Name = "Remove Shadows", Flag = "VisualsShadows", Callback = Visuals.Refresh})
        --
        WorldVisualSection:Toggle({Name = "Use Clock Time", Flag = "VisualsClockTimeEnabled"})
        --
        WorldVisualSection:Slider({Name = "Clock Time", Flag = "VisualsClockTime", Min = 1, Max = 24, Default = 12, Decimal = 1})
        --
        WorldVisualSection:Toggle({Name = "Ambience", Flag = "VisualsAmbience", Callback = Visuals.Refresh})
        --
        local WorldVisualsIndoorColor = WorldVisualSection:Label({Message = "Indoor Ambience Color"})
        WorldVisualsIndoorColor:ColorPicker({Name = "Indoor Ambience Color", Flag = "VisualsAmbienceIndoor", Default = Color3.fromRGB(100, 200, 155), Callback = Visuals.Refresh})
        --
        local WorldVisualOutdoorColor = WorldVisualSection:Label({Message = "Outdoor Ambience Color"})
        WorldVisualOutdoorColor:ColorPicker({Name = "Outdoor Ambience Color", Flag = "VisualsAmbienceOutdoor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.Refresh})
        --
        local WorldVisualFog = WorldVisualSection:Toggle({Name = "Fog", Flag = "VisualsFog", Callback = Visuals.Refresh})
        WorldVisualFog:ColorPicker({Name = "Fog Color", Flag = "VisualsFogColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.Refresh})
        --
        WorldVisualSection:Slider({Name = "Fog Start", Flag = "VisualsFogStart", Min = 0, Max = 5000, Default = 35, Decimal = 1, Callback = Visuals.Refresh})
        --
        WorldVisualSection:Slider({Name = "Fog End", Flag = "VisualsFogEnd", Min = 0, Max = 5000, Default = 350, Decimal = 1, Callback = Visuals.Refresh})
    end
    --
    do -- Pred Visualizer
        local PredictionVisualizerEnabled = PredVisualizerSection:Toggle({Name = "Enable Visualizers", Flag = "PredVisualizersEnabled"})
        PredictionVisualizerEnabled:ColorPicker({Name = "Visualizer Color", Flag = "PredVisualizerColor", Default = Color3.fromRGB(0, 255, 0)})
        --
        PredVisualizerSection:Toggle({Name = "Chams", Flag = "PredVisualizersChams"})
        --
        PredVisualizerSection:Dropdown({Name = "Chams Material", Flag = "PredVisualizerChamsMaterial", Content = {"ForceField", "Plastic", "Neon"}, Default = "ForceField"})
        --
        PredVisualizerSection:Toggle({Name = "Dot", Flag = "PredVisualizersDot"})
        --
        PredVisualizerSection:Toggle({Name = "Line", Flag = "PredVisualizersLine"})
        --
        PredVisualizerSection:Toggle({Name = "Hit Point", Flag = "PredVisualizersHitPoint"})
        --
        PredVisualizerSection:Dropdown({Name = "Hit Part Visualization", Flag = "PredVisualizerHitPart", Content = {"Head", "HumanoidRootPart", "LowerTorso", "UpperTorso", "RightUpperLeg", "LeftUpperLeg", "RightLowerLeg", "LeftLowerLeg", "RightFoot", "LeftFoot", "LeftUpperArm", "RightUpperArm", "RightLowerArm", "LeftLowerArm", "LeftHand", "RightHand"}, Default = "HumanoidRootPart"})
    end
    --
    if CurrentGame.Name == "Da Hood" then
        do -- Bullet Tracers
            local BulletTracerSection = VisualsTab:Section({Name = "Bullet Tracers", Side = "Left"})
            --
            local BulletTracerEnabled = BulletTracerSection:Toggle({Name = "Enabled", Flag = "BulletTracers"})
            BulletTracerEnabled:ColorPicker({Name = "Bullet Tracer Color", Flag = "BulletTracerColor", Default = Color3.fromRGB(0, 255, 0)})
            --
            BulletTracerSection:Dropdown({Name = "Bullet Tracer Type", Flag = "BulletTracerType", Content = {"Beam", "Drawing"}, Default = "Beam"})
            --
            local BulletImpactsEnabled = BulletTracerSection:Toggle({Name = "Impacts", Flag = "BulletImpacts"})
            --
            local BulletImpactColor = BulletTracerSection:Label({Message = "Impact Color"})
            BulletImpactColor:ColorPicker({Name = "Impact Color", Flag = "BulletImpactsColor", Default = Color3.fromRGB(0, 255, 0)})
        end
        --
        do -- In game crosshair
            local InGameCrosshairSection = VisualsTab:Section({Name = "In Game Crosshair", Side = "Left"})
            --
            local InGameCursorEnabled = InGameCrosshairSection:Toggle({Name = "Visible", Flag = "InGameCrosshairVisible", Default = true})
            InGameCursorEnabled:ColorPicker({Name = "Crosshair Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
                Client.PlayerGui.MainScreenGui.Aim.BackgroundColor3 = State
                --
                for i, v in next, Client.PlayerGui.MainScreenGui.Aim:GetChildren() do 
                    v.BackgroundColor3 = State
                end
            end})
            --
            InGameCrosshairSection:Toggle({Name = "Spinning", Flag = "InGameCrosshairSpin", Callback = function()
                Client.PlayerGui.MainScreenGui.Aim.Rotation = 0
            end})
            --
            InGameCrosshairSection:Slider({Name = "Spinning Speed", Flag = "InGameCrosshairSpinSpeed", Min = 1, Max = 10, Default = 3, Decimal = 0.1})
        end
        --
        do -- Backtrack
            local BacktrackSection = VisualsTab:Section({Name = "Back Track", Side = "Left"})
            --
            local BacktrackEnabled = BacktrackSection:Toggle({Name = "Enabled", Flag = "BacktrackEnabled"})
            BacktrackEnabled:ColorPicker({Name = "Back Track Color", Flag = "BacktrackColor", Default = Color3.fromRGB(0, 255, 0)})
            --
            BacktrackSection:Slider({Name = "Delay", Flag = "BacktrackDelay", Min = 0.1, Max = 10, Default = 2, Decimal = 0.1})
            --
            BacktrackSection:Dropdown({Name = "Material", Flag = "BacktrackMaterial", Content = {"Neon", "ForceField", "Plastic"}, Default = "ForceField"})
        end
        --
        do -- AimViewer
            local AimviewSection = VisualsTab:Section({Name = "Aimviewer", Side = "Left"})
            --
            local AimviewEnabled = AimviewSection:Toggle({Name = "Enabled", Default = true, Flag = "AimviewerEnabled"})
            AimviewEnabled:ColorPicker({Name = "Aim viewer Color", Flag = "AimviewerColor", Default = Color3.fromRGB(0, 255, 0)})
        end
        --
        do -- Hit Detection
            local HitDetectionSection = VisualsTab:Section({Name = "Hit Detection", Side = "Right"})
            --
            HitDetectionSection:Toggle({Name = "Enabled", Flag = "HitDetectionEnabled"})
            --
            HitDetectionSection:Toggle({Name = "Notifications", Flag = "HitDetectionNotifications"})
            --
            HitDetectionSection:Dropdown({Name = "Sound Type", Flag = "HitDetectionSoundType", Content = {"None", "Skeet", "Neverlose", "Rust", "Minecraft"}, Default = "Skeet"})
            --
            HitDetectionSection:Dropdown({Name = "Effect Type", Flag = "HitDetectionEffectType", Content = {"None", "Clone", "Slash", "Lightning", "Solar", "Galaxy", "Water"}, Default = "Clone"})
            --
            HitDetectionSection:Dropdown({Name = "Effect Material", Flag = "HitDetectionEffectMaterial", Content = {"ForceField", "Neon", "Plastic"}, Default = "ForceField"})
            --
            local HitEffectColor = HitDetectionSection:Label({Message = "Effect Color"})
            HitEffectColor:ColorPicker({Name = "Hit Effect Color", Flag = "HitDetectionEffectColor", Default = Color3.fromRGB(0, 255, 0)})
        end
        --
        do -- Tools
            local ToolsVisualSection = VisualsTab:Section({Name = "Weapons", Side = "Right"})
            --
            local WeaponPlayerChams = ToolsVisualSection:Toggle({Name = "Weapon Chams", Flag = "WeaponVisualsEnabled", Callback = Visuals.ToolRefresh})
            WeaponPlayerChams:ColorPicker({Name = "Weapon Chams Color", Flag = "WeaponVisualsColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.ToolRefresh})
            --
            ToolsVisualSection:Dropdown({Name = "Weapon Material", Flag = "WeaponVisualsMaterial", Content = {"ForceField", "Neon", "Plastic"}, Default = "Neon", Callback = Visuals.ToolRefresh})
            --
            ToolsVisualSection:Slider({Name = "Weapons Transparency", Flag = "WeaponVisualsTransparency", Min = 0, Max = 1, Default = 0, Decimal = 0.01, Callback = Visuals.ToolRefresh})
        end
        --
        do -- Local Player
            local ClientVisualSection = VisualsTab:Section({Name = "Client", Side = "Right"})
            --
            local LocalPlayerChams = ClientVisualSection:Toggle({Name = "Character Chams", Flag = "ClientPlayerChams", Callback = Visuals.ClientRefresh})
            LocalPlayerChams:ColorPicker({Name = "Character Chams Color", Flag = "ClientPlayerChamsColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.ClientRefresh})
            --
            local TrailEffect = ClientVisualSection:Toggle({Name = "Trail", Flag = "ClientVisualsTrail", Callback = function(State)
                if State and ClientCharacter then
                    for i, v in pairs(ClientCharacter:GetChildren()) do
                        if v:IsA("BasePart") then
                            local trail = Instance.new("Trail", v)
                            trail.Texture = "rbxassetid://1390780157"
                            trail.Parent = v
                            local attachment0 = Instance.new("Attachment", v)
                            attachment0.Name = "TrailAttachment0"
                            local attachment1 = Instance.new("Attachment", ClientCharacter.HumanoidRootPart)
                            attachment1.Name = "TrailAttachment1"
                            trail.Attachment0 = attachment0
                            trail.Attachment1 = attachment1
                            trail.Color = ColorSequence.new(Library.Flags["ClientVisualsTrailColor"])
                        end
                    end
                elseif not State or not ClientCharacter then
                    for i, v in pairs(ClientCharacter:GetChildren()) do
                        if v:FindFirstChild("Trail") then
                            v.Trail:Destroy()
                        end
                        if v.Name == "TrailAttachment0" or v.Name == "TrailAttachment1" then
                            v:Destroy()
                        end
                    end
                end
            end})
            TrailEffect:ColorPicker({Name = "Trail Color", Flag = "ClientVisualsTrailColor", Default = Color3.fromRGB(0, 255, 0)})
            --
            ClientVisualSection:Toggle({Name = "In Game UI", Flag = "InGameUIVisuals", Callback = Visuals.InGameRefresh})
            --
            local InGameEnergyUI = ClientVisualSection:Label({Message = "Energy Color"})
            InGameEnergyUI:ColorPicker({Name = "Energy Color", Flag = "InGameEnergyColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.InGameRefresh})
            --
            local InGameEnergyUI = ClientVisualSection:Label({Message = "Health Color"})
            InGameEnergyUI:ColorPicker({Name = "Health Color", Flag = "InGameHealthColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.InGameRefresh})
            --
            local InGameEnergyUI = ClientVisualSection:Label({Message = "Armor Color"})
            InGameEnergyUI:ColorPicker({Name = "Armor Color", Flag = "InGameArmorColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.InGameRefresh})
            --
            local InGameEnergyUI = ClientVisualSection:Label({Message = "Fire Armor Color"})
            InGameEnergyUI:ColorPicker({Name = "Fire Armor Color", Flag = "InGameFireArmorColor", Default = Color3.fromRGB(0, 255, 0), Callback = Visuals.InGameRefresh})
        end
    end
    --
    do -- Cursor
        local CursorEnabled = CursorVisualSection:Toggle({Name = "Enabled", Callback = function(State)
            Cursor.enabled = State
        end})
        CursorEnabled:ColorPicker({Name = "Cursor Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(State)
            Cursor.color = State
        end})
        --
        CursorVisualSection:Toggle({Name = "Text", Callback = function(State)
            Cursor.textenabled = State
        end})
        --
        CursorVisualSection:Toggle({Name = "Pulsing", Callback = function(State)
            Cursor.pulse = State
        end})
        --
        CursorVisualSection:Dropdown({Name = "Cursor Method", Flag = "CursorMethod", Content = {"Mouse", "Sticky"}, Default = "Mouse"})
        --
        CursorVisualSection:Slider({Name = "Width", Min = 0.1, Max = 3, Default = 1, Decimal = 0.1, Callback = function(State)
            Cursor.width = State
        end})
        --
        CursorVisualSection:Slider({Name = "Length", Min = 5, Max = 25, Default = 10, Decimal = 0.1, Callback = function(State)
            Cursor.length = State
        end})
        --
        CursorVisualSection:Slider({Name = "Gap", Min = 5, Max = 25, Default = 10, Decimal = 0.1, Callback = function(State)
            Cursor.radius = State
        end})
        --
        CursorVisualSection:Toggle({Name = "Spinning", Default = true, Callback = function(State)
            Cursor.spin = State
        end})
        --
        CursorVisualSection:Slider({Name = "Spinning Speed", Min = 100, Max = 500, Default = 200, Callback = function(State)
            Cursor.spin_speed = State
        end})
        --
        CursorVisualSection:Dropdown({Name = "Easing Style", Content = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"}, Default = "Back", Callback = function(State)
            Cursor.spin_style = Enum.EasingStyle[State]
        end})
        --
        CursorVisualSection:Toggle({Name = "Resize", Callback = function(State)
            Cursor.resize = State
        end})
        --
        CursorVisualSection:Slider({Name = "Resizing Speed", Min = 50, Max = 500, Default = 150, Callback = function(State)
            Cursor.resize_speed = State
        end})
    end
end
--
do -- Movement
    local MiscAntilockSection = MiscTab:Section({Name = "Anti Aim", Side = "Left"})
    local MiscMovementSection = MiscTab:Section({Name = "Movement", Side = "Left"})
    local MiscTargetStrafeSection = MiscTab:Section({Name = "Target Strafe", Side = "Right"})
    local MiscCommandsSection = MiscTab:Section({Name = "Commands", Side = "Right"})
    --
    do -- Commands
        MiscCommandsSection:Toggle({Name = "Target Command", Default = true, Flag = "MiscTargetCommandEnabled"})
        MiscCommandsSection:TextBox({PlaceHolder = "Target Command", Default = ">Target", Max = 30, Flag = "MiscTargetCommand"})
        --
        MiscCommandsSection:Toggle({Name = "Goto Command", Default = true, Flag = "MiscGotoCommandEnabled"})
        MiscCommandsSection:TextBox({PlaceHolder = "Goto Command", Default = ">Goto", Max = 30, Flag = "MiscGotoCommand"})
        --
        MiscCommandsSection:Toggle({Name = "Spectate Command", Default = true, Flag = "MiscSpectateCommandEnabled"})
        MiscCommandsSection:TextBox({PlaceHolder = "Spectate Command", Default = ">Spec", Max = 30, Flag = "MiscSpectateCommand"})
        --
        MiscCommandsSection:Toggle({Name = "Aimviewer Command", Default = true, Flag = "MiscAimviewerCommandEnabled"})
        MiscCommandsSection:TextBox({PlaceHolder = "Aimviewer Command", Default = ">Aimview", Max = 30, Flag = "MiscAimviewerCommand"})
    end
    --
    do -- Anti Lock
        local AntiLockDesync = MiscAntilockSection:Toggle({Name = "Desync", Flag = "DesyncEnabled"})
        AntiLockDesync:Keybind({Default = "Z"})
        --
        MiscAntilockSection:Dropdown({Name = "Presets", Flag = "DesyncPreset", Content = {"None", "Walkable", "Disabler"}, Default = "None"})
        --
        MiscAntilockSection:Slider({Name = "Velocity X", Flag = "DesyncX", Min = -10000, Max = 10000, Default = 5000, Decimal = 1})
        --
        MiscAntilockSection:Slider({Name = "Velocity Y", Flag = "DesyncY", Min = -10000, Max = 10000, Default = 5000, Decimal = 1})
        --
        MiscAntilockSection:Slider({Name = "Velocity Z", Flag = "DesyncZ", Min = -10000, Max = 10000, Default = 5000, Decimal = 1})
        --[[
        local DesyncVisualization = MiscAntilockSection:Toggle({Name = "Visualization", Flag = "DesyncVisualization", Callback = function(State)
            if State then
                if ClientCharacter then
                    Visualisation:CreateVisual(ClientCharacter)
                end
            else
                Visualisation:DestroyVisual()
            end
        end})
        DesyncVisualization:ColorPicker({Name = "Visualization Color", Flag = "DesyncVisualizationColor", Default = Color3.fromRGB(0, 255, 0)})
        --
        MiscAntilockSection:Dropdown({Name = "Visualization Material", Flag = "DesyncVisualizationMaterial", Content = {"ForceField", "Neon", "Plastic"}, Default = "ForceField"})
        ]]
    end
    --
    do -- Movement
        local MovementCFrame = MiscMovementSection:Toggle({Name = "CFrame Speed", Flag = "MovementCFrame"})
        MovementCFrame:Keybind({Default = "X"})
        --
        MiscMovementSection:Slider({Name = "CFrame Speed Amount", Flag = "MovementCFrameAmount", Min = 1, Max = 100, Default = 20, Decimal = 0.1})
        --
        local MovementFlyEnabled = MiscMovementSection:Toggle({Name = "Fly", Flag = "MovementFly"})
        MovementFlyEnabled:Keybind({Default = "F"})
        --
        MiscMovementSection:Slider({Name = "Fly Speed", Flag = "MovementFlySpeed", Min = 1, Max = 300, Default = 100, Decimal = 0.1})
        --
        MiscMovementSection:Toggle({Name = "Bunny Hop", Flag = "MovementBhop"})
        --
        MiscMovementSection:Toggle({Name = "No Clip", Flag = "MovementNoClip", Callback = function(State)
            local Noclip = nil
            local Clip = nil
            
            function noclip()
                Clip = false
                local function Nocl()
                    if Clip == false and ClientCharacter ~= nil then
                        for _,v in pairs(ClientCharacter:GetDescendants()) do
                            if v:IsA('BasePart') and v.CanCollide then
                                v.CanCollide = false
                            end
                        end
                    end
                    Wait(0.21)
                end
                LuckyHub["Connections"].NoClip = RunService.Stepped:Connect(Nocl)
            end
            --
            function clip()
                if LuckyHub["Connections"].NoClip then LuckyHub["Connections"].NoClip:Disconnect() end
                Clip = true
            end
            --
            if State then
                noclip()
            else
                clip()
            end
        end})
    end
    --
    do -- Target Strafe
        local TargetStrafeEnabled = MiscTargetStrafeSection:Toggle({Name = "Target Strafe Enabled", Flag = "TargetStrafeEnabled"})
        TargetStrafeEnabled:Keybind({Default = "J"})
        --
        MiscTargetStrafeSection:Dropdown({Name = "Strafe Type", Flag = "TargetStrafeType", Content = {"Strafe", "Random"}, Default = "Strafe"})
        --
        MiscTargetStrafeSection:Slider({Name = "Speed", Flag = "TargetStrafeSpeed", Min = 0.1, Max = 25, Default = 3, Decimal = 0.1})
        --
        MiscTargetStrafeSection:Slider({Name = "Distance", Flag = "TargetStrafeDistance", Min = 1, Max = 25, Default = 10, Decimal = 0.1})
        --
        MiscTargetStrafeSection:Slider({Name = "Height", Flag = "TargetStrafeHeight", Min = 0, Max = 15, Default = 5, Decimal = 0.1})
    end
    --
    if CurrentGame.Name == "Da Hood" then
        local MiscAutoBuy = MiscTab:Section({Name = "Auto Buy", Side = "Left"})
        local MiscExtraSection = MiscTab:Section({Name = "Extra", Side = "Right"})
        --
        do -- Auto Buy
            MiscAutoBuy:Dropdown({Name = "Gun", Flag = "MiscGunOption", Content = {"TacticalShotgun", "Revolver", "Double-Barrel SG", "AK-47", "LMG", "P90"}, Default = "Revolver"})
            --
            MiscAutoBuy:Button({Name = "Buy Gun", Flag = "MiscGunBuyButton", Callback = function()
                if LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) and not ClientCharacter:FindFirstChild("ForceField") then
                    OldCFrame = ClientCharacter.HumanoidRootPart.CFrame
                    --
                    local Gun = Library.Flags["MiscGunOption"]
                    local RealGunName = Format("[%s]", Gun)
                    --
                    if Library.Flags["MiscGunOption"] ~= "Double-Barrel SG" then
                        if not Client.Backpack:FindFirstChild(RealGunName) then
                            LuckyHub:AutoBuy(Library.Flags["MiscGunOption"], "Gun")
                            Wait(0.6)
                        end
                    else
                        if not Client.Backpack:FindFirstChild("[Double-Barrel SG]") then
                            LuckyHub:AutoBuy("Double", "Gun")
                            Wait(0.6)
                        end
                    end
                    --
                    ClientCharacter.HumanoidRootPart.CFrame = OldCFrame
                end
            end})
            --
            MiscAutoBuy:Button({Name = "Buy Ammo", Flag = "MiscAmmoBuyButton", Callback = function()
                if LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) and not ClientCharacter:FindFirstChild("ForceField") then
                    OldCFrame = ClientCharacter.HumanoidRootPart.CFrame
                    --
                    local Gun = Library.Flags["MiscGunOption"]
                    local RealGunName = Format("[%s]", Gun)
                    --
                    if Library.Flags["MiscGunOption"] ~= "Double-Barrel SG" then
                        if Client.Backpack:FindFirstChild(RealGunName) then
                            LuckyHub:AutoBuy(Library.Flags["MiscGunOption"], "Ammo")
                            Wait(0.6)
                        end
                    else
                        if Client.Backpack:FindFirstChild("[Double-Barrel SG]") then
                            LuckyHub:AutoBuy("Double", "Ammo")
                            Wait(0.6)
                        end
                    end
                    --
                    ClientCharacter.HumanoidRootPart.CFrame = OldCFrame
                end
            end})
        end
        --
        do -- Extra
            MiscExtraSection:Toggle({Name = "Auto Reload", Flag = "MiscAutoReload"})
            --
            MiscExtraSection:Toggle({Name = "Auto Armor", Flag = "MiscAutoArmor"})
            --
            MiscExtraSection:Toggle({Name = "Auto Stomp", Flag = "MiscAutoStomp", Callback = function(State)
                if State then
                    LuckyHub["Connections"].AutoStomp = RunService.RenderStepped:Connect(function()
                        RemoteEvent:FireServer("Stomp")
                    end)
                else
                    if LuckyHub["Connections"].AutoStomp then LuckyHub["Connections"].AutoStomp:Disconnect() end
                end
            end})
            --
            MiscExtraSection:Toggle({Name = "No Slow", Flag = "MovementNoSlowdown"})
            --
            local OldCamera
            MiscExtraSection:Toggle({Name = "No Recoil", Flag = "MiscNoRecoil", Callback = function(State)
                if State then
                    local OldCameraCFrame = Workspace.CurrentCamera.CFrame
                    OldCamera = Workspace.CurrentCamera
                    OldCamera.Parent = nil
            
                    NewCamera = Instance.new("Camera", Workspace)
                    NewCamera.CameraSubject = ClientCharacter.Humanoid ~= nil and ClientCharacter.Humanoid
                    NewCamera.CFrame = OldCameraCFrame
                    NewCamera.CameraType = "Custom"
                else
                    if NewCamera then
                        NewCamera:Destroy()
                    end
                    --
                    if OldCamera ~= nil then
                        OldCamera.Parent = Workspace
                    end
                end
            end})
            --
            MiscExtraSection:Toggle({Name = "No Jump Cooldown", Flag = "MovementNoJumpCooldown"})
            --
            MiscExtraSection:Toggle({Name = "Anti Bag", Flag = "MiscAntiBag"})
            --
            MiscExtraSection:Toggle({Name = "Anti Void", Flag = "MiscAntiVoid", Callback = function(State)
                Workspace.FallenPartsDestroyHeight = State and -50000 or -500
            end})
            --
            MiscExtraSection:Toggle({Name = "Infinite Zoom", Flag = "MiscInfiniteZoom", Callback = function(State)
                if State then
                    Client.CameraMaxZoomDistance = Huge
                else
                    Client.CameraMaxZoomDistance = 30
                end
            end})
            --
            MiscExtraSection:Toggle({Name = "Disable Seats", Flag = "MiscRemoveSeats", Callback = function(State)
                if State then
                    ClientCharacter:FindFirstChild("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                else
                    ClientCharacter:FindFirstChild("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                end
            end})
        end
    end
end
--
do -- Settings
    local SettingsUI = SettingsTab:Section({Name = "UI", Side = "Left"})
    local ConfigSettings = SettingsTab:Section({Name = "Configuration", Side = "Right"})
    local UserUISettings = SettingsTab:Section({Name = "User Information", Side = "Right"})
    --
    do -- UI
        SettingsUI:Dropdown({Name = "UI Name Position", Content = {"Left", "Center", "Right"}, Default = "Center", Callback = function(State)
            Main:UpdateTextPosition(State)
        end})
        --
        local TextEffect = SettingsUI:Toggle({Name = "UI Name Text Effect", Flag = "UITextEffect", Default = true})
        local CloseUI = SettingsUI:Toggle({Name = "Open UI", Default = true, Callback = function(State)
            Main:MainUIVisibility(State)
        end})
        CloseUI:Keybind({Default = Enum.KeyCode.LeftAlt, HideFromList = true})
        --
        local WatermarkToggle = SettingsUI:Toggle({Name = "Watermark", Default = true, Callback = function(State) Main:WatermarkVisibility(State) end})
        local KeybindListToggle = SettingsUI:Toggle({Name = "Keybind List", Callback = function(State) Main:KeybindListVisibility(State) end})
        local IndicatorToggle = SettingsUI:Toggle({Name = "Indicators", Callback = function(State) Main:IndicatorVisibility(State) end})
        local VelocityStatsToggle = SettingsUI:Toggle({Name = "Velocity Stats", Callback = function(State) Main:VelocityStatsVisibility(State) end})
    end
    --
    do -- Config
        local ConfigList = ConfigSettings:Dropdown({Name = "Configs", Flag = "ConfigConfig_List"})
        --
        ConfigSettings:TextBox({PlaceHolder = "Config Name", Max = 32, Flag = "ConfigListConfigName"})
        --
        local CurrentList = {};
        --
        local function UpdateConfigList()
			local List = {};
			for idx, file in ipairs(listfiles("LuckyHub/Configs/Public")) do
				local FileName = file:gsub("LuckyHub/Configs/Public\\", ""):gsub(".LuckyHub", "")
				List[#List + 1] = FileName;
			end;

			local IsNew = #List ~= #CurrentList
			if not IsNew then
				for idx, file in ipairs(List) do
					if file ~= CurrentList[idx] then
						IsNew = true;
						break;
					end;
				end;
			end;

			if IsNew then
				CurrentList = List;
                ConfigList:Add("Config", Library.Flags["ConfigListConfigName"])
			end;
		end;
        --
        ConfigSettings:Button({Name = "Create", Flag = "ConfigConfig_Create", Callback = function()
            local ConfigName = Library.Flags["ConfigListConfigName"]
            --
            if ConfigName == "" or isfile("LuckyHub/Configs/Public/" .. ConfigName .. ".LuckyHub") then
				return;
			end
            --
			writefile("LuckyHub/Configs/Public/" .. ConfigName .. ".LuckyHub", Utility:GetConfig())
            --
            UpdateConfigList()
        end})
        --
        ConfigSettings:Button({Name = "Save", Flag = "ConfigConfig_Save", Callback = function()
            local SelectedConfig = Library.Flags["ConfigConfig_List"]
            --
			if SelectedConfig then
				writefile("LuckyHub/Configs/Public/" .. SelectedConfig .. ".LuckyHub", Utility:GetConfig())
			end
        end})
        --
        ConfigSettings:Button({Name = "Load", Flag = "ConfigConfig_Load", Callback = function()
            
        end})
        --
        ConfigSettings:Button({Name = "Delete", Callback = function()
            local SelectedConfig = Library.Flags["ConfigConfig_List"]
            --
			if SelectedConfig then
				delfile("LuckyHub/Configs/Public/" .. SelectedConfig .. ".LuckyHub")
			end
        end})
    end
    --
    do -- User
        local DaysLeft = LPH_OBFUSCATED and string.format("%s Days", tostring((LRM_SecondsLeft ~= math.huge and (LRM_SecondsLeft / 86400)) or "Unlimited")) or "N/A"
        local Executions = LPH_OBFUSCATED and string.format("%s", tostring(LRM_TotalExecutions) or "N/A") or "N/A"
        --
        UserUISettings:Label({Message = ("Username: %s"):format(Client.Name)})
        UserUISettings:Label({Message = ("Subscription: %s"):format(DaysLeft)})
        UserUISettings:Label({Message = ("Executions: %s"):format(Executions)})
        UserUISettings:Label({Message = ("Build Version: %s"):format(LuckyHub.Shared.Build)})
    end
end
--
local temp = tick()
local Tick = tick()
--
RunService.PreRender:Connect(LPH_NO_VIRTUALIZE(function()
	local FPS = math.floor(1 / math.abs(temp - tick()))
	temp = tick()
	local Ping = Stats.Network:FindFirstChild("ServerStatsItem") and tostring(math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())) or "N/A"
	--
	task.spawn(function()
		if (tick() - Tick) > 0.15 then
				Main:UpdateWatermark(string.format("LuckyHub | Build: Buyer | Ping: %s | FPS: %s", tostring(Ping), tostring(FPS)))
			--
			Tick = tick()
		end
	end)
end))
--
RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
        Utility:ThreadFunction(LuckyHub.UpdateFOV, "0x01")
        --
        if Library.Flags["SilentAimEnabled"] and Library.Flags["TargetMode"] == "FOV" then
            Utility:ThreadFunction(LuckyHub.GetTarget, "0x02")
        end
        --
        Utility:ThreadFunction(LuckyHub.CalculateAimpoint, "0x03")
        --
        Utility:ThreadFunction(LuckyHub.AutoPrediction, "0x04")
        --
        Utility:ThreadFunction(LuckyHub.DrawVisualizations, "0x11")
        --
        if Library.Flags["AimAssistEnabled"] and Library.Flags["TargetMode"] == "FOV" then
            Utility:ThreadFunction(LuckyHub.GetAimAssistTarget, "0x05")
        end
        --
        Utility:ThreadFunction(LuckyHub.AimAssist, "0x06")
        --
        Utility:ThreadFunction(Movement.Update, "0x10")
        --
        if CurrentGame.Name == "Da Hood" then
            Utility:ThreadFunction(LuckyHub.RotateCursor, "0x10")
        end
        --
        Utility:ThreadFunction(LuckyHub.GetUniversalAimAssistTarget, "0x119")
        Utility:ThreadFunction(LuckyHub.UniversalAimAssist, "0x120")
        --
        Utility:ThreadFunction(LuckyHub.GetTriggerBotTarget, "0x121")
        Utility:ThreadFunction(LuckyHub.TriggerBot, "0x122")
        --
        Utility:ThreadFunction(LuckyHub.DrawAimviewers, "0x124")
        --
        Utility:ThreadFunction(LuckyHub.UpdateHealth, "0x125")
        --
        if Library.Flags["ESPHighlightTargetEnabled"] and Library.Flags["TargetMode"] == "Target" then
            ESP.UpdateTarget(LuckyHub.Locals.AimAssistTarget)
        end
end))
--
Spawn(function()
    while true do 
        task.wait(Library.Flags["BacktrackDelay"])
        --
        if LuckyHub.Locals.Target and LuckyHub.Locals.Target.Character then 
            if Library.Flags["BacktrackEnabled"] then
                LuckyHub:CreateClone(LuckyHub.Locals.Target, Library.Flags["BacktrackColor"], Library.Flags["BacktrackMaterial"], LuckyHub.Folders["Part Chams"]);
                task.wait(Library.Flags["BacktrackDelay"])
                LuckyHub.Folders["Part Chams"]:ClearAllChildren()
            end     
        end 
    end 
end)
--
RunService.PostSimulation:Connect(LPH_NO_VIRTUALIZE(function()
        if Library.Flags["DesyncEnabled"] then 
            if ClientCharacter and LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) then
                oldvel = ClientCharacter.HumanoidRootPart.Velocity
                ClientCharacter.HumanoidRootPart.CFrame = ClientCharacter.HumanoidRootPart.CFrame * CFrame.Angles(0, Rad(0), 0)
                ClientCharacter.HumanoidRootPart.CFrame = ClientCharacter.HumanoidRootPart.CFrame * CFrame.Angles(0, Rad(0.0001), 0)
                ClientCharacter.HumanoidRootPart.Velocity = Vector3.new(Library.Flags["DesyncX"], Library.Flags["DesyncY"], Library.Flags["DesyncZ"])
                RunService.RenderStepped:Wait()
                ClientCharacter.HumanoidRootPart.Velocity = oldvel
                --
                if Library.Flags["DesyncPreset"] ~= "None" then
                    if Library.Flags["DesyncPreset"] == "Walkable" then
                        Library.Flags["DesyncX"] = Random(-10000, 10000)
                        Library.Flags["DesyncY"] = Random(0, 10000)
                        Library.Flags["DesyncZ"] = Random(-10000, 10000)
                    elseif Library.Flags["DesyncPreset"] == "Disabler" then
                        Library.Flags["DesyncX"] = 0
                        Library.Flags["DesyncY"] = 0
                        Library.Flags["DesyncZ"] = 0
                    end
                end
            end
        end
        --
        if Library.Flags["MiscAutoArmor"] then 
            if ClientCharacter.BodyEffects.Armor.Value < 100 then 
                local Pos = ClientCharacter.HumanoidRootPart.CFrame
                ClientCharacter.HumanoidRootPart.CFrame = Workspace.Ignored.Shop["[High-Medium Armor] - $2440"].Head.CFrame
                fireclickdetector(Workspace.Ignored.Shop["[High-Medium Armor] - $2440"].ClickDetector)
                RunService.RenderStepped:Wait()
                ClientCharacter.HumanoidRootPart.CFrame = Pos 
            end 
        end
        --
        if Library.Flags["TargetStrafeEnabled"] and Library.Flags["TargetMode"] == "Target" then
            if LuckyHub.Locals.Target ~= nil then
                if ClientCharacter and LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) and LuckyHub:ClientAlive(LuckyHub.Locals.Target, LuckyHub.Locals.Target.Character, LuckyHub.Locals.Target.Character:FindFirstChild("Humanoid")) then
                    if Library.Flags["TargetStrafeType"] == "Strafe" then
                        Movement.TargetPosition = LuckyHub.Locals.Target.Character.HumanoidRootPart.Position + Vector3.new(0, Library.Flags["TargetStrafeHeight"], 0)
                        --
                        Movement.StrafeCalculation += Library.Flags["TargetStrafeSpeed"]
                        --
                        ClientCharacter.HumanoidRootPart.CFrame = CFrame.Angles(0, Rad(Movement.StrafeCalculation), 0) * CFrame.new(0, 0, Library.Flags["TargetStrafeDistance"]) + Movement.TargetPosition
                    else
                        Movement.TargetPosition = LuckyHub.Locals.Target.Character.HumanoidRootPart.Position
                        --
                        ClientCharacter.HumanoidRootPart.CFrame = (CFrame.new(Movement.TargetPosition) + Vector3.new(Random(-Library.Flags["TargetStrafeDistance"], Library.Flags["TargetStrafeDistance"]), Random(0, Library.Flags["TargetStrafeHeight"]), Random(-Library.Flags["TargetStrafeDistance"], Library.Flags["TargetStrafeDistance"])))
                    end
                end
            end
        end
end))
--
do -- UserInput
    UserInputService.InputBegan:Connect(function(Input, Processed)
        if not Processed then
            if Input.KeyCode == Enum.KeyCode[tostring(LuckyHub:GetAimAssistKeybind()):upper()] then
                if Library.Flags["TargetMode"] == "Target" then
                    if LuckyHub.Locals.AimAssistTarget then
                        LuckyHub.Locals.AimAssistTarget = nil
                        LuckyHub.Locals.Target = nil
                        --
                        Main:UpdateIndicator(LuckyHub.Locals.Target)
                        --
                        if Library.Flags["NotificationsEnabled"] then
                            Library:Notify("Target: nil", 2)
                        end
                    else
                        LuckyHub:GetAimAssistTarget()
                        --
                        if LuckyHub.Locals.AimAssistTarget then
                            LuckyHub.Locals.Target = LuckyHub.Locals.AimAssistTarget
                            --
                            Main:UpdateIndicator(LuckyHub.Locals.Target)
                            --
                            if Library.Flags["NotificationsEnabled"] then
                                Library:Notify(("Target: %s"):format(LuckyHub.Locals.AimAssistTarget.DisplayName), 2)
                            end
                        end
                    end
                end
            end
        end
    end)
end
--
for _, player in next, Players:GetPlayers() do
    if player == Client then continue end
    --
    if player and player:IsFriendsWith(Client.UserId) then
        Library:SetPlayerFlag(player, "Friend")
    end
end

Players.PlayerAdded:Connect(function(player)
    if player and player:IsFriendsWith(Client.UserId) then
        Library:SetPlayerFlag(player, "Friend")
    end
end)
--
do -- Commands
    Client.Chatted:Connect(function(Message)
        local loweredString = string.lower(Message)
        local args = string.split(loweredString," ")
        --
        local TargetCommand = tostring(Library.Flags["MiscTargetCommand"]):lower()
        local GotoCommand = tostring(Library.Flags["MiscGotoCommand"]):lower()
        local SpectateCommand = tostring(Library.Flags["MiscSpectateCommand"]):lower()
        local firstChar = SpectateCommand:sub(1, 1)
        --
        local UnspectateCommand
        --
        if string.match(firstChar, "%p") then
            UnspectateCommand = firstChar .. "un" .. SpectateCommand:sub(2)
        else
            UnspectateCommand = "un" .. SpectateCommand
        end
        --
        local AimviewCommand = tostring(Library.Flags["MiscAimviewerCommand"]):lower()
        --
        if args[1] == TargetCommand then
            if args[2] ~= nil then
                if not Library.Flags["MiscTargetCommandEnabled"] then return end
                --
                if Library.Flags["TargetMode"] == "Target" then
                    for _, Player in pairs(Players:GetPlayers()) do
                        if Player == Client then continue end
                        --
                        local NameCheck = string.lower(Player.DisplayName or Player.Name)
                        --
                        if string.sub(NameCheck, 1, string.len(args[2])) == string.lower(args[2]) then
                            if LuckyHub.Locals.AimAssistTarget == nil then
                                LuckyHub.Locals.AimAssistTarget = Player
                                --
                                if LuckyHub.Locals.AimAssistTarget then
                                    LuckyHub.Locals.Target = LuckyHub.Locals.AimAssistTarget
                                    --
                                    Main:UpdateIndicator(LuckyHub.Locals.Target)
                                    --
                                    if Library.Flags["NotificationsEnabled"] then Library:Notify(("Target: %s"):format(LuckyHub.Locals.AimAssistTarget.DisplayName), 2) end
                                end
                                --
                                break
                            end
                        end
                    end
                end
            end
        elseif args[1] == GotoCommand then
            if args[2] ~= nil then
                if not Library.Flags["MiscGotoCommandEnabled"] then return end
                --
                for _, Player in pairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local NameCheck = string.lower(Player.DisplayName or Player.Name)
                    --
                    if string.sub(NameCheck, 1, string.len(args[2])) == string.lower(args[2]) then
                        if LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) then
                            ClientCharacter:FindFirstChild("HumanoidRootPart").CFrame = Player.Character:GetPivot()
                            if Library.Flags["NotificationsEnabled"] then Library:Notify(string.format("Successfully teleported to %s at (%s)", Player.Name, tostring(string.format("%.0f, %.0f, %.0f", Player.Character.HumanoidRootPart.Position.X, Player.Character.HumanoidRootPart.Position.Y, Player.Character.HumanoidRootPart.Position.Z)))) end
                            --
                            break
                        end
                    end
                end
            end
        elseif args[1] == SpectateCommand then
            if args[2] ~= nil then
                if not Library.Flags["MiscSpectateCommandEnabled"] then return end
                --
                for _, Player in pairs(Players:GetPlayers()) do
                    if Player == Client then continue end
                    --
                    local NameCheck = string.lower(Player.DisplayName or Player.Name)
                    --
                    if string.sub(NameCheck, 1, string.len(args[2])) == string.lower(args[2]) then
                        if LuckyHub:ClientAlive(Client, ClientCharacter, ClientCharacter:FindFirstChild("Humanoid")) then
                            if LuckyHub.Locals.Spectating == false then
                                LuckyHub.Locals.Spectating = true
                                Workspace.CurrentCamera.CameraSubject = Player.Character
                                --
                                break
                            end
                        end
                    end
                end
            end
        elseif args[1] == UnspectateCommand then
            if not Library.Flags["MiscSpectateCommandEnabled"] then return end
            --
            LuckyHub.Locals.Spectating = false
            Workspace.CurrentCamera.CameraSubject = ClientCharacter
        elseif args[1] == AimviewCommand then
            if args[2] ~= nil then
                if not Library.Flags["MiscAimviewerCommandEnabled"] then return end
                --
                for _, Player in pairs(Players:GetPlayers()) do
                    local NameCheck = string.lower(Player.DisplayName or Player.Name)
                    --
                    if string.sub(NameCheck, 1, string.len(args[2])) == string.lower(args[2]) then
                        LuckyHub.Locals.AimviewerTarget = Player
                        --
                        break
                    end
                end
            end
        end
    end)
end
--
local function Ammo()
    LuckyHub:HitDetection()
end
--
LuckyHub["Connections"]["HitDetection"] = {}
--
Client.CharacterAdded:Connect(function(Character)
    repeat Wait() until Character:FindFirstChildOfClass("Humanoid")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    --
    Wait(0.5)
    --
    ClientCharacter = Character
    --
    if Library.Flags["ClientVisualsTrail"] and ClientCharacter then
        for i, v in pairs(ClientCharacter:GetChildren()) do
            if v:IsA("BasePart") then
                local trail = Instance.new("Trail", v)
                trail.Texture = "rbxassetid://1390780157"
                trail.Parent = v
                local attachment0 = Instance.new("Attachment", v)
                attachment0.Name = "TrailAttachment0"
                local attachment1 = Instance.new("Attachment", ClientCharacter.HumanoidRootPart)
                attachment1.Name = "TrailAttachment1"
                trail.Attachment0 = attachment0
                trail.Attachment1 = attachment1
                trail.Color = ColorSequence.new(Library.Flags["ClientVisualsTrailColor"])
            end
        end
    end
    --
    Visuals:ClientRefresh()
    --
    if LuckyHub["Connections"]["HitDetection"][1] then 
        LuckyHub["Connections"]["HitDetection"][1]:Disconnect()
        LuckyHub["Connections"]["HitDetection"][1] = nil
    end
    --
    Character.ChildAdded:Connect(function(child)
        if Library.Flags["MiscAntiBag"] and child.Name == "Christmas_Sock" then
            child:Destroy()
        end
        --
        if child:IsA("Tool") then
            if LuckyHub.Locals.ToolConnection[1] == nil then
                LuckyHub.Locals.ToolConnection[1] = child 
            end

            if LuckyHub.Locals.ToolConnection[1] ~= child and LuckyHub.Locals.ToolConnection[2] ~= nil then 
                LuckyHub.Locals.ToolConnection[2]:Disconnect()
                LuckyHub.Locals.ToolConnection[1] = child
            end

            if not LuckyHub["Connections"]["HitDetection"][child] then 
                LuckyHub["Connections"]["HitDetection"][child] = child:FindFirstChild("Ammo") and child.Ammo:GetPropertyChangedSignal("Value"):Connect(Ammo)
            end

            if child:FindFirstChild("Ammo") then
                Visuals:ToolRefresh()
            end
    
            LuckyHub.Locals.ToolConnection[2] = child.Activated:Connect(function()
                if Library.Flags["MiscAutoReload"] then
                    if child:FindFirstChild("Ammo") ~= nil then
                        --
                        if child["Ammo"].Value == 0 then
                            RemoteEvent:FireServer("Reload", child)
                        end
                    end
                end
                --
                if LuckyHub.Locals.Target ~= nil and Library.Flags["SilentAimEnabled"] and CurrentGame.MouseArguments then
                    RemoteEvent:FireServer(CurrentGame.MouseArguments, LuckyHub.Locals.AimPoint + LuckyHub.Locals.AimOffset)
                end
            end)
        end
    end)
end)
--
Client.CharacterRemoving:Connect(function(Character)
    if Visualisation.Character then
        for Index, Value in pairs(Visualisation.Character) do
            Utility:RemoveInstance(Value)
        end
    end
    --
    for i, v in pairs(ClientCharacter:GetChildren()) do
        if v:FindFirstChild("Trail") then
            v.Trail:Destroy()
        end
        if v.Name == "TrailAttachment0" or v.Name == "TrailAttachment1" then
            v:Destroy()
        end
    end
    --
    Visualisation.Character = nil
end)
--
ClientCharacter.ChildAdded:Connect(function(child)
    if Library.Flags["MiscAntiBag"] and child.Name == "Christmas_Sock" then
        child:Destroy()
    end
    --
    if child:IsA("Tool") then
        if LuckyHub.Locals.ToolConnection[1] == nil then
            LuckyHub.Locals.ToolConnection[1] = child 
        end

        if LuckyHub.Locals.ToolConnection[1] ~= child and LuckyHub.Locals.ToolConnection[2] ~= nil then 
            LuckyHub.Locals.ToolConnection[2]:Disconnect()
            LuckyHub.Locals.ToolConnection[1] = child
        end

        if not LuckyHub["Connections"]["HitDetection"][child] then
            LuckyHub["Connections"]["HitDetection"][child] = child:FindFirstChild("Ammo") and child.Ammo:GetPropertyChangedSignal("Value"):Connect(Ammo)
        end

        if child:FindFirstChild("Ammo") then
            Visuals:ToolRefresh()
        end

        LuckyHub.Locals.ToolConnection[2] = child.Activated:Connect(function()
            if Library.Flags["MiscAutoReload"] then
                if child:FindFirstChild("Ammo") ~= nil then
                    --
                    if child["Ammo"].Value == 0 then
                        RemoteEvent:FireServer("Reload", child)
                    end
                end
            end
            --
            if LuckyHub.Locals.Target ~= nil and Library.Flags["SilentAimEnabled"] and CurrentGame.MouseArguments then
                RemoteEvent:FireServer(CurrentGame.MouseArguments, LuckyHub.Locals.AimPoint + LuckyHub.Locals.AimOffset)
            end
        end)
    end
end)
--
Spawn(function()
    LPH_NO_VIRTUALIZE(function()
        local Counter = 1
        local TotalLength = #ChangingTitle
        local Direction = false
        while true do
            if Library.Flags["UITextEffect"] then
                Main:UpdateTitle(ChangingTitle[Counter])
                    
                if Counter >= TotalLength then
                    Direction = true
                elseif Counter <= 1 then
                    Direction = false
                end

                if Direction == true then
                    Counter -= 1
                else
                    Counter += 1
                end
            else
                Main:UpdateTitle("LuckyHub")
                Counter = 1
            end

            Wait(0.3)
        end
    end)()
end)
--
Library:Init()
--
if ExecutionTime then
    if LPH_OBFUSCATED then
        if LRM_TotalExecutions == 1 then
            Library:Notify(("Welcome to LuckyHub, %s! Succesfully loaded in %s seconds."):format(Client.Name, string.format("%.".."4".."f", os.clock() - ExecutionTime)), 5)
        end
    else
        Library:Notify(("Succesfully loaded in %s seconds."):format(string.format("%.".."4".."f", os.clock() - ExecutionTime)), 5)
    end
end
