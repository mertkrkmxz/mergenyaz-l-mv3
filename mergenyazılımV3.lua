--[[
    MERGEN YAZILIM V3
    Hazırlayan: mertkorkmaz
    Özellikler: Intro, Fly, ESP, TP, Noclip, Invisible, Tema, Credits
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- UI Oluşturma (Koruma Fonksiyonu)
local function protect_gui(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = CoreGui
    end
end

-- ScreenGui
local MergenGui = Instance.new("ScreenGui")
MergenGui.Name = "MergenYazilimV3"
MergenGui.ResetOnSpawn = false
protect_gui(MergenGui)

-------------------------------------------------------------------------
-- 1. INTRO KISMI
-------------------------------------------------------------------------

local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
IntroFrame.ZIndex = 100
IntroFrame.Parent = MergenGui

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(1, 0, 1, 0)
IntroText.BackgroundTransparency = 1
IntroText.Text = "mergenYazılımV3"
IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroText.TextSize = 50
IntroText.Font = Enum.Font.GothamBold
IntroText.TextTransparency = 1
IntroText.Parent = IntroFrame

local CopyrightText = Instance.new("TextLabel")
CopyrightText.Size = UDim2.new(0, 300, 0, 30)
CopyrightText.Position = UDim2.new(0, 10, 1, -40)
CopyrightText.BackgroundTransparency = 1
CopyrightText.Text = "mergenYazılımV3 Telif hakkı saklıdır"
CopyrightText.TextColor3 = Color3.fromRGB(150, 150, 150)
CopyrightText.TextSize = 14
CopyrightText.Font = Enum.Font.Gotham
CopyrightText.TextXAlignment = Enum.TextXAlignment.Left
CopyrightText.TextTransparency = 1
CopyrightText.Parent = IntroFrame

-- Intro Animasyonu
task.spawn(function()
    wait(1)
    -- Yazı Gelir
    TweenService:Create(IntroText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
    TweenService:Create(CopyrightText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
    wait(3)
    -- Yazı Gider
    TweenService:Create(IntroText, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TweenService:Create(CopyrightText, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TweenService:Create(IntroFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    wait(1)
    IntroFrame:Destroy() -- Intro bitti, yok et
    
    -- Paneli Aç
    local MainPanel = MergenGui:FindFirstChild("MainPanel")
    if MainPanel then
        MainPanel.Visible = true
        TweenService:Create(MainPanel, TweenInfo.new(0.5), {Size = UDim2.new(0, 550, 0, 350)}):Play()
    end
end)

-------------------------------------------------------------------------
-- 2. ANA PANEL & UI TASARIMI
-------------------------------------------------------------------------

-- Renk Paletleri
local Themes = {
    Dark = {Bg = Color3.fromRGB(30, 30, 30), Sidebar = Color3.fromRGB(20, 20, 20), Text = Color3.fromRGB(255, 255, 255), Btn = Color3.fromRGB(45, 45, 45)},
    Light = {Bg = Color3.fromRGB(240, 240, 240), Sidebar = Color3.fromRGB(200, 200, 200), Text = Color3.fromRGB(0, 0, 0), Btn = Color3.fromRGB(220, 220, 220)}
}
local CurrentTheme = Themes.Dark

local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 0, 0, 0) -- Başlangıçta kapalı (Intro için)
MainPanel.Position = UDim2.new(0.5, -275, 0.5, -175)
MainPanel.BackgroundColor3 = CurrentTheme.Bg
MainPanel.ClipsDescendants = true
MainPanel.Visible = false
MainPanel.Parent = MergenGui

-- Yuvarlatılmış Köşeler
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainPanel

-- Sürükleme (Drag) Özelliği
local dragging, dragInput, dragStart, startPos
MainPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainPanel.Position
    end
end)
MainPanel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Başlık Çubuğu
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, -40, 0, 40)
TitleBar.Position = UDim2.new(0, 15, 0, 0)
TitleBar.BackgroundTransparency = 1
TitleBar.Text = "Mergen Yazılım"
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 18
TitleBar.TextColor3 = CurrentTheme.Text
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Parent = MainPanel

-- Kapatma Tuşu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainPanel
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    MergenGui:Destroy()
end)

-- Yan Menü (Sekmeler)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -50)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundColor3 = CurrentTheme.Sidebar
Sidebar.Parent = MainPanel
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

-- İçerik Alanı
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -145, 1, -50)
ContentContainer.Position = UDim2.new(0, 135, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainPanel

local Tabs = {} -- Sekmeleri tutacak tablo
local Pages = {} -- Sayfaları tutacak tablo

-- Sekme Oluşturma Fonksiyonu
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -10, 0, 35)
    TabBtn.BackgroundColor3 = CurrentTheme.Btn
    TabBtn.Text = name
    TabBtn.TextColor3 = CurrentTheme.Text
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 14
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
    
    -- Listeleme düzeni
    if not Sidebar:FindFirstChild("UIListLayout") then
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 5)
        list.HorizontalAlignment = Enum.HorizontalAlignment.Center
        list.VerticalAlignment = Enum.VerticalAlignment.Top
        list.Parent = Sidebar
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 5)
        pad.Parent = Sidebar
    end
    
    -- Sayfa Oluştur
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.Parent = ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = Page
    
    Tabs[name] = TabBtn
    Pages[name] = Page
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
    end)
    
    return Page
end

-- UI Yardımcı Fonksiyonları (Toggle, Button, Slider)
local function CreateToggle(page, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = CurrentTheme.Btn
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,6)
    
    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = Frame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 30, 0, 30)
    Button.Position = UDim2.new(1, -40, 0, 5)
    Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Kırmızı (Kapalı)
    Button.Text = ""
    Button.Parent = Frame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0,6)
    
    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Button.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Yeşil (Açık)
        else
            Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
        pcall(callback, state)
    end)
end

local function CreateButton(page, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = CurrentTheme.Btn
    Button.Text = text
    Button.TextColor3 = CurrentTheme.Text
    Button.Font = Enum.Font.Gotham
    Button.Parent = page
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0,6)
    Button.MouseButton1Click:Connect(callback)
end

local function CreateSlider(page, text, min, max, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = CurrentTheme.Btn
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,6)
    
    local Label = Instance.new("TextLabel")
    Label.Text = text .. ": " .. min
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = CurrentTheme.Text
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, -20, 0, 5)
    SliderBg.Position = UDim2.new(0, 10, 0, 35)
    SliderBg.BackgroundColor3 = Color3.fromRGB(80,80,80)
    SliderBg.Parent = Frame
    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1,0)
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Fill.Parent = SliderBg
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)
    
    local Trigger = Instance.new("TextButton")
    Trigger.Size = UDim2.new(1,0,1,0)
    Trigger.BackgroundTransparency = 1
    Trigger.Text = ""
    Trigger.Parent = SliderBg
    
    local mouse = LocalPlayer:GetMouse()
    local draggingSlider = false
    
    Trigger.MouseButton1Down:Connect(function() draggingSlider = true end)
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end 
    end)
    
    RunService.RenderStepped:Connect(function()
        if draggingSlider then
            local pos = math.clamp((mouse.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(((max - min) * pos) + min)
            Label.Text = text .. ": " .. value
            pcall(callback, value)
        end
    end)
end

-------------------------------------------------------------------------
-- 3. FONKSİYONELLİK
-------------------------------------------------------------------------

-- Tablar
local PageFly = CreateTab("Fly")
local PageESP = CreateTab("ESP")
local PageTp = CreateTab("Tp")
local PageGrum = CreateTab("Grum")
local PageSettings = CreateTab("Settings")
local PageCredits = CreateTab("Credits")

-- === FLY ===
local flying = false
local flySpeed = 50
local flyConnection

CreateToggle(PageFly, "Uçuş Modu (Fly)", function(state)
    flying = state
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "MergenFly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = root
        
        flyConnection = RunService.RenderStepped:Connect(function()
            if not flying or not char:FindFirstChild("HumanoidRootPart") then return end
            bv.Velocity = Vector3.new(0,0,0)
            local camCF = Camera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then bv.Velocity = bv.Velocity + camCF.LookVector * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then bv.Velocity = bv.Velocity - camCF.LookVector * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then bv.Velocity = bv.Velocity - camCF.RightVector * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then bv.Velocity = bv.Velocity + camCF.RightVector * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then bv.Velocity = bv.Velocity + Vector3.new(0, flySpeed/2, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then bv.Velocity = bv.Velocity - Vector3.new(0, flySpeed/2, 0) end
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
        for _, v in pairs(root:GetChildren()) do if v.Name == "MergenFly" then v:Destroy() end end
    end
end)

CreateSlider(PageFly, "Hız", 10, 300, function(val)
    flySpeed = val
end)

-- === ESP ===
local playerEspEnabled = false
local itemEspEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)
local espStorage = {}

local function UpdateESP()
    -- Temizle
    for _, v in pairs(espStorage) do v:Destroy() end
    espStorage = {}
    
    if playerEspEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hl = Instance.new("Highlight")
                hl.Adornee = plr.Character
                hl.FillColor = espColor
                hl.OutlineColor = Color3.new(1,1,1)
                hl.Parent = CoreGui
                table.insert(espStorage, hl)
            end
        end
    end
    
    if itemEspEnabled then
        for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("Tool") or item:IsA("Handle") then
                if item.Parent ~= LocalPlayer.Character and not item:IsDescendantOf(LocalPlayer.Character) then
                   local hl = Instance.new("Highlight")
                   hl.Adornee = item
                   hl.FillColor = Color3.fromRGB(0, 255, 0)
                   hl.FillTransparency = 0.5
                   hl.Parent = CoreGui
                   table.insert(espStorage, hl) 
                end
            end
        end
    end
end

RunService.Stepped:Connect(function()
    -- ESP'yi sürekli güncellemek performans yiyebilir, basit tutmak için 2 saniyede bir veya manuel tetikleme
    -- Burada basit highlight logic kullandım, daha gelişmişi için loop gerekir.
    -- Bu haliyle toggle aç kapa yapılınca yenilenir.
end)

CreateToggle(PageESP, "Player ESP", function(state)
    playerEspEnabled = state
    UpdateESP()
end)

CreateToggle(PageESP, "Item ESP", function(state)
    itemEspEnabled = state
    UpdateESP()
end)

-- Basit bir renk değiştirici (Kırmızı, Yeşil, Mavi seçenekleri)
CreateButton(PageESP, "Renk: Kırmızı Yap", function() espColor = Color3.fromRGB(255,0,0); UpdateESP() end)
CreateButton(PageESP, "Renk: Mavi Yap", function() espColor = Color3.fromRGB(0,0,255); UpdateESP() end)

-- === TP (Teleport) ===
local TpListFrame = Instance.new("ScrollingFrame")
TpListFrame.Size = UDim2.new(1, 0, 0, 200)
TpListFrame.Parent = PageTp
TpListFrame.BackgroundTransparency = 1
local tpLayout = Instance.new("UIListLayout")
tpLayout.Parent = TpListFrame

local function RefreshTpList()
    for _, v in pairs(TpListFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Text = plr.Name
            btn.BackgroundColor3 = CurrentTheme.Btn
            btn.TextColor3 = CurrentTheme.Text
            btn.Parent = TpListFrame
            
            btn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                end
            end)
        end
    end
end

CreateButton(PageTp, "Listeyi Yenile", RefreshTpList)

-- === GRUM (Noclip & Invisible) ===
local noclip = false
local invisible = false
local invisConnection

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end)

CreateToggle(PageGrum, "Noclip (Duvarlardan Geç)", function(state)
    noclip = state
end)

CreateToggle(PageGrum, "Invisible (Görünmezlik)", function(state)
    invisible = state
    local char = LocalPlayer.Character
    if not char then return end
    
    if invisible then
        -- Client Tarafı (Biz şeffaf görüyoruz)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name == "HumanoidRootPart" then
                    part.Transparency = 1
                else
                    part.Transparency = 0.5 -- Kendimiz yarı saydam görelim
                end
            end
        end
        
        -- Diğer Oyuncular İçin (Attempt)
        -- Not: Tam sunucu görünmezliği için özel exploitler gerekir, bu yöntem karakteri görsel olarak gizler.
        -- Genellikle FE oyunlarda HumanoidRootPart silmeden görünmezlik zordur.
        -- Buradaki mantık görseldir.
        
    else
        -- Görünür yap
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                end
            end
        end
    end
end)

-- === SETTINGS ===
CreateToggle(PageSettings, "Karanlık Tema", function(state)
    if state then
        MainPanel.BackgroundColor3 = Themes.Dark.Bg
        Sidebar.BackgroundColor3 = Themes.Dark.Sidebar
        TitleBar.TextColor3 = Themes.Dark.Text
    else
        MainPanel.BackgroundColor3 = Themes.Light.Bg
        Sidebar.BackgroundColor3 = Themes.Light.Sidebar
        TitleBar.TextColor3 = Themes.Light.Text
    end
end)

-- === CREDITS ===
local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Size = UDim2.new(1, 0, 1, 0)
CreditsLabel.Text = "Yapımcı: Mergen\nVersiyon: V3\n\nBu yazılım hile amaçlıdır."
CreditsLabel.TextColor3 = CurrentTheme.Text
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.TextSize = 20
CreditsLabel.Parent = PageCredits

-- Başlangıçta ilk sayfayı aç
Pages["Fly"].Visible = true
