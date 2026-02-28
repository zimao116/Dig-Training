local Compkiller = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/CompKiller/refs/heads/main/src/source.luau"))();

local Notifier = Compkiller.newNotify();

local ConfigManager = Compkiller:ConfigManager({
	Directory = "PixelArt",
	Config = "Configs"
});

local Window = Compkiller.new({
	Name = "Pixel Art",
	Keybind = "LeftAlt",
	Logo = "rbxassetid://96747458534237",
	Scale = Compkiller.Scale.Window,
	TextSize = 17,
});

local player = game.Players.LocalPlayer
local myName = player.Name
local playerGui = player:WaitForChild("PlayerGui")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local autoFightButton
local knit = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit")
local RunTrainEvent = knit:WaitForChild("Services"):WaitForChild("TrainService"):WaitForChild("RE"):WaitForChild("RunTrain")
local AutoHatchEvent = knit:WaitForChild("Services"):WaitForChild("EggHatchService"):WaitForChild("RE"):WaitForChild("Hatch")
local claimRemote = knit:WaitForChild("Services"):WaitForChild("OnlineRewardService"):WaitForChild("RE"):WaitForChild("ClaimOnlineReward")
local autoServiceRE = knit:WaitForChild("Services"):WaitForChild("AutoService"):WaitForChild("RE")
local function updateButton()
    autoFightButton = playerGui:WaitForChild("HomeGui"):WaitForChild("RightFrame"):WaitForChild("AutoFightButton")
end

updateButton()

local function jimsDigButton()
    local mouse = {"MouseButton1Click", "Activated", "MouseButton1Down"}
    for _, click in ipairs(mouse) do
        local auto = autoFightButton[click]
        if auto then
            for _, connection in pairs(getconnections(auto)) do
                connection:Fire()
            end
        end
    end
end

local function tpToBlock()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local targetModel = workspace:FindFirstChild("Areas")
            and workspace.Areas:FindFirstChild("Area_3")
            and workspace.Areas.Area_3:FindFirstChild("Blocks")
            and workspace.Areas.Area_3.Blocks:FindFirstChild("Block_3_1")
            
        if targetModel and targetModel:IsA("Model") then

            character.HumanoidRootPart.CFrame = targetModel:GetPivot() * CFrame.new(0, 10, 0)
        end
    end
end

local StartTime = os.time() 
local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

local Watermark = Window:Watermark();

Watermark:AddText({
    Icon = "user",
    Text = myName,
});

local ServerTimeInfo = Watermark:AddText({
    Icon = "clock", 
    Text = "00:00:00",
});

task.spawn(function()
    while true do task.wait(1) 
        local TimePassed = os.time() - StartTime
        ServerTimeInfo:SetText(FormatTime(TimePassed)); 
    end
end)

Window:DrawCategory({
	Name = "Main"
});

local MainTab = Window:DrawTab({
	Name = "General",
	Icon = "rbxassetid://79770494476008",
	EnableScrolling = true
});

local FarmSection = MainTab:DrawSection({
    Name = "Dig",
    Position = 'left'   
});

getgenv().DigWait = 1

FarmSection:AddSlider({
    Name = "Wait",
    Min = 1,
    Max = 100,
    Default = 1,
    Round = 0,
    Flag = "Slider_DigWait",
    Callback = function(Value)
        getgenv().DigWait = Value
    end
});

getgenv().AutoDig = false

local Toggle = FarmSection:AddToggle({
    Name = "Auto Dig",
    Flag = "Toggle_AutoDig",
    Default = false,
    Callback = function(state)
        getgenv().AutoDig = state
        if state == true then
            task.spawn(function()
                autoServiceRE.AutoFightStop:FireServer()
                task.wait(0.1)
                
                while getgenv().AutoDig do
                    if autoFightButton and autoFightButton.Parent then
                        jimsDigButton()
                        task.wait()
                        if getgenv().AutoTP == true then
                            tpToBlock()
                        end
                        task.wait(getgenv().DigWait)
                        
                        if not getgenv().AutoDig then break end
                        
                        autoServiceRE.AutoFightStop:FireServer()
                        task.wait(0.1)
                        jimsDigButton()
                        task.wait(0.1)
                    else
                        updateButton()
                        task.wait(1)
                    end
                end
            end)
        end
    end,
});

getgenv().AutoTP = false

local Toggle = FarmSection:AddToggle({
    Name = "TP",
    Flag = "Toggle_TP",
    Default = false,
    Callback = function(state)
        getgenv().AutoTP = state
    end,
});

local TrainingSection = MainTab:DrawSection({
    Name = "Training",
    Position = 'Right'   
});

getgenv().AutoTrain = false

local Toggle = TrainingSection:AddToggle({
    Name = "Auto Training",
    Flag = "Toggle_AutoTraining",
    Default = false,
    Callback = function(state)
        getgenv().AutoTrain = state
        if state == true then
            task.spawn(function()
                while getgenv().AutoTrain do
                    RunTrainEvent:FireServer("Anvil_3_VIP")
                    task.wait(0.3)
                end
            end)
        end
    end,
});

TrainingSection:AddParagraph({
    Title = "Worlds | Seabed",
    Content = "Training VIP"
})

local RewardSection = MainTab:DrawSection({
    Name = "Online Gifts",
    Position = 'Right'   
});

getgenv().AutoClaim = false

local Toggle = RewardSection:AddToggle({
    Name = "Auto Claim",
    Flag = "Toggle_AutoClaim",
    Default = false,
    Callback = function(state)
        getgenv().AutoClaim = state
        if state == true then
            task.spawn(function()
                while getgenv().AutoClaim do
                    for i = 1, 12 do
                        claimRemote:FireServer(i)
                        task.wait(60)
                    end
                    task.wait(60)
                end
            end)
        end
    end,
});

local HatchSection = MainTab:DrawSection({
    Name = "Hatch Egg",
    Position = 'Left'   
});

getgenv().HatchSpeed = 0.1

HatchSection:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 10,
    Default = 0.1,
    Round = 1,
    Flag = "Slider_HatchSpeed",
    Callback = function(Value)
        getgenv().HatchSpeed = Value
    end
});

getgenv().AutoHatch = false

local Toggle = HatchSection:AddToggle({
    Name = "Auto Hatch",
    Flag = "Toggle_AutoHatch",
    Default = false,
    Callback = function(state)
        getgenv().AutoHatch = state
        if state == true then
            task.spawn(function()
                while getgenv().AutoHatch do
                    AutoHatchEvent:FireServer("Egg_3_1",3)
                    task.wait(getgenv().HatchSpeed)
                end
            end)
        end
    end,
});

HatchSection:AddParagraph({
    Title = "Worlds | Seabed",
    Content = "Egg Open x3 | Egg 1"
})

Window:DrawCategory({
	Name = "Other"
});

local ConfigUI = Window:DrawConfig({
    Name = "Config",
    Icon = "folder",
    Config = ConfigManager
});

ConfigUI:Init()

local AutoLoadFileName = "AFK"

task.spawn(function()
    task.wait(1)

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
    task.wait(1)
        
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
    task.wait(1)
        
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

    Notifier.new({
            Title = "Reset Player",
            Content = "Succeed",
            Duration = 5,
            Icon = Compkiller:_GetIcon('settings'),
        });

    task.wait(1)

    local success, err = pcall(function()
        ConfigManager:LoadConfig(AutoLoadFileName)
    end)
    if success then
        Notifier.new({
            Title = "Configs",
            Content = "Load config" .. AutoLoadFileName,
            Duration = 5,
            Icon = Compkiller:_GetIcon('settings'),
        });
    end
end)

task.spawn(function()
    while task.wait(420) do 
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Jump = true
        end
    end
end)
