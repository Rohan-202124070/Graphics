//--------------------------------------------------------------------------------------
// File: Tutorial10.fx
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License (MIT).
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
Texture2D txDiffuse : register(t0);
SamplerState samLinear : register(s0);

cbuffer cbNeverChanges : register(b0)
{
	float3 vLightDir;
};

cbuffer cbChangesEveryFrame : register(b1)
{
	matrix WorldViewProj;
	matrix World;
	matrix HeadmHeadWorldViewProjection;
	matrix HeadWorld;
	matrix RightLeg;
	matrix LeftLeg;
	float Puffiness;
	float4 Time;
	float4 Frequence;
	float4 Scaling;
	float4 Translation;
	float4 HeadRotate;
    
};

struct VS_INPUT
{
	float3 Pos : POSITION; //position
	float3 Norm : NORMAL; //normal
	float2 Tex : TEXCOORD0; //texture coordinate
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

//for the exercise 2 and 3
//PS_INPUT VS(VS_INPUT input)
//{
//	matrix scaling_matrix = { { 3.2, 0, 0, 0 }, { 0, 0.6, 0, 0 }, { 0, 0, 0.10, 0 }, { 0, 0, 0.1, 1 } };
//    //matrix shering_matrix = { { 1, 0.4, 0.1, 0.4 }, { 0, 1, 0, 0 }, { 0, 0, 1, 0 }, { 0, 0, 0, 1 } };
//	matrix scaling_matrix_res;
//    matrix translation_matrix = { { 1, 0, 0, 0 }, { 0, 1, 0, 0 }, { 0, 0, 1, 0 }, { -0.4, 0.3, -0.095, 1 } };
//    vector translation_vector = { 0, 0.4, 0, 0 };
	
//	if ((int) Scaling.x == 1)
//	{
//        scaling_matrix_res = mul(WorldViewProj, scaling_matrix);
//    }
//	else if (Translation.x == 1)
//	{
//        scaling_matrix_res = mul(WorldViewProj, translation_matrix);

//	}
//	else
//	{
//		scaling_matrix_res = WorldViewProj;

//	}
	
//	float magnitude = 0.5f;

//	PS_INPUT output = (PS_INPUT) 0;
//	input.Pos += input.Norm * Puffiness;

//	output.Pos = mul(float4(input.Pos, 1), scaling_matrix_res);
//	float3 vNormalWorldSpace = normalize(mul(input.Norm, (float3x3) World));
    
//	if (Frequence.x > 0.0)
//	{
//		float scale = magnitude * smoothstep(140, 160, output.Pos.z) * (sin(Time.x * Frequence) + 0.5);
//		output.Pos += scale * float4(vNormalWorldSpace, 0);
//	}
	
//	float fLighting = saturate(dot(vNormalWorldSpace, vLightDir));
//	output.Diffuse.rgb = fLighting;
//	output.Diffuse.a = 1.0f;

//	output.Tex = input.Tex;
//	return output;
//}

PS_INPUT VS(VS_INPUT input)
{
    
	matrix rotation_matrix_res;
	float3 vNormalWorldSpace;
	PS_INPUT outVS = (PS_INPUT) 0;
	input.Pos += input.Norm * Puffiness;
   
	// head rotation
	//if (HeadRotate.x == 1)
	//{
	//	if (input.Pos.y > -35 && input.Pos.z > 175)
	//	{
	//		float scale_Head = 2.5 * smoothstep(400, 780, outVS.Pos.y);
	//		outVS.Pos = mul(float4(input.Pos, 1), HeadmHeadWorldViewProjection);
	//		vNormalWorldSpace = normalize(mul(input.Norm, (float3x3) HeadWorld));
	//		outVS.Pos += scale_Head * float4(vNormalWorldSpace, 0);
	//	}
	//	else
	//	{
	//		outVS.Pos = mul(float4(input.Pos, 1), WorldViewProj);
	//		vNormalWorldSpace = normalize(mul(input.Norm, ((float3x3) World)));
	//		outVS.Pos += float4(vNormalWorldSpace, 0);
	//	}
       
	//}
	//else
	//{
	//	outVS.Pos = mul(float4(input.Pos, 1), WorldViewProj);
	//	vNormalWorldSpace = normalize(mul(input.Norm, ((float3x3) World)));
	//	outVS.Pos += float4(vNormalWorldSpace, 0);
	//}
	
	//for walking
	//if (HeadRotate.x == 1)
	//{
		
	//	if (input.Pos.z < -90 && input.Pos.x < 10)
	//	{
	//		if (sin(Time.x + 30) < 0)
	//		{
	//			outVS.Pos = mul(float4(input.Pos, 1), HeadmHeadWorldViewProjection);
	//			vNormalWorldSpace = normalize(mul(input.Norm, (float3x3) HeadWorld));
				
	//		}
	//		else
	//		{
	//			outVS.Pos = mul(float4(input.Pos, 1), WorldViewProj);
	//			vNormalWorldSpace = normalize(mul(input.Norm, (float3x3) HeadWorld));
	//		}
				
	//	}
	//	else if (input.Pos.z < -90 && input.Pos.x > -10)
	//	{
	//		if (cos(Time.x + 30) < 0)
	//		{
	//			outVS.Pos = mul(float4(input.Pos, 1), HeadmHeadWorldViewProjection);
	//			vNormalWorldSpace = normalize(mul(input.Norm, (float3x3) HeadWorld));
	//		}
	//		else
	//		{
	//			outVS.Pos = mul(float4(input.Pos, 1), WorldViewProj);
	//			vNormalWorldSpace = normalize(mul(input.Norm, (float3x3) HeadWorld));
	//		}
	//	}
	//	else
	//	{
	//		outVS.Pos = mul(float4(input.Pos, 1), WorldViewProj);
	//		vNormalWorldSpace = normalize(mul(input.Norm, ((float3x3) World)));
	//	}
	//}
	//else
	//{
	//	outVS.Pos = mul(float4(input.Pos, 1), WorldViewProj);
	//	vNormalWorldSpace = normalize(mul(input.Norm, ((float3x3) World)));
	//}
	
	//mouth open and close
	if (HeadRotate.x == 1)
	{
		if (input.Pos.z > 185 && input.Pos.z < 190 && tan(Time.x * 5) < 0)
		{
			outVS.Pos = mul(float4(input.Pos, 1), HeadmHeadWorldViewProjection);
			vNormalWorldSpace = normalize(mul(input.Norm, (float3x3) HeadWorld));
			outVS.Pos +=  float4(vNormalWorldSpace, 0);
		}
		else
		{
			outVS.Pos = mul(float4(input.Pos, 1), WorldViewProj);
			vNormalWorldSpace = normalize(mul(input.Norm, ((float3x3) World)));
			outVS.Pos += float4(vNormalWorldSpace, 0);
		}
       
	}
	else
	{
		outVS.Pos = mul(float4(input.Pos, 1), WorldViewProj);
		vNormalWorldSpace = normalize(mul(input.Norm, ((float3x3) World)));
		outVS.Pos += float4(vNormalWorldSpace, 0);
	}
	
	float fLighting = saturate(dot(vNormalWorldSpace, vLightDir));
	outVS.Diffuse.rgb = fLighting;
	outVS.Diffuse.a = 1.0f;
	outVS.Tex = input.Tex;
	return outVS;
}




//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
    //calculate lighting assuming light color is <1,1,1,1>
	float4 outputColor = txDiffuse.Sample(samLinear, input.Tex) * input.Diffuse;
	outputColor.a = 1;
	return outputColor;
}
