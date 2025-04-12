-- Script ẩn đồ họa Blox Fruits, giữ nhân vật, nền xám
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hàm ẩn đối tượng đồ họa
local function hideObject(obj)
    -- Không ẩn nhân vật của người chơi
    if obj:IsDescendantOf(LocalPlayer.Character) then
        return
    end

    -- Ẩn các loại Part
    if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Part") then
        obj.LocalTransparencyModifier = 1 -- Ẩn trên client
        obj.CanCollide = false -- Tắt va chạm
        obj.CastShadow = false -- Tắt bóng
    -- Ẩn Model
    elseif obj:IsA("Model") then
        for _, part in pairs(obj:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Part") then
                part.LocalTransparencyModifier = 1
                part.CanCollide = false
                part.CastShadow = false
            end
        end
    -- Ẩn Decal, Texture, SurfaceAppearance
    elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then
        obj.Transparency = 1
    -- Tắt hiệu ứng
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Light") or obj:IsA("Sparkles") or obj:IsA("Smoke") or obj:IsA("Fire") then
        obj.Enabled = false
    -- Tắt GUI trên bề mặt
    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
        obj.Enabled = false
    end
end

-- Ẩn tất cả đối tượng hiện tại trong Workspace
for _, obj in pairs(Workspace:GetDescendants()) do
    hideObject(obj)
end

-- Theo dõi và ẩn các đối tượng mới
Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.05) -- Đợi ngắn để tránh lỗi server tái tạo
    hideObject(obj)
end)

-- Nhắm vào các thư mục đồ họa chính của Blox Fruits
local function clearBloxFruitsGraphics()
    local folders = {
        Workspace:FindFirstChild("Map"), -- Đảo, cây, nước
        Workspace:FindFirstChild("NPC"), -- NPC
        Workspace:FindFirstChild("Enemies"), -- Quái
        Workspace:FindFirstChild("Boats"), -- Thuyền
        Workspace:FindFirstChild("Items"), -- Vật phẩm
        Workspace:FindFirstChild("Live"), -- Các thực thể khác
        Workspace:FindFirstChild("Camera") -- Hiệu ứng camera
    }

    for _, folder in pairs(folders) do
        if folder then
            for _, obj in pairs(folder:GetDescendants()) do
                hideObject(obj)
            end
            folder.DescendantAdded:Connect(function(obj)
                task.wait(0.05)
                hideObject(obj)
            end)
        end
    end
end
clearBloxFruitsGraphics()

-- Xóa và ẩn địa hình
Workspace.Terrain:ClearAllChildren()
Workspace.Terrain.Transparency = 1

-- Đặt màu nền xám, không làm trắng
Lighting.Ambient = Color3.fromRGB(128, 128, 128) -- Màu xám trung tính
Lighting.Brightness = 0.8 -- Giảm sáng để tránh trắng
Lighting.GlobalShadows = false
Lighting.FogEnd = 10000 -- Tắt sương mù
Lighting.FogStart = 10000
Lighting.ColorShift_Top = Color3.fromRGB(128, 128, 128)
Lighting.ColorShift_Bottom = Color3.fromRGB(128, 128, 128)

-- Tắt hiệu ứng ánh sáng không cần thiết
for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("PostEffect") or effect:IsA("Sky") then
        effect.Enabled = false
    end
end

-- Cố định camera để thấy nhân vật
local Camera = Workspace.CurrentCamera
Camera.CameraType = Enum.CameraType.Custom
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Camera.CFrame = CFrame.new(
            LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 10),
            LocalPlayer.Character.HumanoidRootPart.Position
        )
    end
end)

-- Đảm bảo render 3D bật để thấy nhân vật
RunService:Set3dRenderingEnabled(true)
