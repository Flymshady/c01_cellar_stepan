#version 150
in vec2 inPosition; // input from the vertex buffer

uniform mat4 view;
uniform mat4 projection;
uniform float time;
uniform mat4 lightViewProjection;
uniform float type;

//out vec3  vertColor; //bud ev projektu
out vec3 normal;
out vec3 light;
out vec3 viewDirection;
out vec4 depthTextureCoord;
out vec2 texCoord;

float getZ(vec2 vec) {
	return sin(time + vec.y * 3.14 *2)-1.5;
}
vec3 getVlnka(vec2 vec){
	float x= vec.x;
	float y=vec.y;
	float z = getZ(vec);

	return vec3(x,y,z);
}


// udelat taj dalsi objekt
vec3 getSphere2(vec2 vec) {
	float az = vec.x * 3.14;
	float ze = vec.y * 3.14 / 2;
	float r = 1;

	float x = r*cos(az)*cos(ze);
	float y = 2* r*sin(az)*cos(ze); //2pryc
	float z = 0.5 * r*sin(ze) +1.5; //0.5pryc

	return vec3(x,y,z);
}

vec3 getSphere(vec2 vec) {
	float az = vec.x * 3.14;
	float ze = vec.y * 3.14 / 2;
	float r = 1;

	float x = r*cos(az)*cos(ze);
	float y = 2* r*sin(az)*cos(ze); //2pryc
	float z = 0.5 * r*sin(ze); //0.5pryc

	return vec3(x,y,z);
}
//a taj taky to samy jinak
vec3 getSphereNormal(vec2 vec){
	vec3 u = getSphere(vec+vec2(0.001, 0))
	- getSphere(vec-vec2(0.001,0));

	vec3 v = getSphere(vec+vec2(0, 0.001))
	- getSphere(vec-vec2(0, 0.001));

	return cross(u,v); //vektorovy soucin
}

vec3 getSphere2Normal(vec2 vec){
	vec3 u = getSphere(vec+vec2(0.001, 0))
	- getSphere(vec-vec2(0.001,0));

	vec3 v = getSphere(vec+vec2(0, 0.001))
	- getSphere(vec-vec2(0, 0.001));

	return cross(u,v); //vektorovy soucin
}

vec3 getVlnkaNormal(vec2 vec){
	vec3 u = getVlnka(vec+vec2(0.001, 0))
	- getVlnka(vec-vec2(0.001,0));

	vec3 v = getVlnka(vec+vec2(0, 0.001))
	- getVlnka(vec-vec2(0, 0.001));

	return cross(u,v); //vektorovy soucin
}

void main() {
	vec2 position;
	vec4 pos4;
	if(type==0){
		//metoda na rozvetveni objektu pres type == 1 ...

		position = inPosition * 2 - 1;
		//  vec4 pos4 = vec4(position, getZ(position), 1.0);
		pos4 = vec4(getSphere(position), 1.0);
		gl_Position = projection * view * pos4;
		//vec4(position, getZ(position) , 1.0);

		// vercol v projektu bude
		// vertColor = pos4.xyz;

		normal = mat3(view)* getSphereNormal(position);
	}
	if(type==1){
		//metoda na rozvetveni objektu pres type == 1 ...

		position = inPosition * 2 - 1;
		//  vec4 pos4 = vec4(position, getZ(position), 1.0);
		pos4 = vec4(getSphere2(position), 1.0);
		gl_Position = projection * view * pos4;
		//vec4(position, getZ(position) , 1.0);

		// vercol v projektu bude
		// vertColor = pos4.xyz;

		normal = mat3(view)* getSphere2Normal(position);




	}
	if(type==2){
		position = inPosition * 2 - 1;
		vec4(position, getZ(position) , 1.0);
		pos4 = vec4(position, getZ(position), 1.0);
		gl_Position = projection * view * pos4;
		normal = mat3(view)* getVlnkaNormal(position);


	}
	vec3 lightPos = vec3(1, 1, 0);
	light = lightPos - (view * pos4).xyz;

	texCoord = inPosition;

	viewDirection = -(view* pos4).xyz;
	depthTextureCoord = lightViewProjection * pos4;
	depthTextureCoord.xyz = depthTextureCoord.xyz/depthTextureCoord.w;
	depthTextureCoord.xyz = (depthTextureCoord.xyz + 1) / 2;




} 
