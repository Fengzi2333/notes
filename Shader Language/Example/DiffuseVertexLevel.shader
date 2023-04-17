// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unity Shaders Book/Chapter 6/ Diffuse Vertex-Level"{
    Properties{
        _Diffuse("Diffuse",Color)=(1,1,1,1)
    }
    SubShader{
        Pass{
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            fixed4 _Diffuse;
            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };
            struct v2f{
                float4 pos:SV_POSITION;
                fixed3 color:COLOR;
            };
            v2f vert(a2v v){
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                //get ambient term
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
                //tranform normal from object space to world space
                fixed3 worldNormal=normalize(mul(v.normal,(float3x3)unity_WorldToObject));
                //get light direction in world space
                fixed3 worldLight=normalize(_WorldSpaceLightPos0.xyz);
                //compute diffuse term
                fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal,worldLight));
                o.color=ambient+diffuse;
                return o;
            }
            fixed4 frag(v2f i):SV_TARGET{
                return fixed4(i.color,1.0);
            }
            ENDCG
        }
    }
    Fallback "DifFuse"
}