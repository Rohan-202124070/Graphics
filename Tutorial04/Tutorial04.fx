//--------------------------------------------------------------------------------------
// File: Tutorial04.fx
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------

#define  NeighborSize 2

Texture2D txDiffuse : register(t0);
SamplerState samLinear : register(s0);
cbuffer ConstantBuffer : register( b0 )
{
	matrix World;
	matrix View;
	matrix Projection;
	float4 Time;
}

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
    float4 Norm : NORMAL0;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS(VS_INPUT input)
{
    PS_INPUT output = (PS_INPUT)0;
    float4 inPos = input.Pos;
    inPos = mul(inPos, World);
    inPos = mul(inPos, View);
    inPos = mul(inPos, Projection);
    output.Norm.xyz = mul(input.Norm, World).xyz;
    output.Pos = inPos;
    output.Tex = input.Tex;
    return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
    //exercise 01
	//return txDiffuse.Sample(samLinear, input.Tex);
    
    //exercise 02
    //float2 XY = input.Tex;
    //float pixelSize = 0.1f;
    //float Nabsize = 2.5f;
    //float4 ColAtST = float4(0.0, 0.0, 0.0, 0.0);
    //for (int i = -NeighborSize; i <= NeighborSize; i++)
    //{
    //    for (int j = -NeighborSize; j <= NeighborSize; j++)
    //    {
    //        XY = input.Tex.x + float2(i * pixelSize, j * pixelSize);
    //        ColAtST.rgb += txDiffuse.Sample(samLinear, XY);
    //    }
    //}
    //ColAtST.rgb /= (2 * Nabsize + 1) * (2 * Nabsize + 1);
    //return ColAtST;
    
    //exercise 03
    float scale = 2.0f;
    float2 XY = input.Tex;
    XY -= 1.5;
    float LocalTr = smoothstep(0.2, 0.6, length(XY));
    XY *= scale * LocalTr + (1.0 - LocalTr);
    XY += 1.5;
    float4 glow = txDiffuse.Sample(samLinear, XY);
	
    float2 scaleCenter = float2(0.5f, 0.5f);
    input.Tex.xy = (input.Tex.xy - scaleCenter) * float2(3.0f, 2.0f) + scaleCenter;
    float4 orignalTexCol = txDiffuse.Sample(samLinear, input.Tex);
    if (orignalTexCol.r >= 1.0)
    {
        orignalTexCol = float4(5.0 * glow.xy, 1.5 * glow.z, 1.0);
    }
    return orignalTexCol;
	
	//exercise 04
 //   float burnSpeed = 12.5f;
 //   float scale = 2.0f;
 //   float2 XY = input.Tex;
 //   XY -= 1.5;
 //   float LocalTr = smoothstep(0.2, 0.6, length(XY));
 //   XY *= scale * LocalTr + (1.0 - LocalTr);
 //   XY += 1.5;
 //   XY.x = scale * input.Tex.x - burnSpeed * Time.x;
 //   XY.y = scale * input.Tex.y - burnSpeed * Time.x;
	////float4 glow = txDiffuse.Sample(samLinear, XY);
 //   float4 glow = txDiffuse.Sample(samLinear, input.Tex);
 //   glow.z = 1.9f * Time.x;
	
 //   float noise = 1.5f * Time.x;
 //   float2 heatXY = float2(input.Tex.x + 0.1 * noise, input.Tex.y + 0.1 * noise);
 //   heatXY = (heatXY - 0.5) * scale;
 //   heatXY += 1.5f;
 //   float2 pixelSize = float2(1.0 / 1800.0, 1.0 / 1200.0);
 //  // float3 procssedImage = Poisson(float2(1.1f, 1.9f), heatXY, pixelSize, float2(0.1f, 1.9f));
 //   return glow;
}
