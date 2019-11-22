#version 150

out vec4 outColor;
in vec3 vertColor;
in vec3 normal;
in vec3 light;
in vec3 viewDirection;
in vec4 depthTextureCoord;
in vec2 texCoord;
in vec3 depthColor;
in vec4 pos4;
in float intensity;

uniform sampler2D depthTexture;
uniform sampler2D texture1;
uniform int mode;
uniform int blinn_phong;
uniform float type;



void main() {
	float bias = 0.0005*tan(acos(dot(normalize(normal), normalize(light))));
	vec4 ambient = vec4(0.2,0,0,1);
	float NdotL = max(0,dot(normalize(normal), normalize(light)));
	vec4 diffuse = vec4(NdotL*vec3(0,0.8,0),1);
	vec3 halfVector = normalize(normalize(light)+normalize(viewDirection));
	float NdotH = dot(normalize(normal), halfVector);
	vec4 specular = vec4(pow(NdotH, 16)*vec3(0,0,0.8),1);
	vec4 textureColor =texture(texture1, texCoord);

	//odkomentovat svetlo
	vec4 finalColor;
	if(blinn_phong==1){
		finalColor = ambient +diffuse +specular;
	}else {
		finalColor=vec4(1,1,1,1);

	}
	//	tohle uz nwm co je tk to ne
	//vec4(vertColor, 1.0);

	float zL = texture(depthTexture, depthTextureCoord.xy).r; // R G i B jsou stejne ptze .zzz
	float zA = depthTextureCoord.z;

	vec4 normalColor = vec4 (normalize(normal), 1.0);
	vec4 textureCoordColor = vec4(texCoord,1,1);
	vec4 depthColor4 = vec4(depthColor,1);
	vec4 vertColor4 = vec4(vertColor,1);
	vec4 color = vec4(0,1,0,1);

	bool shadow = zL < zA - bias;

	switch(mode){
		case 1: //texture
			if(shadow) {
			outColor = ambient *textureColor;
			//vec4(1,0,0,1);
			}else {
				outColor=textureColor * finalColor;
				//=vec4(0,1,0,1);
			}
		break;
		case 2: //normal
			if(shadow) {
			outColor = ambient *normalColor;
			}else {
			outColor=normalColor * finalColor;
			}

		break;
		case 3: //textureCoord
		if(shadow) {
			outColor = ambient *textureCoordColor;
		}else {
			outColor=textureCoordColor * finalColor;
		}
		break;
		case 4: //vertexColor

		if(shadow) {
			outColor = ambient *vertColor4;
		}else {
			outColor= vertColor4 * finalColor;
		}
		break;
		case 5: //depthColor
		if(shadow) {
			outColor = ambient *depthColor4;
		}else {
			outColor=depthColor4 * finalColor;
		}
		break;
		case 6: //color
		if(shadow) {
			outColor = ambient *vertColor4;
		}else {
			outColor=color * finalColor;
		}
		break;
		case 7: //per vertex
		if(intensity>0.95) color=vec4(1.0,0.5,0.5,1.0);
		else if(intensity>0.8) color=vec4(0.6,0.3,0.3,1.0);
		else if(intensity>0.5) color=vec4(0.0,0.0,3.0,1.0);
		else if(intensity>0.25) color=vec4(0.4,0.2,0.2,1.0);
		else color=vec4(0.2,0.1,0.1,1.0);
		outColor = vec4(color);
		break;

		case 8: //per pixel
		float intensityPP = dot(normalize(light), normalize(normal));
		if(intensityPP>0.95) color=vec4(1.0,0.5,0.5,1.0);
		else if(intensityPP>0.8) color=vec4(0.6,0.3,0.3,1.0);
		else if(intensityPP>0.5) color=vec4(0.0,0.0,3.0,1.0);
		else if(intensityPP>0.25) color=vec4(0.4,0.2,0.2,1.0);
		else color=vec4(0.2,0.1,0.1,1.0);
		outColor = vec4(color);
		break;

		default:
			if(shadow) {
			outColor = ambient *textureColor;
			//vec4(1,0,0,1);
			}else {
			outColor=textureColor * finalColor;
			//=vec4(0,1,0,1);
			}
	}

	if(type==7){
		outColor=vec4(1,1,1,1);
	}
	// outColor = vec4 (normalize(normal), 1.0); //zobrazeni normaly do textury
	// outColor = depthTextureCoord;

} 
