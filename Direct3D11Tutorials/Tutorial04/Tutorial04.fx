//--------------------------------------------------------------------------------------
// File: Tutorial05.fx
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
Texture2D txDiffuse : register(t0);
SamplerState samLinear : register(s0);
cbuffer ConstantBuffer : register(b0)
{
    matrix World;
    matrix View;
    matrix Projection;
	matrix Translation;
	matrix Scale;
	float4 time;
}

//--------------------------------------------------------------------------------------
struct VS_INPUT
{
    float4 Pos : POSITION;
	float2 Tex : TEXCOORD0;
    float4 Color : COLOR;
	
};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
	float2 Tex : TEXCOORD0;
    float4 Color : COLOR;
    float4 fadingRate : COLOR1;
};


//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS(VS_INPUT input)
{
    PS_INPUT output = (PS_INPUT)0;
	
	//fire
    float _lifeSpan = 4.5;
    float _time = 1.2 * fmod(0.2 * time.x, _lifeSpan);
    float _velocity = 0.4f;
    float fadingRate = (1 - _time / _lifeSpan);
	
	//for quads
	float3 viewLeft = View._11_21_31;
	float3 viewUp = View._12_22_32;
	float4 inPos = input.Pos;
	inPos.xyz = inPos.x * viewLeft + inPos.y * viewUp;
	inPos *= 0.5;
	float3 particlePos = (float3) input.Pos.z;
	
    //particlePos = _velocity * _time;
	inPos += float4(particlePos, 1.0);
	
    float3 fire_up = _velocity * _time;
	
    inPos.xyz += fire_up;
    output.Pos = mul(inPos, World);
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
	output.Tex = input.Tex;
    output.Color = input.Color;
    output.fadingRate.x = fadingRate;
    return output;
}

PS_INPUT VS_Sphere(VS_INPUT input)
{
	PS_INPUT output = (PS_INPUT) 0;
	output.Pos = mul(input.Pos, World);
	output.Pos = mul(output.Pos, View);
	output.Pos = mul(output.Pos, Projection);
	output.Pos = mul(output.Pos, Translation);
	output.Pos = mul(output.Pos, Scale);
	output.Color = input.Color;

	return output;
}



//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
   // float _smooth =  1.0 - smoothstep(0.0, 0.9, length(input.Tex - 0.5));
    return txDiffuse.Sample(samLinear, input.Tex) * input.fadingRate.x; //* _smooth;
}


float4 PS_Sphere(PS_INPUT input) : SV_Target
{
	return input.Color;
}