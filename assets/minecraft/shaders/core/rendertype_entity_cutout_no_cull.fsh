#version 150

#moj_import <fog.glsl>
#moj_import <light.glsl>

#define RES 64
#define IS_LEATHER_LAYER texelFetch(Sampler0, ivec2(0, 1), 0) == vec4(1)

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;
in vec4 Color;
in vec3 Normal;

in float vertexDistance;
in vec4 vertexColor;
in vec4 vertexColor2;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec4 normal;
flat in vec4 tint;

out vec4 fragColor;

void main() {
	ivec2 atlasSize = textureSize(Sampler0, 0);
	float armorAmount = atlasSize.x / atlasSize.y;
	float resolution = atlasSize.y;

	vec2 coords = texCoord0;
	int flag = 0;
	
	vec4 color = texture(Sampler0, texCoord0);

	if (IS_LEATHER_LAYER) {

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