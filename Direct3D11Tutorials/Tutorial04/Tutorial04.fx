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
};


//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS(VS_INPUT input)
{
    PS_INPUT output = (PS_INPUT)0;
	
	float3 viewLeft = View._11_21_31;
	float3 viewUp = View._12_22_32;
	float4 inPos = input.Pos;
	inPos.xyz = inPos.x * viewLeft + inPos.y * viewUp;
	inPos *= 0.1;
	float4 particlePos = input.Pos.z;
	inPos += particlePos;
    output.Pos = mul(inPos, World);
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
	output.Tex = input.Tex;
    output.Color = input.Color;

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
	return txDiffuse.Sample(samLinear, input.Tex);
}


float4 PS_Sphere(PS_INPUT input) : SV_Target
{
	return input.Color;
}