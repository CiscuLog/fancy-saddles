#version 150

#moj_import <fog.glsl>

#define RES 64
#define IS_LEATHER_LAYER texelFetch(Sampler0, ivec2(0,1),0) == vec4(1)
#define IS_WOLF_ARMOR texelFetch(Sampler0, ivec2(0,1),0) == vec4(0.0,0.0,0.0,1.0)

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 vertexColor2;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
flat in vec4 tint;

out vec4 fragColor;

void main() {
	
	vec4 color = texture(Sampler0, texCoord0);


	int flag = 0;
	ivec2 atlasSize = ivec2(0);
	float armorAmount = 0;
	float resolution = 0;
	vec2 coords = vec2(0);
	if (IS_LEATHER_LAYER) {
	
		atlasSize = textureSize(Sampler0, 0);
		armorAmount = atlasSize.x / atlasSize.y;
		resolution = atlasSize.y;

		coords = texCoord0;

		coords.x /= armorAmount;
        int i = 0;
        for(i = 0; i<armorAmount;i++){
            vec4 customColor = texelFetch(Sampler0,ivec2(i*resolution,0),0);
            if(tint.rgb == customColor.rgb){
                flag = 1;
                coords.x += i/armorAmount;
                break;
            }
        }
        
        color = texture(Sampler0,coords);
	}
	if (IS_WOLF_ARMOR){
		atlasSize = textureSize(Sampler0, 0);
		armorAmount = atlasSize.x / atlasSize.y / 2;
		resolution = atlasSize.y*2;

		coords = texCoord0;

		coords.x /= armorAmount;
        int i = 0;
        for(i = 0; i<armorAmount;i++){
            vec4 customColor = texelFetch(Sampler0,ivec2(i*resolution,0),0);
            if(tint.rgb == customColor.rgb){
                flag = 1;
                coords.x += i/armorAmount;
                break;
            }
        }
        color = texture(Sampler0,coords);
	}
	if (flag == 1){
		color *= vertexColor2 * ColorModulator;
	}
	if (flag == 0){
		color *= vertexColor * ColorModulator;
	}
    if (color.a < 0.1) {
        discard;
    }
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
    color *= lightMapColor;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
