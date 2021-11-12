//--------------------------------------------------------------------------------------
// File: Tutorial10.fx
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License (MIT).
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
Texture2D txDiffuse : register( t0 );
SamplerState samLinear : register( s0 );

cbuffer cbNeverChanges : register( b0 )
{
    float3 vLightDir;
};

cbuffer cbChangesEveryFrame : register( b1 )
{
    matrix WorldViewProj;
    matrix World;
    float Puffiness;
	float4 Time;
	float4 Frequence;
};

struct VS_INPUT
{
    float3 Pos          : POSITION;         //position
    float3 Norm         : NORMAL;           //normal
    float2 Tex          : TEXCOORD0;        //texture coordinate
};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float4 Diffuse : COLOR0;
    float2 Tex : TEXCOORD1;
};


//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
//PS_INPUT VS( VS_INPUT input )
//{
//    PS_INPUT output = (PS_INPUT)0;

//    input.Pos += input.Norm * Puffiness;

//    output.Pos = mul( float4(input.Pos,1), WorldViewProj );
//    float3 vNormalWorldSpace = normalize( mul( input.Norm, (float3x3)World ) );

//    float fLighting = saturate( dot( vNormalWorldSpace, vLightDir ) );
//    output.Diffuse.rgb = fLighting;
//    output.Diffuse.a = 1.0f; 

//    output.Tex = input.Tex;
    
//    return output;
//}

//PS_INPUT VS(VS_INPUT input)
//{
//	float magnitude = 3.5f;

//	PS_INPUT output = (PS_INPUT) 0;
//	input.Pos += input.Norm * Puffiness;

//	output.Pos = mul(float4(input.Pos, 1), WorldViewProj);
//	float3 vNormalWorldSpace = normalize(mul(input.Norm, (float3x3) World));
    
//	float scale = magnitude * smoothstep(140, 160, output.Pos.z) * (sin(Time.x * Frequence) + 0.5);
    
//	output.Pos += scale * float4(vNormalWorldSpace, 0);

//	float fLighting = saturate(dot(vNormalWorldSpace, vLightDir));
//	output.Diffuse.rgb = fLighting;
//	output.Diffuse.a = 1.0f;

//	output.Tex = input.Tex;
//	return output;
//}


PS_INPUT VS(VS_INPUT input)
{
	float magnitude = 3.5f;

	PS_INPUT output = (PS_INPUT) 0;
	input.Pos += input.Norm * Puffiness;

	output.Pos = mul(float4(input.Pos, 1), WorldViewProj);
	float3 vNormalWorldSpace = normalize(mul(input.Norm, (float3x3) World));
    
	float scale = magnitude * smoothstep(140, 160, output.Pos.z) * (sin(Time.x * Frequence) + 0.5);
    
	output.Pos += scale * float4(vNormalWorldSpace, 0);

	float fLighting = saturate(dot(vNormalWorldSpace, vLightDir));
	output.Diffuse.rgb = fLighting;
	output.Diffuse.a = 1.0f;

	output.Tex = input.Tex;
	return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( PS_INPUT input) : SV_Target
{
    //calculate lighting assuming light color is <1,1,1,1>
    float4 outputColor = txDiffuse.Sample( samLinear, input.Tex ) * input.Diffuse;
    outputColor.a = 1;
    return outputColor;
}
