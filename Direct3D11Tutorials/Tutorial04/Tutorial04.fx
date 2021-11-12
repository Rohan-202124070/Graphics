//--------------------------------------------------------------------------------------
// File: Tutorial04.fx
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------
Texture2D txCoinColor: register(t0);
Texture2D txTileColor: register(t1);
//
SamplerState wrapTexture 
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Wrap;
    AddressV = Wrap;
};

float3 bumpNormal(float2 xy, float3 normal);
float2 RayMatching(float2 startCoord, float3 viewDir);
//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
cbuffer ConstantBuffer : register(b0)
{
    matrix World;
    matrix View;
    matrix Projection;
    float4 color;
	float4 lightPos;
}

//--------------------------------------------------------------------------------------
struct VS_INPUT
{ 
    float4 Pos: POSITION; 
    float3 Norm: NORMAL; 
    float2 Tex: TEXCOORD;
	float3 Tang : TANGENT;
	float3 Binormal : BINORMAL;
};

struct PS_INPUT
{ 
    float4 Pos: SV_POSITION; 
    float2 Tex: TEXCOORD0; 
    float3 Norm: TEXCOORD1;
	float3 viewDirInTang : TEXCOORD2;
	float3 lightDirInTang : TEXCOORD3;
};

//for exercise 1
//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS(VS_INPUT input)
{
    PS_INPUT output = (PS_INPUT)0;
    output.Pos = mul(input.Pos, World);
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
	float3 N = normalize(input.Norm);
	float3 T = normalize(input.Tang);
	float3 B = normalize(input.Binormal);
	float4 eyePos = float4(0.0f, -2.0f, 0.0f, 0.0f);
	float3 viewDirW = eyePos - input.Pos;
	float3 lightDirW = lightPos - input.Pos;
	float3x3 mat2Tang = float3x3(T, B, N);
	output.Norm = input.Norm;
	output.viewDirInTang = mul(mat2Tang, viewDirW);
	output.lightDirInTang = mul(mat2Tang, lightDirW);
    output.Tex = input.Tex;
    return output;
}

//for exercise 1
//--------------------------------------------------------------------------------------
// pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input, bool front : SV_IsFrontFace) : SV_Target
{
	float4 stroneCol = txCoinColor.SampleLevel(wrapTexture, input.Tex, 0);
	float4 stoneNormal = txTileColor.Sample(wrapTexture, input.Tex);
	//exercise 1
    //float3 N = normalize(2.0 * stoneNormal.xyz - 1.0);
	
	// exercise 2
    float x = input.Tex.x * 5;
    float y = input.Tex.y * 5;
    //float3 N = bumpNormal(float2(x, y), input.Norm);
	
	//exercise 3
    //float height = stoneNormal.r;
    //float dx = ddx(height);
    //float dy = ddy(height);
    //float3 N = normalize(float3(-dx, -dy, 0.3));
	
	//paralax mapping - exercise 04 
	float height = stoneNormal.r;
	height = 5 * height - 0.1;
	float2 new_texCoord = RayMatching(input.Tex.xy, input.viewDirInTang);
	float3 N = 2.0 * txTileColor.Sample(wrapTexture, new_texCoord) - 1;

	//common for all exrecises 
	float3 lightDir = normalize(lightPos.xyz - input.Pos.xyz);
	float diff = max(0.0, dot(lightDir, N));

	float3 R = reflect(-lightDir, N);
	float4 eyePos = float4(0.0f, 1.0f, -5.0f, 0.0f);
	float3 V = eyePos.xyz - input.Pos.xyz;
	R = normalize(R);
	V = normalize(V);
	float dotRV = max(0.5, dot(R, V));
	dotRV = pow(dotRV, 80);
	float4 specColo = float4(1.1, 1.7, 1.9, 0.0);
	float4 spec = dotRV * specColo;

    return diff + spec + stroneCol;
}

float2 RayMatching(float2 startCoord, float3 viewDir)
{
	float3 invV = -viewDir;
	float stapSize = 0.00001;
	float maxHeightBump = 1.5;
	
	float3 P0 = float3(startCoord.x, startCoord.y, maxHeightBump);
	float H0 = maxHeightBump * txTileColor.SampleLevel(wrapTexture, P0.xy, 0).r;
	
	for (int i = 0; i < 100; i++)
	{
		if (P0.z > H0)
		{
			P0 += stapSize * invV;
			H0 = maxHeightBump * txTileColor.SampleLevel(wrapTexture, P0.xy, 0).r;

		}
		else
		{
			break;
		}

	}
	return P0.xy;

}

float3 bumpNormal(float2 xy, float3 normal)
{
	float3 N = normal;
	
	//map xy to map[-1,1]X[-1,1]
	float2 st = 2.0 * frac(xy) - 1.0;

	// 0.5 is the radius
	float R2 = 0.5 * 0.5 - dot(st, st);
	if (R2 > 0.0)
	{
		N.xy = st / sqrt(R2);
	}
	return normalize(N);
}