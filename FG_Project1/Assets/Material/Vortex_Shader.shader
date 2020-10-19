// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Vortex_Shader"
{
	Properties
	{
		_T_Clouds_2("T_Clouds_2", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Lightning_output("Lightning_output", 2D) = "white" {}
		_EmissionStr("Emission Str", Float) = 10
		_Color("Color", Color) = (0.1000391,0,0.3396226,0)
		_Color_Stripes("Color_Stripes", Color) = (0,0.2921473,0.5176471,0)
		_Opacity("Opacity", Float) = 0
		_Gradient_Bottom_TEST1("Gradient_Bottom_TEST 1", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _EmissionStr;
		uniform float4 _Color_Stripes;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Lightning_output);
		SamplerState sampler_Lightning_output;
		uniform float4 _Color;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Clouds_2);
		SamplerState sampler_T_Clouds_2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TextureSample0);
		SamplerState sampler_TextureSample0;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Gradient_Bottom_TEST1);
		uniform float4 _Gradient_Bottom_TEST1_ST;
		SamplerState sampler_Gradient_Bottom_TEST1;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color30 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			o.Albedo = ( color30 * 1.0 ).rgb;
			float2 uv_TexCoord19 = i.uv_texcoord * float2( 5,5 );
			float2 panner20 = ( 1.0 * _Time.y * float2( 0,-0.4 ) + uv_TexCoord19);
			float2 panner3 = ( 1.0 * _Time.y * float2( -0.05,-0.4 ) + i.uv_texcoord);
			float4 tex2DNode1 = SAMPLE_TEXTURE2D( _T_Clouds_2, sampler_T_Clouds_2, panner3 );
			float2 panner4 = ( 1.0 * _Time.y * float2( 0.05,-0.7 ) + i.uv_texcoord);
			float4 tex2DNode2 = SAMPLE_TEXTURE2D( _TextureSample0, sampler_TextureSample0, panner4 );
			float temp_output_13_0 = ( tex2DNode1.r + tex2DNode2.r );
			float temp_output_27_0 = ( temp_output_13_0 * tex2DNode2.g );
			o.Emission = ( _EmissionStr * ( ( ( _Color_Stripes * SAMPLE_TEXTURE2D( _Lightning_output, sampler_Lightning_output, panner20 ) ) * ( _Color + temp_output_27_0 ) ) + ( _Color * temp_output_13_0 ) ) ).rgb;
			float2 uv_Gradient_Bottom_TEST1 = i.uv_texcoord * _Gradient_Bottom_TEST1_ST.xy + _Gradient_Bottom_TEST1_ST.zw;
			o.Alpha = ( SAMPLE_TEXTURE2D( _Gradient_Bottom_TEST1, sampler_Gradient_Bottom_TEST1, uv_Gradient_Bottom_TEST1 ) * ( temp_output_27_0 * _Opacity ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
136;561.3334;1850;751.6667;1608.093;1024.293;1.930877;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1454.621,97.36954;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1457.306,-175.0855;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;3;-1099.076,-174.0855;Inherit;False;3;0;FLOAT2;0,0.5;False;2;FLOAT2;-0.05,-0.4;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;4;-1112.611,97.33955;Inherit;False;3;0;FLOAT2;0,0.3;False;2;FLOAT2;0.05,-0.7;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-815.6312,67.93451;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;False;-1;a48388a484839cc4aaaa84ef90b7fa0c;a48388a484839cc4aaaa84ef90b7fa0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-819.5812,-204.0855;Inherit;True;Property;_T_Clouds_2;T_Clouds_2;1;0;Create;True;0;0;False;0;False;-1;a48388a484839cc4aaaa84ef90b7fa0c;a48388a484839cc4aaaa84ef90b7fa0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-929.7254,-596.2246;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;16.20775,-56.3615;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;20;-622.4953,-593.2246;Inherit;False;3;0;FLOAT2;0,0.5;False;2;FLOAT2;0,-0.4;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;24;-326.1141,-600.0278;Inherit;True;Property;_Lightning_output;Lightning_output;3;0;Create;True;0;0;False;0;False;-1;285d15bcbe54a8a4894a815deb10a3ea;285d15bcbe54a8a4894a815deb10a3ea;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-119.6842,-860.7266;Inherit;False;Property;_Color_Stripes;Color_Stripes;6;0;Create;True;0;0;False;0;False;0,0.2921473,0.5176471,0;0,0.2921473,0.5176471,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;309.0654,548.6971;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-78.64291,-300.2487;Inherit;False;Property;_Color;Color;5;0;Create;True;0;0;False;0;False;0.1000391,0,0.3396226,0;0.1000391,0,0.3396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;26;318.1584,-25.59285;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;151.7667,-595.8991;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;426.2253,-587.7343;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;292.2838,-250.7383;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;640.1454,750.9089;Inherit;False;Property;_Opacity;Opacity;7;0;Create;True;0;0;False;0;False;0;1.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;1073.347,-344.4655;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;863.6339,-107.9289;Inherit;True;Property;_Gradient_Bottom_TEST1;Gradient_Bottom_TEST 1;8;0;Create;True;0;0;False;0;False;-1;53f8b72c648ffdd43849f8502f359b5d;53f8b72c648ffdd43849f8502f359b5d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;30;969.4363,-616.1426;Inherit;False;Constant;_Color2;Color 2;7;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;805.4975,529.2965;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;709.337,-508.6739;Inherit;False;Property;_EmissionStr;Emission Str;4;0;Create;True;0;0;False;0;False;10;2.97;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;623.7168,-277.9686;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;1289.986,-398.28;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;880.05,-303.1791;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-258.6734,-66.63355;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;1314.903,380.293;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1648.851,-39.87913;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Vortex_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;5;0
WireConnection;4;0;6;0
WireConnection;2;1;4;0
WireConnection;1;1;3;0
WireConnection;13;0;1;1
WireConnection;13;1;2;1
WireConnection;20;0;19;0
WireConnection;24;1;20;0
WireConnection;27;0;13;0
WireConnection;27;1;2;2
WireConnection;26;0;14;0
WireConnection;26;1;27;0
WireConnection;22;0;23;0
WireConnection;22;1;24;0
WireConnection;21;0;22;0
WireConnection;21;1;26;0
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;31;0;27;0
WireConnection;31;1;32;0
WireConnection;25;0;21;0
WireConnection;25;1;15;0
WireConnection;34;0;30;0
WireConnection;34;1;35;0
WireConnection;16;0;17;0
WireConnection;16;1;25;0
WireConnection;8;0;1;1
WireConnection;8;1;2;1
WireConnection;37;0;46;0
WireConnection;37;1;31;0
WireConnection;0;0;34;0
WireConnection;0;2;16;0
WireConnection;0;9;37;0
ASEEND*/
//CHKSM=D1CD6D4D3C5839C919B72F0F88D8FACA54B31F12