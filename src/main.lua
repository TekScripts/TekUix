-- >!strict
local Tekscripts = {}
Tekscripts.__index = Tekscripts

-- > Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local IconLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/TekScripts/TekUix/refs/heads/main/src/IconLibrary.lua"))()
local FALLBACK_ICON_NAME = "mouse-pointer" 


-- > Tabela de Constantes de Design (Tema Dark Clean com alto contraste)
local DESIGN = {
	-- > Cores principais
	WindowColor1          = Color3.fromRGB(25, 26, 28),
	WindowColor2          = Color3.fromRGB(20, 21, 23),
	BlockScreenColor      = Color3.fromRGB(0, 0, 0, 0.65),
	WindowTransparency    = 0.4,
	TabContainerTransparency = 0.15,

	TitleColor            = Color3.fromRGB(240, 240, 245),
	ComponentTextColor    = Color3.fromRGB(215, 215, 220),
	InputTextColor        = Color3.fromRGB(230, 230, 235),
	NotifyTextColor       = Color3.fromRGB(220, 220, 225),
	EmptyStateTextColor   = Color3.fromRGB(150, 150, 155),

	ComponentBackground   = Color3.fromRGB(34, 35, 38),
	InputBackgroundColor  = Color3.fromRGB(42, 43, 47),

	AccentColor           = Color3.fromRGB(90, 160, 255),
	ItemHoverColor        = Color3.fromRGB(50, 52, 57),
	ComponentHoverColor   = Color3.fromRGB(65, 68, 75),

	ActiveToggleColor     = Color3.fromRGB(90, 160, 255),
	InactiveToggleColor   = Color3.fromRGB(55, 56, 60),

	MinimizeButtonColor   = Color3.fromRGB(180, 180, 185),
	CloseButtonColor      = Color3.fromRGB(255, 85, 100),
	FloatButtonColor      = Color3.fromRGB(45, 46, 52),

	DropdownBackground    = Color3.fromRGB(32, 33, 37),
	DropdownItemHover     = Color3.fromRGB(55, 57, 63),

	TabActiveColor        = Color3.fromRGB(90, 160, 255),
	TabInactiveColor      = Color3.fromRGB(36, 37, 41),

	SliderTrackColor      = Color3.fromRGB(58, 59, 63),
	SliderFillColor       = Color3.fromRGB(90, 160, 255),
	ThumbColor            = Color3.fromRGB(240, 240, 245),
	ThumbOutlineColor     = Color3.fromRGB(45, 46, 50),

	HRColor               = Color3.fromRGB(75, 76, 82),
	ResizeHandleColor     = Color3.fromRGB(60, 61, 66),
	NotifyBackground      = Color3.fromRGB(38, 39, 43),
	TagBackground         = Color3.fromRGB(90, 160, 255),

	-- > Dimensões e layout (otimizadas para telas menores)
	WindowSize            = UDim2.new(0, 450, 0, 300),
	MinWindowSize         = Vector2.new(320, 260),
	MaxWindowSize         = Vector2.new(520, 370),

	TitleHeight           = 32,
	TitlePadding          = 10,

	ComponentHeight       = 32,
	ComponentPadding      = 6,
	ContainerPadding      = 5,
	CornerRadius          = 6,

	ButtonIconSize        = 20,
	IconSize              = 24,

	TabButtonWidth        = 110,
	TabButtonHeight       = 36,

	FloatButtonSize       = UDim2.new(0, 130, 0, 42),
	ResizeHandleSize      = 14,

	NotifyWidth           = 250,
	NotifyHeight          = 65,
	TagHeight             = 28,
	TagWidth              = 100,

	HRHeight              = 1,
	HRTextPadding         = 10,
	HRMinTextSize         = 16,
	HRMaxTextSize         = 24,

	DropdownWidth         = 140,
	DropdownItemHeight    = 32,

	BlurEffectSize        = 8,
	AnimationSpeed        = 0.2,
}

-- > Armazena objetos que dependem de cada chave do tema para atualização dinâmica
local THEME_BINDINGS = {}

-- > > {UTILITÁRIO}
-- > Cópia superficial de tabela (usada para criar presets independentes)
local function ShallowCopy(original: table): table
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

-- > > {REGISTRO DE COMPONENTES}
-- > Registra um objeto UI para ser atualizado automaticamente quando a chave do tema mudar
local function RegisterThemeItem(key: string, object: Instance, property: string)
	if not THEME_BINDINGS[key] then
		THEME_BINDINGS[key] = {}
	end

	table.insert(THEME_BINDINGS[key], { object = object, property = property })

	-- > Aplica valor inicial se já existir no DESIGN
	if DESIGN[key] ~= nil then
		object[property] = DESIGN[key]
	end
end

-- > > {ATUALIZAÇÃO DINÂMICA}
-- > Aplica uma nova cor/dimensão a todos os objetos registrados para a chave
local function ApplyThemeChange(key: string, newValue: any)
	DESIGN[key] = newValue

	if THEME_BINDINGS[key] then
		for _, data in ipairs(THEME_BINDINGS[key]) do
			if data.object and data.object.Parent then
				data.object[data.property] = newValue
			end
		end
	end
end

-- > Atualiza uma chave específica do tema (com validação)
local function SetThemeKey(key: string, value: any)
	if DESIGN[key] == nil then
		warn("[Theme] Chave inexistente no DESIGN:", key)
		return
	end
	ApplyThemeChange(key, value)
end

-- > > {PRESETS DE TEMAS}
local PRESETS = {
	Default = ShallowCopy(DESIGN),

	Oceanic = {
		WindowColor1          = Color3.fromRGB(18, 24, 32),
		WindowColor2          = Color3.fromRGB(13, 18, 25),
		BlockScreenColor      = Color3.fromRGB(0, 0, 0),
		WindowTransparency    = 0.1,
		TabContainerTransparency = 0.12,

		TitleColor            = Color3.fromRGB(220, 235, 245),
		ComponentTextColor    = Color3.fromRGB(210, 225, 235),
		InputTextColor        = Color3.fromRGB(225, 235, 240),
		NotifyTextColor       = Color3.fromRGB(215, 230, 240),
		EmptyStateTextColor   = Color3.fromRGB(150, 170, 175),

		ComponentBackground   = Color3.fromRGB(26, 34, 44),
		InputBackgroundColor  = Color3.fromRGB(30, 38, 50),

		AccentColor           = Color3.fromRGB(42, 160, 200),
		ItemHoverColor        = Color3.fromRGB(34, 44, 57),
		ComponentHoverColor   = Color3.fromRGB(40, 52, 68),

		ActiveToggleColor     = Color3.fromRGB(42, 160, 200),
		InactiveToggleColor   = Color3.fromRGB(60, 66, 74),

		MinimizeButtonColor   = Color3.fromRGB(185, 190, 195),
		CloseButtonColor      = Color3.fromRGB(230, 90, 90),
		FloatButtonColor      = Color3.fromRGB(28, 34, 42),

		DropdownBackground    = Color3.fromRGB(24, 32, 42),
		DropdownItemHover     = Color3.fromRGB(36, 46, 60),

		TabActiveColor        = Color3.fromRGB(42, 160, 200),
		TabInactiveColor      = Color3.fromRGB(38, 44, 50),

		SliderTrackColor      = Color3.fromRGB(52, 60, 70),
		SliderFillColor       = Color3.fromRGB(42, 160, 200),
		ThumbColor            = Color3.fromRGB(235, 245, 250),
		ThumbOutlineColor     = Color3.fromRGB(48, 56, 64),

		HRColor               = Color3.fromRGB(64, 76, 90),
		ResizeHandleColor     = Color3.fromRGB(56, 62, 70),
		NotifyBackground      = Color3.fromRGB(26, 34, 44),
		TagBackground         = Color3.fromRGB(42, 160, 200),
	},

	Slate = {
		WindowColor1          = Color3.fromRGB(28, 30, 34),
		WindowColor2          = Color3.fromRGB(22, 24, 28),
		BlockScreenColor      = Color3.fromRGB(0, 0, 0),
		WindowTransparency    = 0.12,
		TabContainerTransparency = 0.16,

		TitleColor            = Color3.fromRGB(235, 238, 240),
		ComponentTextColor    = Color3.fromRGB(220, 224, 226),
		InputTextColor        = Color3.fromRGB(230, 233, 235),
		NotifyTextColor       = Color3.fromRGB(225, 228, 230),
		EmptyStateTextColor   = Color3.fromRGB(155, 160, 165),

		ComponentBackground   = Color3.fromRGB(36, 38, 42),
		InputBackgroundColor  = Color3.fromRGB(42, 44, 48),

		AccentColor           = Color3.fromRGB(84, 185, 150),
		ItemHoverColor        = Color3.fromRGB(46, 48, 52),
		ComponentHoverColor   = Color3.fromRGB(52, 56, 60),

		ActiveToggleColor     = Color3.fromRGB(84, 185, 150),
		InactiveToggleColor   = Color3.fromRGB(64, 66, 70),

		MinimizeButtonColor   = Color3.fromRGB(190, 190, 195),
		CloseButtonColor      = Color3.fromRGB(255, 95, 95),
		FloatButtonColor      = Color3.fromRGB(34, 36, 40),

		DropdownBackground    = Color3.fromRGB(32, 34, 38),
		DropdownItemHover     = Color3.fromRGB(48, 50, 54),

		TabActiveColor        = Color3.fromRGB(84, 185, 150),
		TabInactiveColor      = Color3.fromRGB(40, 42, 46),

		SliderTrackColor      = Color3.fromRGB(58, 60, 64),
		SliderFillColor       = Color3.fromRGB(84, 185, 150),
		ThumbColor            = Color3.fromRGB(244, 246, 246),
		ThumbOutlineColor     = Color3.fromRGB(50, 52, 56),

		HRColor               = Color3.fromRGB(80, 84, 88),
		ResizeHandleColor     = Color3.fromRGB(60, 62, 66),
		NotifyBackground      = Color3.fromRGB(34, 36, 40),
		TagBackground         = Color3.fromRGB(84, 185, 150),
	},

	MonoDark = {
		WindowColor1          = Color3.fromRGB(30, 30, 30),
		WindowColor2          = Color3.fromRGB(20, 20, 20),
		BlockScreenColor      = Color3.fromRGB(0, 0, 0, 0.6),
		WindowTransparency    = 0.1,
		TabContainerTransparency = 0.15,

		TitleColor            = Color3.fromRGB(255, 255, 255),
		ComponentTextColor    = Color3.fromRGB(210, 210, 210),
		InputTextColor        = Color3.fromRGB(230, 230, 230),
		NotifyTextColor       = Color3.fromRGB(220, 220, 220),
		EmptyStateTextColor   = Color3.fromRGB(140, 140, 140),

		ComponentBackground   = Color3.fromRGB(40, 40, 40),
		InputBackgroundColor  = Color3.fromRGB(50, 50, 50),

		AccentColor           = Color3.fromRGB(255, 255, 255),
		ItemHoverColor        = Color3.fromRGB(60, 60, 60),
		ComponentHoverColor   = Color3.fromRGB(75, 75, 75),

		ActiveToggleColor     = Color3.fromRGB(255, 255, 255),
		InactiveToggleColor   = Color3.fromRGB(60, 60, 60),

		MinimizeButtonColor   = Color3.fromRGB(180, 180, 180),
		CloseButtonColor      = Color3.fromRGB(255, 80, 80),
		FloatButtonColor      = Color3.fromRGB(35, 35, 35),

		DropdownBackground    = Color3.fromRGB(30, 30, 30),
		DropdownItemHover     = Color3.fromRGB(55, 55, 55),

		TabActiveColor        = Color3.fromRGB(255, 255, 255),
		TabInactiveColor      = Color3.fromRGB(45, 45, 45),

		SliderTrackColor      = Color3.fromRGB(70, 70, 70),
		SliderFillColor       = Color3.fromRGB(255, 255, 255),
		ThumbColor            = Color3.fromRGB(255, 255, 255),
		ThumbOutlineColor     = Color3.fromRGB(50, 50, 50),

		HRColor               = Color3.fromRGB(85, 85, 85),
		ResizeHandleColor     = Color3.fromRGB(65, 65, 65),
		NotifyBackground      = Color3.fromRGB(45, 45, 45),
		TagBackground         = Color3.fromRGB(255, 255, 255),
	},

	Forest = {
		WindowColor1          = Color3.fromRGB(20, 28, 20),
		WindowColor2          = Color3.fromRGB(15, 22, 15),
		BlockScreenColor      = Color3.fromRGB(0, 0, 0, 0.7),
		WindowTransparency    = 0.5,
		TabContainerTransparency = 0.10,

		TitleColor            = Color3.fromRGB(230, 245, 230),
		ComponentTextColor    = Color3.fromRGB(200, 220, 200),
		InputTextColor        = Color3.fromRGB(210, 230, 210),
		NotifyTextColor       = Color3.fromRGB(205, 225, 205),
		EmptyStateTextColor   = Color3.fromRGB(130, 160, 130),

		ComponentBackground   = Color3.fromRGB(30, 42, 30),
		InputBackgroundColor  = Color3.fromRGB(40, 55, 40),

		AccentColor           = Color3.fromRGB(100, 170, 100),
		ItemHoverColor        = Color3.fromRGB(40, 55, 40),
		ComponentHoverColor   = Color3.fromRGB(50, 70, 50),

		ActiveToggleColor     = Color3.fromRGB(100, 170, 100),
		InactiveToggleColor   = Color3.fromRGB(50, 65, 50),

		MinimizeButtonColor   = Color3.fromRGB(170, 190, 170),
		CloseButtonColor      = Color3.fromRGB(255, 90, 90),
		FloatButtonColor      = Color3.fromRGB(25, 35, 25),

		DropdownBackground    = Color3.fromRGB(20, 30, 20),
		DropdownItemHover     = Color3.fromRGB(45, 60, 45),

		TabActiveColor        = Color3.fromRGB(100, 170, 100),
		TabInactiveColor      = Color3.fromRGB(35, 45, 35),

		SliderTrackColor      = Color3.fromRGB(60, 80, 60),
		SliderFillColor       = Color3.fromRGB(100, 170, 100),
		ThumbColor            = Color3.fromRGB(230, 245, 230),
		ThumbOutlineColor     = Color3.fromRGB(50, 65, 50),

		HRColor               = Color3.fromRGB(75, 100, 75),
		ResizeHandleColor     = Color3.fromRGB(60, 80, 60),
		NotifyBackground      = Color3.fromRGB(35, 45, 35),
		TagBackground         = Color3.fromRGB(100, 170, 100),
	},

	CrimsonDusk = {
		WindowColor1          = Color3.fromRGB(15, 17, 21),
		WindowColor2          = Color3.fromRGB(10, 12, 15),
		BlockScreenColor      = Color3.fromRGB(0, 0, 0, 0.7),
		WindowTransparency    = 0.1,
		TabContainerTransparency = 0.15,

		TitleColor            = Color3.fromRGB(250, 250, 255),
		ComponentTextColor    = Color3.fromRGB(220, 225, 230),
		InputTextColor        = Color3.fromRGB(240, 240, 245),
		NotifyTextColor       = Color3.fromRGB(230, 235, 240),
		EmptyStateTextColor   = Color3.fromRGB(130, 140, 150),

		ComponentBackground   = Color3.fromRGB(24, 28, 34),
		InputBackgroundColor  = Color3.fromRGB(30, 35, 42),

		AccentColor           = Color3.fromRGB(220, 50, 80),
		ItemHoverColor        = Color3.fromRGB(35, 40, 50),
		ComponentHoverColor   = Color3.fromRGB(45, 50, 60),

		ActiveToggleColor     = Color3.fromRGB(220, 50, 80),
		InactiveToggleColor   = Color3.fromRGB(45, 50, 58),

		MinimizeButtonColor   = Color3.fromRGB(190, 195, 200),
		CloseButtonColor      = Color3.fromRGB(255, 80, 80),
		FloatButtonColor      = Color3.fromRGB(20, 23, 28),

		DropdownBackground    = Color3.fromRGB(20, 22, 26),
		DropdownItemHover     = Color3.fromRGB(40, 45, 55),

		TabActiveColor        = Color3.fromRGB(220, 50, 80),
		TabInactiveColor      = Color3.fromRGB(30, 34, 40),

		SliderTrackColor      = Color3.fromRGB(50, 55, 65),
		SliderFillColor       = Color3.fromRGB(220, 50, 80),
		ThumbColor            = Color3.fromRGB(250, 250, 255),
		ThumbOutlineColor     = Color3.fromRGB(40, 45, 52),

		HRColor               = Color3.fromRGB(70, 80, 95),
		ResizeHandleColor     = Color3.fromRGB(60, 70, 85),
		NotifyBackground      = Color3.fromRGB(24, 28, 34),
		TagBackground         = Color3.fromRGB(220, 50, 80),
	},
}

-- > > {APLICAÇÃO DE TEMA}
-- > Aplica um preset completo, atualizando apenas as chaves que mudaram
local function SetTheme(presetTable: table)
	if type(presetTable) ~= "table" then
		warn("[Theme] Preset inválido fornecido para SetTheme")
		return
	end

	for key, value in pairs(presetTable) do
		if DESIGN[key] ~= nil and DESIGN[key] ~= value then
			ApplyThemeChange(key, value)
		end
	end
end

-- > > {UTILITÁRIO EXTRA}
-- > Retorna uma string JSON com a lista de nomes de temas disponíveis (ordenada)
local function GetAvailableThemesJson(): string
	local themeNames = {}
	for name, _ in pairs(PRESETS) do
		table.insert(themeNames, name)
	end

	table.sort(themeNames)
	return '[\"' .. table.concat(themeNames, '\",\"') .. '\"]'
end

-- > Tema inicial aplicado ao carregar o módulo
SetTheme(PRESETS.Oceanic)

-- > Funções de Criação de Componentes


-- > cache de TweenInfo (evita recriar o mesmo objeto várias vezes)
local tweenInfo = TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Quad)

-- > utilitário para criar cantos arredondados (reutilizável e limpo)
local function addRoundedCorners(instance: Instance, radius: number?)
	if not instance or not instance:IsA("GuiObject") then return end

	local corner = instance:FindFirstChildOfClass("UICorner")
	if not corner then
		corner = Instance.new("UICorner")
		corner.Name = "Corner"
		corner.Parent = instance
	end

	corner.CornerRadius = UDim.new(0, radius or DESIGN.CornerRadius)
	return corner
end

-- > efeito de hover otimizado e com cleanup
local function addHoverEffect(button: GuiObject, originalColor: Color3, hoverColor: Color3, condition: (() -> boolean)?)
	if not button or not button:IsA("GuiObject") then return end

	local isHovering, isDown = false, false
	local activeTween

	local function safeTween(targetColor)
		if activeTween then
			activeTween:Cancel()
			activeTween = nil
		end
		if not condition or condition() then
			activeTween = TweenService:Create(button, tweenInfo, { BackgroundColor3 = targetColor })
			activeTween:Play()
		end
	end

	-- > Conexões armazenadas para facilitar desconexão no Destroy
	local connections = {}

	table.insert(connections, button.MouseEnter:Connect(function()
		isHovering = true
		if not isDown then safeTween(hoverColor) end
	end))

	table.insert(connections, button.MouseLeave:Connect(function()
		isHovering = false
		if not isDown then safeTween(originalColor) end
	end))

	table.insert(connections, button.MouseButton1Down:Connect(function()
		isDown = true
	end))

	table.insert(connections, button.MouseButton1Up:Connect(function()
		isDown = false
		if not isHovering then safeTween(originalColor) end
	end))

	-- > Cleanup automático ao destruir o botão
	button.AncestryChanged:Connect(function(_, parent)
		if not parent then
			for _, conn in ipairs(connections) do
				conn:Disconnect()
			end
			connections = {}
			activeTween = nil
		end
	end)
end

-- > criação do botão
local function createButton(text: string, size: UDim2?, parent: Instance)
	local btn = Instance.new("TextButton")
	btn.Text = text
	btn.Size = size or UDim2.new(1, 0, 0, DESIGN.ComponentHeight)
	btn.BackgroundColor3 = DESIGN.ComponentBackground
	btn.TextColor3 = DESIGN.ComponentTextColor
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.Roboto
	btn.TextScaled = true
	btn.AutoButtonColor = false -- > desativa o hover padrão
	btn.Parent = parent

	addRoundedCorners(btn, DESIGN.CornerRadius)
	addHoverEffect(btn, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)

	return btn
end

local Tab = {}
Tab.__index = Tab

-- > > Construtor de uma aba individual
function Tab.new(name: string, parent: Instance)
    local self = setmetatable({}, Tab)

    self.Name = name
    self.Components = {}
    self._connections = {}

    -- > > Cria o container principal (ScrollingFrame) da aba
    self:_CreateContainer(parent)

    -- > > Configura o overlay e box de estado vazio
    self:_SetupEmptyState()

    -- > > Configura reaplicação de cores do tema para elementos da aba
    self:_SetupThemeReapplication()

    -- > > Controle automático de visibilidade do empty state e scrollbar
    self:_SetupVisibilityControl()

    return self
end

-- > > Cria o ScrollingFrame principal da aba
function Tab:_CreateContainer(parent)
    local container = Instance.new("ScrollingFrame")
    self.Container = container
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 6
    container.ScrollBarImageColor3 = DESIGN.ComponentHoverColor
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.ScrollingDirection = Enum.ScrollingDirection.Y
    container.ClipsDescendants = true
    container.Parent = parent

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, DESIGN.ContainerPadding)
    padding.PaddingLeft = UDim.new(0, DESIGN.ContainerPadding)
    padding.PaddingRight = UDim.new(0, DESIGN.ContainerPadding)
    padding.PaddingBottom = UDim.new(0, DESIGN.ContainerPadding)
    padding.Parent = container

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, DESIGN.ComponentPadding)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = container
    self._listLayout = listLayout
end

-- > > Configura o overlay com box de "aba vazia"
function Tab:_SetupEmptyState()
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 5
    overlay.Parent = self.Container
    self._overlay = overlay

    local emptyBox = Instance.new("Frame")
    self.EmptyBox = emptyBox
    emptyBox.Size = UDim2.new(0.6, 0, 0.2, 0)
    emptyBox.AnchorPoint = Vector2.new(0.5, 0.5)
    emptyBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    emptyBox.BackgroundColor3 = DESIGN.EmptyStateBoxColor or Color3.fromRGB(30, 30, 30)
    emptyBox.BackgroundTransparency = 0.2
    emptyBox.BorderSizePixel = 0
    emptyBox.Visible = true
    emptyBox.ZIndex = 6
    emptyBox.Parent = overlay

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius or 10)
    corner.Parent = emptyBox

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = DESIGN.EmptyStateBorderColor or Color3.fromRGB(80, 80, 80)
    stroke.Transparency = 0.3
    stroke.Parent = emptyBox
    self._emptyStroke = stroke

    local emptyText = Instance.new("TextLabel")
    self.EmptyText = emptyText
    emptyText.Size = UDim2.new(1, -10, 1, -10)
    emptyText.AnchorPoint = Vector2.new(0.5, 0.5)
    emptyText.Position = UDim2.new(0.5, 0, 0.5, 0)
    emptyText.BackgroundTransparency = 1
    emptyText.Text = "Parece que ainda não há nada aqui."
    emptyText.TextColor3 = DESIGN.EmptyStateTextColor or Color3.fromRGB(180, 180, 180)
    emptyText.Font = Enum.Font.Roboto
    emptyText.TextScaled = true
    emptyText.TextWrapped = true
    emptyText.ZIndex = 7
    emptyText.Parent = emptyBox

    RegisterThemeItem("EmptyStateTextColor", emptyText, "TextColor3")
end

-- > > Configura reaplicação de cores específicas da aba
function Tab:_SetupThemeReapplication()
    function self:_reapplyScrollAndEmptyColors()
        self.Container.ScrollBarImageColor3 = DESIGN.ComponentHoverColor
        self.EmptyBox.BackgroundColor3 = DESIGN.EmptyStateBoxColor or Color3.fromRGB(30, 30, 30)
        if self._emptyStroke then
            self._emptyStroke.Color = DESIGN.EmptyStateBorderColor or Color3.fromRGB(80, 80, 80)
        end
    end

    RegisterThemeItem("ComponentHoverColor", self, "_reapplyScrollAndEmptyColors")
    RegisterThemeItem("EmptyStateBoxColor", self, "_reapplyScrollAndEmptyColors")
    RegisterThemeItem("EmptyStateBorderColor", self, "_reapplyScrollAndEmptyColors")
end

-- > > Controla visibilidade do empty state e transparência da scrollbar
function Tab:_SetupVisibilityControl()
    self._listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local hasComponents = #self.Components > 0
        self._overlay.Visible = not hasComponents

        local totalContentHeight = self._listLayout.AbsoluteContentSize.Y + (DESIGN.ContainerPadding * 2)
        local containerHeight = self.Container.AbsoluteSize.Y
        self.Container.ScrollBarImageTransparency = totalContentHeight > containerHeight and 0 or 1
    end)
end

-- > Definição de tipos para clareza e persistência de dados
type TabOptions = { 
    Title: string, 
    Icon: string?,
    Expire: string? -- > Adicionado suporte a expiração customizada por aba
}

function Tekscripts:CreateTab(options: TabOptions)
    local title = assert(options.Title, "CreateTab: argumento 'Title' inválido")
    assert(type(title) == "string", "CreateTab: argumento 'Title' deve ser string")

    -- > Persistência e Recuperação de Ícone via Cache
    -- --> intenção: Obter a rota rbxasset:// ou buscar no cache local
    local iconPath = nil
    if options.Icon and type(options.Icon) == "string" then
        -- > Chama a Library que já retorna o getcustomasset(path)
        iconPath = IconLibrary:GetIcon({
            Icon = options.Icon,
            Expire = options.Expire or "1d" -- > Default de 1 dia para persistência consistente
        })
    end

    local tab = Tab.new(title, self.TabContentContainer)
    tab._parentRef = self
    tab.IconPath = iconPath -- > Armazena a rota do cache (rbxasset)
    self.Tabs[title] = tab

    -- > Cria o botão da aba no container lateral
    tab:_CreateTabButton(self)

    -- > Define aba inicial se necessário
    if (self.startTab == title) or not self.CurrentTab then
        self:SetActiveTab(tab)
    end

    -- > Atualiza label de "sem abas"
    self.NoTabsLabel.Visible = next(self.Tabs) == nil

    -- > Método Destroy da aba com limpeza profunda
    function tab:Destroy()
        if self._destroyed then return end
        self._destroyed = true

        for _, conn in ipairs(self._connections or {}) do
            if conn.Connected then conn:Disconnect() end
        end
        self._connections = {}

        for _, comp in pairs(self.Components or {}) do
            if typeof(comp) == "table" and comp.Destroy then
                comp:Destroy()
            end
        end
        self.Components = {}

        if self.Container then self.Container:Destroy() end
        if self.Button then self.Button:Destroy() end

        if self._parentRef and self._parentRef.Tabs then
            self._parentRef.Tabs[title] = nil
            if self._parentRef.CurrentTab == self then
                local nextKey = next(self._parentRef.Tabs)
                local nextTab = nextKey and self._parentRef.Tabs[nextKey]
                self._parentRef.CurrentTab = nextTab
                self._parentRef.NoTabsLabel.Visible = nextTab == nil
                if nextTab then self._parentRef:SetActiveTab(nextTab) end
            end
        end

        self._parentRef = nil
        table.clear(self)
    end

    return tab
end

-- > Cria o botão visual com integração de ícone por cache
function Tab:_CreateTabButton(parentWindow)
    -- --> intenção: Validar se o path do cache foi gerado com sucesso
    local hasIcon = self.IconPath ~= nil
    
    local button = Instance.new("TextButton")
    self.Button = button
    button.Name = self.Name
    button.Text = "" 
    button.Size = UDim2.new(1, -6, 0, DESIGN.TabButtonHeight or 28)
    button.AutomaticSize = Enum.AutomaticSize.Y 
    button.BackgroundColor3 = DESIGN.TabInactiveColor
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.ZIndex = 3
    button.Parent = parentWindow.TabContainer

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, hasIcon and 8 or 0)
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.Parent = button

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 4)
    padding.Parent = button

    -- > Renderização do Ícone via Cache
    if hasIcon then
        local iconImage = Instance.new("ImageLabel")
        iconImage.Name = "Icon"
        iconImage.BackgroundTransparency = 1
        iconImage.Size = UDim2.new(0, 16, 0, 16)
        -- --> intenção: Usar o path retornado pela library (rbxasset://...)
        iconImage.Image = self.IconPath 
        iconImage.ZIndex = 4
        iconImage.Parent = button
        
        -- --> intenção: Garantir que o ícone seja branco ou siga o tema
        iconImage.ImageColor3 = Color3.fromRGB(255, 255, 255) 
        RegisterThemeItem("ComponentTextColor", iconImage, "ImageColor3")
    end

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Title"
    textLabel.BackgroundTransparency = 1
    textLabel.Text = self.Name
    textLabel.Size = UDim2.new(1, hasIcon and -24 or 0, 0, 0) 
    textLabel.AutomaticSize = Enum.AutomaticSize.Y
    textLabel.TextColor3 = DESIGN.ComponentTextColor
    textLabel.Font = Enum.Font.Roboto
    textLabel.TextSize = 14
    textLabel.TextWrapped = true 
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.ZIndex = 4
    textLabel.Parent = button
    RegisterThemeItem("ComponentTextColor", textLabel, "TextColor3")

    local textConstraint = Instance.new("UISizeConstraint")
    textConstraint.MaxSize = Vector2.new(9000, 36)
    textConstraint.Parent = textLabel

    addRoundedCorners(button, DESIGN.CornerRadius)

    addHoverEffect(button, DESIGN.TabInactiveColor, DESIGN.ComponentHoverColor, function()
        return parentWindow.CurrentTab ~= self
    end)

    table.insert(self._connections, button.MouseButton1Click:Connect(function()
        if not parentWindow.Blocked then
            parentWindow:SetActiveTab(self)
        end
    end))

    table.insert(self._connections, button.AncestryChanged:Connect(function(_, p)
        if not p and not self._destroyed then
            self:Destroy()
        end
    end))

    self.Container.Visible = false
end

-- > > Ativa uma aba específica (lazy visibility)
function Tekscripts:SetActiveTab(tab)
    if self.CurrentTab and self.CurrentTab ~= tab then
        self.CurrentTab.Container.Visible = false
        self.CurrentTab.Button.BackgroundColor3 = DESIGN.TabInactiveColor
    end

    self.CurrentTab = tab
    if tab then
        tab.Container.Visible = true
        tab.Button.BackgroundColor3 = DESIGN.TabActiveColor
    end
end

-- > > Construtor principal da janela Tekscripts
function Tekscripts.new(options: { 
    Name: string?, 
    Parent: Instance?, 
    FloatText: string?, 
    startTab: string?, 
    iconId: string?, 
    Transparent: boolean?, 
    TabContainerTransparency: number?, 
    WindowTransparency: number?,
    LoadScreen: boolean?,       
    Loading: table?             
})
    options = options or {}
    
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer

    -- > > Configuração inicial de transparência baseada nas opções do usuário
    local useThemeTransparency = options.Transparent == true
    local windowTransparency = useThemeTransparency 
        and (options.WindowTransparency or DESIGN.WindowTransparency) 
        or DESIGN.WindowTransparency or 0.1
    local tabContainerTransparency = useThemeTransparency 
        and (options.TabContainerTransparency or DESIGN.TabContainerTransparency) 
        or DESIGN.TabContainerTransparency or 0.1

    -- > > Detecção de dispositivo móvel para escala responsiva
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local responsiveScale = isMobile and 0.85 or 1.0

    -- > > Criação do objeto principal com estado inicial
    local self = setmetatable({
        ScreenGui = nil,
        Window = nil,
        TitleBar = nil,
        TabContainer = nil,
        TabContentContainer = nil,
        ResizeHandle = nil,
        FloatButton = nil,
        EdgeButtons = {},
        Connections = {},
        BlockScreen = nil,
        Blocked = false,
        MinimizedState = nil,
        Tabs = {},
        CurrentTab = nil,
        IsDragging = false,
        IsResizing = false,
        
        CloseButtonContainer = nil,
        CloseButton = nil,
        NoTabsLabel = nil,
        Title = nil,
        BlurEffect = nil,
        
        startTab = options.startTab,
        
        _useThemeTransparency = useThemeTransparency,
        _userWindowTransparency = options.WindowTransparency,
        _userTabContainerTransparency = options.TabContainerTransparency,
    }, Tekscripts)

    -- > > Criação do ScreenGui base
    self:_CreateScreenGui(options, localPlayer)

    -- > > Cálculo do tamanho e posição final da janela
    local finalWindowSize = self:_GetWindowSize()
    local finalWindowPos = self:_GetWindowPosition()
    local finalAnchorPoint = self._isSmallScreen and Vector2.new(0.5, 0.5) or Vector2.new(0, 0)

    -- > > Verifica se deve iniciar com loading screen
    local isLoading = options.LoadScreen == true and options.Loading ~= nil

    -- > > Criação da janela principal com tamanho inicial adequado
    self:_CreateMainWindow(isLoading, finalWindowSize, finalWindowPos, finalAnchorPoint, responsiveScale, windowTransparency)

    -- > > Configuração da barra de título completa
    self:_SetupTitleBar(isLoading, options, responsiveScale, tabContainerTransparency)

    -- > > Configuração do dropdown de fechar (••• → Fechar)
    self:_SetupCloseDropdown()

    -- > > Configuração dos containers de abas e conteúdo
    self:_SetupTabContainers(tabContainerTransparency, windowTransparency, isLoading)

    -- > > Componentes adicionais (resize, float button, block screen)
    self:_SetupAdditionalComponents(options.FloatText or "abrir")

    -- > > Sistema de reaplicação de tema
    self:_SetupThemeReapplication()

    -- > > Conexão para destruir a UI ao sair do jogo
    self.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        if player == localPlayer then
            self:Destroy()
        end
    end)

    -- > > Inicialização do loading screen, se ativado
    if isLoading then
        self:_SetupLoadingScreen(options.Loading, finalWindowSize, finalWindowPos, finalAnchorPoint)
    end

    return self
end

-- > > Cria o ScreenGui e define propriedades básicas
function Tekscripts:_CreateScreenGui(options, localPlayer)
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = options.Name or "TEKSCRIPTS"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = options.Parent or localPlayer:WaitForChild("PlayerGui")
end

-- > > Cria a janela principal (Frame) com gradiente e escala
function Tekscripts:_CreateMainWindow(isLoading, finalSize, finalPos, finalAnchor, scale, transparency)
    self.Window = Instance.new("Frame")
    
    if isLoading then
        self.Window.Size = UDim2.new(0, 280 * scale, 0, 120 * scale)
        self.Window.Position = UDim2.new(0.5, 0, 0.5, 0)
        self.Window.AnchorPoint = Vector2.new(0.5, 0.5)
    else
        self.Window.Size = finalSize
        self.Window.Position = finalPos
        self.Window.AnchorPoint = finalAnchor
    end

    self.Window.BackgroundColor3 = DESIGN.WindowColor1
    self.Window.BackgroundTransparency = transparency
    self.Window.BorderSizePixel = 0
    self.Window.ClipsDescendants = true
    self.Window.Parent = self.ScreenGui

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = scale
    uiScale.Parent = self.Window

    addRoundedCorners(self.Window, DESIGN.CornerRadius)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(DESIGN.WindowColor1, DESIGN.WindowColor2)
    gradient.Rotation = 90
    gradient.Parent = self.Window
    self._windowGradient = gradient  -- > guardado para uso no reapply
end

-- > > Configura toda a barra de título (ícone, título, botões)
function Tekscripts:_SetupTitleBar(isLoading, options, scale, transparency)
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, DESIGN.TitleHeight)
    self.TitleBar.BackgroundColor3 = DESIGN.WindowColor2
    self.TitleBar.BackgroundTransparency = transparency
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Visible = not isLoading
    self.TitleBar.Parent = self.Window

    addRoundedCorners(self.TitleBar, DESIGN.CornerRadius)
    RegisterThemeItem("WindowColor2", self.TitleBar, "BackgroundColor3")

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 1, 0)
    header.BackgroundTransparency = 1
    header.Parent = self.TitleBar

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = header

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = header

    -- > Ícone opcional
    local iconSize = 0
    if options.iconId then
        iconSize = DESIGN.IconSize
        local iconFrame = Instance.new("Frame")
        iconFrame.Size = UDim2.new(0, iconSize, 0, iconSize)
        iconFrame.BackgroundTransparency = 1
        iconFrame.ClipsDescendants = true
        iconFrame.Parent = header

        local icon = Instance.new("ImageLabel")
        icon.Image = options.iconId
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Parent = iconFrame

        addRoundedCorners(iconFrame, 5)
    end

    -- > Título
    local titleOffset = iconSize + (iconSize > 0 and 5 or 0) + (DESIGN.TitleHeight * 2) + DESIGN.TitlePadding
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, -titleOffset, 1, 0)
    titleFrame.BackgroundTransparency = 1
    titleFrame.ClipsDescendants = true
    titleFrame.Parent = header

    local title = Instance.new("TextLabel")
    self.Title = title
    title.Name = "Title"
    title.Text = options.Name or "Tekscripts"
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = DESIGN.TitleColor
    title.Font = Enum.Font.RobotoMono
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleFrame
    RegisterThemeItem("TitleColor", title, "TextColor3")

    self:SetupTitleScroll()

    -- > Botões de controle
    self:_SetupTitleBarButtons(header)
    self:SetupDragSystem()
end

-- > > Cria os botões da barra de título
function Tekscripts:_SetupTitleBarButtons(parent)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0, DESIGN.TitleHeight * 2, 1, 0)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.Padding = UDim.new(0, 5)
    layout.Parent = buttonFrame

    -- > Botão de Controle (Menu/More)
    -- --> intenção: Substituir o texto "•••" por um ícone real processado pelo cache
    local controlBtn = Instance.new("ImageButton")
    controlBtn.Name = "ControlBtn"
    controlBtn.Size = UDim2.new(0, DESIGN.TitleHeight, 0, DESIGN.TitleHeight)
    controlBtn.BackgroundColor3 = DESIGN.ComponentBackground
    controlBtn.BorderSizePixel = 0
    controlBtn.ScaleType = Enum.ScaleType.Fit
    controlBtn.Parent = buttonFrame

    -- > Busca ícone de menu (ajuste o nome "ellipsis" para o correspondente na sua Icons.lua)
    local menuIcon = IconLibrary:GetIcon({ Icon = "ellipsis", Expire = "7d" })
    controlBtn.Image = menuIcon or ""
    controlBtn.ImageColor3 = DESIGN.ComponentTextColor

    RegisterThemeItem("ComponentBackground", controlBtn, "BackgroundColor3")
    RegisterThemeItem("ComponentTextColor", controlBtn, "ImageColor3")
    addRoundedCorners(controlBtn, DESIGN.CornerRadius)
    addHoverEffect(controlBtn, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)
    self._controlBtn = controlBtn

    -- > Botão Minimizar
    -- --> intenção: Persistência de dados - usar ícone do cache em vez de rbxassetid fixo
    local minimizeBtn = Instance.new("ImageButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, DESIGN.TitleHeight, 0, DESIGN.TitleHeight)
    minimizeBtn.BackgroundColor3 = DESIGN.MinimizeButtonColor
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.ScaleType = Enum.ScaleType.Fit
    minimizeBtn.Parent = buttonFrame

    -- > Busca ícone de minimizar no cache
    local minIcon = IconLibrary:GetIcon({ Icon = "minus", Expire = "7d" })
    minimizeBtn.Image = minIcon or ""
    minimizeBtn.ImageColor3 = Color3.fromRGB(255, 255, 255) -- > Força branco para contraste

    RegisterThemeItem("MinimizeButtonColor", minimizeBtn, "BackgroundColor3")
    addRoundedCorners(minimizeBtn, DESIGN.CornerRadius)
    addHoverEffect(minimizeBtn, DESIGN.MinimizeButtonColor, DESIGN.ComponentHoverColor)

    -- > Persistência de conexões
    self.Connections.MinimizeClick = minimizeBtn.MouseButton1Click:Connect(function()
        if not self.Blocked then
            self:Minimize()
            self:HideCloseButton()
        end
    end)
end

-- > > Configura o dropdown de fechar
function Tekscripts:_SetupCloseDropdown()
    self.CloseButtonContainer = Instance.new("Frame")
    local width = DESIGN.DropdownWidth or 100
    local height = DESIGN.DropdownItemHeight or 25
    self.CloseButtonContainer.Size = UDim2.new(0, width + 10, 0, height + 10)
    self.CloseButtonContainer.BackgroundColor3 = DESIGN.DropdownBackground
    self.CloseButtonContainer.BackgroundTransparency = DESIGN.DropdownTransparency or 0
    self.CloseButtonContainer.BorderSizePixel = 0
    self.CloseButtonContainer.Visible = false
    self.CloseButtonContainer.ZIndex = 10
    self.CloseButtonContainer.Parent = self.Window
    addRoundedCorners(self.CloseButtonContainer)

    local closeBtn = Instance.new("TextButton")
    self.CloseButton = closeBtn
    closeBtn.Text = "Fechar"
    closeBtn.Size = UDim2.new(1, -10, 1, -10)
    closeBtn.Position = UDim2.new(0, 5, 0, 5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.TextColor3 = DESIGN.CloseButtonColor
    closeBtn.Font = Enum.Font.Roboto
    closeBtn.TextScaled = true
    closeBtn.ZIndex = 11
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = self.CloseButtonContainer
    RegisterThemeItem("CloseButtonColor", closeBtn, "TextColor3")
    addRoundedCorners(closeBtn, 5)
    addHoverEffect(closeBtn, DESIGN.DropdownBackground, DESIGN.DropdownItemHover)

    self.Connections.CloseClick = closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    -- > Toggle e posicionamento do dropdown
    self.Connections.ControlBtn = self._controlBtn.MouseButton1Click:Connect(function()
        local visible = not self.CloseButtonContainer.Visible
        self.CloseButtonContainer.Visible = visible
        if visible then
            local absCtrl = self._controlBtn.AbsolutePosition
            local absWin = self.Window.AbsolutePosition
            local size = self.CloseButtonContainer.AbsoluteSize
            local x = absCtrl.X - absWin.X + self._controlBtn.AbsoluteSize.X - size.X
            self.CloseButtonContainer.Position = UDim2.new(0, x, 0, DESIGN.TitleHeight + 2)
        end
    end)

    -- > Fechar ao clicar fora
    self.Connections.InputBegan = game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
        if gp or not self.CloseButtonContainer.Visible then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = game:GetService("UserInputService"):GetMouseLocation()
            local dropPos = self.CloseButtonContainer.AbsolutePosition
            local dropSize = self.CloseButtonContainer.AbsoluteSize
            local ctrlPos = self._controlBtn.AbsolutePosition
            local ctrlSize = self._controlBtn.AbsoluteSize

            local outsideDrop = mouse.X < dropPos.X or mouse.X > dropPos.X + dropSize.X
                or mouse.Y < dropPos.Y or mouse.Y > dropPos.Y + dropSize.Y
            local outsideCtrl = mouse.X < ctrlPos.X or mouse.X > ctrlPos.X + ctrlSize.X
                or mouse.Y < ctrlPos.Y or mouse.Y > ctrlPos.Y + ctrlSize.Y

            if outsideDrop and outsideCtrl then
                self.CloseButtonContainer.Visible = false
            end
        end
    end)
end

-- > > Configura containers de abas e conteúdo principal
function Tekscripts:_SetupTabContainers(tabTransparency, winTransparency, isLoading)
    local tabSize = self:_GetTabContainerSize()

    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(tabSize.X.Scale, tabSize.X.Offset, 1, -DESIGN.TitleHeight)
    self.TabContainer.Position = UDim2.new(0, 0, 0, DESIGN.TitleHeight)
    self.TabContainer.BackgroundColor3 = DESIGN.WindowColor2
    self.TabContainer.BackgroundTransparency = tabTransparency
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Visible = not isLoading
    self.TabContainer.Parent = self.Window
    RegisterThemeItem("WindowColor2", self.TabContainer, "BackgroundColor3")
    addRoundedCorners(self.TabContainer, DESIGN.CornerRadius)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = self.TabContainer

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = self.TabContainer

    -- > Estado vazio
    self.NoTabsLabel = Instance.new("TextLabel")
    self.NoTabsLabel.Size = UDim2.new(1, 0, 1, 0)
    self.NoTabsLabel.BackgroundTransparency = 1
    self.NoTabsLabel.Text = "nada ainda"
    self.NoTabsLabel.TextColor3 = DESIGN.EmptyStateTextColor
    self.NoTabsLabel.Font = Enum.Font.Roboto
    self.NoTabsLabel.TextScaled = true
    self.NoTabsLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.NoTabsLabel.Parent = self.TabContainer
    RegisterThemeItem("EmptyStateTextColor", self.NoTabsLabel, "TextColor3")

    -- > Conteúdo das abas
    self.TabContentContainer = Instance.new("Frame")
    self.TabContentContainer.Size = UDim2.new(1 - tabSize.X.Scale, -tabSize.X.Offset, 1, -DESIGN.TitleHeight)
    self.TabContentContainer.Position = UDim2.new(tabSize.X.Scale, tabSize.X.Offset, 0, DESIGN.TitleHeight)
    self.TabContentContainer.BackgroundColor3 = DESIGN.WindowColor1
    self.TabContentContainer.BackgroundTransparency = winTransparency
    self.TabContentContainer.BorderSizePixel = 0
    self.TabContentContainer.Visible = not isLoading
    self.TabContentContainer.Parent = self.Window
end

-- > > Configura resize, float button e tela de bloqueio
function Tekscripts:_SetupAdditionalComponents(floatText)
    self:SetupResizeSystem()
    self:SetupFloatButton(floatText)

    self.BlockScreen = Instance.new("Frame")
    self.BlockScreen.Size = UDim2.new(1, 0, 1, 0)
    self.BlockScreen.BackgroundColor3 = DESIGN.BlockScreenColor
    self.BlockScreen.BackgroundTransparency = 0.5
    self.BlockScreen.ZIndex = 10
    self.BlockScreen.Visible = false
    self.BlockScreen.Parent = self.ScreenGui
    RegisterThemeItem("BlockScreenColor", self.BlockScreen, "BackgroundColor3")

    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = self.BlockScreen
    self.BlurEffect = blur
end

-- > > Configura o sistema de reaplicação de tema
function Tekscripts:_SetupThemeReapplication()
    function self:_reapplyThemeColors()
        local winTransp = self._useThemeTransparency and (self._userWindowTransparency or DESIGN.WindowTransparency) or DESIGN.WindowTransparency or 0.1
        local tabTransp = self._useThemeTransparency and (self._userTabContainerTransparency or DESIGN.TabContainerTransparency) or DESIGN.TabContainerTransparency or 0.1

        self.Window.BackgroundColor3 = DESIGN.WindowColor1
        self.Window.BackgroundTransparency = winTransp
        self._windowGradient.Color = ColorSequence.new(DESIGN.WindowColor1, DESIGN.WindowColor2)

        self.TitleBar.BackgroundColor3 = DESIGN.WindowColor2
        self.TitleBar.BackgroundTransparency = tabTransp
        self.Title.TextColor3 = DESIGN.TitleColor

        self.TabContainer.BackgroundColor3 = DESIGN.WindowColor2
        self.TabContainer.BackgroundTransparency = tabTransp
        self.TabContentContainer.BackgroundColor3 = DESIGN.WindowColor1
        self.TabContentContainer.BackgroundTransparency = winTransp

        self._controlBtn.BackgroundColor3 = DESIGN.ComponentBackground
        self._controlBtn.TextColor3 = DESIGN.ComponentTextColor
        addHoverEffect(self._controlBtn, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)

        self.CloseButtonContainer.BackgroundColor3 = DESIGN.DropdownBackground
        self.CloseButtonContainer.BackgroundTransparency = DESIGN.DropdownTransparency or 0
        self.CloseButton.TextColor3 = DESIGN.CloseButtonColor
        addHoverEffect(self.CloseButton, DESIGN.DropdownBackground, DESIGN.DropdownItemHover)

        self.NoTabsLabel.TextColor3 = DESIGN.EmptyStateTextColor
        self.BlockScreen.BackgroundColor3 = DESIGN.BlockScreenColor

        if self.ResizeHandle and self.ResizeHandle._reapplyThemeColors then
            self.ResizeHandle:_reapplyThemeColors()
        end
        if self.FloatButton and self.FloatButton._reapplyThemeColors then
            self.FloatButton:_reapplyThemeColors()
        end
    end

    local keys = {
        "WindowColor1", "WindowColor2", "WindowTransparency", "TabContainerTransparency",
        "TitleColor", "ComponentBackground", "ComponentTextColor", "ComponentHoverColor",
        "MinimizeButtonColor", "DropdownBackground", "DropdownTransparency",
        "CloseButtonColor", "DropdownItemHover", "EmptyStateTextColor", "BlockScreenColor"
    }
    for _, key in ipairs(keys) do
        RegisterThemeItem(key, self, "_reapplyThemeColors")
    end
end

-- > > Configura e executa a animação do loading screen
function Tekscripts:_SetupLoadingScreen(config, finalSize, finalPos, finalAnchor)
    self.Blocked = true

    local content = Instance.new("Frame")
    content.Name = "LoadingContent"
    content.Size = UDim2.new(1, -40, 1, -40)
    content.Position = UDim2.new(0, 20, 0, 20)
    content.BackgroundTransparency = 1
    content.Parent = self.Window

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Padding = UDim.new(0, 2)
    layout.Parent = content

    local title = Instance.new("TextLabel")
    title.Text = config.Title or "Carregando"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 19
    title.TextColor3 = DESIGN.TitleColor or Color3.fromRGB(255, 255, 255)
    title.Size = UDim2.new(1, 0, 0, 24)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = content

    local desc = Instance.new("TextLabel")
    desc.Text = config.Desc or "Aguarde..."
    desc.Font = Enum.Font.SourceSans
    desc.TextSize = 13
    desc.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(160, 160, 160)
    desc.Size = UDim2.new(1, 0, 0, 18)
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.BackgroundTransparency = 1
    desc.TextWrapped = true
    desc.Parent = content

    local spinner = Instance.new("Frame")
    spinner.Name = "MinimalSpinner"
    spinner.Size = UDim2.new(0, 16, 0, 16)
    spinner.Position = UDim2.new(1, -15, 1, -15)
    spinner.AnchorPoint = Vector2.new(1, 1)
    spinner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    spinner.Parent = self.Window
    addRoundedCorners(spinner, UDim.new(1, 0))

    local grad = Instance.new("UIGradient")
    grad.Transparency = NumberSequence.new(0, 0, 0.8, 1, 1, 1)
    grad.Color = ColorSequence.new(DESIGN.ComponentHoverColor or Color3.fromRGB(0, 170, 255))
    grad.Parent = spinner

    task.spawn(function()
        local tween = game:GetService("TweenService"):Create(spinner, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
        tween:Play()

        task.wait(2.5)

        local fade = TweenInfo.new(0.4)
        game:GetService("TweenService"):Create(title, fade, {TextTransparency = 1}):Play()
        game:GetService("TweenService"):Create(desc, fade, {TextTransparency = 1}):Play()
        game:GetService("TweenService"):Create(spinner, fade, {BackgroundTransparency = 1}):Play()

        task.wait(0.4)
        content:Destroy()
        spinner:Destroy()

        local expand = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local expandTween = game:GetService("TweenService"):Create(self.Window, expand, {
            Size = finalSize,
            Position = finalPos,
            AnchorPoint = finalAnchor
        })
        expandTween:Play()
        expandTween.Completed:Wait()

        self.TitleBar.Visible = true
        self.TabContainer.Visible = true
        self.TabContentContainer.Visible = true
        self.Blocked = false
    end)
end
function Tekscripts:HideCloseButton()
    if self.CloseButtonContainer and self.CloseButtonContainer.Parent then
        self.CloseButtonContainer.Visible = false
    end
end

function Tekscripts:Destroy()
    self:HideCloseButton() 
    

    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end


function Tekscripts:_UpdateScreenSize()
    self._viewSize = workspace.CurrentCamera.ViewportSize
    self._isSmallScreen = self._viewSize.X < DESIGN.MinWindowSize.X
end

function Tekscripts:_GetWindowSize()
    return self._isSmallScreen and UDim2.new(0.95, 0, 0.95, 0) or DESIGN.WindowSize
end

function Tekscripts:_GetWindowPosition()
    if self._isSmallScreen then
        return UDim2.new(0.5, 0, 0.5, 0)
    else
        local size = DESIGN.WindowSize
        return UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
    end
end

function Tekscripts:_GetTabContainerSize()
    return self._isSmallScreen and UDim2.new(0.3, 0, 1, -DESIGN.TitleHeight) or UDim2.new(0, DESIGN.TabButtonWidth, 1, -DESIGN.TitleHeight)
end

function Tekscripts:_GetContentContainerSize()
    local tabWidth = self._isSmallScreen and UDim.new(0.3, 0) or UDim.new(0, DESIGN.TabButtonWidth)
    local remainingScale = 1 - tabWidth.Scale
    local remainingOffset = -tabWidth.Offset
    
    return UDim2.new(remainingScale, remainingOffset, 1, -DESIGN.TitleHeight)
end

function Tekscripts:Destroy()
    if self.TitleScrollConnection then
        self.TitleScrollConnection:Disconnect()
        self.TitleScrollConnection = nil
    end
    if self.TitleScrollTween then
        self.TitleScrollTween:Cancel()
        self.TitleScrollTween = nil
    end
    if self._activeTween then
        self._activeTween:Cancel()
        self._activeTween = nil
    end
    for _, buttonData in pairs(self.EdgeButtons) do
        if buttonData.Frame then
            buttonData.Frame:Destroy()
        end
    end
    self.EdgeButtons = {}
    if self.ScreenGui then
        self.ScreenGui:Destroy()
        self.ScreenGui = nil
    end
    for _, connection in pairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    self.Connections = {}
    for _, tab in pairs(self.Tabs) do
        if tab.Destroy then
            tab:Destroy()
        end
    end
    self.Tabs = {}
    setmetatable(self, nil)
end


-- > NOVO: Sistema de rolagem de título (otimizado para não criar tweens desnecessários)

function Tekscripts:SetupTitleScroll()
    local title = self.Title
    local parent = title.Parent
    if not title or not parent then return end

    local isScrolling = false

    local function checkAndScroll()
        local textWidth = title.TextBounds.X
        local parentWidth = parent.AbsoluteSize.X
        if textWidth <= parentWidth then
            if isScrolling then
                if self.TitleScrollTween then
                    self.TitleScrollTween:Cancel()
                    self.TitleScrollTween = nil
                end
                title.Position = UDim2.new(0, 0, 0, 0)
                isScrolling = false
            end
            return
        end

        if not isScrolling then
            isScrolling = true
            local scrollDistance = textWidth - parentWidth + 5
            local scrollTime = scrollDistance / 50

            local tweenInfo = TweenInfo.new(
                scrollTime,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.InOut,
                -1,
                false,
                0
            )

            self.TitleScrollTween = TweenService:Create(title, tweenInfo, { Position = UDim2.new(0, -scrollDistance, 0, 0) })
            self.TitleScrollTween:Play()
        end
    end

    self.TitleScrollConnection = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(checkAndScroll)
    title:GetPropertyChangedSignal("TextBounds"):Connect(checkAndScroll)

    checkAndScroll()
end


-- > Sistema de Arrastar (otimizado: atualização direta, sem tweens por input)

function Tekscripts:SetupDragSystem()
    local UIS = game:GetService("UserInputService")

    self.Connections.DragBegin = self.TitleBar.InputBegan:Connect(function(input)
        if self.Blocked or self.MinimizedState then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            
            self.IsDragging = true

            local pos = Vector2.new(input.Position.X, input.Position.Y)

            -- > Pega o offset correto (dedo - posição da janela)
            local absPos = self.Window.AbsolutePosition
            self._offset = Vector2.new(pos.X - absPos.X, pos.Y - absPos.Y)
        end
    end)

    self.Connections.DragChanged = UIS.InputChanged:Connect(function(input)
        if not self.IsDragging or self.Blocked or self.MinimizedState then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            
            local pos = Vector2.new(input.Position.X, input.Position.Y)

            -- > Nova posição = dedo - offset
            local newX = pos.X - self._offset.X
            local newY = pos.Y - self._offset.Y

            self.Window.Position = UDim2.fromOffset(newX, newY)
        end
    end)

    self.Connections.DragEnded = UIS.InputEnded:Connect(function(input)
        if not self.IsDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            
            self.IsDragging = false

            if not self.MinimizedState then
            end
        end
    end)
end


-- > Sistema de Redimensionamento (atualização direta)

function Tekscripts:SetupResizeSystem()
    local GripVisualSize = 30  
    local ResizeGrip = Instance.new("Frame")
    ResizeGrip.Name = "ResizeGripVisual"
    ResizeGrip.Size = UDim2.new(0, GripVisualSize, 0, GripVisualSize)
    ResizeGrip.Position = UDim2.new(1, -12, 1, -12) 
    ResizeGrip.BackgroundTransparency = 1
    ResizeGrip.ClipsDescendants = false  
    ResizeGrip.ZIndex = 10
    ResizeGrip.Parent = self.Window
    self.ResizeHandle = ResizeGrip

    local function createLine(offset)
        local line = Instance.new("Frame")
        line.BackgroundColor3 = DESIGN.ResizeHandleColor or Color3.fromRGB(160, 160, 160)
        line.BorderSizePixel = 0
        line.Size = UDim2.new(0, 14, 0, 2)
        line.AnchorPoint = Vector2.new(1, 1)
        line.Position = UDim2.new(1, 2 + offset * -7, 1, 2 + offset * -7)
        line.Rotation = 45
        line.BackgroundTransparency = 1
        line.ZIndex = 10
        line.Parent = ResizeGrip
        return line
    end

    local line1 = createLine(0)  -- > a mais externa (toca na borda)
    local line2 = createLine(1)
    local line3 = createLine(2)  -- > a mais interna

    -- > Animação de hover
    local function setHover(hovering)
        local target = hovering and 0 or 1
        local tween = TweenService:Create(line1, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = target})
        TweenService:Create(line2, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = target}):Play()
        TweenService:Create(line3, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = target}):Play()
        tween:Play()
    end

    -- > == HITBOX (área de clique grande) ==
    local Hitbox = Instance.new("Frame")
    Hitbox.Name = "ResizeHitbox"
    Hitbox.Size = UDim2.new(0, 40, 0, 40)
    Hitbox.Position = UDim2.new(1, -40, 1, -40)
    Hitbox.BackgroundTransparency = 1
    Hitbox.ZIndex = 10
    Hitbox.Parent = self.Window

    -- > Hover + cursor
    self.Connections.ResizeMouseEnter = Hitbox.MouseEnter:Connect(function()
        setHover(true)
        UserInputService.MouseIcon = "rbxassetid://6258410714"
    end)

    self.Connections.ResizeMouseLeave = Hitbox.MouseLeave:Connect(function()
        setHover(false)
        if not self.IsDragging and not self.IsResizing then
            UserInputService.MouseIcon = ""
        end
    end)

    -- > == REDIMENSIONAMENTO ==
    self.Connections.ResizeBegin = Hitbox.InputBegan:Connect(function(input)
        if self.Blocked or input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        self.IsResizing = true
        self._resizeStart = input.Position
        self._startSize = self.Window.Size
    end)

    self.Connections.ResizeChanged = UserInputService.InputChanged:Connect(function(input)
        if not self.IsResizing or self.Blocked then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - self._resizeStart
        local screen = workspace.CurrentCamera.ViewportSize
        local maxW = math.min(DESIGN.MaxWindowSize.X, screen.X * 0.9)
        local maxH = math.min(DESIGN.MaxWindowSize.Y, screen.Y * 0.9)

        local newW = math.clamp(self._startSize.X.Offset + delta.X, DESIGN.MinWindowSize.X, maxW)
        local newH = math.clamp(self._startSize.Y.Offset + delta.Y, DESIGN.MinWindowSize.Y, maxH)

        self.Window.Size = UDim2.new(0, newW, 0, newH)
        self:UpdateContainersSize()
    end)

    self.Connections.ResizeEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsResizing = false
            if not self.IsDragging then UserInputService.MouseIcon = "" end
            setHover(false)
        end
    end)
end

function Tekscripts:UpdateContainersSize()
    local tabContainerSize = self:_GetTabContainerSize()

    if self.TabContainer then
        self.TabContainer.Size = UDim2.new(tabContainerSize.X.Scale, tabContainerSize.X.Offset, 1, -DESIGN.TitleHeight)
        self.TabContainer.Position = UDim2.new(0, 0, 0, DESIGN.TitleHeight)
    end

    if self.TabContentContainer then
        local tabContainerXScale = tabContainerSize.X.Scale
        local tabContainerXOffset = tabContainerSize.X.Offset
        
        local contentSizeX = UDim.new(1 - tabContainerXScale, -tabContainerXOffset)
        
        self.TabContentContainer.Position = UDim2.new(tabContainerXScale, tabContainerXOffset, 0, DESIGN.TitleHeight)
        self.TabContentContainer.Size = UDim2.new(contentSizeX.Scale, contentSizeX.Offset, 1, -DESIGN.TitleHeight)
    end

    if self.ResizeHandle then
        self.ResizeHandle.Position = UDim2.new(1, -12, 1, -12)
    end


    local hitbox = self.Window:FindFirstChild("ResizeHitbox")
    if hitbox then
        hitbox.Position = UDim2.new(1, -40, 1, -40)
    end
end


-- > Float Button
function Tekscripts:FloatButtonEdit(options: {Text: string?, Icon: string?})
    local float = self.FloatButton
    if not float or not float:IsA("Frame") then
        warn("Tekscripts:FloatButtonEdit: FloatButton não encontrado.")
        return
    end

    local actionBtn = float:FindFirstChild("ActionButton")
    local dragBtn = float:FindFirstChild("DragButton")

    -- > Atualização de Texto
    if options.Text and actionBtn and actionBtn:IsA("TextButton") then
        actionBtn.Text = options.Text
    end
    
    if options.Icon and dragBtn and dragBtn:IsA("ImageButton") then
        -- --> intenção: Buscar o asset no cache ou baixar se necessário
        local iconPath = IconLibrary:GetIcon({
            Icon = options.Icon,
            Expire = "1d"
        })
        
        -- Fallback se a busca falhar
        if not iconPath then
            iconPath = IconLibrary:GetIcon({ Icon = FALLBACK_ICON_NAME, Expire = "7d" })
        end

        dragBtn.Image = iconPath
        dragBtn.ImageColor3 = Color3.fromRGB(255, 255, 255) -- > Força ícone branco
    end
end

-- > FUNÇÃO ORIGINAL ADAPTADA: CRIAÇÃO DO BOTÃO FLUTUANTE
function Tekscripts:SetupFloatButton(text: string, icon: string?)
    local UIS = game:GetService("UserInputService")
    
    -- > Frame principal
    local float = Instance.new("Frame")
    float.Name = "FloatButton"
    float.Size = UDim2.new(0, 180, 0, 45)
    float.Position = UDim2.new(1, -200, 0, 20)
    float.BackgroundColor3 = DESIGN.FloatButtonColor
    float.BorderSizePixel = 0
    float.Visible = false
    float.Parent = self.ScreenGui
    self.FloatButton = float 

    addRoundedCorners(float, DESIGN.CornerRadius)

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(DESIGN.FloatButtonColor, DESIGN.WindowColor2)
    grad.Rotation = 45
    grad.Parent = float

    -- > BOTÃO DE ARRASTAR (esquerda)
    local dragBtn = Instance.new("ImageButton")
    dragBtn.Name = "DragButton"
    dragBtn.Size = UDim2.new(0, 45, 1, 0)
    dragBtn.Position = UDim2.new(0, 0, 0, 0)
    dragBtn.BackgroundColor3 = DESIGN.FloatButtonColor
    dragBtn.BackgroundTransparency = 1 -- Melhora estética para ícones
    dragBtn.BorderSizePixel = 0
    dragBtn.ScaleType = Enum.ScaleType.Fit
    dragBtn.Parent = float

    -- > LÓGICA DE ÍCONE INICIAL COM CACHE:
    -- --> intenção: Garantir que o ícone inicial seja persistente e renderizado pelo Workspace
    local initialIcon = icon or FALLBACK_ICON_NAME
    local iconPath = IconLibrary:GetIcon({
        Icon = initialIcon,
        Expire = "1d"
    })
    
    dragBtn.Image = iconPath or "" 
    dragBtn.ImageColor3 = Color3.fromRGB(255, 255, 255) -- > Consistência de cor

    addHoverEffect(dragBtn, nil, DESIGN.ComponentHoverColor)

    -- > BOTÃO DE AÇÃO (texto - abre painel)
    local actionBtn = Instance.new("TextButton")
    actionBtn.Name = "ActionButton" 
    actionBtn.Size = UDim2.new(1, -45, 1, 0)
    actionBtn.Position = UDim2.new(0, 45, 0, 0)
    actionBtn.BackgroundTransparency = 1
    actionBtn.Text = text
    actionBtn.Font = Enum.Font.Roboto
    actionBtn.TextScaled = true
    actionBtn.TextColor3 = DESIGN.ComponentTextColor
    actionBtn.Parent = float

    addHoverEffect(actionBtn, nil, DESIGN.ComponentHoverColor)

    -- > Registro de tema para ícone e texto
    RegisterThemeItem("ComponentTextColor", dragBtn, "ImageColor3")
    RegisterThemeItem("ComponentTextColor", actionBtn, "TextColor3")

    -- > Abre painel ao clicar no texto
    self.Connections.FloatExpand = actionBtn.MouseButton1Click:Connect(function()
        if not self.Blocked then
            self:ExpandFromFloat()
        end
    end)

    -- [Lógica de Arrastar mantida sem alterações para garantir funcionamento do movimento]
    local dragging = false
    local dragStart
    local startPos

    self.Connections.FloatBegin = dragBtn.InputBegan:Connect(function(input)
        if self.Blocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = UIS:GetMouseLocation()
            startPos = float.Position
        end
    end)

    self.Connections.FloatChange = UIS.InputChanged:Connect(function(input)
        if not dragging or self.Blocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = UIS:GetMouseLocation() - dragStart
            float.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    self.Connections.FloatEnd = UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- > Funções de Estado (Minimizar/Expandir) otimizadas


function Tekscripts:Minimize()
if self.Blocked or self.MinimizedState then return end

self.MinimizedState = "float"
self.LastWindowPosition = self.Window.Position
self.LastWindowSize = self.Window.Size

if self._activeTween then self._activeTween:Cancel() end

local minimizeTween = TweenService:Create(self.Window, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0)
})

self._activeTween = minimizeTween

minimizeTween.Completed:Once(function()
    self.Window.Visible = false
    self.FloatButton.Visible = true
    self._activeTween = TweenService:Create(self.FloatButton, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = DESIGN.FloatButtonSize
    })
    self._activeTween:Play()
    self._activeTween.Completed:Once(function()
        self._activeTween = nil
    end)
end)

minimizeTween:Play()
end

function Tekscripts:ExpandFromFloat()
if self.MinimizedState ~= "float" or self.Blocked then return end

if self._activeTween then self._activeTween:Cancel() end

local floatTween = TweenService:Create(self.FloatButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
    Size = UDim2.new(0, 0, 0, 0)
})

self._activeTween = floatTween

floatTween.Completed:Once(function()
    self.FloatButton.Visible = false
    self.Window.Visible = true
    self._activeTween = nil

    local screenSize = workspace.CurrentCamera.ViewportSize
    local windowW = math.min(DESIGN.WindowSize.X.Offset, screenSize.X * 0.8)
    local windowH = math.min(DESIGN.WindowSize.Y.Offset, screenSize.Y * 0.8)
    
    local newPos = UDim2.new(0.5, -windowW/2, 0.5, -windowH/2)
    
    local expandTween = TweenService:Create(self.Window, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, windowW, 0, windowH),
        Position = newPos
    })
    
    self._activeTween = expandTween
    expandTween:Play()
    
    expandTween.Completed:Once(function()
        self.MinimizedState = nil
        self._activeTween = nil
    end)
end)

floatTween:Play()
end


function Tekscripts:Block(state: boolean)
    self.Blocked = state
    self.BlockScreen.Visible = state
    local targetSize = state and DESIGN.BlurEffectSize or 0
    TweenService:Create(self.BlurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
end

-- > Funções Públicas para criar componentes

Tekscripts.Localization = {
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    CurrentLanguage = "en",
    Translations = {},
    -- > Evento interno para disparar atualizações globais
    _Changed = Instance.new("BindableEvent"),

    -- > API de Inicialização
    Init = function(self, translations)
        if type(translations) == "table" then
            self.Translations = translations
        end
    end,

    -- > Função interna para componentes usarem
    -- > label: O Objeto TextLabel/TextButton
    -- > rawText: A string original (ex: "loc:play" ou "Olá")
    _ApplyDynamicLocalization = function(self, label: TextLabel | TextButton, rawText: string)
        if not label or type(rawText) ~= "string" then return end

        -- > Função que aplica a tradução no momento atual
        local function update()
            if label and label.Parent then
                label.Text = self:TranslateText(rawText)
            end
        end

        -- > Executa a primeira vez (Inicia o texto)
        update()

        -- > Conecta ao evento de mudança para manter consistência
        local connection
        connection = self._Changed.Event:Connect(function()
            -- > Verifica se o objeto ainda existe para evitar memory leak
            if label and label.Parent then
                update()
            else
                connection:Disconnect() -- > Limpa cache de conexão se o objeto sumiu
            end
        end)

        return connection
    end,

    SetLanguage = function(self, lang)
        if self.Translations[lang] then
            self.CurrentLanguage = lang
            -- > Notifica todos os componentes inscritos
            self._Changed:Fire(lang)
        else
            warn("Idioma não encontrado: "..tostring(lang))
        end
    end,

    GetLanguage = function(self)
        return self.CurrentLanguage
    end,

    SetTranslations = function(self, lang, translations)
        if type(translations) ~= "table" then return end
        self.Translations[lang] = self.Translations[lang] or {}
        for k,v in pairs(translations) do
            self.Translations[lang][k] = v
        end
    end,

    Get = function(self, key)
        if not self.Enabled then return key end
        if type(key) == "string" and key:sub(1,#self.Prefix) == self.Prefix then
            key = key:sub(#self.Prefix+1)
        end
        local lang = self.CurrentLanguage
        local t = self.Translations[lang] or self.Translations[self.DefaultLanguage]
        return (t and t[key]) or key
    end,

    TranslateText = function(self, text)
        if type(text) ~= "string" then return text end
        if text:sub(1, #self.Prefix) == self.Prefix then
            return self:Get(text)
        end
        return text
    end,

    SetEnabled = function(self, state)
        self.Enabled = state and true or false
        self._Changed:Fire(self.CurrentLanguage) -- > Atualiza visual ao ligar/desligar
    end
}


-- > 🟩 API COPY

-- > 🔹 Copiar texto universalmente
function Tekscripts:Copy(text: string)
	assert(type(text) == "string", "O texto precisa ser uma string")

	local success, msg = false, ""

	if typeof(setclipboard) == "function" then
		pcall(setclipboard, text)
		success, msg = true, "[Clipboard] Copiado com setclipboard."

	elseif typeof(toclipboard) == "function" then
		pcall(toclipboard, text)
		success, msg = true, "[Clipboard] Copiado com toclipboard."

	elseif plugin and typeof(plugin.SetClipboard) == "function" then
		pcall(function()
			plugin:SetClipboard(text)
			success = true
			msg = "[Clipboard] Copiado com plugin:SetClipboard."
		end)

	elseif rawget(getgenv and getgenv() or {}, "setclipboard") then
		pcall(getgenv().setclipboard, text)
		success, msg = true, "[Clipboard] Copiado via getgenv().setclipboard."

	else
		msg = "[Clipboard] Nenhuma API de cópia disponível neste ambiente."
	end

	if success then
		print(msg)
	else
		warn(msg .. " Texto: " .. text)
	end

	return success
end


-- > 🔹 Copiar path de instância automaticamente
function Tekscripts:CopyInstancePath(instance: Instance)
	assert(typeof(instance) == "Instance", "O argumento precisa ser uma instância válida")
	local path = instance:GetFullName()
	return self:Copy(path)
end
-- > 🟩 FIM API COPY

-- > 🟩 API DIRECTORY
function Tekscripts:WriteFile(path: string, content: string)
	assert(type(path) == "string", "Caminho inválido")
	assert(type(content) == "string", "Conteúdo inválido")

	local writeFunc =
		writefile
		or (fluxus and fluxus.writefile)
		or (trigon and trigon.writeFile)
		or (codex and codex.writefile)
		or (syn and syn.write_file)
		or (KRNL and KRNL.WriteFile)

	if not writeFunc then
		warn("[FS] Executor não suporta escrita de arquivos")
		return false
	end

	local ok, err = pcall(writeFunc, path, content)
	if not ok then warn("[FS] Erro ao escrever arquivo:", err) end
	return ok
end

function Tekscripts:ReadFile(path: string)
	assert(type(path) == "string", "Caminho inválido")

	local readFunc =
		readfile
		or (fluxus and fluxus.readFile)
		or (trigon and trigon.readFile)
		or (codex and codex.readFile)
		or (syn and syn.read_file)
		or (KRNL and KRNL.ReadFile)

	local existsFunc =
		isfile
		or (fluxus and fluxus.isfile)
		or (trigon and trigon.isfile)
		or (codex and codex.isfile)
		or (syn and syn.file_exists)
		or (KRNL and KRNL.IsFile)
		or function() return false end

	if not readFunc or not existsFunc(path) then
		warn("[FS] Arquivo não existe ou leitura não suportada")
		return nil
	end

	local ok, result = pcall(readFunc, path)
	if ok then
		return result
	else
		warn("[FS] Erro ao ler arquivo:", result)
		return nil
	end
end

function Tekscripts:IsFile(path: string)
	assert(type(path) == "string", "Caminho inválido")

	local existsFunc =
		isfile
		or (fluxus and fluxus.isfile)
		or (trigon and trigon.isfile)
		or (codex and codex.isfile)
		or (syn and syn.file_exists)
		or (KRNL and KRNL.IsFile)
		or function() return false end

	return existsFunc(path)
end

-- >  FIM API DIRECTORY

-- >  API REQUEST
function Tekscripts:Request(options)
    assert(type(options) == "table", "As opções precisam ser uma tabela.")
    local HttpService = game:GetService("HttpService")

    local requestFunc = (syn and syn.request) or 
                        (fluxus and fluxus.request) or 
                        (http and http.request) or 
                        (krnl and krnl.request) or 
                        (getgenv() and getgenv().request) or 
                        request

    if not requestFunc then
        warn("[Tekscripts] Executor sem suporte a HTTP.")
        return nil
    end

    -- > Encode automático do Body (se você enviar uma tabela para o servidor)
    if options.Body and type(options.Body) == "table" then
        options.Headers = options.Headers or {}
        options.Headers["Content-Type"] = "application/json"
        options.Body = HttpService:JSONEncode(options.Body)
    end

    local ok, response = pcall(requestFunc, options)
    
    if ok and type(response) == "table" then
        -- > Retorna SEMPRE o conteúdo bruto (Body) como string
        -- > Isso evita que o Lua retorne a tabela da memória
        return tostring(response.Body or "")
    end

    warn("[Tekscripts] Erro na requisição.")
    return nil
end

-- >  FIM DA API REQUEST

function Tekscripts:CreateTextBox(tab, options)
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateTextBox")
    assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateTextBox")

    local titleRaw = options.Text or "Log"
    local descRaw = options.Desc
    local defaultText = options.Default or ""
    local readonly = options.ReadOnly or true

    -- > // CONTAINER BASE
    local boxHolder = Instance.new("Frame")
    boxHolder.Name = "TextBox"
    RegisterThemeItem("ComponentBackground", boxHolder, "BackgroundColor3")
    boxHolder.BackgroundColor3 = DESIGN.ComponentBackground
    boxHolder.Size = UDim2.new(1, 0, 0, descRaw and 140 or 120)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius or 8)
    corner.Parent = boxHolder

    local stroke = Instance.new("UIStroke")
    RegisterThemeItem("HRColor", stroke, "Color")
    stroke.Color = DESIGN.HRColor
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = boxHolder

    -- > // LAYOUT BASE
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, DESIGN.ComponentPadding or 10)
    padding.PaddingBottom = UDim.new(0, DESIGN.ComponentPadding or 10)
    padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding or 10)
    padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding or 10)
    padding.Parent = boxHolder

    -- > // TÍTULO (Com Tradução Dinâmica)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.Gotham
    RegisterThemeItem("ComponentTextColor", titleLabel, "TextColor3")
    titleLabel.TextColor3 = DESIGN.ComponentTextColor
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Size = UDim2.new(1, -10, 0, 18)
    titleLabel.Parent = boxHolder
    
    -- > Aplica localização dinâmica ao título
    local titleConn = Tekscripts.Localization:_ApplyDynamicLocalization(titleLabel, titleRaw)

    -- > // SUBTÍTULO (Com Tradução Dinâmica)
    local currentY = 22
    local descConn = nil
    if descRaw then
        local sub = Instance.new("TextLabel")
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.GothamSemibold
        sub.TextColor3 = Color3.fromRGB(150, 150, 150)
        sub.TextSize = 12
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Position = UDim2.new(0, 0, 0, currentY)
        sub.Size = UDim2.new(1, -10, 0, 16)
        sub.Parent = boxHolder
        
        -- > Aplica localização dinâmica à descrição
        descConn = Tekscripts.Localization:_ApplyDynamicLocalization(sub, descRaw)
        currentY += 20
    end

    -- > // CONTAINER DO TEXTO (com scroll)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll"
    scroll.BackgroundColor3 = DESIGN.InputBackgroundColor 
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.new(0, 0, 0, currentY + 6)
    scroll.Size = UDim2.new(1, 0, 1, descRaw and -currentY - 14 or -28)
    scroll.ScrollBarThickness = 4
    RegisterThemeItem("SliderTrackColor", scroll, "ScrollBarImageColor3")
    scroll.ScrollBarImageColor3 = DESIGN.SliderTrackColor
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ClipsDescendants = true
    scroll.Active = true
    scroll.Parent = boxHolder

    local innerPadding = Instance.new("UIPadding")
    innerPadding.PaddingTop = UDim.new(0, 6)
    innerPadding.PaddingLeft = UDim.new(0, 6)
    innerPadding.PaddingRight = UDim.new(0, 6)
    innerPadding.PaddingBottom = UDim.new(0, 6)
    innerPadding.Parent = scroll

    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 6)
    scrollCorner.Parent = scroll

    local scrollStroke = Instance.new("UIStroke")
    scrollStroke.Color = DESIGN.SliderTrackColor
    scrollStroke.Thickness = 1
    scrollStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    scrollStroke.Parent = scroll

    -- > // TEXTO PRINCIPAL (Conteúdo do Log)
    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    RegisterThemeItem("InputTextColor", textLabel, "TextColor3")
    textLabel.TextColor3 = DESIGN.InputTextColor
    textLabel.Font = Enum.Font.Code
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    textLabel.Text = defaultText
    textLabel.Size = UDim2.new(1, -8, 0, 0)
    textLabel.AutomaticSize = Enum.AutomaticSize.Y
    textLabel.Parent = scroll

    -- > // INTERAÇÃO
    local function updateInteractivity()
        local blocked = self.Blocked or readonly
        scroll.Active = not blocked
        textLabel.TextTransparency = blocked and 0.5 or 0
        
        local scrollBgColor = blocked and DESIGN.WindowColor2 or DESIGN.InputBackgroundColor
        scroll.BackgroundColor3 = scrollBgColor
        
        local scrollStrokeColor = blocked and DESIGN.HRColor or DESIGN.SliderTrackColor
        scrollStroke.Color = scrollStrokeColor
    end

    updateInteractivity()

    -- > // API PÚBLICA
    local publicApi = {
        _instance = boxHolder,
        _scroll = scroll,
        _label = textLabel,
        _readonly = readonly,
        _titleConn = titleConn, -- > Guardado para limpeza
        _descConn = descConn
    }

    function publicApi:_reapplyThemeColors()
        updateInteractivity()
    end

    RegisterThemeItem("InputBackgroundColor", publicApi, "_reapplyThemeColors")
    RegisterThemeItem("WindowColor2", publicApi, "_reapplyThemeColors")
    RegisterThemeItem("SliderTrackColor", publicApi, "_reapplyThemeColors")
    RegisterThemeItem("HRColor", publicApi, "_reapplyThemeColors")

    function publicApi:SetText(newText)
        textLabel.Text = tostring(newText)
        task.wait()
        scroll.CanvasPosition = Vector2.new(0, math.huge)
    end

    function publicApi:GetText()
        return textLabel.Text
    end

    function publicApi:Append(line)
        local current = textLabel.Text
        textLabel.Text = (current == "" and "" or current .. "\n") .. tostring(line)
        task.wait()
        scroll.CanvasPosition = Vector2.new(0, math.huge)
    end

    function publicApi:Clear()
        textLabel.Text = ""
    end

    function publicApi:SetBlocked(state)
        self._blocked = state
        updateInteractivity()
    end

    function publicApi:Destroy()
        -- > Limpeza de conexões de tradução para evitar memory leaks
        if self._titleConn then self._titleConn:Disconnect() end
        if self._descConn then self._descConn:Disconnect() end
        
        if publicApi._instance then
            publicApi._instance:Destroy()
            publicApi._instance = nil
        end
    end

    table.insert(tab.Components, publicApi)
    boxHolder.Parent = tab.Container

    if self.BlockChanged then
        self.BlockChanged:Connect(updateInteractivity)
    end

    return publicApi
end

function Tekscripts:CreateBind(tab, options)
	assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateBind")
	assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateBind")

	local titleRaw = options.Text or "Keybind"
	local descRaw = options.Desc
	local defaultKey = options.Default or Enum.KeyCode.F
	local callback = typeof(options.Callback) == "function" and options.Callback or function() end

	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")

	-- > CRIAÇÃO DE ELEMENTOS
	local box = Instance.new("Frame")
	box.Name = "BindBox"
	RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
	box.BackgroundColor3 = DESIGN.ComponentBackground
    box.BackgroundTransparency = DESIGN.TabContainerTransparency or 0
	box.Size = UDim2.new(1, 0, 0, descRaw and DESIGN.ComponentHeight + 10 or DESIGN.ComponentHeight)
	box.ClipsDescendants = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
	corner.Parent = box

	local stroke = Instance.new("UIStroke")
	RegisterThemeItem("HRColor", stroke, "Color")
	stroke.Color = DESIGN.HRColor
	stroke.Thickness = 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = box

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, DESIGN.ComponentPadding / 2)
	padding.PaddingBottom = UDim.new(0, DESIGN.ComponentPadding / 2)
	padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
	padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)
	padding.Parent = box

	local holder = Instance.new("Frame")
	holder.BackgroundTransparency = 1
	holder.Size = UDim2.new(1, 0, 1, 0)
	holder.Parent = box

	-- > TÍTULO (Com Localização Dinâmica)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	RegisterThemeItem("ComponentTextColor", label, "TextColor3")
	label.TextColor3 = DESIGN.ComponentTextColor
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(1, -80, 1, 0)
	label.Parent = holder
	
	-- > Conecta o título ao sistema de tradução
	local titleConn = Tekscripts.Localization:_ApplyDynamicLocalization(label, titleRaw)

	-- > DESCRIÇÃO (Com Localização Dinâmica)
	local descConn = nil
	if descRaw then
		label.TextYAlignment = Enum.TextYAlignment.Top
		local sub = Instance.new("TextLabel")
		sub.BackgroundTransparency = 1
		sub.Font = Enum.Font.GothamSemibold
		RegisterThemeItem("EmptyStateTextColor", sub, "TextColor3")
		sub.TextColor3 = DESIGN.EmptyStateTextColor
		sub.TextSize = 12
		sub.TextXAlignment = Enum.TextXAlignment.Left
		sub.TextYAlignment = Enum.TextYAlignment.Bottom
		sub.Size = UDim2.new(1, -80, 1, 0)
		sub.Parent = holder
		
		-- > Conecta a descrição ao sistema de tradução
		descConn = Tekscripts.Localization:_ApplyDynamicLocalization(sub, descRaw)
	end

	local button = Instance.new("TextButton")
	button.AnchorPoint = Vector2.new(1, 0.5)
	button.Position = UDim2.new(1, -DESIGN.ComponentPadding, 0.5, 0)
	button.Size = UDim2.new(0, 80, 0, DESIGN.ComponentHeight * 0.5)
	RegisterThemeItem("InputBackgroundColor", button, "BackgroundColor3")
	button.BackgroundColor3 = DESIGN.InputBackgroundColor
	RegisterThemeItem("InputTextColor", button, "TextColor3")
	button.TextColor3 = DESIGN.InputTextColor
	button.Text = defaultKey.Name
	button.Font = Enum.Font.Gotham
	button.TextSize = 13
	button.AutoButtonColor = false
	button.Parent = holder

	local btnStroke = Instance.new("UIStroke")
	RegisterThemeItem("HRColor", btnStroke, "Color")
	btnStroke.Color = DESIGN.HRColor
	btnStroke.Thickness = 1
	btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	btnStroke.Parent = button

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, DESIGN.CornerRadius / 2)
	btnCorner.Parent = button

	-- > SEGURANÇA DE ESTADO
	local destroyed = false
	local listening = false
	local currentKey = defaultKey
	local connections = {}

	-- > FUNÇÃO SEGURA DE CONEXÃO
	local function safeConnect(signal, func)
		local conn = signal:Connect(function(...)
			if destroyed then return end
			local ok, err = pcall(func, ...)
			if not ok then warn("[CreateBind:CallbackError]:", err) end
		end)
		table.insert(connections, conn)
		return conn
	end

	-- > LISTEN SEGURO
	local function listenForKey()
		if listening or destroyed then return end
		listening = true
		
		-- > Traduz "Pressione..." se houver chave loc:pressing
		button.Text = Tekscripts.Localization:TranslateText("loc:pressing") or "..."
		
		local oldColor = button.BackgroundColor3
		TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 170, 0) }):Play()

		local inputConn
		inputConn = safeConnect(UserInputService.InputBegan, function(input, processed)
			if destroyed or processed or not listening then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				currentKey = input.KeyCode
				pcall(function()
					if button then 
						button.Text = currentKey.Name 
						TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = DESIGN.InputBackgroundColor }):Play()
					end
				end)
				listening = false
				if inputConn and inputConn.Connected then inputConn:Disconnect() end
			end
		end)
	end

	-- > INTERAÇÕES
	safeConnect(button.MouseEnter, function()
		if button and not destroyed and not listening then
			button.BackgroundColor3 = DESIGN.ItemHoverColor
		end
	end)

	safeConnect(button.MouseLeave, function()
		if button and not destroyed and not listening then
			button.BackgroundColor3 = DESIGN.InputBackgroundColor
		end
	end)

	safeConnect(button.MouseButton1Click, function()
		listenForKey()
	end)

	safeConnect(UserInputService.InputBegan, function(input, processed)
		if destroyed or processed then return end
		if input.KeyCode == currentKey and not self.Blocked then
			local ok, err = pcall(callback, currentKey)
			if not ok then
				warn("[BindError]:", err)
				pcall(function()
					if button and not destroyed then
						TweenService:Create(button, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(200, 80, 80) }):Play()
						task.delay(0.25, function()
							if button and not destroyed then
								TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = DESIGN.InputBackgroundColor }):Play()
							end
						end)
					end
				end)
			end
		end
	end)

	-- > API PÚBLICA
	local publicApi = {
		_instance = box,
		_connections = connections,
		_titleConn = titleConn, -- > Cache para limpeza
		_descConn = descConn
	}

	function publicApi:_reapplyButtonColor()
		if button and not destroyed and not listening then
			button.BackgroundColor3 = DESIGN.InputBackgroundColor
		end
	end

	RegisterThemeItem("InputBackgroundColor", publicApi, "_reapplyButtonColor")
	RegisterThemeItem("ItemHoverColor", publicApi, "_reapplyButtonColor")

	function publicApi:GetKey() return currentKey end

	function publicApi:SetKey(newKey)
		if destroyed then return end
		if typeof(newKey) == "EnumItem" and newKey.EnumType == Enum.KeyCode then
			currentKey = newKey
			if button then button.Text = newKey.Name end
		end
	end

	function publicApi:Update(newOptions)
		if destroyed or not newOptions then return end
		if newOptions.Text then 
			titleRaw = newOptions.Text
			label.Text = Tekscripts.Localization:TranslateText(titleRaw)
		end
		-- ... (atualizar desc se necessário)
	end

	function publicApi:Destroy()
		if destroyed then return end
		destroyed = true
		
		-- > Desconecta localizações
		if self._titleConn then self._titleConn:Disconnect() end
		if self._descConn then self._descConn:Disconnect() end
		
		for _, conn in ipairs(connections) do
			if conn and conn.Connected then conn:Disconnect() end
		end
		table.clear(connections)
		if box then box:Destroy() end
	end

	table.insert(tab.Components, publicApi)
	box.Parent = tab.Container

	return publicApi
end

function Tekscripts:CreateDropdown(tab: any, options: {
    Title: string,
    Values: { { Name: string, Image: string? } },
    Callback: (selected: {string} | string) -> (),
    MultiSelect: boolean?,
    MaxVisibleItems: number?,
    InitialValues: {string}?
})
    assert(type(tab) == "table" and tab.Container, "Objeto 'tab' inválido")
    assert(type(options) == "table" and type(options.Title) == "string" and type(options.Values) == "table", "Argumentos inválidos")

    local TweenService = game:GetService("TweenService")
    local Localization = Tekscripts.Localization

    local multiSelect = options.MultiSelect or false
    local maxVisibleItems = math.min(options.MaxVisibleItems or 5, 8)
    local itemHeight = 44
    local imagePadding = 8
    local imageSize = itemHeight - (imagePadding * 2)
    
    local box = Instance.new("Frame")
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.Size = UDim2.new(1, 0, 0, 0)
    RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
    box.BackgroundColor3 = DESIGN.ComponentBackground
    box.BackgroundTransparency = DESIGN.TabContainerTransparency or 0
    box.BorderSizePixel = 0
    box.Parent = tab.Container
    addRoundedCorners(box, DESIGN.CornerRadius or 8)

    local boxLayout = Instance.new("UIListLayout")
    boxLayout.Padding = UDim.new(0, 0)
    boxLayout.SortOrder = Enum.SortOrder.LayoutOrder
    boxLayout.Parent = box
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(1, 0, 0, 50)
    main.BackgroundTransparency = 1
    main.LayoutOrder = 1
    main.Parent = box

    local mainPadding = Instance.new("UIPadding")
    mainPadding.PaddingLeft = UDim.new(0, 12)
    mainPadding.PaddingRight = UDim.new(0, 12)
    mainPadding.PaddingTop = UDim.new(0, 12)
    mainPadding.PaddingBottom = UDim.new(0, 12)
    mainPadding.Parent = main

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -110, 1, 0)
    title.BackgroundTransparency = 1
    RegisterThemeItem("ComponentTextColor", title, "TextColor3")
    title.TextColor3 = DESIGN.ComponentTextColor
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.Parent = main

    -- > APLICAÇÃO DE TRADUÇÃO DINÂMICA (TÍTULO)
    local titleLocConn = Localization:_ApplyDynamicLocalization(title, options.Title)

    local botaoText = createButton("Selecionar ▼", UDim2.new(0, 100, 1, 0), main)
    botaoText.Name = "BotaoText"
    botaoText.Position = UDim2.new(1, -100, 0, 0)
    botaoText.TextSize = 13
    botaoText.Parent = main

    local lister = Instance.new("ScrollingFrame")
    lister.Name = "Lister"
    lister.Size = UDim2.new(1, 0, 0, 0)
    lister.BackgroundTransparency = 1
    lister.BorderSizePixel = 0
    lister.ClipsDescendants = true
    RegisterThemeItem("AccentColor", lister, "ScrollBarImageColor3")
    lister.ScrollBarImageColor3 = DESIGN.AccentColor
    lister.ScrollBarThickness = 5
    lister.ScrollingDirection = Enum.ScrollingDirection.Y
    lister.CanvasSize = UDim2.new(0, 0, 0, 0)
    lister.AutomaticCanvasSize = Enum.AutomaticSize.Y
    lister.LayoutOrder = 2
    lister.Parent = box

    local listerLayout = Instance.new("UIListLayout")
    listerLayout.Padding = UDim.new(0, 4)
    listerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listerLayout.Parent = lister

    local listerPadding = Instance.new("UIPadding")
    listerPadding.PaddingLeft = UDim.new(0, 12)
    listerPadding.PaddingRight = UDim.new(0, 12)
    listerPadding.PaddingTop = UDim.new(0, 8)
    listerPadding.PaddingBottom = UDim.new(0, 12)
    listerPadding.Parent = lister

    local isOpen = false
    local selectedValues = {} -- > Armazena as chaves "raw" (podem ser loc: chaves)
    local connections = {}
    local itemElements = {}
    local itemOrder = {}

    -- > ATUALIZAÇÃO DE TEXTO DO BOTÃO (Respeita Localização)
    local function updateButtonText()
        local arrow = isOpen and "▲" or "▼"
        if #selectedValues == 0 then
            -- > Traduz "Selecionar" dinamicamente
            botaoText.Text = Localization:Get("loc:select_none") or "Selecionar" .. " " .. arrow
        elseif #selectedValues == 1 then
            -- > Traduz o valor único selecionado
            local displayText = Localization:TranslateText(selectedValues[1])
            if #displayText > 10 then displayText = string.sub(displayText, 1, 10) .. "..." end
            botaoText.Text = displayText .. " " .. arrow
        else
            -- > Traduz "itens" dinamicamente
            local itemWord = Localization:Get("loc:items_count") or "itens"
            botaoText.Text = string.format("%d %s %s", #selectedValues, itemWord, arrow)
        end
    end

    -- > Escuta mudança de idioma para atualizar o texto do botão
    connections.LocaleChange = Localization._Changed.Event:Connect(updateButtonText)

    local function toggleDropdown()
        isOpen = not isOpen
        local numItems = #itemOrder
        local totalItemHeight = (numItems * itemHeight) + ((numItems - 1) * listerLayout.Padding.Offset)
        local maxHeight = (maxVisibleItems * itemHeight) + ((maxVisibleItems - 1) * listerLayout.Padding.Offset)
        local targetHeight = isOpen and math.min(totalItemHeight + listerPadding.PaddingTop.Offset + listerPadding.PaddingBottom.Offset, maxHeight + listerPadding.PaddingTop.Offset + listerPadding.PaddingBottom.Offset) or 0
        
        lister.CanvasSize = UDim2.new(0, 0, 0, listerLayout.AbsoluteContentSize.Y)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        TweenService:Create(lister, tweenInfo, { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
        updateButtonText()
    end

    local function setItemSelected(valueName, isSelected)
        local elements = itemElements[valueName]
        if not elements then return end
        
        local targetColor = isSelected and DESIGN.AccentColor or DESIGN.ComponentBackground
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
        TweenService:Create(elements.container, tweenInfo, { BackgroundColor3 = targetColor }):Play()
        
        if elements.indicator then
            elements.indicator.Visible = isSelected
            if isSelected then elements.indicator.BackgroundColor3 = DESIGN.AccentColor end
        end
        
        if multiSelect and elements.checkIconImage then
            elements.checkIconImage.Visible = isSelected
        end
    end

    local function toggleItemSelection(valueName)
        local isCurrentlySelected = table.find(selectedValues, valueName)
        
        if multiSelect then
            if isCurrentlySelected then
                table.remove(selectedValues, isCurrentlySelected)
                setItemSelected(valueName, false)
            else
                table.insert(selectedValues, valueName)
                setItemSelected(valueName, true)
            end
        else
            for name, _ in pairs(itemElements) do setItemSelected(name, false) end
            if isCurrentlySelected then
                selectedValues = {}
            else
                selectedValues = { valueName }
                setItemSelected(valueName, true)
            end
            if isOpen and not isCurrentlySelected then task.delay(0.15, toggleDropdown) end
        end
        
        updateButtonText()
        local selected = multiSelect and selectedValues or (selectedValues[1] or nil)
        if options.Callback then options.Callback(selected) end
    end

    local function createItem(valueInfo, index)
        local hasImage = valueInfo.Image and valueInfo.Image ~= ""
        
        local itemContainer = Instance.new("TextButton")
        itemContainer.Name = "Item_" .. index
        itemContainer.Size = UDim2.new(1, 0, 0, itemHeight)
        RegisterThemeItem("ComponentBackground", itemContainer, "BackgroundColor3")
        itemContainer.BackgroundColor3 = DESIGN.ComponentBackground
        itemContainer.BackgroundTransparency = DESIGN.TabContainerTransparency or 0
        itemContainer.BorderSizePixel = 0
        itemContainer.Text = ""
        itemContainer.AutoButtonColor = false
        itemContainer.LayoutOrder = index
        itemContainer.Parent = lister
        addRoundedCorners(itemContainer, (DESIGN.CornerRadius or 8) - 2)

        local contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1, -20, 1, 0)
        contentFrame.Position = UDim2.new(0, 10, 0, 0)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = itemContainer

        local indicator
        local checkIconImage 

        if multiSelect then
            indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 18, 0, 18)
            indicator.Position = UDim2.new(1, -18, 0.5, -9)
            RegisterThemeItem("AccentColor", indicator, "BackgroundColor3")
            indicator.BackgroundColor3 = DESIGN.AccentColor
            indicator.BorderSizePixel = 0
            indicator.Visible = false
            indicator.Parent = contentFrame
            addRoundedCorners(indicator, UDim.new(0, 3))
            
            checkIconImage = Instance.new("ImageLabel")
            checkIconImage.Size = UDim2.new(1, 0, 1, 0)
            checkIconImage.BackgroundTransparency = 1
            checkIconImage.Image = "rbxassetid://10709790644" 
            checkIconImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
            checkIconImage.ScaleType = Enum.ScaleType.Fit
            checkIconImage.Visible = false 
            checkIconImage.Parent = indicator
        else
            indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 8, 0, 8)
            indicator.Position = UDim2.new(1, -8, 0.5, -4)
            RegisterThemeItem("AccentColor", indicator, "BackgroundColor3")
            indicator.BackgroundColor3 = DESIGN.AccentColor
            indicator.BorderSizePixel = 0
            indicator.Visible = false
            indicator.Parent = contentFrame
            addRoundedCorners(indicator, UDim.new(1, 0))
        end

        if hasImage then
            local foto = Instance.new("ImageLabel")
            foto.Size = UDim2.new(0, imageSize, 0, imageSize)
            foto.Position = UDim2.new(0, 0, 0.5, -imageSize/2)
            foto.BackgroundTransparency = 1
            foto.Image = valueInfo.Image
            foto.ScaleType = Enum.ScaleType.Fit
            foto.Parent = contentFrame
            addRoundedCorners(foto, UDim.new(0, 4))
        end

        local textXOffset = hasImage and (imageSize + 8) or 0
        local textWidth = multiSelect and -30 or -12
        
        local itemText = Instance.new("TextLabel")
        itemText.Size = UDim2.new(1, textWidth, 1, 0)
        itemText.Position = UDim2.new(0, textXOffset, 0, 0)
        itemText.BackgroundTransparency = 1
        RegisterThemeItem("ComponentTextColor", itemText, "TextColor3")
        itemText.TextColor3 = DESIGN.ComponentTextColor
        itemText.Font = Enum.Font.Gotham
        itemText.TextSize = 14
        itemText.TextXAlignment = Enum.TextXAlignment.Left
        itemText.TextYAlignment = Enum.TextYAlignment.Center
        itemText.TextTruncate = Enum.TextTruncate.AtEnd
        itemText.Parent = contentFrame

        -- > APLICAÇÃO DE TRADUÇÃO DINÂMICA (ITEM DA LISTA)
        local locConn = Localization:_ApplyDynamicLocalization(itemText, valueInfo.Name)
        
        local function forceItemColorUpdate(selectedState)
            local targetColor = selectedState and DESIGN.AccentColor or DESIGN.ComponentBackground
            itemContainer.BackgroundColor3 = targetColor
            if indicator then indicator.Visible = selectedState end
            if checkIconImage then checkIconImage.Visible = selectedState end
        end

        itemElements[valueInfo.Name] = {
            container = itemContainer,
            indicator = indicator,
            textLabel = itemText,
            checkIconImage = checkIconImage, 
            forceColorUpdate = forceItemColorUpdate,
            _locConn = locConn,
            connections = {}
        }

        itemElements[valueInfo.Name].connections.Click = itemContainer.MouseButton1Click:Connect(function()
            toggleItemSelection(valueInfo.Name)
        end)

        itemElements[valueInfo.Name].connections.Hover = itemContainer.MouseEnter:Connect(function()
            if not table.find(selectedValues, valueInfo.Name) then
                local hoverColor = DESIGN.ItemHoverColor or Color3.fromRGB(45, 45, 50) 
                TweenService:Create(itemContainer, TweenInfo.new(0.15), { BackgroundColor3 = hoverColor }):Play()
            end
        end)

        itemElements[valueInfo.Name].connections.Leave = itemContainer.MouseLeave:Connect(function()
            if not table.find(selectedValues, valueInfo.Name) then
                TweenService:Create(itemContainer, TweenInfo.new(0.15), { BackgroundColor3 = DESIGN.ComponentBackground }):Play()
            end
        end)
    end

    -- > Inicialização dos Itens
    for index, valueInfo in ipairs(options.Values) do
        table.insert(itemOrder, valueInfo.Name)
        createItem(valueInfo, index)
    end

    if options.InitialValues then
        for _, val in ipairs(options.InitialValues) do
            if itemElements[val] then
                table.insert(selectedValues, val)
                itemElements[val].forceColorUpdate(true)
            end
        end
        updateButtonText()
    end

    connections.Toggle = botaoText.MouseButton1Click:Connect(toggleDropdown)

    local publicApi = {
        _instance = box,
        _connections = connections,
        _itemElements = itemElements,
        _titleLocConn = titleLocConn
    }
    
    function publicApi:_reapplyItemColors()
        for name, elements in pairs(publicApi._itemElements) do
            elements.forceColorUpdate(table.find(selectedValues, name)) 
        end
    end

    RegisterThemeItem("AccentColor", publicApi, "_reapplyItemColors")
    RegisterThemeItem("ComponentBackground", publicApi, "_reapplyItemColors")

    function publicApi:AddItem(valueInfo, position)
        if itemElements[valueInfo.Name] then return end
        position = math.clamp(position or (#itemOrder + 1), 1, #itemOrder + 1)
        table.insert(itemOrder, position, valueInfo.Name)
        createItem(valueInfo, position)
        for i, name in ipairs(itemOrder) do
            if itemElements[name] then itemElements[name].container.LayoutOrder = i end
        end
        if isOpen then toggleDropdown() task.delay(0.3, toggleDropdown) end
    end

    function publicApi:RemoveItem(valueName)
        local elements = itemElements[valueName]
        if elements then
            if elements._locConn then elements._locConn:Disconnect() end
            for _, conn in pairs(elements.connections) do conn:Disconnect() end
            elements.container:Destroy()
            itemElements[valueName] = nil
            
            local idx = table.find(itemOrder, valueName)
            if idx then table.remove(itemOrder, idx) end
            
            local sIdx = table.find(selectedValues, valueName)
            if sIdx then table.remove(selectedValues, sIdx) end
            
            updateButtonText()
            if isOpen then toggleDropdown() task.delay(0.3, toggleDropdown) end
        end
    end

    function publicApi:ClearItems()
        while #itemOrder > 0 do self:RemoveItem(itemOrder[1]) end
    end

    function publicApi:Destroy()
        if self._instance then
            if self._titleLocConn then self._titleLocConn:Disconnect() end
            for _, conn in pairs(self._connections) do conn:Disconnect() end
            for name, _ in pairs(itemElements) do self:RemoveItem(name) end
            self._instance:Destroy()
            self._instance = nil
        end
    end

    function publicApi:SetSelected(values)
        local valuesToSet = type(values) == "table" and values or {values}
        for name, _ in pairs(itemElements) do setItemSelected(name, false) end
        selectedValues = {}
        for _, v in ipairs(valuesToSet) do
            if itemElements[v] then
                table.insert(selectedValues, v)
                setItemSelected(v, true)
            end
        end
        updateButtonText()
        if options.Callback then options.Callback(self:GetSelected()) end
    end

    function publicApi:GetSelected()
        return multiSelect and selectedValues or (selectedValues[1] or nil)
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateDialog(options) 
    assert(type(options) == "table", "Invalid options")

    local titleRaw = options.Title or "Título"
    local messageRaw = options.Message or "Mensagem"
    local buttons = options.Buttons or { {Text = "Ok", Callback = function() end} }

    local player = game:GetService("Players").LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    local screen = Instance.new("ScreenGui")
    screen.Name = "TekscriptsDialog"
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.ResetOnSpawn = false
    screen.Parent = PlayerGui

    -- > // OVERLAY DE FUNDO
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    -- > O overlay usa a transparência baseada no design
    overlay.BackgroundTransparency = 1 - (DESIGN.WindowTransparency or 0.1)
    overlay.ZIndex = 999 
    overlay.Parent = screen
    
    -- > Função auxiliar para o overlay, que usa 1 - DESIGN.WindowTransparency
    local function updateOverlayTransparency()
        if overlay and overlay.Parent then
            overlay.BackgroundTransparency = 1 - (DESIGN.WindowTransparency or 0.1)
        end
    end
    -- > Registra o overlay em uma chave customizada para a transparência
    RegisterThemeItem("WindowTransparency", {object = {BackgroundTransparency = overlay.BackgroundTransparency}, property = "BackgroundTransparency"}, updateOverlayTransparency)

    -- > // CAIXA DE DIÁLOGO
    local box = Instance.new("Frame")
    box.Name = "DialogBox"
    box.Size = UDim2.new(0, 340, 0, 0)
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.Position = UDim2.new(0.5, 0, 0.5, 0)
    RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
    box.BackgroundColor3 = DESIGN.ComponentBackground
    RegisterThemeItem("WindowTransparency", box, "BackgroundTransparency")
    box.BackgroundTransparency = DESIGN.WindowTransparency 
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.ZIndex = 1000
    box.Parent = screen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius or 8)
    corner.Parent = box

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, DESIGN.ComponentPadding or 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = box

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, DESIGN.TitlePadding or 15)
    padding.PaddingBottom = UDim.new(0, DESIGN.TitlePadding or 15)
    padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding or 10)
    padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding or 10)
    padding.Parent = box

    -- > // TÍTULO (Dinâmico)
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, DESIGN.TitleHeight or 30)
    title.BackgroundTransparency = 1
    RegisterThemeItem("TitleColor", title, "TextColor3")
    title.TextColor3 = DESIGN.TitleColor
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.ZIndex = 1001
    title.LayoutOrder = 1
    title.Parent = box

    -- > Aplica Localização ao Título
    local titleLoc = Tekscripts.Localization:_ApplyDynamicLocalization(title, titleRaw)

    local hr = Instance.new("Frame")
    hr.Name = "TitleDivider"
    hr.Size = UDim2.new(1, 0, 0, 2)
    RegisterThemeItem("DividerColor", hr, "BackgroundColor3")
    hr.BackgroundColor3 = DESIGN.DividerColor or Color3.fromRGB(200,200,200)
    hr.BorderSizePixel = 0
    hr.ZIndex = 1001
    hr.LayoutOrder = 2
    hr.Parent = box

    -- > // MENSAGEM (Dinâmica)
    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, 0, 0, 0)
    message.AutomaticSize = Enum.AutomaticSize.Y
    message.BackgroundTransparency = 1
    message.TextWrapped = true
    RegisterThemeItem("ComponentTextColor", message, "TextColor3")
    message.TextColor3 = DESIGN.ComponentTextColor
    message.Font = Enum.Font.Gotham
    message.TextSize = 14
    message.TextXAlignment = Enum.TextXAlignment.Center
    message.TextYAlignment = Enum.TextYAlignment.Center
    message.ZIndex = 1001
    message.LayoutOrder = 3
    message.Parent = box

    -- > Aplica Localização à Mensagem
    local messageLoc = Tekscripts.Localization:_ApplyDynamicLocalization(message, messageRaw)

    local buttonHolder = Instance.new("Frame")
    buttonHolder.Name = "ButtonHolder"
    buttonHolder.Size = UDim2.new(1, 0, 0, 36)
    buttonHolder.BackgroundTransparency = 1
    buttonHolder.LayoutOrder = 4
    buttonHolder.ZIndex = 1001
    buttonHolder.Parent = box

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Padding = UDim.new(0, DESIGN.ComponentPadding or 10)
    btnLayout.Parent = buttonHolder

    local connections = {}
    local localizationConns = {titleLoc, messageLoc}
    local buttonsApi = {} 

    -- > // GERAÇÃO DE BOTÕES
    for i, btnInfo in ipairs(buttons) do
        local btnRawText = btnInfo.Text or "Button"
        local btn = Instance.new("TextButton")
        btn.Name = "DialogButton_" .. i
        btn.Size = UDim2.new(0, 100, 0, 30)
        
        RegisterThemeItem("InputBackgroundColor", btn, "BackgroundColor3")
        RegisterThemeItem("InputTextColor", btn, "TextColor3")
        
        btn.BackgroundColor3 = DESIGN.InputBackgroundColor
        btn.TextColor3 = DESIGN.InputTextColor
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.ZIndex = 1002
        btn.AutoButtonColor = false
        btn.Parent = buttonHolder

        -- > Aplica Localização ao Botão
        local btnLoc = Tekscripts.Localization:_ApplyDynamicLocalization(btn, btnRawText)
        table.insert(localizationConns, btnLoc)

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, (DESIGN.CornerRadius or 8) / 2)
        btnCorner.Parent = btn

        -- > // LOGICA DE HOVER
        local function mouseEnter()
            btn.BackgroundColor3 = DESIGN.ComponentHoverColor
        end
        local function mouseLeave()
            btn.BackgroundColor3 = DESIGN.InputBackgroundColor
        end
        
        table.insert(connections, btn.MouseEnter:Connect(mouseEnter))
        table.insert(connections, btn.MouseLeave:Connect(mouseLeave))
        
        -- > API interna para compatibilidade com Temas
        local buttonApi = {
            instance = btn,
            reapplyTheme = function()
                mouseLeave()
            end
        }
        table.insert(buttonsApi, buttonApi)
        RegisterThemeItem("ComponentHoverColor", buttonApi, "reapplyTheme")

        -- > // CALLBACK DO BOTÃO
        table.insert(connections, btn.MouseButton1Click:Connect(function()
            if btnInfo.Callback then 
                local success, err = pcall(btnInfo.Callback)
                if not success then warn("[Dialog] Callback Error: " .. tostring(err)) end
            end
            screen:Destroy()
        end))
    end

    local api = {
        _screen = screen,
        _connections = connections,
        _locConns = localizationConns
    }

    -- > // LIMPEZA TOTAL
    function api:Destroy()
        -- > Desconecta todas as localizações dinâmicas (Prevenção de Memory Leak)
        for _, locConn in ipairs(localizationConns) do
            if locConn then locConn:Disconnect() end
        end
        -- > Desconecta eventos de input
        for _, c in ipairs(connections) do
            if c.Connected then c:Disconnect() end
        end
        -- > Destrói a interface
        if screen then screen:Destroy() end
    end

    return api
end

function Tekscripts:CreateInput(tab, options)
	assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateInput")
	assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateInput")

	local TweenService = game:GetService("TweenService")

	-- > // CONFIGURAÇÃO DE ESTADOS INICIAIS
	local rawTitle = options.Text
	local rawPlaceholder = options.Placeholder or ""
	local rawDesc = options.Desc
	local rawBlockText = options.BlockText or "🔒 BLOQUEADO"

	-- > // CONTAINER PRINCIPAL
	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight + 30)
	RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
	box.BackgroundColor3 = DESIGN.ComponentBackground
	box.BackgroundTransparency = DESIGN.TabContainerTransparency
	box.Parent = tab.Container
	addRoundedCorners(box, DESIGN.CornerRadius)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = box

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = box

	-- > // LINHA SUPERIOR (Título + Input)
	local topRow = Instance.new("Frame")
	topRow.Size = UDim2.new(1, 0, 0, 28)
	topRow.BackgroundTransparency = 1
	topRow.Parent = box

	local rowLayout = Instance.new("UIListLayout")
	rowLayout.FillDirection = Enum.FillDirection.Horizontal
	rowLayout.Padding = UDim.new(0, 6)
	rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rowLayout.Parent = topRow

	-- > TÍTULO (Dinâmico)
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.4, 0, 1, 0)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true
	title.TextXAlignment = Enum.TextXAlignment.Left
	RegisterThemeItem("ComponentTextColor", title, "TextColor3")
	title.TextColor3 = DESIGN.ComponentTextColor
	title.Parent = topRow
	
	-- > Conexão de Localização do Título
	local titleLoc = Tekscripts.Localization:_ApplyDynamicLocalization(title, rawTitle)

	-- > INPUT TEXTBOX
	local textbox = Instance.new("TextBox")
	textbox.Size = UDim2.new(0.6, 0, 1, 0)
	RegisterThemeItem("InputBackgroundColor", textbox, "BackgroundColor3")
	textbox.BackgroundColor3 = DESIGN.InputBackgroundColor
	textbox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
	RegisterThemeItem("InputTextColor", textbox, "TextColor3")
	textbox.TextColor3 = DESIGN.InputTextColor
	textbox.TextScaled = true
	textbox.Font = Enum.Font.Roboto
	textbox.TextXAlignment = Enum.TextXAlignment.Left
	textbox.TextYAlignment = Enum.TextYAlignment.Center
	textbox.BorderSizePixel = 0
	textbox.Text = ""
	textbox.ClipsDescendants = true
	textbox.Parent = topRow
	addRoundedCorners(textbox, DESIGN.CornerRadius)
	
	-- > Placeholder Dinâmico (Usa função interna para atualizar a propriedade PlaceholderText)
	local placeholderLoc = nil
	local function updatePlaceholder()
		textbox.PlaceholderText = Tekscripts.Localization:TranslateText(rawPlaceholder)
	end
	placeholderLoc = Tekscripts.Localization._Changed.Event:Connect(updatePlaceholder)
	updatePlaceholder()

	local hoverConnections = addHoverEffect(textbox, DESIGN.InputBackgroundColor, DESIGN.InputHoverColor)

	-- > OVERLAY DE BLOQUEIO
	local blockOverlay = Instance.new("Frame")
	blockOverlay.Size = UDim2.new(1, 0, 1, 0)
	blockOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blockOverlay.BackgroundTransparency = 0.35
	blockOverlay.Visible = false
	blockOverlay.ZIndex = textbox.ZIndex + 2
	addRoundedCorners(blockOverlay, DESIGN.CornerRadius)
	blockOverlay.Parent = textbox

	local blockText = Instance.new("TextLabel")
	blockText.AnchorPoint = Vector2.new(0.5, 0.5)
	blockText.Position = UDim2.new(0.5, 0, 0.5, 0)
	blockText.Size = UDim2.new(1, -8, 1, -8)
	blockText.BackgroundTransparency = 1
	blockText.Font = Enum.Font.GothamBold
	blockText.TextScaled = true
	blockText.TextColor3 = Color3.fromRGB(255, 85, 85)
	blockText.ZIndex = blockOverlay.ZIndex + 1
	blockText.Parent = blockOverlay
	
	-- > Localização do texto de bloqueio
	local blockLoc = Tekscripts.Localization:_ApplyDynamicLocalization(blockText, rawBlockText)

	local errorIndicator = Instance.new("Frame")
	errorIndicator.Size = UDim2.new(0, 8, 0, 8)
	errorIndicator.Position = UDim2.new(1, -10, 0, 2)
	errorIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	errorIndicator.Visible = false
	errorIndicator.ZIndex = textbox.ZIndex + 3
	addRoundedCorners(errorIndicator, 100)
	errorIndicator.Parent = textbox

	-- > DESCRIÇÃO (Dinâmica)
	local desc = nil
	local descLoc = nil
	if rawDesc then
		desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, 0, 0, 14)
		desc.BackgroundTransparency = 1
		desc.Font = Enum.Font.Gotham
		desc.TextScaled = true
		desc.TextWrapped = true
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.TextColor3 = DESIGN.ComponentTextColor:lerp(Color3.new(0.7, 0.7, 0.7), 0.6)
		desc.Parent = box
		
		descLoc = Tekscripts.Localization:_ApplyDynamicLocalization(desc, rawDesc)
	end

	-- > // LOGICA E API
	local connections = {}
	local publicApi = { 
		_instance = box, 
		_connections = connections, 
		Blocked = false, 
		_hoverConnections = hoverConnections,
		_locConnections = { titleLoc, placeholderLoc, blockLoc, descLoc } 
	}
	
	local inError = false
	
	local function reapplyHoverEffect()
		if publicApi._hoverConnections then
			for _, conn in pairs(publicApi._hoverConnections) do
				if conn and conn.Connected then conn:Disconnect() end
			end
		end
		publicApi._hoverConnections = addHoverEffect(textbox, DESIGN.InputBackgroundColor, DESIGN.InputHoverColor)
	end
	
	RegisterThemeItem("InputHoverColor", publicApi, "_reapplyHover")
	
	function publicApi:_reapplyHover()
	    reapplyHoverEffect()
	end

	local function pulseError()
		if not textbox then return end
		inError = true
		errorIndicator.Visible = true
		TweenService:Create(textbox, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 60, 60) }):Play()
		task.delay(0.5, function()
			if textbox and not publicApi.Blocked then
				inError = false
				errorIndicator.Visible = false
				TweenService:Create(textbox, TweenInfo.new(0.2), { BackgroundColor3 = DESIGN.InputBackgroundColor }):Play()
			end
		end)
	end

	local function safeCallback(value)
		if publicApi.Blocked or not options.Callback then return end
		local ok, err = pcall(function() options.Callback(value) end)
		if not ok then
			warn("[Input Error]:", err)
			pulseError()
		end
	end

	if options.Type and options.Type:lower() == "number" then
		connections.Changed = textbox:GetPropertyChangedSignal("Text"):Connect(function()
			if publicApi.Blocked then return end
			local newText = textbox.Text
			if tonumber(newText) or newText == "" or newText == "-" then
				safeCallback(tonumber(newText) or 0)
			else
				textbox.Text = newText:sub(1, #newText - 1)
			end
		end)
	else
		connections.FocusLost = textbox.FocusLost:Connect(function(enterPressed)
			if publicApi.Blocked then return end
			if enterPressed then safeCallback(textbox.Text) end
		end)
	end

	-- > // METODOS PUBLICOS
	function publicApi:SetBlocked(state, text)
		self.Blocked = state
		textbox.Active = not state
		textbox.TextEditable = not state
		blockOverlay.Visible = state
		if text then 
			rawBlockText = tostring(text)
			blockText.Text = Tekscripts.Localization:TranslateText(rawBlockText)
		end
	end

	function publicApi:Update(newOptions)
		if not newOptions then return end
		if newOptions.Text then 
			rawTitle = newOptions.Text
			title.Text = Tekscripts.Localization:TranslateText(rawTitle)
		end
		if newOptions.Placeholder then 
			rawPlaceholder = newOptions.Placeholder
			updatePlaceholder()
		end
		if newOptions.Desc then
			rawDesc = newOptions.Desc
			if desc then 
				desc.Text = Tekscripts.Localization:TranslateText(rawDesc)
			elseif rawDesc ~= "" then
				desc = Instance.new("TextLabel")
				desc.Size = UDim2.new(1, 0, 0, 14)
				desc.BackgroundTransparency = 1
				desc.TextColor3 = DESIGN.ComponentTextColor:lerp(Color3.new(0.7, 0.7, 0.7), 0.6)
				desc.Font = Enum.Font.Gotham
				desc.TextScaled = true
				desc.TextWrapped = true
				desc.TextXAlignment = Enum.TextXAlignment.Left
				desc.Parent = box
				publicApi._locConnections[4] = Tekscripts.Localization:_ApplyDynamicLocalization(desc, rawDesc)
			end
		end
		if newOptions.Value ~= nil then textbox.Text = tostring(newOptions.Value) end
		if newOptions.BlockText then 
			rawBlockText = newOptions.BlockText
			blockText.Text = Tekscripts.Localization:TranslateText(rawBlockText)
		end
	end

	function publicApi:Destroy()
		-- > Limpa todas as conexões de localização (Cache)
		if self._locConnections then
			for _, conn in pairs(self._locConnections) do
				if conn and conn.Disconnect then conn:Disconnect() end
			end
			self._locConnections = nil
		end
		
		if self._connections then
			for _, conn in pairs(self._connections) do
				if conn and conn.Connected then conn:Disconnect() end
			end
			self._connections = nil
		end
		if self._hoverConnections then
			for _, conn in pairs(self._hoverConnections) do
				if conn and conn.Connected then conn:Disconnect() end
			end
			self._hoverConnections = nil
		end
		if self._instance then
			self._instance:Destroy()
			self._instance = nil
		end
	end

	table.insert(tab.Components, publicApi)
	return publicApi
end

function Tekscripts:CreateButton(tab, options)
    assert(typeof(tab) == "table" and tab.Container, "CreateButton: 'tab' inválido ou sem Container.")
    assert(typeof(options) == "table" and typeof(options.Text) == "string", "CreateButton: 'options' inválido.")

    local TweenService = game:GetService("TweenService")

    local callback = typeof(options.Callback) == "function" and options.Callback or function() end
    local debounceTime = tonumber(options.Debounce or 0.25)
    local lastClick = 0
    local rawText = options.Text -- > Armazena a chave original para tradução dinâmica
    
    local errorColor = Color3.fromRGB(255, 60, 60)
    
    local function getColors()
        return {
            btn = self._blocked and Color3.fromRGB(60, 60, 60) or DESIGN.ComponentBackground,
            hover = DESIGN.ComponentHoverColor
        }
    end

    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight)
    
    RegisterThemeItem("ComponentBackground", btn, "BackgroundColor3")
    btn.BackgroundColor3 = DESIGN.ComponentBackground
    
    btn.BackgroundTransparency = DESIGN.TabContainerTransparency
    
    RegisterThemeItem("ComponentTextColor", btn, "TextColor3")
    btn.TextColor3 = DESIGN.ComponentTextColor
    
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.Parent = tab.Container

    -- > APLICAÇÃO DA LOCALIZAÇÃO DINÂMICA
    -- > A função interna cuida de setar o texto inicial e monitorar mudanças de idioma
    local localizationConn = Tekscripts.Localization:_ApplyDynamicLocalization(btn, rawText)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    RegisterThemeItem("HRColor", stroke, "Color")
    stroke.Color = DESIGN.HRColor
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    local function tweenTo(props, duration)
        if not btn or not btn.Parent then return end
        local tween = TweenService:Create(btn, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad), props)
        tween:Play()
        return tween
    end

    local function pulseError()
        tweenTo({BackgroundColor3 = errorColor}, 0.1)
        task.delay(0.2, function()
            tweenTo({BackgroundColor3 = getColors().btn}, 0.2)
        end)
    end

    local hoverConn = btn.MouseEnter:Connect(function()
        if not self._blocked then tweenTo({BackgroundColor3 = getColors().hover}) end
    end)

    local leaveConn = btn.MouseLeave:Connect(function()
        if not self._blocked then tweenTo({BackgroundColor3 = getColors().btn}) end
    end)

    local clickConn = btn.MouseButton1Click:Connect(function()
        if self._blocked then return end
        if tick() - lastClick < debounceTime then return end
        lastClick = tick()

        -- > Feedback visual de clique (Encolher levemente)
        tweenTo({Size = UDim2.new(0.95, 0, 0, DESIGN.ComponentHeight * 0.9)}, 0.1)
        task.delay(0.1, function()
            tweenTo({Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight)}, 0.1)
        end)

        task.spawn(function()
            local ok, err = pcall(callback)
            if not ok then
                warn("[CreateButton] Callback error:", err)
                pulseError()
                if Tekscripts.Log then
                    Tekscripts.Log("[Button Error] " .. tostring(err))
                end
            end
        end)
    end)

    local publicApi = {
        _instance = btn,
        _connections = {clickConn, hoverConn, leaveConn, localizationConn}, -- > Adicionada a conexão de localização
        _blocked = false,
        _callback = callback,
        -- > Método para forçar a reaplicação de cor em caso de troca de tema
        _reapplyTheme = function() 
            if not self._blocked then
                tweenTo({BackgroundColor3 = getColors().btn}, 0.1) 
            end
        end
    }

    function publicApi:SetBlocked(state)
        self._blocked = state
        self._instance.Active = not state
        local color = getColors().btn
        tweenTo({BackgroundColor3 = color}, 0.15)
    end

    function publicApi:Update(newOptions)
        if typeof(newOptions) ~= "table" then return end
        
        -- > Se o texto mudar, precisamos atualizar a localização dinâmica
        if newOptions.Text then 
            rawText = newOptions.Text
            -- > Disconecta a antiga e cria uma nova para o novo texto
            if self._connections[4] then self._connections[4]:Disconnect() end
            self._connections[4] = Tekscripts.Localization:_ApplyDynamicLocalization(btn, rawText)
        end

        if typeof(newOptions.Callback) == "function" then
            callback = newOptions.Callback
            self._callback = callback
        end
        
        if newOptions.Debounce then
            debounceTime = tonumber(newOptions.Debounce)
        end
    end

    function publicApi:Destroy()
        -- > Limpa todas as conexões, incluindo o listener de idioma
        if self._connections then
            for _, c in ipairs(self._connections) do
                if c and typeof(c) == "RBXScriptConnection" then
                    c:Disconnect()
                elseif c and typeof(c) == "table" and c.Disconnect then
                    c:Disconnect() -- > Caso o retorno do localization seja uma tabela fake de conexão
                end
            end
        end

        if self._instance then
            self._instance:Destroy()
        end
        
        self._connections = nil
        self._instance = nil
        self._callback = nil
        setmetatable(self, nil)
        table.clear(self)
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateFloatButton(options)
    assert(typeof(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateFloatButton")

    local textRaw = options.Text or "Button"
    local titleRaw = options.Title or "Arraste aqui" -- > Texto do cabeçote
    local Drag = options.Drag ~= false -- > default true
    local Visible = options.Visible ~= false -- > default true
    local Pos = options.Pos or UDim2.new(0.5, 0, 0.5, 0)
    local Callback = typeof(options.Callback) == "function" and options.Callback or function() end

    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- > Verifica ou cria o ScreenGui para FloatButtons
    local screenGui = playerGui:FindFirstChild("TekscriptsFloatGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "TekscriptsFloatGui"
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 100 -- > Garante que fique acima de outros menus
        screenGui.Parent = playerGui
    end

    -- > Container do botão flutuante
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 120, 0, Drag and 60 or 40)
    container.Position = Pos
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundTransparency = 1
    container.Visible = Visible
    container.Parent = screenGui

    -- > Cabeçote para arrastar
    local header
    local headerLocaleConn = nil
    if Drag then
        header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, 0, 0, 20)
        header.Position = UDim2.new(0, 0, 0, 0)
        header.Font = Enum.Font.Gotham
        header.TextSize = 12
        header.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(255, 255, 255)
        header.BackgroundColor3 = DESIGN.InputBackgroundColor or Color3.fromRGB(40, 40, 40)
        header.Parent = container

        local cornerHeader = Instance.new("UICorner")
        cornerHeader.CornerRadius = UDim.new(0, (DESIGN.CornerRadius or 8) / 2)
        cornerHeader.Parent = header
        
        -- > Tradução dinâmica do cabeçote
        headerLocaleConn = Tekscripts.Localization:_ApplyDynamicLocalization(header, titleRaw)
    end

    -- > Botão principal
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = Drag and UDim2.new(0, 0, 0, 20) or UDim2.new(0, 0, 0, 0)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BackgroundColor3 = DESIGN.InputBackgroundColor or Color3.fromRGB(40, 40, 40)
    button.TextColor3 = DESIGN.InputTextColor or Color3.fromRGB(255, 255, 255)
    button.AutoButtonColor = false
    button.Parent = container

    local cornerButton = Instance.new("UICorner")
    cornerButton.CornerRadius = UDim.new(0, DESIGN.CornerRadius or 8)
    cornerButton.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = DESIGN.HRColor or Color3.fromRGB(100, 100, 100)
    stroke.Parent = button
    
    -- > Tradução dinâmica do botão principal
    local buttonLocaleConn = Tekscripts.Localization:_ApplyDynamicLocalization(button, textRaw)

    -- > Overlay para bloquear interações
    local overlay = Instance.new("Frame")
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.5
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.Visible = false
    overlay.ZIndex = 5
    overlay.Parent = button

    -- > Lógica de Drag Aprimorada
    local dragConnection = nil
    local dragStartOffset = Vector2.new(0, 0)
    
    local function clampPosition(position)
        local parentSize = screenGui.AbsoluteSize
        local containerSize = container.AbsoluteSize
        local containerAnchor = container.AnchorPoint
        
        local minX = containerAnchor.X * containerSize.X
        local minY = containerAnchor.Y * containerSize.Y
        local maxX = parentSize.X - ((1 - containerAnchor.X) * containerSize.X)
        local maxY = parentSize.Y - ((1 - containerAnchor.Y) * containerSize.Y)
        
        local clampedX = math.clamp(position.X, minX, maxX)
        local clampedY = math.clamp(position.Y, minY, maxY)

        return UDim2.new(clampedX / parentSize.X, 0, clampedY / parentSize.Y, 0)
    end
    
    local function getScreenVector2(input)
        return Vector2.new(input.Position.X, input.Position.Y)
    end
    
    local function onInputChanged(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local currentScreenPosition = getScreenVector2(input)
            local newAbsoluteCenter = currentScreenPosition - dragStartOffset
            container.Position = clampPosition(newAbsoluteCenter)
        end
    end

    if Drag and header then
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local currentScreenPosition = getScreenVector2(input)
                local absoluteCenter = container.AbsolutePosition + container.AbsoluteSize * container.AnchorPoint
                dragStartOffset = currentScreenPosition - absoluteCenter

                if dragConnection then dragConnection:Disconnect() end
                dragConnection = UserInputService.InputChanged:Connect(onInputChanged)
                
                local inputEndedConnection
                inputEndedConnection = UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                        if dragConnection then dragConnection:Disconnect() dragConnection = nil end
                        if inputEndedConnection then inputEndedConnection:Disconnect() end
                    end
                end)
            end
        end)
    end
    
    -- > Clique chama callback
    button.MouseButton1Click:Connect(function()
        if not overlay.Visible then
            pcall(Callback)
        end
    end)

    -- > API pública
    local api = {}

    function api:SetBlock(state)
        overlay.Visible = state
    end

    function api:SetText(newText)
        textRaw = newText or ""
        -- > Reinicia a tradução dinâmica com o novo texto/chave
        if buttonLocaleConn then buttonLocaleConn:Disconnect() end
        buttonLocaleConn = Tekscripts.Localization:_ApplyDynamicLocalization(button, textRaw)
    end

    function api:SetTitle(newTitle)
        if Drag and header then
            titleRaw = newTitle or ""
            if headerLocaleConn then headerLocaleConn:Disconnect() end
            headerLocaleConn = Tekscripts.Localization:_ApplyDynamicLocalization(header, titleRaw)
        end
    end

    function api:SetVisible(state)
        container.Visible = state
    end

    function api:Destroy()
        -- > Limpa conexões de tradução para evitar memory leaks
        if buttonLocaleConn then buttonLocaleConn:Disconnect() end
        if headerLocaleConn then headerLocaleConn:Disconnect() end
        if dragConnection then dragConnection:Disconnect() end
        
        container:Destroy()
    end

    -- > Registro de cores no tema
    if typeof(RegisterThemeItem) == "function" then
        RegisterThemeItem("InputBackgroundColor", button, "BackgroundColor3")
        RegisterThemeItem("InputTextColor", button, "TextColor3")
        RegisterThemeItem("HRColor", stroke, "Color")
        if header then
            RegisterThemeItem("InputBackgroundColor", header, "BackgroundColor3")
            RegisterThemeItem("ComponentTextColor", header, "TextColor3")
        end
    end

    return api
end

function Tekscripts:CreateTabContainer(parentTab: any, options: { Title: string?, TabBarHeight: number? })
    assert(type(parentTab) == "table" and parentTab.Container, "Invalid parent Tab object provided to CreateTabContainer")

    local DESIGN = DESIGN or {}
    local tabHeight = options.TabBarHeight or 40
    local minTabWidth = 100
    local contentPadding = 10
    local TweenService = game:GetService("TweenService")

    -- > Armazenamento das abas
    local tabs = {}
    local activeTab = nil

    -- > Container principal da TabView
    local container = Instance.new("Frame")
    RegisterThemeItem("ComponentBackground", container, "BackgroundColor3")
    container.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(30, 30, 30)
    container.BackgroundTransparency = 0
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BorderSizePixel = 0
    container.Parent = parentTab.Container

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = container

    local tabListContainer = Instance.new("ScrollingFrame")
    tabListContainer.BackgroundTransparency = 1
    tabListContainer.Size = UDim2.new(1, 0, 0, tabHeight)
    tabListContainer.Position = UDim2.new(0, 0, 0, 0)
    tabListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabListContainer.ScrollBarThickness = 6
    tabListContainer.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    tabListContainer.VerticalScrollBarInset = Enum.ScrollBarInset.None
    tabListContainer.Parent = container

    RegisterThemeItem("HRColor", tabListContainer, "ScrollBarImageColor3")

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Parent = tabListContainer

    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabListContainer.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X + 5, 0, 0)
    end)

    local contentContainer = Instance.new("Frame")
    contentContainer.BackgroundTransparency = 1
    contentContainer.Size = UDim2.new(1, 0, 1, -tabHeight)
    contentContainer.Position = UDim2.new(0, 0, 0, tabHeight)
    contentContainer.ClipsDescendants = true
    contentContainer.Parent = container

    local function switchToTab(tabName)
        local inactiveTextColor = DESIGN.ComponentTextColor or Color3.fromRGB(180, 180, 180)
        local activeTextColor = DESIGN.ComponentHoverColor or Color3.fromRGB(255, 255, 255)
        local activeBorderColor = DESIGN.HRColor or Color3.fromRGB(0, 120, 255)

        if activeTab and tabs[activeTab] then
            local prevTab = tabs[activeTab]
            prevTab.ContentFrame.Visible = false
            TweenService:Create(prevTab.Button, TweenInfo.new(0.15), { BackgroundTransparency = 1, TextColor3 = inactiveTextColor }):Play()

            if prevTab.Border then
                prevTab.Border.Enabled = false
            end
        end

        local newTab = tabs[tabName]
        if newTab then
            newTab.ContentFrame.Visible = true
            TweenService:Create(newTab.Button, TweenInfo.new(0.15), { BackgroundTransparency = 0.8, TextColor3 = activeTextColor }):Play()

            if newTab.Border then
                newTab.Border.Color = activeBorderColor
                newTab.Border.Enabled = true
            end

            activeTab = tabName
            newTab.Button.ZIndex = 3
        end
    end

    local function createTabButton(tabName)
        local button = Instance.new("TextButton")
        button.Name = tabName
        -- > O texto inicial é definido pela função de tradução dinâmica abaixo
        button.Font = Enum.Font.GothamBold
        button.TextSize = 16
        button.TextXAlignment = Enum.TextXAlignment.Center
        button.TextWrapped = true
        button.Size = UDim2.new(0, minTabWidth, 1, 0)

        -- > Estilo Normal (Não Selecionado)
        button.BackgroundTransparency = 1
        RegisterThemeItem("ComponentTextColor", button, "TextColor3")
        button.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(180, 180, 180)
        RegisterThemeItem("ComponentBackground", button, "BackgroundColor3")
        button.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(40, 40, 40)

        -- > Aplica Localização Dinâmica ao Botão (Usa tabName como chave)
        local locConn = Tekscripts.Localization:_ApplyDynamicLocalization(button, tabName)

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button

        local buttonBorder = Instance.new("UIStroke")
        buttonBorder.Thickness = 1
        buttonBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        RegisterThemeItem("HRColor", buttonBorder, "Color")
        buttonBorder.Enabled = false
        buttonBorder.Parent = button

        local textPadding = Instance.new("UIPadding")
        textPadding.PaddingLeft = UDim.new(0, 5)
        textPadding.PaddingRight = UDim.new(0, 5)
        textPadding.Parent = button

        local hoverColor = DESIGN.ComponentHoverColor or Color3.fromRGB(200, 200, 200)
        local inactiveTextColor = DESIGN.ComponentTextColor or Color3.fromRGB(180, 180, 180)

        button.MouseEnter:Connect(function()
            if tabName ~= activeTab then
                TweenService:Create(button, TweenInfo.new(0.1), { BackgroundTransparency = 0.9, TextColor3 = hoverColor }):Play()
            end
        end)

        button.MouseLeave:Connect(function()
            if tabName ~= activeTab then
                TweenService:Create(button, TweenInfo.new(0.1), { BackgroundTransparency = 1, TextColor3 = inactiveTextColor }):Play()
            end
        end)

        button.MouseButton1Click:Connect(function()
            switchToTab(tabName)
        end)

        button.Parent = tabListContainer

        return button, buttonBorder, locConn
    end
    
    local publicApi = {
        _instance = container,
        Tabs = {}
    }

    function publicApi:AddTab(tabName: string, icon: string?)
        if tabs[tabName] then
            warn("Tab '" .. tabName .. "' já existe.")
            return tabs[tabName].PublicAPI
        end

        local tabContentFrame = Instance.new("ScrollingFrame")
        tabContentFrame.BackgroundTransparency = 1
        tabContentFrame.Size = UDim2.new(1, 0, 1, 0)
        tabContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContentFrame.ScrollBarThickness = 6
        tabContentFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        tabContentFrame.Visible = false
        tabContentFrame.Parent = contentContainer

        RegisterThemeItem("HRColor", tabContentFrame, "ScrollBarImageColor3")

        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Padding = UDim.new(0, 5)
        tabContentLayout.Parent = tabContentFrame

        tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContentFrame.CanvasSize = UDim2.new(0, 0, 0, tabContentLayout.AbsoluteContentSize.Y + contentPadding)
        end)

        -- > Cria o botão da aba, a Borda e recebe a conexão de localização
        local tabButton, buttonBorder, locConn = createTabButton(tabName)

        local tabApi = {
            _instance = tabContentFrame,
            Components = {},
            _locConn = locConn -- > Persistência da conexão para limpeza
        }

        function tabApi:AddComponent(...)
            local components = { ... }
            for _, component in ipairs(components) do
                if component and component._instance then
                    component._instance.Parent = tabContentFrame
                    table.insert(tabApi.Components, component)
                else
                    warn("[TabContainer] Componente inválido na tab:", tabName)
                end
            end
            return tabApi
        end

        function tabApi:Destroy()
            if tabApi._locConn then tabApi._locConn:Disconnect() end
            for _, comp in ipairs(tabApi.Components) do
                if comp.Destroy then comp:Destroy() end
            end
            tabButton:Destroy()
            tabContentFrame:Destroy()
        end

        -- > Armazena
        tabs[tabName] = {
            Button = tabButton,
            Border = buttonBorder,
            ContentFrame = tabContentFrame,
            PublicAPI = tabApi
        }

        if not activeTab then
            switchToTab(tabName)
        end

        table.insert(publicApi.Tabs, tabApi)
        return tabApi
    end

    function publicApi:SwitchTo(tabName: string)
        if tabs[tabName] then
            switchToTab(tabName)
        else
            warn("Tab '" .. tabName .. "' não encontrada.")
        end
    end

    function publicApi:Destroy()
        for _, tabApi in ipairs(publicApi.Tabs) do
            tabApi:Destroy()
        end
        container:Destroy()
    end

    return publicApi
end

function Tekscripts:CreateLabel(tab, options)
    assert(type(tab) == "table" and tab.Container, "Objeto de Aba inválido")
    assert(type(options) == "table" and type(options.Title) == "string", "Opções inválidas")

    local HttpService = game:GetService("HttpService")
    local mode = options.imageGround or "min" -- > "min", "medium", or "max"
    
    -- > Configuração de tamanhos
    local IMAGE_SIZE = 40
    if mode == "medium" then IMAGE_SIZE = 55 end
    if mode == "max" then IMAGE_SIZE = 75 end

    local function loadExternalImage(url)
        local success, result = pcall(function()
            local filename = "img_" .. HttpService:GenerateGUID(false):gsub("-","") .. ".png"
            if not isfile(filename) then
                writefile(filename, game:HttpGet(url))
            end
            return (getsynasset or getcustomasset)(filename)
        end)
        return success and result or ""
    end

    -- > 1. ESTRUTURA PRINCIPAL
    local outerBox = Instance.new("Frame")
    outerBox.Name = "Label_" .. options.Title
    outerBox.BorderSizePixel = 0
    outerBox.Size = UDim2.new(1, 0, 0, 0)
    outerBox.AutomaticSize = Enum.AutomaticSize.Y
    outerBox.Parent = tab.Container

    RegisterThemeItem("ComponentBackground", outerBox, "BackgroundColor3")
    outerBox.BackgroundTransparency = DESIGN.ComponentBackgroundTransparency or 0.2

    local uicorner = Instance.new("UICorner", outerBox)
    uicorner.CornerRadius = UDim.new(0, DESIGN.CornerRadius or 9)

    local uiPadding = Instance.new("UIPadding", outerBox)
    local pV = DESIGN.ComponentPadding or 10
    uiPadding.PaddingTop = UDim.new(0, pV)
    uiPadding.PaddingBottom = UDim.new(0, pV)
    uiPadding.PaddingLeft = UDim.new(0, pV)
    uiPadding.PaddingRight = UDim.new(0, pV)

    -- > 2. CONTAINER DE CONTEÚDO
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
    contentFrame.Parent = outerBox

    local horizontalLayout = Instance.new("UIListLayout", contentFrame)
    horizontalLayout.FillDirection = Enum.FillDirection.Horizontal
    horizontalLayout.SortOrder = Enum.SortOrder.LayoutOrder
    horizontalLayout.Padding = UDim.new(0, 12)
    horizontalLayout.VerticalAlignment = (mode == "min" and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Center)

    -- > 3. CONTAINER DE TEXTO (Título e Descrição)
    local textContainer = Instance.new("Frame")
    textContainer.Name = "TextContainer"
    textContainer.AutomaticSize = Enum.AutomaticSize.Y
    textContainer.BackgroundTransparency = 1
    textContainer.Size = UDim2.new(1, -(IMAGE_SIZE + 12), 0, 0) 
    textContainer.LayoutOrder = 2
    textContainer.Parent = contentFrame

    local verticalLayout = Instance.new("UIListLayout", textContainer)
    verticalLayout.Padding = UDim.new(0, 2)
    verticalLayout.SortOrder = Enum.SortOrder.LayoutOrder
    verticalLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    -- > TÍTULO
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = (mode == "max" and 15 or 14)
    titleLabel.TextColor3 = options.Color or Color3.fromRGB(240, 240, 245)
    titleLabel.TextWrapped = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Size = UDim2.new(1, 0, 0, 0)
    titleLabel.AutomaticSize = Enum.AutomaticSize.Y
    titleLabel.LayoutOrder = 1 
    titleLabel.Parent = textContainer

    if not options.Color then
        RegisterThemeItem("ComponentTextColor", titleLabel, "TextColor3")
    end

    -- > API e Gerenciamento de Conexões
    local component = {
        _instance = outerBox,
        _titleConn = nil,
        _descConn = nil
    }
    local imageLabel = nil
    local descLabel = nil

    -- > Aplicação inicial da localização no Título
    component._titleConn = Tekscripts.Localization:_ApplyDynamicLocalization(titleLabel, options.Title)

    function component:SetText(val)
        -- > Se mudar o texto, precisamos renovar a conexão dinâmica
        if component._titleConn then component._titleConn:Disconnect() end
        component._titleConn = Tekscripts.Localization:_ApplyDynamicLocalization(titleLabel, tostring(val or ""))
    end

    function component:SetDescription(val)
        local text = tostring(val or "")
        
        -- > Limpa conexão anterior se existir
        if component._descConn then 
            component._descConn:Disconnect()
            component._descConn = nil
        end

        if text == "" then
            if descLabel then descLabel.Visible = false end
            return
        end

        if not descLabel then
            descLabel = Instance.new("TextLabel")
            descLabel.Name = "Description"
            descLabel.BackgroundTransparency = 1
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextSize = 13
            descLabel.TextWrapped = true
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.Size = UDim2.new(1, 0, 0, 0)
            descLabel.AutomaticSize = Enum.AutomaticSize.Y
            descLabel.LayoutOrder = 2 
            descLabel.Parent = textContainer
            descLabel.TextColor3 = Color3.fromRGB(170, 170, 175) 
        end
        
        descLabel.Visible = true
        -- > Aplica localização dinâmica na descrição
        component._descConn = Tekscripts.Localization:_ApplyDynamicLocalization(descLabel, text)
    end

    function component:SetImage(urlOrId)
        if not urlOrId or urlOrId == "" then
            if imageLabel then imageLabel.Visible = false end
            textContainer.Size = UDim2.new(1, 0, 0, 0)
            return
        end

        if not imageLabel then
            imageLabel = Instance.new("ImageLabel")
            imageLabel.Name = "Icon"
            imageLabel.Size = UDim2.new(0, IMAGE_SIZE, 0, IMAGE_SIZE) 
            imageLabel.BackgroundTransparency = 1
            imageLabel.ScaleType = Enum.ScaleType.Fit
            imageLabel.LayoutOrder = 1 
            imageLabel.Parent = contentFrame
            
            local imgCorner = Instance.new("UICorner", imageLabel)
            imgCorner.CornerRadius = UDim.new(0, (mode == "max" and 10 or 6))
        end

        imageLabel.Visible = true
        if tostring(urlOrId):match("^https?://") then
            imageLabel.Image = loadExternalImage(urlOrId)
        else
            imageLabel.Image = urlOrId
        end
        
        textContainer.Size = UDim2.new(1, -(IMAGE_SIZE + 12), 0, 0)
    end

    function component:SetVisible(state)
        outerBox.Visible = state
    end

    function component:Destroy()
        -- > Limpeza de cache e persistência de memória
        if component._titleConn then component._titleConn:Disconnect() end
        if component._descConn then component._descConn:Disconnect() end
        
        if outerBox then
            outerBox:Destroy()
        end
    end

    -- > Inicialização
    if options.Desc then component:SetDescription(options.Desc) end
    if options.Image then component:SetImage(options.Image) end

    table.insert(tab.Components, component)
    return component
end

function Tekscripts:CreateDivider(tab, options)
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateDividerBox")

    local textRaw = options and options.Text or "Título"
    local height = options and options.Height or 28
    local boxColor = options and options.Color or DESIGN.ComponentBackground
    local txtColor = options and options.TextColor or DESIGN.ComponentTextColor

    -- > CONTAINER COMPATÍVEL COM UIListLayout
    local container = Instance.new("Frame")
    container.Name = "DividerBox"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, height + 10)

    -- > BOX CENTRAL
    local box = Instance.new("Frame")
    box.Name = "Box"
    RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
    box.BackgroundColor3 = boxColor
    box.BorderSizePixel = 0
    box.Size = UDim2.new(1, -20, 0, height) -- > Margens laterais de 10px
    box.Position = UDim2.new(0, 10, 0, 5)
    box.ClipsDescendants = true -- > Impede que qualquer coisa vaze visualmente do box
    box.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius or 8)
    corner.Parent = box

    -- > PADDING INTERNO (Evita o texto colado nas bordas)
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = box

    -- > TEXTO CENTRAL
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextScaled = true -- > Faz o texto diminuir se for muito grande
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    RegisterThemeItem("ComponentTextColor", label, "TextColor3")
    label.TextColor3 = txtColor
    label.Size = UDim2.new(1, 0, 1, 0)
    label.ZIndex = 2 -- > Garante que fique acima de qualquer fundo ou linha
    label.Parent = box

    -- > Aplicação de Localização Dinâmica (Persistência de idioma)
    -- > O componente passa a escutar mudanças no Localization._Changed automaticamente
    local locConnection = Tekscripts.Localization:_ApplyDynamicLocalization(label, textRaw)

    -- > LIMITADOR DE TAMANHO DE TEXTO
    local sizeConstraint = Instance.new("UITextSizeConstraint")
    sizeConstraint.MaxTextSize = 15
    sizeConstraint.MinTextSize = 8
    sizeConstraint.Parent = label

    -- > API PÚBLICA
    local api = {
        _instance = container,
        _box = box,
        _label = label,
        _locConn = locConnection -- > Cache da conexão para limpeza
    }

    -- > Função para alterar o texto manualmente mantendo suporte a tradução
    function api:SetText(newText)
        if self._locConn then self._locConn:Disconnect() end
        self._locConn = Tekscripts.Localization:_ApplyDynamicLocalization(label, newText)
    end

    function api:SetColor(newColor)
        box.BackgroundColor3 = newColor
    end

    function api:SetTextColor(newColor)
        label.TextColor3 = newColor
    end

    -- > Limpeza de recursos e bugs de memória
    function api:Destroy()
        if self._locConn then
            self._locConn:Disconnect()
            self._locConn = nil
        end
        if container then
            container:Destroy()
            container = nil
        end
    end

    -- > REGISTRAR COMPONENTE NA TAB
    table.insert(tab.Components, api)
    container.Parent = tab.Container

    return api
end

function Tekscripts:CreateToggle(tab: any, options: { Text: string, Desc: string?, Callback: (state: boolean) -> (), Type: "Toggle" | "CheckBox" | nil, FeedbackDebug: boolean? })
    -- > Validação robusta de entrada
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object")
    assert(type(options.Text) == "string", "Toggle text is required")
    
    local TweenService = game:GetService("TweenService")
    local componentType = options.Type and string.lower(options.Type) == "checkbox" and "CheckBox" or "Toggle"
    
    -- > Se FeedbackDebug não for definido, o padrão é true (mostrar o erro)
    local useFeedback = (options.FeedbackDebug == nil) and true or options.FeedbackDebug

    -- >  1. ESTRUTURA PRINCIPAL 
    local outerBox = Instance.new("Frame")
    outerBox.Name = "Toggle_" .. options.Text
    outerBox.Size = UDim2.new(1, 0, 0, 0)
    outerBox.AutomaticSize = Enum.AutomaticSize.Y 
    outerBox.BackgroundColor3 = DESIGN.ComponentBackground
    outerBox.BackgroundTransparency = DESIGN.TabContainerTransparency
    outerBox.BorderSizePixel = 0
    outerBox.Parent = tab.Container
    addRoundedCorners(outerBox, DESIGN.CornerRadius)
    RegisterThemeItem("ComponentBackground", outerBox, "BackgroundColor3")

    -- > Borda de Erro (UIStroke)
    local borderStroke = Instance.new("UIStroke")
    borderStroke.Thickness = 1.6
    borderStroke.Color = Color3.fromRGB(255, 60, 60)
    borderStroke.Transparency = 1 
    borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    borderStroke.Parent = outerBox

    -- > Indicador de Erro (Bolinha superior esquerda)
    local errorDot = Instance.new("Frame")
    errorDot.Name = "ErrorIndicator"
    errorDot.Size = UDim2.new(0, 6, 0, 6)
    errorDot.Position = UDim2.new(0, 4, 0, 4)
    errorDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    errorDot.BackgroundTransparency = 1 
    errorDot.BorderSizePixel = 0
    errorDot.Parent = outerBox
    addRoundedCorners(errorDot, 100)

    local mainPadding = Instance.new("UIPadding")
    mainPadding.PaddingTop = UDim.new(0, 8)
    mainPadding.PaddingBottom = UDim.new(0, 8)
    mainPadding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
    mainPadding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)
    mainPadding.Parent = outerBox

    -- >  2. TEXTOS 
    local textContainer = Instance.new("Frame")
    textContainer.Size = UDim2.new(1, -60, 0, 0) 
    textContainer.AutomaticSize = Enum.AutomaticSize.Y
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = outerBox
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = textContainer

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.TextColor3 = DESIGN.ComponentTextColor
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 1
    label.Parent = textContainer
    RegisterThemeItem("ComponentTextColor", label, "TextColor3")

    -- > Localização dinâmica do Título
    local titleConn = Tekscripts.Localization:_ApplyDynamicLocalization(label, options.Text)

    local descLabel
    local descConn
    if options.Desc and options.Desc ~= "" then
        descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, 0, 0, 0)
        descLabel.AutomaticSize = Enum.AutomaticSize.Y
        descLabel.BackgroundTransparency = 1
        descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        descLabel.Font = Enum.Font.SourceSans
        descLabel.TextSize = 14
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.LayoutOrder = 2
        descLabel.Parent = textContainer

        -- > Localização dinâmica da Descrição
        descConn = Tekscripts.Localization:_ApplyDynamicLocalization(descLabel, options.Desc)
    end

    -- >  3. CONTROLE VISUAL 
    local controlSize = componentType == "CheckBox" and Vector2.new(22, 22) or Vector2.new(38, 18)
    local control = Instance.new("TextButton")
    control.Size = UDim2.new(0, controlSize.X, 0, controlSize.Y)
    control.Position = UDim2.new(1, 0, 0.5, 0)
    control.AnchorPoint = Vector2.new(1, 0.5)
    control.BackgroundColor3 = DESIGN.InactiveToggleColor
    control.Text = ""
    control.AutoButtonColor = false
    control.Parent = outerBox
    addRoundedCorners(control, componentType == "CheckBox" and 4 or 100)
    RegisterThemeItem("InactiveToggleColor", control, "BackgroundColor3")

    local knob
    if componentType == "Toggle" then
        knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = UDim2.new(0, 2, 0.5, -7)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = control
        addRoundedCorners(knob, 100)
    else
        knob = Instance.new("TextLabel")
        knob.Text = "✔"
        knob.Size = UDim2.new(1, 0, 1, 0)
        knob.BackgroundTransparency = 1
        knob.TextColor3 = Color3.fromRGB(255, 255, 255)
        knob.TextSize = 14
        knob.Visible = false
        knob.Parent = control
    end

    -- >  4. LÓGICA E SEGURANÇA 
    local state = false
    local isLocked = false
    local isBlockedByError = false
    local connections = {}

    local function animateControl(newState)
        local targetColor = newState and DESIGN.ActiveToggleColor or DESIGN.InactiveToggleColor
        local tInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        TweenService:Create(control, tInfo, {
            BackgroundColor3 = targetColor
        }):Play()

        if componentType == "Toggle" and knob then
            local targetPos = newState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            TweenService:Create(knob, tInfo, {
                Position = targetPos
            }):Play()
        elseif componentType == "CheckBox" and knob then
            knob.Visible = newState
        end
    end

    local function pulseError()
        if not useFeedback then return end 
        isBlockedByError = true
        borderStroke.Transparency = 0
        errorDot.BackgroundTransparency = 0
        
        local originalPos = outerBox.Position
        task.spawn(function()
            for i = 1, 6 do
                outerBox.Position = originalPos + UDim2.new(0, (i % 2 == 0 and 2 or -2), 0, 0)
                task.wait(0.05)
            end
            outerBox.Position = originalPos
        end)

        task.delay(0.7, function()
            isBlockedByError = false
            local fadeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)
            TweenService:Create(borderStroke, fadeInfo, { Transparency = 1 }):Play()
            TweenService:Create(errorDot, fadeInfo, { BackgroundTransparency = 1 }):Play()
        end)
    end

    local function toggle(newState, skipCallback)
        if isLocked or isBlockedByError then return end
        state = newState
        animateControl(state)
        
        if not skipCallback and options.Callback then
            local success, result = pcall(function()
                options.Callback(state)
            end)
            
            if not success then
                pulseError()
                state = not newState
                task.delay(0.1, function() animateControl(state) end)
            end
        end
    end

    connections.Click = control.MouseButton1Click:Connect(function()
        toggle(not state)
    end)

    -- >  5. API PÚBLICA 
    local publicApi = {
        _instance = outerBox,
        _connections = connections,
        _titleConn = titleConn,
        _descConn = descConn
    }

    function publicApi:SetState(s)
        state = s
        animateControl(s)
    end

    function publicApi:GetState() return state end
    function publicApi:SetLocked(l) isLocked = l end
    function publicApi:PulseError() pulseError() end
    function publicApi:SetBlocked(b) isBlockedByError = b end

    function publicApi:Destroy()
        -- > Limpeza de conexões de localização
        if self._titleConn then self._titleConn:Disconnect() end
        if self._descConn then self._descConn:Disconnect() end
        
        for _, c in pairs(connections) do c:Disconnect() end
        outerBox:Destroy()
        if tab.Components then
            for i, comp in ipairs(tab.Components) do
                if comp == publicApi then table.remove(tab.Components, i) break end
            end
        end
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:Notify(options)
    -- >  1. PARÂMETROS E CONFIGURAÇÕES 
    local TitleRaw = options.Title or options.Text or "Notificação"
    local DescRaw = options.Desc or "Sem descrição."
    local Duration = options.Duration or 5 
    local IconID = options.Icon
    local PosMode = options.Position or "Below" 
    
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Camera = workspace.CurrentCamera
    
    local isSmallScreen = Camera.ViewportSize.X < 600
    local maxWidth = isSmallScreen and 230 or 270
    local textSizeTitle = isSmallScreen and 13 or 14
    local textSizeDesc = isSmallScreen and 11 or 12

    -- >  2. HOLDER DINÂMICO 
    local NotificationsHolder = (function()
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local container = PlayerGui:FindFirstChild("TekScriptsNotifications_" .. PosMode)
        
        if not container then
            container = Instance.new("ScreenGui", PlayerGui)
            container.Name = "TekScriptsNotifications_" .. PosMode
            container.IgnoreGuiInset = true
            container.DisplayOrder = 2147483647 
            
            local holder = Instance.new("Frame", container)
            holder.Name = "Holder"
            holder.BackgroundTransparency = 1
            
            if PosMode == "Above" then
                holder.AnchorPoint = Vector2.new(1, 0)
                holder.Position = UDim2.new(1, -15, 0, 50) 
            else
                holder.AnchorPoint = Vector2.new(1, 1)
                holder.Position = UDim2.new(1, -15, 1, -15) 
            end
            
            holder.Size = UDim2.new(0, maxWidth, 0.8, 0)
            
            local layout = Instance.new("UIListLayout", holder)
            layout.VerticalAlignment = (PosMode == "Above") and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Bottom
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            layout.Padding = UDim.new(0, 8)
            layout.SortOrder = Enum.SortOrder.Name 
        end
        return container.Holder
    end)()

    -- >  3. CONSTRUÇÃO DO CARD 
    local box = Instance.new("CanvasGroup")
    box.Name = tostring(tick())
    box.Size = UDim2.new(1, 0, 0, 0)
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.Position = UDim2.new(1.2, 0, 0, 0) 
    box.GroupTransparency = 1 
    box.Parent = NotificationsHolder
    
    RegisterThemeItem("NotifyBackground", box, "BackgroundColor3")
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", box)
    stroke.Transparency = 0.85
    RegisterThemeItem("AccentColor", stroke, "Color")

    local contentFrame = Instance.new("Frame", box)
    contentFrame.Size = UDim2.new(1, 0, 0, 0)
    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
    contentFrame.BackgroundTransparency = 1
    
    local padding = Instance.new("UIPadding", contentFrame)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)

    -- > Título com Tradução
    local titleLabel = Instance.new("TextLabel", contentFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 18)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = textSizeTitle
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    RegisterThemeItem("TitleColor", titleLabel, "TextColor3")
    -- > Aplica localização dinâmica (embora a notificação dure pouco, garante consistência no spawn)
    local tConn = Tekscripts.Localization:_ApplyDynamicLocalization(titleLabel, TitleRaw)

    -- > Descrição com Tradução
    local descLabel = Instance.new("TextLabel", contentFrame)
    descLabel.Position = UDim2.new(0, 0, 0, 20)
    descLabel.Size = UDim2.new(1, 0, 0, 0)
    descLabel.AutomaticSize = Enum.AutomaticSize.Y
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = textSizeDesc
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.BackgroundTransparency = 1
    RegisterThemeItem("NotifyTextColor", descLabel, "TextColor3")
    -- > Aplica localização dinâmica
    local dConn = Tekscripts.Localization:_ApplyDynamicLocalization(descLabel, DescRaw)

    -- > Barra de Progresso
    local barBG = Instance.new("Frame", box)
    barBG.Size = UDim2.new(1, 0, 0, 2)
    barBG.Position = UDim2.new(0, 0, 1, -2)
    barBG.BackgroundTransparency = 0.9
    
    local progressBar = Instance.new("Frame", barBG)
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    RegisterThemeItem("AccentColor", progressBar, "BackgroundColor3")

    -- >  4. ANIMAÇÕES E LIMPEZA 
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    TweenService:Create(box, tweenInfo, { Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0 }):Play()
    TweenService:Create(progressBar, TweenInfo.new(Duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) }):Play()

    task.delay(Duration, function()
        if box and box.Parent then
            -- > Desconecta antes de destruir para evitar chamadas fantasmas
            if tConn then tConn:Disconnect() end
            if dConn then dConn:Disconnect() end

            local fadeOut = TweenService:Create(box, tweenInfo, { 
                Position = UDim2.new(1.2, 0, 0, 0),
                GroupTransparency = 1 
            })
            fadeOut:Play()
            fadeOut.Completed:Connect(function() box:Destroy() end)
        end
    end)
end

function Tekscripts:CreateSlider(tab: any, options: {
    Text: string?,
    Min: number?,
    Max: number?,
    Step: number?,
    Value: number?,
    Callback: ((number) -> ())?
})
    assert(tab and tab.Container, "Invalid Tab object provided to CreateSlider")

    -- > Inicialização de opções
    options = options or {}
    local titleRaw = options.Text or "Slider" -- > Mantido o texto original para tradução
    local minv = tonumber(options.Min) or 0
    local maxv = tonumber(options.Max) or 100
    local step = tonumber(options.Step) or 1
    local value = tonumber(options.Value) or minv
    local callback = options.Callback

    local function clamp(n)
        return math.max(minv, math.min(maxv, n))
    end

    local function roundToStep(n)
        if step <= 0 then return n end
        return math.floor(n / step + 0.5) * step
    end

    value = clamp(roundToStep(value))

    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    
    local ANIM = {
        ThumbHover = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        ThumbPress = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        ValueChange = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        FillChange = TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
    }

    -- > Base visual principal
    local box = Instance.new("Frame")
    box.Name = "Slider_Component"
    box.Size = UDim2.new(1, 0, 0, 0)
    box.AutomaticSize = Enum.AutomaticSize.Y 
    RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
    box.BackgroundColor3 = DESIGN.ComponentBackground
    box.BackgroundTransparency = DESIGN.TabContainerTransparency
    box.BorderSizePixel = 0
    box.Parent = tab.Container

    Instance.new("UICorner", box).CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.92
    shadow.ZIndex = 0
    shadow.Parent = box
    
    local padding = Instance.new("UIPadding", box)
    padding.PaddingTop = UDim.new(0, DESIGN.ComponentPadding) 
    padding.PaddingBottom = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = box

    local listLayout = Instance.new("UIListLayout", container)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8) 

    -- > Header (Título com tradução dinâmica)
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.Size = UDim2.new(1, 0, 0, 0)
    headerFrame.AutomaticSize = Enum.AutomaticSize.Y 
    headerFrame.BackgroundTransparency = 1
    headerFrame.LayoutOrder = 1
    headerFrame.Parent = container

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, 0, 0, 0)
    titleLabel.AutomaticSize = Enum.AutomaticSize.Y 
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextSize = 14
    titleLabel.TextWrapped = true 
    titleLabel.TextTruncate = Enum.TextTruncate.None 
    RegisterThemeItem("ComponentTextColor", titleLabel, "TextColor3")
    titleLabel.TextColor3 = DESIGN.ComponentTextColor
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Top
    titleLabel.Parent = headerFrame

    -- > Inicia Tradução Dinâmica do Título
    local localeConn = Tekscripts.Localization:_ApplyDynamicLocalization(titleLabel, titleRaw)

    -- > Track Container (Slider e Badge de Valor)
    local trackContainer = Instance.new("Frame")
    trackContainer.Name = "TrackContainer"
    trackContainer.Size = UDim2.new(1, 0, 0, 24)
    trackContainer.BackgroundTransparency = 1
    trackContainer.LayoutOrder = 2
    trackContainer.Parent = container
    
    local listLayoutTrack = Instance.new("UIListLayout", trackContainer)
    listLayoutTrack.FillDirection = Enum.FillDirection.Horizontal
    listLayoutTrack.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayoutTrack.Padding = UDim.new(0, 10)
    listLayoutTrack.SortOrder = Enum.SortOrder.LayoutOrder

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Size = UDim2.new(1, -75, 1, 0)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = trackContainer
    sliderFrame.LayoutOrder = 1

    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 6)
    track.AnchorPoint = Vector2.new(0, 0.5)
    track.Position = UDim2.new(0, 0, 0.5, 0)
    RegisterThemeItem("SliderTrackColor", track, "BackgroundColor3")
    track.BackgroundColor3 = DESIGN.SliderTrackColor or Color3.fromRGB(40, 40, 45)
    track.BorderSizePixel = 0
    track.Parent = sliderFrame
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = DESIGN.SliderFillColor or Color3.fromRGB(88, 101, 242)
    fill.BorderSizePixel = 0
    fill.ZIndex = 2
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 18, 0, 18)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.BackgroundColor3 = Color3.new(1, 1, 1)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 3
    thumb.Parent = sliderFrame
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    local thumbRing = Instance.new("Frame")
    thumbRing.Name = "Ring"
    thumbRing.Size = UDim2.new(0.5, 0, 0.5, 0)
    thumbRing.AnchorPoint = Vector2.new(0.5, 0.5)
    thumbRing.Position = UDim2.new(0.5, 0, 0.5, 0)
    thumbRing.BackgroundColor3 = DESIGN.SliderFillColor or Color3.fromRGB(88, 101, 242)
    thumbRing.BorderSizePixel = 0
    thumbRing.ZIndex = 4
    thumbRing.Parent = thumb
    Instance.new("UICorner", thumbRing).CornerRadius = UDim.new(1, 0)

    local valueBadge = Instance.new("Frame")
    valueBadge.Name = "ValueBadge"
    valueBadge.Size = UDim2.new(0, 65, 0, 22)
    valueBadge.BackgroundColor3 = DESIGN.SliderFillColor or Color3.fromRGB(88, 101, 242)
    valueBadge.BorderSizePixel = 0
    valueBadge.Parent = trackContainer
    valueBadge.LayoutOrder = 2
    Instance.new("UICorner", valueBadge).CornerRadius = UDim.new(0, 6)

    local function isBright(color)
        local r, g, b = color.R * 255, color.G * 255, color.B * 255
        return (r * 0.299 + g * 0.587 + b * 0.114) > 160
    end

    local valueLabel = Instance.new("TextBox")
    valueLabel.Name = "ValueInput"
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextColor3 = isBright(valueBadge.BackgroundColor3) and Color3.new(0.1,0.1,0.1) or Color3.new(1,1,1)
    valueLabel.Text = tostring(value)
    valueLabel.ClearTextOnFocus = false
    valueLabel.Parent = valueBadge

    -- > Lógica e API
    local connections = {}
    local dragging = false
    local hovering = false

    local publicApi = {
        _instance = box,
        _connections = connections,
        _localeConn = localeConn, -- > Armazenado para persistência e limpeza
        _onChanged = {},
        _locked = false,
    }
    
    function publicApi:_reapplyFillColors()
        local color = DESIGN.SliderFillColor
        valueBadge.BackgroundColor3 = color
        fill.BackgroundColor3 = color
        thumbRing.BackgroundColor3 = color
        valueLabel.TextColor3 = isBright(color) and Color3.new(0.1,0.1,0.1) or Color3.new(1,1,1)
        publicApi.SetLocked(publicApi._locked)
    end
    
    RegisterThemeItem("SliderFillColor", publicApi, "_reapplyFillColors")

    local function updateVisuals(animate)
        local frac = math.clamp((value - minv) / math.max(1, (maxv - minv)), 0, 1)
        
        if animate then
            TweenService:Create(fill, ANIM.FillChange, {Size = UDim2.new(frac, 0, 1, 0)}):Play()
            TweenService:Create(thumb, ANIM.FillChange, {Position = UDim2.new(frac, 0, 0.5, 0)}):Play()
        else
            fill.Size = UDim2.new(frac, 0, 1, 0)
            thumb.Position = UDim2.new(frac, 0, 0.5, 0)
        end
        
        valueLabel.Text = tostring(math.floor(value * 100) / 100)
    end

    local function handleDrag(inputPos)
        local absPos = track.AbsolutePosition
        local absSize = track.AbsoluteSize
        local relX = math.clamp(inputPos.X - absPos.X, 0, absSize.X)
        local newVal = clamp(roundToStep(minv + (relX / absSize.X) * (maxv - minv)))
        
        if newVal ~= value then
            value = newVal
            updateVisuals(false)
            if callback then task.spawn(callback, value) end
            for _, fn in ipairs(publicApi._onChanged) do task.spawn(fn, value) end
        end
    end
    
    table.insert(connections, track.InputBegan:Connect(function(input)
        if publicApi._locked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            TweenService:Create(thumb, ANIM.ThumbPress, {Size = UDim2.new(0, 22, 0, 22)}):Play()
            handleDrag(input.Position)
        end
    end))

    table.insert(connections, UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            handleDrag(input.Position)
        end
    end))

    table.insert(connections, UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            TweenService:Create(thumb, ANIM.ThumbHover, {Size = hovering and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 18, 0, 18)}):Play()
        end
    end))

    table.insert(connections, thumb.MouseEnter:Connect(function()
        hovering = true
        if not dragging and not publicApi._locked then
            TweenService:Create(thumb, ANIM.ThumbHover, {Size = UDim2.new(0, 20, 0, 20)}):Play()
        end
    end))

    table.insert(connections, thumb.MouseLeave:Connect(function()
        hovering = false
        if not dragging then
            TweenService:Create(thumb, ANIM.ThumbHover, {Size = UDim2.new(0, 18, 0, 18)}):Play()
        end
    end))

    table.insert(connections, valueLabel.FocusLost:Connect(function()
        local newVal = tonumber(valueLabel.Text:match("-?%d+%.?%d*"))
        if newVal then
            value = clamp(roundToStep(newVal))
            updateVisuals(true)
            if callback then task.spawn(callback, value) end
        else
            updateVisuals(false)
        end
    end))

    function publicApi.Set(v)
        value = clamp(roundToStep(tonumber(v) or value))
        updateVisuals(true)
    end

    function publicApi.Get() return value end

    function publicApi.SetLocked(state)
        publicApi._locked = state
        valueLabel.TextEditable = not state
        local transparency = state and 0.5 or 0
        TweenService:Create(container, ANIM.ThumbHover, {GroupTransparency = transparency}):Play()
    end

    function publicApi.Destroy()
        -- > Limpeza de conexões e cache
        if publicApi._localeConn then publicApi._localeConn:Disconnect() end
        for _, c in ipairs(connections) do c:Disconnect() end
        if box then box:Destroy() end
    end

    updateVisuals(false)
    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateSection(tab: any, options: { Title: string?, Open: boolean?, Fixed: boolean?, EmptyMessage: string?, EmptyImage: string? })
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateSection")

    local DESIGN = DESIGN or {}
    local titleHeight = 45 
    local minClosedHeight = titleHeight 
    local contentPadding = 10 

    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")

    -- > Configurações de estado e persistência de dados do "Empty State"
    local open = options.Open ~= false
    local fixed = options.Fixed == true
    local dragThreshold = 5
    local emptyText = options.EmptyMessage or "Parece que não tem nada aqui"
    local emptyImageId = options.EmptyImage or "rbxassetid://10309244524" -- > ID de exemplo (ícone de busca/vazio)

    -- [Trecho de criação do sectionContainer, titleFrame e labels omitido para brevidade, permanece igual ao seu]
    -- ... (Código original do sectionContainer até o contentContainer)

    -- > Container do estado vazio (Placeholder)
    local emptyStateFrame = Instance.new("Frame")
    emptyStateFrame.Name = "EmptyState"
    emptyStateFrame.Size = UDim2.new(1, 0, 0, 100)
    emptyStateFrame.BackgroundTransparency = 1
    emptyStateFrame.Visible = false
    emptyStateFrame.Parent = contentContainer

    local emptyLayout = Instance.new("UIListLayout")
    emptyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    emptyLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    emptyLayout.Padding = UDim.new(0, 8)
    emptyLayout.Parent = emptyStateFrame

    local emptyIcon = Instance.new("ImageLabel")
    emptyIcon.Size = UDim2.new(0, 40, 0, 40)
    emptyIcon.BackgroundTransparency = 1
    emptyIcon.Image = emptyImageId
    emptyIcon.ImageTransparency = 0.5
    RegisterThemeItem("ComponentTextColor", emptyIcon, "ImageColor3")
    emptyIcon.Parent = emptyStateFrame

    local emptyLabel = Instance.new("TextLabel")
    emptyLabel.Size = UDim2.new(1, 0, 0, 20)
    emptyLabel.BackgroundTransparency = 1
    emptyLabel.Font = Enum.Font.Gotham
    emptyLabel.TextSize = 14
    emptyLabel.ImageTransparency = 0.6
    RegisterThemeItem("ComponentTextColor", emptyLabel, "TextColor3")
    emptyLabel.Parent = emptyStateFrame
    
    -- > Conexão de localização para a mensagem de vazio
    local emptyLocaleConn = Tekscripts.Localization:_ApplyDynamicLocalization(emptyLabel, emptyText)

    -- > Lógica de verificação de conteúdo (Cache/Persistence Check)
    local function checkEmptyState()
        -- > Ignora o próprio emptyStateFrame e o UIListLayout
        local componentCount = 0
        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("GuiObject") and child ~= emptyStateFrame then
                componentCount += 1
            end
        end

        local isActuallyEmpty = (componentCount == 0)
        local shouldShow = isActuallyEmpty and (open or fixed)
        
        emptyStateFrame.Visible = shouldShow
        
        -- > Se estiver vazio, forçamos uma altura mínima para o placeholder aparecer bem
        if shouldShow then
            emptyStateFrame.LayoutOrder = 999 -- > Sempre no fim
        end
    end

    -- > Atualização de Altura Dinâmica (Modificada para considerar o Empty State)
    local function updateHeight()
        checkEmptyState() -- > Verifica antes de calcular altura
        
        local contentHeight = layout.AbsoluteContentSize.Y
        local isActuallyOpen = fixed or open 
        
        -- > Garante consistência: se aberto e vazio, define altura mínima para o aviso
        if isActuallyOpen and emptyStateFrame.Visible then
            contentHeight = math.max(contentHeight, 110)
        end

        local targetHeight = isActuallyOpen and (titleHeight + contentHeight + contentPadding) or minClosedHeight
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        TweenService:Create(sectionContainer, tweenInfo, { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
        
        -- ... (Restante da lógica de rotação da seta e overlay)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateHeight)
    contentContainer.ChildAdded:Connect(updateHeight)
    contentContainer.ChildRemoved:Connect(updateHeight)

    -- > API Pública do Componente
    local publicApi = {
        _instance = sectionContainer,
        _content = contentContainer,
        Components = {},
        _emptyLocaleConn = emptyLocaleConn
    }

    -- > API para Editar o Empty State dinamicamente
    function publicApi:SetEmptyMessage(text)
        -- > Intenção: Atualizar a mensagem de "nada encontrado" com suporte a tradução
        if self._emptyLocaleConn then self._emptyLocaleConn:Disconnect() end
        self._emptyLocaleConn = Tekscripts.Localization:_ApplyDynamicLocalization(emptyLabel, text or "")
        updateHeight()
    end

    function publicApi:SetEmptyImage(imageId)
        -- > Intenção: Mudar o ícone do estado vazio
        emptyIcon.Image = imageId or ""
    end

    function publicApi:AddComponent(...)
        local components = { ... }
        for _, component in ipairs(components) do
            if component and component._instance then
                component._instance.Parent = contentContainer
                table.insert(publicApi.Components, component)
            end
        end
        -- > updateHeight será chamado automaticamente pelo ChildAdded
        return publicApi 
    end

    -- [Outros métodos da API: Open, Close, Toggle, Block, Destroy permanecem iguais]

    function publicApi:Destroy()
        if self._titleLocaleConn then self._titleLocaleConn:Disconnect() end
        if self._blockLocaleConn then self._blockLocaleConn:Disconnect() end
        if self._emptyLocaleConn then self._emptyLocaleConn:Disconnect() end -- > Limpeza extra
        
        for _, comp in ipairs(publicApi.Components) do
            if comp.Destroy then comp:Destroy() end
        end
        sectionContainer:Destroy()
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end

return Tekscripts
