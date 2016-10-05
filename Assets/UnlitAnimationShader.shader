Shader "Unlit/Animation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_FrameCount("FrameCount", float) = 1
		_WaitTime("WaitTime", float) = 1
		_Speed("Speed", float) = 1
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _FrameCount;
			float _WaitTime;
			float _t;
			float _Speed;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				if ((_WaitTime * _Speed) != 0)
				{
					float t_w = trunc(_Time.y * _Speed % (_WaitTime * _Speed));
					if (t_w == 0)
					{
						_t = trunc(_Time.y * _FrameCount * _Speed % _FrameCount);
					}
					else {

						_t = 0;
					}
				}
				else 
				{
					_t = trunc(_Time.y * _FrameCount * _Speed  % _FrameCount);
				}

				fixed4 col = tex2D(_MainTex, float2(i.uv.x / _FrameCount + (1.0 / _FrameCount * _t) , i.uv.y));
				return col;
			}

			ENDCG
		}
	}
}
