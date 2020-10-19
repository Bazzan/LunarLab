// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GravityFlow"
{
	Properties
	{
		_T_Clouds_2("T_Clouds_2", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_T_Ice_Stripes("T_Ice_Stripes", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Vector0("Vector 0", Vector) = (1,1,0,0)
		_gradient_Circle("gradient_Circle", 2D) = "white" {}
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
			float3 worldPos;
			float2 uv_texcoord;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_TextureSample1);
		SamplerState sampler_TextureSample1;
		uniform float2 _Vector0;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Ice_Stripes);
		SamplerState sampler_T_Ice_Stripes;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Clouds_2);
		SamplerState sampler_T_Clouds_2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TextureSample0);
		SamplerState sampler_TextureSample0;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_gradient_Circle);
		uniform float4 _gradient_Circle_ST;
		SamplerState sampler_gradient_Circle;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color71 = IsGammaSpace() ? float4(0.7610062,0.9950219,1,0) : float4(0.5398318,0.9887129,1,0);
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_90_0 = ((ase_worldPos).xy*_Vector0 + 0.0);
			float2 panner66 = ( 1.0 * _Time.y * float2( -0.1,0.1 ) + temp_output_90_0);
			float2 panner67 = ( 1.0 * _Time.y * float2( 0.1,0.2 ) + temp_output_90_0);
			float4 color60 = IsGammaSpace() ? float4(0,1,0.8259592,0) : float4(0,1,0.648766,0);
			float2 panner54 = ( 1.0 * _Time.y * float2( -0.1,0.5 ) + temp_output_90_0);
			float2 break19_g2 = float2( 0,0.1 );
			float temp_output_1_0_g2 = _Time.y;
			float sinIn7_g2 = sin( temp_output_1_0_g2 );
			float sinInOffset6_g2 = sin( ( temp_output_1_0_g2 + 1.0 ) );
			float lerpResult20_g2 = lerp( break19_g2.x , break19_g2.y , frac( ( sin( ( ( sinIn7_g2 - sinInOffset6_g2 ) * 91.2228 ) ) * 43758.55 ) ));
			float2 panner55 = ( ( lerpResult20_g2 + sinIn7_g2 ) * float2( 0.1,0.2 ) + temp_output_90_0);
			float temp_output_58_0 = ( SAMPLE_TEXTURE2D( _T_Clouds_2, sampler_T_Clouds_2, panner54 ).r * SAMPLE_TEXTURE2D( _TextureSample0, sampler_TextureSample0, panner55 ).r );
			o.Emission = ( 1.0 * ( ( ( 5.0 * color71 ) * ( SAMPLE_TEXTURE2D( _TextureSample1, sampler_TextureSample1, panner66 ).r * SAMPLE_TEXTURE2D( _T_Ice_Stripes, sampler_T_Ice_Stripes, panner67 ).r ) ) + ( 3.0 * ( color60 * temp_output_58_0 ) ) ) ).rgb;
			float2 uv_gradient_Circle = i.uv_texcoord * _gradient_Circle_ST.xy + _gradient_Circle_ST.zw;
			o.Alpha = ( temp_output_58_0 * SAMPLE_TEXTURE2D( _gradient_Circle, sampler_gradient_Circle, uv_gradient_Circle ) ).r;
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
				surfIN.worldPos = worldPos;
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
200.6667;705.3334;1850;903;2654.348;-43.41093;1;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;89;-2233.118,211.2211;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;82;-1455.687,814.4543;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;91;-1940.379,210.8651;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;94;-2107.862,402.4928;Inherit;False;Property;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;False;1,1;0.1,0.03;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScaleAndOffsetNode;90;-1698.155,215.2471;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;83;-1190.261,841.3059;Inherit;False;Noise Sine Wave;-1;;2;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT;0;False;2;FLOAT2;0,0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;55;-958.4528,617.6471;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;54;-948.1132,312.4458;Inherit;False;3;0;FLOAT2;0,0.5;False;2;FLOAT2;-0.1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;66;-1466.224,-273.4966;Inherit;False;3;0;FLOAT2;0,0.5;False;2;FLOAT2;-0.1,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;67;-1408.81,-1.581399;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;52;-582.3063,286.8014;Inherit;True;Property;_T_Clouds_2;T_Clouds_2;0;0;Create;True;0;0;False;0;False;-1;a48388a484839cc4aaaa84ef90b7fa0c;a48388a484839cc4aaaa84ef90b7fa0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;53;-581.0525,586.4388;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;False;-1;a48388a484839cc4aaaa84ef90b7fa0c;a48388a484839cc4aaaa84ef90b7fa0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;68;-1123.646,-304.346;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;False;-1;1f5046feb96a2e847b22952ec4098a11;1f5046feb96a2e847b22952ec4098a11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;60;-65.94142,214.1389;Inherit;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;False;0;False;0,1,0.8259592,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;-1125.88,-29.64718;Inherit;True;Property;_T_Ice_Stripes;T_Ice_Stripes;2;0;Create;True;0;0;False;0;False;-1;1f5046feb96a2e847b22952ec4098a11;1f5046feb96a2e847b22952ec4098a11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;682.9808,-437.6538;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;71;610.81,-328.9074;Inherit;False;Constant;_Color1;Color 1;4;0;Create;True;0;0;False;0;False;0.7610062,0.9950219,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-50.93405,501.7774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-67.39487,-179.537;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;220.0081,386.7214;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;887.238,-319.9119;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;61;297.775,228.0741;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;False;3;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;596.8076,361.0879;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;1067.116,-199.2915;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;85;1447.692,161.5301;Inherit;False;Constant;_Float3;Float 3;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;1373.977,653.495;Inherit;True;Property;_gradient_Circle;gradient_Circle;5;0;Create;True;0;0;False;0;False;-1;c6adeecc4728fd9499963762df89f3b2;c6adeecc4728fd9499963762df89f3b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;73;1256.248,338.5167;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-1743.833,-92.95225;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;102;-1906.159,-252.3312;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;1674.773,324.8558;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;1679.457,469.2118;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;101;-1119.657,-513.1895;Inherit;True;Property;_TextureSample2;Texture Sample 2;6;0;Create;True;0;0;False;0;False;-1;1f5046feb96a2e847b22952ec4098a11;1f5046feb96a2e847b22952ec4098a11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-1146.214,218.7422;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2032.164,282.6403;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;GravityFlow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;91;0;89;0
WireConnection;90;0;91;0
WireConnection;90;1;94;0
WireConnection;83;1;82;0
WireConnection;55;0;90;0
WireConnection;55;1;83;0
WireConnection;54;0;90;0
WireConnection;66;0;90;0
WireConnection;67;0;90;0
WireConnection;52;1;54;0
WireConnection;53;1;55;0
WireConnection;68;1;66;0
WireConnection;63;1;67;0
WireConnection;58;0;52;1
WireConnection;58;1;53;1
WireConnection;69;0;68;1
WireConnection;69;1;63;1
WireConnection;59;0;60;0
WireConnection;59;1;58;0
WireConnection;79;0;80;0
WireConnection;79;1;71;0
WireConnection;62;0;61;0
WireConnection;62;1;59;0
WireConnection;70;0;79;0
WireConnection;70;1;69;0
WireConnection;73;0;70;0
WireConnection;73;1;62;0
WireConnection;84;0;85;0
WireConnection;84;1;73;0
WireConnection;99;0;58;0
WireConnection;99;1;100;0
WireConnection;101;1;66;0
WireConnection;92;0;90;0
WireConnection;0;2;84;0
WireConnection;0;9;99;0
ASEEND*/
//CHKSM=DFD05AB774FBD6EBAF33CF8F64549307ED8E0123