local Lighting = game:GetService("Lighting")

local LightingPropertyNames = {
	"Ambient",
	"Brightness",
	"ColorShift_Bottom",
	"ColorShift_Top",
	"EnvironmentDiffuseScale",
	"EnvironmentSpecularScale",
	"GlobalShadows",
	"OutdoorAmbient",
	"ShadowSoftness",
	"ClockTime",
	"GeographicLatitude",
	"ExposureCompensation",
	"FogColor",
	"FogEnd",
	"FogStart"
}
local DefaultLighting_Properties = {}
local DefaultLighting_Effects = {}

for _,PropertyName in pairs(LightingPropertyNames) do
	DefaultLighting_Properties[PropertyName] = Lighting[PropertyName]
end

for _,Object in pairs(Lighting:GetChildren()) do
	table.insert(DefaultLighting_Effects,Object:Clone())
end

return {
	Properties = DefaultLighting_Properties,
	Effects = DefaultLighting_Effects
}