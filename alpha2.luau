local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Emote System",
   LoadingTitle = "Emote Interface",
   LoadingSubtitle = "by CongKa",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "EmoteConfig"
   },
})

local Tab = Window:CreateTab("Emotes", "smile")

-- Khai báo các service
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator")
local head = character:WaitForChild("Head")
local camera = Workspace.CurrentCamera

local originalCameraSubject = camera.CameraSubject
local cameraFollowing = false

local defaultWalkSpeed = humanoid.WalkSpeed
local defaultJumpPower = humanoid.JumpPower

-- Biến toàn cục
local activeAnimationTrack
local activeSound

-- Hàm theo dõi camera
local function startFollowingHead()
    if not cameraFollowing then
        cameraFollowing = true
        originalCameraSubject = camera.CameraSubject
        camera.CameraSubject = head
    end
end

local function stopFollowingHead()
    if cameraFollowing then
        cameraFollowing = false
        camera.CameraSubject = originalCameraSubject
    end
end

-- Hàm vô hiệu hóa/kích hoạt di chuyển
local function disableMovement()
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
end

local function enableMovement()
    humanoid.WalkSpeed = defaultWalkSpeed
    humanoid.JumpPower = defaultJumpPower
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
end

-- Tạo animation và sound
local hakariAnimation = Instance.new("Animation")
hakariAnimation.AnimationId = "rbxassetid://138019937280193"

local hakariSound = Instance.new("Sound")
hakariSound.SoundId = "rbxassetid://87166578676888"
hakariSound.Volume = 2
hakariSound.Looped = true
hakariSound.RollOffMode = Enum.RollOffMode.Linear
hakariSound.MaxDistance = 50

-- Hàm chính để chơi emote
local function playHakariDance()
    if animator then
        -- Dừng emote hiện tại
        if activeAnimationTrack then
            activeAnimationTrack:Stop()
        end
        if activeSound then
            activeSound:Stop()
            activeSound:Destroy()
        end

        -- Vô hiệu hóa di chuyển
        disableMovement()
        startFollowingHead()

        -- Tải và phát animation
        activeAnimationTrack = animator:LoadAnimation(hakariAnimation)
        activeAnimationTrack:Play()
        
        -- Tạo và phát sound
        activeSound = hakariSound:Clone()
        activeSound.Parent = head
        activeSound:Play()

        -- Kết nối sự kiện khi animation kết thúc
        activeAnimationTrack.Stopped:Connect(function()
            enableMovement()
            stopFollowingHead()
            if activeSound then
                activeSound:Stop()
                activeSound:Destroy()
                activeSound = nil
            end
            activeAnimationTrack = nil
        end)
        
        Rayfield:Notify({
            Title = "Emote Started",
            Content = "Hakari Dance!",
            Duration = 3,
            Image = "play"
        })
    end
end

-- Hàm dừng emote
local function stopEmote()
    if activeAnimationTrack then
        activeAnimationTrack:Stop()
    end
    if activeSound then
        activeSound:Stop()
        activeSound:Destroy()
        activeSound = nil
    end
    enableMovement()
    stopFollowingHead()
    activeAnimationTrack = nil
    
    Rayfield:Notify({
        Title = "Emote Stopped",
        Content = "Emote has been stopped!",
        Duration = 3,
        Image = "stop"
    })
end


-- Section chính cho emote
local MainSection = Tab:CreateSection("Hakari Dance Emote")

-- Nút emote
local PlayButton = Tab:CreateButton({
   Name = "Hakari Dance",
   Callback = function()
      playHakariDance()
   end,
})

-- Nút dừng emote
local StopButton = Tab:CreateButton({
   Name = "Stop",
   Callback = function()
      stopEmote()
   end,
})

-- Divider
Tab:CreateDivider()

-- Section cài đặt
local SettingsSection = Tab:CreateSection("Settings")

-- Toggle cho camera follow
local CameraToggle = Tab:CreateToggle({
   Name = "Camera Follow Head",
   CurrentValue = true,
   Flag = "CameraFollow",
   Callback = function(Value)
      if not Value then
         stopFollowingHead()
      end
   end,
})

-- Slider cho âm lượng
local VolumeSlider = Tab:CreateSlider({
   Name = "Sound Volume",
   Range = {0, 10},
   Increment = 0.5,
   Suffix = "Level",
   CurrentValue = 2,
   Flag = "Volume",
   Callback = function(Value)
      hakariSound.Volume = Value
   end,
})

-- Keybind để kích hoạt nhanh
local EmoteKeybind = Tab:CreateKeybind({
   Name = "Quick Emote Key",
   CurrentKeybind = "`",
   HoldToInteract = false,
   Flag = "EmoteKeybind",
   Callback = function()
      playHakariDance()
   end,
})

-- Paragraph hướng dẫn
Tab:CreateParagraph({
    Title = "Hướng dẫn sử dụng", 
    Content = "Nhấn nút Play để bắt đầu emote Hakari Dance. Camera sẽ tự động theo đầu nhân vật và di chuyển bị vô hiệu hóa trong thời gian emote."
})

-- Label
local CreditLabel = Tab:CreateLabel("Made by: CongKa", "heart")

-- Xử lý khi nhân vật respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    head = character:WaitForChild("Head")
    animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator")
    
    -- Cập nhật giá trị mặc định
    defaultWalkSpeed = humanoid.WalkSpeed
    defaultJumpPower = humanoid.JumpPower
    
    -- Gắn lại sound vào head mới
    hakariSound.Parent = head
end)

-- Tải cấu hình
Rayfield:LoadConfiguration()
