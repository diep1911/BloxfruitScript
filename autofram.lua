-- FixLag.lua
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hàm ẩn đối tượng
local function optimizeObject(obj)
    if obj:IsDescendantOf(LocalPlayer.Character) then
        return
    end
    
    if obj:IsA("BasePart") or obj:IsA("MeshPart") then
        obj.Transparency = 1
        obj.CanCollide = false
    elseif obj:IsA("Model") then
        for _, part in pairs(obj:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Transparency = 1
                part.CanCollide = false
            end
        end
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        obj.Enabled = false
    end
end

-- Ẩn tất cả đối tượng trong Workspace
for _, obj in pairs(Workspace:GetDescendants()) do
    optimizeObject(obj)
end

-- Theo dõi đối tượng mới
Workspace.DescendantAdded:Connect(function(obj)
    optimizeObject(obj)
end)

-- Tắt địa hình
Workspace.Terrain:ClearAllChildren()

-- Tắt ánh sáng và hiệu ứng
Lighting:ClearAllChildren()
Lighting.Ambient = Color3.fromRGB(128, 128, 128) -- Màu xám
Lighting.Brightness = 1
Lighting.GlobalShadows = false

-- Giảm tải render
RunService:Set3dRenderingEnabled(false) -- Tắt render 3D
