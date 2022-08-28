local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LightingFolder = ReplicatedStorage.Assets.Lighting.Level1

return {
	Properties = {
		Ambient = Color3.fromRGB(195, 195, 195),
		Brightness = 3,
		ColorShift_Bottom = Color3.fromRGB(0,0,0),
		ColorShift_Top = Color3.fromRGB(0,0,0),
		EnvironmentDiffuseScale = 1,
		EnvironmentSpecularScale = 1,
		GlobalShadows = true,
		OutdoorAmbient = Color3.fromRGB(70,70,70),
		ShadowSoftness = 0.2,
		ClockTime = 14.5,
		GeographicLatitude = 0,
		ExposureCompensation = 0.25
	},
	Effects = {
		Atmosphere = LightingFolder.Atmosphere,
		Bloom = LightingFolder.Bloom,
		DepthOfField = LightingFolder.DepthOfField,
		SunRays = LightingFolder.SunRays
	}
}