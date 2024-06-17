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
	performanceDrag = false,
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
function Library:AutoResize(scrollingFrame, uilistlayout)
	local function ResizeScrollingFrame()
		local totalHeight = 0
		for _, child in ipairs(scrollingFrame:GetChildren()) do
			if child:IsA("GuiObject") then
				totalHeight = totalHeight + child.AbsoluteSize.Y
			end
		end
		totalHeight = totalHeight + (#scrollingFrame:GetChildren() - 1) * uilistlayout.Padding.Offset
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight - 7)
		scrollingFrame.ScrollBarImageTransparency = scrollingFrame.CanvasSize.Y.Offset <= scrollingFrame.AbsoluteSize.Y and 1 or 0
	end

	uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(ResizeScrollingFrame)
	ResizeScrollingFrame()
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
		GUI["1c"]["Size"] = UDim2.new(0, 200, 0, 30);
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
			local size = UDim2.new(0, 200, 0, 30)

			if #GUI["hh"]:GetChildren() >= 1 then
				local largestTextBounds = GetLargestTextBounds()

				size = UDim2.new(0, math.max(largestTextBounds.X + 12, 200), 0, 30)
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
		GUI["4"].Visible = State
	end

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
		end
	end)

	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
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
	end)

	cornerFrame.MouseLeave:Connect(function()
		Hover = false
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

		Library:AutoResize(GUI["47"], GUI["49"])

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

			Library:AutoResize(Tab["8"], Tab["42"])
			Library:AutoResize(Tab["41"], Tab["42"])
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

				-- StarterGui.MyLibrary.MainBackground.ContentContainer.PlayerTab.PlayerListSection.PlayerList
				PlayerListTab["5"] = Instance.new("Frame", Tab["7"]);
				PlayerListTab["5"]["BorderSizePixel"] = 0;
				PlayerListTab["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				PlayerListTab["5"]["BackgroundTransparency"] = 1;
				PlayerListTab["5"]["Size"] = UDim2.new(1, -2, 1, 20);
				PlayerListTab["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				PlayerListTab["5"]["Position"] = UDim2.new(0, 1, 0, -12);
				PlayerListTab["5"]["Name"] = [[PlayerTab]];
				PlayerListTab["5"]["ClipsDescendants"] = false;

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

			Library:AutoResize(PlayerListTab["24"], PlayerListTab["2f"])

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
						Item["29"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
						Item["29"]["Size"] = UDim2.new(0.33000001311302185, 0, 1, 0);
						Item["29"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						Item["29"]["Text"] = Tab:GetFlag(Player) ~= nil and tostring(Tab:GetFlag(Player)) or "None";
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
					end

					function PlayerListTab:UpdateFlag(Player)
						if Player == nil then return end
						--
						for i, v in pairs(PlayerListTab["24"]:GetDescendants()) do
							if v.Name == Player.Name then
								local FlagsText = v:FindFirstChild("Flags")
								if FlagsText then
									Item.Flag = Tab:GetFlag(Player) ~= nil and tostring(Tab:GetFlag(Player)) or "None"
									local FlagColor = Tab:GetColor(Tab:GetFlag(Player))
									FlagsText.Text = Item.Flag
									FlagsText.TextColor3 = FlagColor
								end
							end
						end
					end

					function Library:GetPlayerFlag(Player)
						if Player == nil then return end

						local Flag

						for i, v in pairs(PlayerListTab["24"]:GetDescendants()) do
							if v.Name == Player.Name then
								local FlagsText = v:FindFirstChild("Flags")
								--
								if FlagsText then
									Flag = FlagsText.Text
								end
							end
						end

						return Flag
					end

					function Library:SetPlayerFlag(Player, Flag)
						if Player == nil then return end

						Tab:SetFlag(Flag)
						PlayerListTab:UpdateFlag(Player)
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
							Library.Flags[options.Default] = options.Default
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

										options.Callback(ColorPicker.Color)
										Library.Flags[ColorPicker:GetFlag()] = ColorPicker.Color
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


						options.Callback(ColorPicker.Color)
						Library.Flags[options.Flag] = ColorPicker.Color

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
							State = true,
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
									if Keybind.Mode == "Off Hold" then
										Keybind:Toggle(true)
									else
										Keybind:Toggle()
									end
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

								if Keybind.Mode ~= "Off Hold" then
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
							Library.Flags[options.Default] = options.Default
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

										options.Callback(ColorPicker.Color)
										Library.Flags[ColorPicker:GetFlag()] = ColorPicker.Color
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
						Library.Flags[options.Flag] = ColorPicker.Color

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

return Library
