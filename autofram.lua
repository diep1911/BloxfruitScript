getgenv().Team = "Pirates"
getgenv().AutoLoad = false -- Will Load Script On Server Hop

getgenv().AutoFarm = true -- Auto farm level and quests
getgenv().CheckMeleeItems = true -- Get melee items while farming
getgenv().AutoHop = true
getgenv().AntiBan = true

local function hasItem(itemName)
    local player = game.Players.LocalPlayer
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name == itemName then
            return true
        end
    end
    for _, item in pairs(player.Character:GetChildren()) do
        if item.Name == itemName then
            return true
        end
    end
    return false
end

local function equipMelee()
    local player = game.Players.LocalPlayer
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name == "Dragon Talon" or item.Name == "Electric Claw" or item.Name == "Sharkman Karate") then
            player.Character.Humanoid:EquipTool(item)
            return
        end
    end
end

local function serverHop()
    wait(math.random(3, 7)) -- Random delay to avoid detection
    local TeleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    TeleportService:Teleport(placeId)
end

local function claimQuest()
    local player = game.Players.LocalPlayer
    local questNPCs = {"Quest Giver", "Boss Quest NPC"} -- Thêm tên NPC nhiệm vụ nếu cần
    
    for _, npc in pairs(game.Workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("ProximityPrompt") then
            for _, npcName in pairs(questNPCs) do
                if npc.Name == npcName then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
                    wait(1)
                    fireproximityprompt(npc.ProximityPrompt)
                    wait(2)
                    return true
                end
            end
        end
    end
    return false
end

local function autoFarm()
    while getgenv().AutoFarm do
        if claimQuest() then -- Nhận nhiệm vụ trước khi farm
            equipMelee() -- Đảm bảo luôn cầm vũ khí Melee trước khi đánh
            
            for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                    local bv = Instance.new("BodyVelocity", hrp)
                    bv.Velocity = Vector3.new(0, 25, 0) -- Bay cao hơn 1 chút
                    bv.MaxForce = Vector3.new(4000, 4000, 4000)
                    
                    repeat
                        wait(math.random(1, 3) / 10)
                        hrp.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, -20) -- Giữ khoảng cách xa hơn quái
                        equipMelee()
                        local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                            wait(math.random(1, 2))
                        end
                    until enemy.Humanoid.Health <= 0 or not getgenv().AutoFarm
                    bv:Destroy()
                end
            end
        end
        wait(2)
    end
end

local function checkAndGetMeleeItems()
    local requiredItems = {"Dragon Talon", "Electric Claw", "Sharkman Karate"}
    for _, item in pairs(requiredItems) do
        if not hasItem(item) then
            print("Missing melee item: " .. item .. ", farming for it...")
            autoFarm()
        end
    end
end

local function antiBan()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end

if getgenv().AntiBan then
    spawn(antiBan)
end

if getgenv().AutoFarm then
    spawn(autoFarm)
end

if getgenv().CheckMeleeItems then
    spawn(checkAndGetMeleeItems)
end
