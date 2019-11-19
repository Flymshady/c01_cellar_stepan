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

uniform sampler2D depthTexture;
uniform sampler2D texture1;
uniform int mode;



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
	vec4 finalColor = ambient +diffuse +specular;
	//	tohle uz nwm co je tk to ne
	//vec4(vertColor, 1.0);

	float zL = texture(depthTexture, depthTextureCoord.xy).r; // R G i B jsou stejne ptze .zzz
	float zA = depthTextureCoord.z;

	vec4 normalColor = vec4 (normalize(normal), 1.0);
	vec4 textureCoordColor = vec4(texCoord,1,1);
	vec4 depthColor4 = vec4(depthColor,1);
	vec4 vertColor4 = vec4(vertColor,1);
	vec4 color = pos4.rgba;

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
		case 6: //depthColor
		if(shadow) {
			outColor = ambient *vertColor4;
		}else {
			outColor=color * finalColor;
		}
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


	// outColor = vec4 (normalize(normal), 1.0); //zobrazeni normaly do textury
	// outColor = depthTextureCoord;

} 
