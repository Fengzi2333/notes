// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unity Shaders Book/Chapter 6/ Diffuse Pixel-Level"{
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
                //fixed3 color:COLOR;
                float3 worldNormal:TEXCOORD0;
            };
            v2f vert(a2v v){
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                //tranform normal from object space to world space
                o.worldNormal=mul(v.normal,(float3x3)unity_WorldToObject);                
                return o;
            }
            fixed4 frag(v2f i):SV_TARGET{
                //get ambient term
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
                //get the normal in world space
                fixed3 worldNormal=normalize(i.worldNormal);
                //get light direction in world space
                fixed3 worldLight=normalize(_WorldSpaceLightPos0.xyz);
                //compute diffuse term
                fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal,worldLight));
                fixed3 color=ambient+diffuse;
                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
    Fallback "DifFuse"
}