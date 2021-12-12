Shader "Chapter6/DiffusePixelLevel"
{
    Properties
    {
        _Diffuse("Diffuse", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Pass
        {
            // LightMode是Pass标签中的一种，用于定义该Pass在Unity的光照流水线中的角色。
            // 只有定义了正确的LightMode，才能得到一些Unity的内置光照变量。
            Tags {"LightMode" = "ForwardBase"}
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"   // 同为需要Unity的一些内置变量

            fixed4 _Diffuse;            // 材质的漫反射属性

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed3 worldNormal: TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));   // 获得世界空间的模型法线

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldNormal = normalize(i.worldNormal);

                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
                
                fixed3 color = ambient + diffuse;
                
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
