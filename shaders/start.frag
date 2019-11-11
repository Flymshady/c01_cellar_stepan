#version 150

out vec4 outColor; // output from the fragment shader
in vec3 vertColor; // bud ev projektu
in vec3 normal;
in vec3 light;
in vec3 viewDirection;
in vec4 depthTextureCoord;
in vec2 texCoord;

uniform sampler2D depthTexture;
uniform sampler2D texture1;



void main() {

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

	bool shadow = zL < zA - 0.001; //0.0001 =bias
	if(shadow) {
		outColor = ambient *textureColor;
		//vec4(1,0,0,1);
	}else{
		outColor=textureColor * finalColor;
		//=vec4(0,1,0,1);
	}

	// outColor = vec4 (normalize(normal), 1.0); //zobrazeni normaly do textury
	// outColor = depthTextureCoord;

} 
