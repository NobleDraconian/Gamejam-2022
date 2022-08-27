local TransitionUI = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local UI = ReplicatedStorage.Assets.UIs.TransitionScreen:Clone()
UI.Frame.BackgroundTransparency = 0
UI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local FadeInTween = TweenService:Create(
	UI.Frame,
	TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),
	{
		BackgroundTransparency = 0
	}
)

local FadeOutTween = TweenService:Create(
	UI.Frame,
	TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),
	{
		BackgroundTransparency = 1
	}
)

function TransitionUI:Show()
	FadeInTween:Play()
	FadeInTween.Completed:wait()
end

function TransitionUI:Hide()
	FadeOutTween:Play()
	FadeOutTween.Completed:wait()
end

return TransitionUI