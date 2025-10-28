local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Emote",
   LoadingTitle = "Emote Interface",
   LoadingSubtitle = "by CongKa",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "EmoteConfig"
   },
})

local Tab = Window:CreateTab("Emotes", "smile")

local Button = Tab:CreateButton({
   Name = "Hakari Dance",
   Callback = function()
      -- Lấy nhân vật người chơi
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoid = character:WaitForChild("Humanoid")
      
      -- Tạo animation
      local animation = Instance.new("Animation")
      animation.AnimationId = "rbxassetid://138019937280193"
      
      -- Tạo sound
      local sound = Instance.new("Sound")
      sound.SoundId = "rbxassetid://87166578676888"
      sound.Parent = character.Head
      
      -- Tải và phát animation
      local animationTrack = humanoid:LoadAnimation(animation)
      animationTrack:Play()
      sound:Play()
      
      -- Vô hiệu hóa di chuyển
      humanoid.WalkSpeed = 0
      
      -- Kết nối sự kiện khi animation kết thúc
      animationTrack.Stopped:Connect(function()
         humanoid.WalkSpeed = 16 -- Khôi phục tốc độ di chuyển bình thường
         sound:Stop()
         sound:Destroy()
      end)
   end,
})
