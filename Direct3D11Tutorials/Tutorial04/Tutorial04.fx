//--------------------------------------------------------------------------------------
// File: Tutorial04.fx
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------

//Texture2D txWoodColor: register(t0);

//SamplerState wrapTextureMirror : register(s1);


//for exercisse 05
Texture2D txCoinColor : register(t0);
Texture2D txTileColor : register(t1);
//
SamplerState wrapTexture
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Wrap;
    AddressV = Wrap;
};

//SamplerState wrapTextureCoin
//{
//    Filter = COMPARISON_MIN_MAG_POINT_MIP_LINEAR;
//    AddressU = Wrap;
//    AddressV = Wrap;
//};
//
//SamplerState wrapTextureTile
//{
//    Filter = COMPARISON_MIN_MAG_POINT_MIP_LINEAR;
//    AddressU = Wrap;
//    AddressV = Wrap;
//};
//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
cbuffer ConstantBuffer : register(b0)
{
    matrix World;
    matrix View;
    matrix Projection;
    matrix Trans_1;
    matrix Trans_2;
    float4 color;
    float4 Time;
    
}

//--------------------------------------------------------------------------------------
struct VS_INPUT
{
    float4 Pos : POSITION;
    float3 Norm : NORMAL;
    float2 Tex : TEXCOORD;
};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD0;
    float3 Norm : TEXCOORD1;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS(VS_INPUT input)
{
    PS_INPUT output = (PS_INPUT) 0;
 
    output.Pos = mul(input.Pos, World);
 
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
    
    //left hand
    if (output.Pos.y <= 1.0 && output.Pos.x >= 0.3f && output.Pos.z >= 0.7f)
    {
        if (tan(Time.x * 5) < 0)
        {
            output.Pos = mul(output.Pos, Trans_1);
        }
    }
    
    //right hand
    if (output.Pos.y <= 1.0 && output.Pos.x <= -0.3f && output.Pos.z >= 0.7f)
    {
        if (tan(Time.x * 5) > 0)
        {
            output.Pos = mul(output.Pos, Trans_1);
        }
    }
   
    //right leg
    if (output.Pos.y <= 0.1 && output.Pos.x <= -0.1f)
    {
        if (tan(Time.x * 5) < 0)
        {
            output.Pos = mul(output.Pos, Trans_2);
        }
    }
    
    //left leg
    if (output.Pos.y <= 0.1 && output.Pos.x >= 0.0f)
    {
        if (tan(Time.x * 5) > 0)
        {
            output.Pos = mul(output.Pos, Trans_2);
        }
    }
    output.Norm = input.Norm;
    output.Tex = float4(input.Tex, 1, 1);
    return output;
}

//for 6 exercise  
float4 PS(PS_INPUT input, bool front : SV_IsFrontFace) : SV_Target
{
    float4 woodColor = 0;
  
    woodColor = txCoinColor.Sample(wrapTexture, input.Tex);
 
    return woodColor * color;
}
 

