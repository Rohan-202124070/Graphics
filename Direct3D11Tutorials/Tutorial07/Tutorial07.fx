//--------------------------------------------------------------------------------------
// File: Tutorial07.fx
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
Texture2D txDiffuse : register( t0 );
TextureCube txSkyColor : register(t1);
SamplerState samLinear : register( s0 );
SamplerState sampler_Sky_Linear : register(s1);

cbuffer cbNeverChanges : register( b0 )
{
    matrix View;
};

cbuffer cbChangeOnResize : register( b1 )
{
    matrix Projection;
};

cbuffer cbChangesEveryFrame : register( b2 )
{
    matrix World;
    float4 eyePos;
    float4 vMeshColor;
};


//--------------------------------------------------------------------------------------
struct VS_INPUT
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
    float4 Norm : NORMAL0;
};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD0;
    float3 viewDir : TEXCOORD1;
    float4 Norm : NORMAL0;
    float4 Color : COLOR0;
};


//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS(VS_INPUT input)
{
	PS_INPUT output = (PS_INPUT) 0;   
    float4 inPos = input.Pos;
    output.viewDir = inPos.xyz;
    inPos.xyz += eyePos.xyz;
	inPos = mul(inPos, World);
    inPos = mul(inPos, View);
    inPos = mul(inPos, Projection);
	//output.Norm.xyz = mul(input.Norm, World).xyz;
    output.Pos = inPos;
    return output;
}

PS_INPUT VS_CubeMap(VS_INPUT input)
{
	PS_INPUT output = (PS_INPUT) 0;
	float4 inPos = input.Pos;
	output.viewDir = inPos.xyz;
	inPos.xyz += eyePos.xyz;
	inPos = mul(inPos, World);
	inPos = mul(inPos, View);
	inPos = mul(inPos, Projection);
    output.Norm.xyz = mul(input.Norm, World).xyz;
	output.Pos = inPos;
	return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{	
	//exercise 02 - 03
	return txSkyColor.Sample(sampler_Sky_Linear, input.viewDir);;
}

float4 PS_CubeMap(PS_INPUT input) : SV_Target
{	
	//exrecise 03
    float3 viewDirection = reflect(input.viewDir, (float3) input.Norm);
    float3 refDir = refract(viewDirection, (float3) input.Norm, 0.9);
    float4 skyColor = txSkyColor.Sample(sampler_Sky_Linear, viewDirection);
    float4 reflColor = txSkyColor.Sample(sampler_Sky_Linear, refDir);
    return 0.5 * reflColor + 0.5 * skyColor;
}


//float3 viewDir = reflect(-input.viewDir, input.Norm);
 //return txSkyColor.Sample(txSkySampler, viewDir); 