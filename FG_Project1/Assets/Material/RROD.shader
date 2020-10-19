// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RROD"
{
	Properties
	{
		_T_Clouds_2("T_Clouds_2", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_T_Ice_Stripes("T_Ice_Stripes", 2D) = "white" {}
		_T_Ice_Stripes3("T_Ice_Stripes", 2D) = "white" {}
		_T_Ice_Stripes1("T_Ice_Stripes", 2D) = "white" {}
		_T_Ice_Stripes2("T_Ice_Stripes", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
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

		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Ice_Stripes2);
		SamplerState sampler_T_Ice_Stripes2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Ice_Stripes3);
		SamplerState sampler_T_Ice_Stripes3;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Ice_Stripes1);
		SamplerState sampler_T_Ice_Stripes1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Ice_Stripes);
		SamplerState sampler_T_Ice_Stripes;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Clouds_2);
		SamplerState sampler_T_Clouds_2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TextureSample0);
		SamplerState sampler_TextureSample0;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color71 = IsGammaSpace() ? float4(1,0.3178913,0,0) : float4(1,0.08241221,0,0);
			float2 panner91 = ( 1.0 * _Time.y * float2( -0.2,-0.2 ) + i.uv_texcoord);
			float2 panner95 = ( 1.0 * _Time.y * float2( 0.1,0.3 ) + i.uv_texcoord);
			float2 panner66 = ( 1.0 * _Time.y * float2( -0.5,-1 ) + i.uv_texcoord);
			float2 panner67 = ( 1.0 * _Time.y * float2( 0.5,0.5 ) + i.uv_texcoord);
			float4 tex2DNode63 = SAMPLE_TEXTURE2D( _T_Ice_Stripes, sampler_T_Ice_Stripes, panner67 );
			float4 color60 = IsGammaSpace() ? float4(0.972549,0.1626206,0.007843129,0) : float4(0.9386859,0.02262946,0.0006070533,0);
			float2 panner54 = ( 1.0 * _Time.y * float2( -0.1,0.5 ) + i.uv_texcoord);
			float4 tex2DNode52 = SAMPLE_TEXTURE2D( _T_Clouds_2, sampler_T_Clouds_2, panner54 );
			float2 break19_g2 = float2( 0,0.1 );
			float temp_output_1_0_g2 = _Time.y;
			float sinIn7_g2 = sin( temp_output_1_0_g2 );
			float sinInOffset6_g2 = sin( ( temp_output_1_0_g2 + 1.0 ) );
			float lerpResult20_g2 = lerp( break19_g2.x , break19_g2.y , frac( ( sin( ( ( sinIn7_g2 - sinInOffset6_g2 ) * 91.2228 ) ) * 43758.55 ) ));
			float2 panner55 = ( ( lerpResult20_g2 + sinIn7_g2 ) * float2( 0.1,0.2 ) + i.uv_texcoord);
			float temp_output_58_0 = ( tex2DNode52.r * SAMPLE_TEXTURE2D( _TextureSample0, sampler_TextureSample0, panner55 ).r );
			o.Emission = ( ( ( 10.0 * color71 ) * ( ( SAMPLE_TEXTURE2D( _T_Ice_Stripes2, sampler_T_Ice_Stripes2, panner91 ) + SAMPLE_TEXTURE2D( _T_Ice_Stripes3, sampler_T_Ice_Stripes3, panner95 ) ) * ( SAMPLE_TEXTURE2D( _T_Ice_Stripes1, sampler_T_Ice_Stripes1, panner66 ).r + tex2DNode63.r ) ) ) + ( 3.0 * ( color60 * temp_output_58_0 ) ) ).rgb;
			o.Alpha = temp_output_58_0;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
438;618.6667;1850;1003;-424.4517;420.0401;1.700366;True;True
Node;AmplifyShaderEditor.SimpleTimeNode;82;-1169.185,775.7685;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;94;-1285.957,-714.733;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-1066.565,354.8956;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-1059.415,628.4516;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;-1249.876,-456.6703;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-1229.83,-225.9776;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-1260.699,37.43997;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;83;-885.7622,885.854;Inherit;False;Noise Sine Wave;-1;;2;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT;0;False;2;FLOAT2;0,0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;67;-927.2232,37.43991;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;66;-941.6288,-236.2673;Inherit;False;3;0;FLOAT2;0,0.5;False;2;FLOAT2;-0.5,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;54;-740.3448,354.7443;Inherit;False;3;0;FLOAT2;0,0.5;False;2;FLOAT2;-0.1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;55;-725.9391,628.4515;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;91;-961.6753,-466.96;Inherit;False;3;0;FLOAT2;0,0.5;False;2;FLOAT2;-0.2,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;95;-952.4802,-714.7332;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;53;-479.2501,582.6777;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;False;-1;a48388a484839cc4aaaa84ef90b7fa0c;a48388a484839cc4aaaa84ef90b7fa0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;52;-475.1678,323.7765;Inherit;True;Property;_T_Clouds_2;T_Clouds_2;0;0;Create;True;0;0;False;0;False;-1;a48388a484839cc4aaaa84ef90b7fa0c;a48388a484839cc4aaaa84ef90b7fa0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;-601.2855,7.582115;Inherit;True;Property;_T_Ice_Stripes;T_Ice_Stripes;2;0;Create;True;0;0;False;0;False;-1;1f5046feb96a2e847b22952ec4098a11;1f5046feb96a2e847b22952ec4098a11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;96;-626.5426,-744.5909;Inherit;True;Property;_T_Ice_Stripes3;T_Ice_Stripes;3;0;Create;True;0;0;False;0;False;-1;1f5046feb96a2e847b22952ec4098a11;1f5046feb96a2e847b22952ec4098a11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;92;-619.0976,-497.8094;Inherit;True;Property;_T_Ice_Stripes2;T_Ice_Stripes;5;0;Create;True;0;0;False;0;False;-1;1f5046feb96a2e847b22952ec4098a11;1f5046feb96a2e847b22952ec4098a11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;68;-599.051,-267.1167;Inherit;True;Property;_T_Ice_Stripes1;T_Ice_Stripes;4;0;Create;True;0;0;False;0;False;-1;1f5046feb96a2e847b22952ec4098a11;1f5046feb96a2e847b22952ec4098a11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;93;124.6659,-464.376;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;80;907.2866,-372.1741;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;71;872.9625,-240.8649;Inherit;False;Constant;_Color1;Color 1;4;0;Create;True;0;0;False;0;False;1,0.3178913,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;60;414.2145,278.7528;Inherit;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;False;0;False;0.972549,0.1626206,0.007843129,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;101;496.6188,1.217361;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;491.4027,511.1259;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;745.7737,419.1972;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;951.4729,-7.163851;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;1131.904,-292.155;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;61;843.7866,287.5447;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;False;3;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;1353.612,-36.57738;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;1127.358,400.6282;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;1902.657,378.3882;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;17.96297,142.2629;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2114.467,332.1179;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RROD;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;83;1;82;0
WireConnection;67;0;65;0
WireConnection;66;0;64;0
WireConnection;54;0;56;0
WireConnection;55;0;57;0
WireConnection;55;1;83;0
WireConnection;91;0;90;0
WireConnection;95;0;94;0
WireConnection;53;1;55;0
WireConnection;52;1;54;0
WireConnection;63;1;67;0
WireConnection;96;1;95;0
WireConnection;92;1;91;0
WireConnection;68;1;66;0
WireConnection;93;0;92;0
WireConnection;93;1;96;0
WireConnection;101;0;68;1
WireConnection;101;1;63;1
WireConnection;58;0;52;1
WireConnection;58;1;53;1
WireConnection;59;0;60;0
WireConnection;59;1;58;0
WireConnection;97;0;93;0
WireConnection;97;1;101;0
WireConnection;79;0;80;0
WireConnection;79;1;71;0
WireConnection;70;0;79;0
WireConnection;70;1;97;0
WireConnection;62;0;61;0
WireConnection;62;1;59;0
WireConnection;73;0;70;0
WireConnection;73;1;62;0
WireConnection;81;0;63;1
WireConnection;81;1;52;2
WireConnection;0;2;73;0
WireConnection;0;9;58;0
ASEEND*/
//CHKSM=9C30CB065A9239AC1BD5793238DDD84C8EFE2E01