cbuffer Uniforms : register(b0)
{
  float4 State;
  matrix Transform;
  float4 Scalar4[2];
  float4 Vector[8];
  uint ClipSize;
  matrix Clip[8];
};

bool SnapEnabled() { return bool(uint(State[0] + 0.5)); }
float ScreenWidth() { return State[1]; }
float ScreenHeight() { return State[2]; }
float Scalar(int i) { if (i < 4) return Scalar4[0][i]; else return Scalar4[1][i - 4]; }
float4 sRGBToLinear(float4 val) { return float4(val.xyz * (val.xyz * (val.xyz * 0.305306011 + 0.682171111) + 0.012522878), val.w); }

struct VS_OUTPUT
{
  float4 Position    : SV_POSITION;
  float4 Color       : COLOR0;
  float2 TexCoord    : TEXCOORD0;
  float4 Data0       : COLOR1;
  float4 Data1       : COLOR2;
  float4 Data2       : COLOR3;
  float4 Data3       : COLOR4;
  float4 Data4       : COLOR5;
  float4 Data5       : COLOR6;
  float4 Data6       : COLOR7;
  float2 ObjectCoord : TEXCOORD1;
  float2 ScreenCoord : TEXCOORD2;
};

void SnapToScreen(inout float4 pos)
{
  pos.xy += 1.0;
  pos.xy /= 2.0;
  pos.xy *= float2(ScreenWidth(), ScreenHeight());
  pos.x = round(pos.x);
  pos.y = round(pos.y);
  pos.xy /= float2(ScreenWidth(), ScreenHeight());
  pos.xy *= 2.0;
  pos.xy -= 1.0;
}

VS_OUTPUT VS(float2 Position : POSITION,
             uint4  Color    : COLOR0,
             float2 TexCoord : TEXCOORD0,
             float2 ObjCoord : TEXCOORD1,
             float4 Data0    : COLOR1,
			       float4 Data1    : COLOR2,
             float4 Data2    : COLOR3,
             float4 Data3    : COLOR4,
             float4 Data4    : COLOR5,
             float4 Data5    : COLOR6,
             float4 Data6    : COLOR7)
{
  VS_OUTPUT output;
  output.ObjectCoord = ObjCoord;
  output.Position = mul(Transform, float4(Position, 0.0, 1.0));
  if (SnapEnabled())
    SnapToScreen(output.Position);
  output.Color = sRGBToLinear(float4(Color) / 255.0);
  output.TexCoord = TexCoord;
  output.Data0 = Data0;
  output.Data1 = Data1;
  output.Data2 = Data2;
  output.Data3 = Data3;
  output.Data4 = Data4;
  output.Data5 = Data5;
  output.Data6 = Data6;
  return output;
}