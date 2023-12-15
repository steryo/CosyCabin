Shader "Billboard"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent+500" }
        LOD 100

        Pass
        {
        
            ZTest Off
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 color : COLOR0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
            UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert (appdata v)
            {
                v2f o;

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);

                float4 worldOrigin = mul(UNITY_MATRIX_M, float4(0, 0, 0, 1));
                float4 viewOrigin = float4(UnityObjectToViewPos(float3(0, 0, 0)), 1);
                float4 worldPos = mul(UNITY_MATRIX_M, v.vertex);

                float4 viewPos = worldPos - worldOrigin + viewOrigin;

                float4 clipsPos = mul(UNITY_MATRIX_P, viewPos);
                o.vertex = clipsPos;

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = UNITY_ACCESS_INSTANCED_PROP(Props, _Color) * tex2D(_MainTex, i.uv);
                UNITY_APPLY_FOG(i.fogCoord, col);
                UNITY_SETUP_INSTANCE_ID(i);

                return col;

            }
            ENDCG
        }
    }
}