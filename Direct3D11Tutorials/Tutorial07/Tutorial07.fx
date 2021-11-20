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
    inPos = mul(inPos, View);
    inPos = mul(inPos, Projection);
    output.Pos = inPos;
    return output;
}

PS_INPUT VS_CubeMap(VS_INPUT input)
{
	PS_INPUT output = (PS_INPUT) 0;
	float4 inPos = input.Pos;
	output.viewDir = inPos.xyz;
	inPos.xyz += eyePos.xyz;
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
    return txDiffuse.SampleLevel(samLinear, input.Tex, 0);
}

float4 PS_CubeMap(PS_INPUT input) : SV_Target
{
    float4 materialAmb = float4(0.05, 0.01, 0.01, 1.0);
    float4 materialDiff = float4(0.2, 0.1, 0.2, 1.0);
    float4 lightCol = float4(1.0, 1.0, 1.0, 1.0);
    float4 lightPos = float4(0.0, 10.0, 0.0, 1.0);;
    float3 lightDir = normalize(lightPos.xyz - input.Pos.xyz);
    float3 normal = normalize(input.Norm);
    float diff = max(0.0, dot(lightDir, normal));
    float3 R = reflect(-lightDir, normal);
    float3 V = eyePos.xyz - input.Pos.xyz;
    R = normalize(R);
    V = normalize(V);
    float dotRV = max(0.0, dot(R, V));
    dotRV = pow(dotRV, 80);
    float4 specColo = float4(1.3f, 2.1f, 0.6f, 1.0f);
    float4 spec = dotRV * specColo;
    float4 envRes = txSkyColor.Sample(sampler_Sky_Linear, input.viewDir);
    float4 ligntRes = (materialAmb + diff * materialDiff + spec) * lightCol;
    input.Color = ligntRes + envRes;
    return input.Color;
}
