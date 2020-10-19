// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ice_Shader"
{
	Properties
	{
		_T_Ice_TopSnow("T_Ice_TopSnow", 2D) = "white" {}
		_T_Ice_Stripes("T_Ice_Stripes", 2D) = "white" {}
		_T_Clouds_2("T_Clouds_2", 2D) = "white" {}
		_gradient_Circle("gradient_Circle", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,0)
		_Str("Str", Float) = 2
		_Opacity("Opacity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
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

		uniform float4 _Color;
		uniform float _Str;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Ice_Stripes);
		uniform float4 _T_Ice_Stripes_ST;
		SamplerState sampler_T_Ice_Stripes;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Clouds_2);
		SamplerState sampler_T_Clouds_2;
		uniform float4 _T_Clouds_2_ST;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_T_Ice_TopSnow);
		uniform float4 _T_Ice_TopSnow_ST;
		SamplerState sampler_T_Ice_TopSnow;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_gradient_Circle);
		SamplerState sampler_gradient_Circle;
		uniform float4 _gradient_Circle_ST;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_T_Ice_Stripes = i.uv_texcoord * _T_Ice_Stripes_ST.xy + _T_Ice_Stripes_ST.zw;
			float4 color7 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float2 uv_T_Clouds_2 = i.uv_texcoord * _T_Clouds_2_ST.xy + _T_Clouds_2_ST.zw;
			float4 tex2DNode3 = SAMPLE_TEXTURE2D( _T_Clouds_2, sampler_T_Clouds_2, uv_T_Clouds_2 );
			float4 color4 = IsGammaSpace() ? float4(0.6855345,0.9585036,1,0) : float4(0.4276641,0.908186,1,0);
			o.Emission = ( _Color * ( _Str * ( ( SAMPLE_TEXTURE2D( _T_Ice_Stripes, sampler_T_Ice_Stripes, uv_T_Ice_Stripes ) + color7 ) * ( tex2DNode3.g * color4 ) ) ) ).rgb;
			o.Specular = color7.rgb;
			float2 uv_T_Ice_TopSnow = i.uv_texcoord * _T_Ice_TopSnow_ST.xy + _T_Ice_TopSnow_ST.zw;
			o.Smoothness = ( 1.0 - SAMPLE_TEXTURE2D( _T_Ice_TopSnow, sampler_T_Ice_TopSnow, uv_T_Ice_TopSnow ) ).r;
			float2 uv_gradient_Circle = i.uv_texcoord * _gradient_Circle_ST.xy + _gradient_Circle_ST.zw;
			o.Alpha = ( (0.0 + (( SAMPLE_TEXTURE2D( _gradient_Circle, sampler_gradient_Circle, uv_gradient_Circle ).r * tex2DNode3.r ) - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) * _Opacity );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

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
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
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
136;561.3334;1850;751.6667;545.7391;416.5273;1.3;True;True
Node;AmplifyShaderEditor.SamplerNode;3;-769.6005,323.8977;Inherit;True;Property;_T_Clouds_2;T_Clouds_2;2;0;Create;True;0;0;False;0;False;-1;a48388a484839cc4aaaa84ef90b7fa0c;a48388a484839cc4aaaa84ef90b7fa0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-1161.674,-310.7875;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;False;0.6855345,0.9585036,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-841.6798,-531.11;Inherit;True;Property;_T_Ice_Stripes;T_Ice_Stripes;1;0;Create;True;0;0;False;0;False;-1;1f5046feb96a2e847b22952ec4098a11;1f5046feb96a2e847b22952ec4098a11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-309.0326,-81.93515;Inherit;False;Constant;_Color1;Color 1;4;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-526.9276,-157.2711;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-366.2969,-546.4508;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-1029.601,136.6977;Inherit;True;Property;_gradient_Circle;gradient_Circle;3;0;Create;True;0;0;False;0;False;-1;c6adeecc4728fd9499963762df89f3b2;c6adeecc4728fd9499963762df89f3b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;248.1245,-358.3634;Inherit;False;Property;_Str;Str;5;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-451.0012,132.2978;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-77.29688,-357.4508;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;402.2682,-138.9911;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;19;455.4696,-417.3474;Inherit;False;Property;_Color;Color;4;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;12;380.451,131.1806;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1161.673,-131.1701;Inherit;True;Property;_T_Ice_TopSnow;T_Ice_TopSnow;0;0;Create;True;0;0;False;0;False;-1;c7dca8b56826c1b488f54304a42f456c;c7dca8b56826c1b488f54304a42f456c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;438.3608,406.3727;Inherit;False;Property;_Opacity;Opacity;6;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;849.2314,246.5979;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;699.4696,-138.3474;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;18;-720.6967,-1.818481;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1044.766,-77.38486;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Ice_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;3;2
WireConnection;8;1;4;0
WireConnection;16;0;2;0
WireConnection;16;1;7;0
WireConnection;5;0;6;1
WireConnection;5;1;3;1
WireConnection;13;0;16;0
WireConnection;13;1;8;0
WireConnection;17;0;10;0
WireConnection;17;1;13;0
WireConnection;12;0;5;0
WireConnection;21;0;12;0
WireConnection;21;1;22;0
WireConnection;20;0;19;0
WireConnection;20;1;17;0
WireConnection;18;0;1;0
WireConnection;0;2;20;0
WireConnection;0;3;7;0
WireConnection;0;4;18;0
WireConnection;0;9;21;0
ASEEND*/
//CHKSM=3D34DE52135F046416FDB3F13FCA9CE669413F14