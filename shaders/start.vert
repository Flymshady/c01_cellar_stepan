#version 150
in vec2 inPosition; // input from the vertex buffer

uniform mat4 view;
uniform mat4 projection;
uniform float time;
uniform mat4 lightViewProjection;
uniform float type;
uniform mat4 model;

//out vec3  vertColor; //bud ev projektu
out vec3 normal;
out vec3 light;
out vec3 viewDirection;
out vec4 depthTextureCoord;
out vec2 texCoord;

vec3 getSun(vec2 vec){
	float az = vec.x * 3.14;
	float ze = vec.y * 3.14 / 2;
	float r = 1;

	float x = r*cos(az)*cos(ze);
	float y = r*sin(az)*cos(ze);
	float z = r*sin(ze)+20;

	return vec3(x,y,z);
}

vec3 getSunNormal(vec2 vec){
	vec3 u = getSun(vec+vec2(0.001, 0))
	- getSun(vec-vec2(0.001,0));
	vec3 v = getSun(vec+vec2(0, 0.001))
	- getSun(vec-vec2(0, 0.001));
	return cross(u,v);
}

vec3 getKart(vec2 vec){
	float x= 1.5*cos(vec.x*3.14)+cos(vec.y*2*3.14/2)*cos(vec.x*3.14);
	float y=2*sin(vec.x*3.14/2)+cos(vec.y*3.14/2)*sin(vec.x*3.14/2);
	float z =sin(vec.y*3.14);

	return vec3(x,y,z);
}

vec3 getKartNormal(vec2 vec){
	vec3 u = getKart(vec+vec2(0.001, 0))
	- getKart(vec-vec2(0.001,0));
	vec3 v = getKart(vec+vec2(0, 0.001))
	- getKart(vec-vec2(0, 0.001));
	return cross(u,v);
}


float getZ(vec2 vec) {
	return sin(time + vec.y * 3.14 *2);
}


vec3 getWave(vec2 vec){
	float x= vec.x;
	float y=vec.y;
	float z = getZ(vec);

	return vec3(x,y,z);
}


vec3 getDesk(vec2 vec){
	float x= vec.x;
	float y=vec.y;
	float z=1;
	return vec3(x,y,z);
}
vec3 getDeskNormal(vec2 vec){
	vec3 u = getDesk(vec+vec2(0.001, 0))
	- getDesk(vec-vec2(0.001, 0));

	vec3 v = getDesk(vec+vec2(0, 0.001))
	- getDesk(vec-vec2(0, 0.001));

	return cross(u, v);//vektorovy soucin
}

// udelat taj dalsi objekt
vec3 getElephant(vec2 vec) {
	float az = vec.x * 3.14;
	float ze = vec.y * 3.14/2;
	float r = 1+cos(4*az);

	float x = r*cos(az)*cos(ze);
	float y = r*sin(az)*cos(ze);
	float z = r*sin(ze);

	return vec3(x,y,z);
}

vec3 getMySpheric(vec2 vec) {
	float az = vec.x * 3.14;
	float ze = vec.y * 3.14 / 2;
	float r = 1+sin(ze)+cos(az);

	float x = r*cos(az)*cos(ze);
	float y = r*sin(az)*cos(ze); //2pryc
	float z = r*sin(ze); //0.5pryc

	return vec3(x,y,z);
}
//a taj taky to samy jinak
vec3 getElephantNormal(vec2 vec){
	vec3 u = getElephant(vec+vec2(0.001, 0))
	- getElephant(vec-vec2(0.001,0));

	vec3 v = getElephant(vec+vec2(0, 0.001))
	- getElephant(vec-vec2(0, 0.001));

	return cross(u,v); //vektorovy soucin
}

vec3 getMySphericNormal(vec2 vec){
	vec3 u = getMySpheric(vec+vec2(0.001, 0))
	- getMySpheric(vec-vec2(0.001,0));

	vec3 v = getMySpheric(vec+vec2(0, 0.001))
	- getMySpheric(vec-vec2(0, 0.001));

	return cross(u,v); //vektorovy soucin
}

vec3 getWaveNormal(vec2 vec){
	vec3 u = getWave(vec+vec2(0.001, 0))
	- getWave(vec-vec2(0.001,0));

	vec3 v = getWave(vec+vec2(0, 0.001))
	- getWave(vec-vec2(0, 0.001));

	return cross(u,v); //vektorovy soucin
}

vec3 getMySombrero(vec2 vec) {
	float az = vec.x*3.14/2; //theta=s
	float r = vec.y*3.14; //r=t
	float v = cos(2*r)+1;

	float x = r*cos(az);
	float y = r*sin(az);
	float z = v;

	return vec3(x,y,z);
}
vec3 getSombreroNormal(vec2 vec){
	vec3 u = getMySombrero(vec+vec2(0.001, 0))
	- getMySombrero(vec-vec2(0.001,0));

	vec3 v = getMySombrero(vec+vec2(0, 0.001))
	- getMySombrero(vec-vec2(0, 0.001));

	return cross(u,v); //vektorovy soucin
}

vec3 getMyCylindric(vec2 vec) {
	float az = vec.x*3.14;//theta=s
	float r = vec.y*3.14/2;
	float v = r;

	float x = r*cos(az);
	float y = r*sin(az);
	float z = v;

	return vec3(x, y, z);
}
vec3 getCylindricNormal(vec2 vec){
	vec3 u = getMyCylindric(vec+vec2(0.001, 0))
	- getMyCylindric(vec-vec2(0.001,0));

	vec3 v = getMyCylindric(vec+vec2(0, 0.001))
	- getMyCylindric(vec-vec2(0, 0.001));

	return cross(u,v); //vektorovy soucin
}

void main() {
	vec2 position;
	vec4 pos4;
	if(type==0){
		//metoda na rozvetveni objektu pres type == 1 ...

		position = inPosition * 2 - 1;
		//  vec4 pos4 = vec4(position, getZ(position), 1.0);
		pos4 = model*vec4(getMySpheric(position), 1.0);
		gl_Position = projection * view * pos4;
		//vec4(position, getZ(position) , 1.0);

		// vercol v projektu bude
		// vertColor = pos4.xyz;

		normal = mat3(view)* mat3(model)*getMySphericNormal(position);
	}
	if(type==1){
		//metoda na rozvetveni objektu pres type == 1 ...

		position = inPosition * 2 - 1;
		//  vec4 pos4 = vec4(position, getZ(position), 1.0);
		pos4 = model*vec4(getElephant(position), 1.0);
		gl_Position = projection * view * pos4;
		//vec4(position, getZ(position) , 1.0);

		// vercol v projektu bude
		// vertColor = pos4.xyz;

		normal = mat3(view)* mat3(model)*getElephantNormal(position);




	}
	if(type==2){
		position = inPosition * 2 - 1;
		pos4 = model*vec4(position, getZ(position), 1.0);
		gl_Position = projection * view * pos4;
		normal = mat3(view)*mat3(model)* getWaveNormal(position);


	}

	if(type==3){
		position = inPosition * 2 - 1;
		pos4 = model*vec4(getDesk(position), 1.0);
		gl_Position = projection * view * pos4;
		normal = mat3(view)* mat3(model)*getDeskNormal(position);
	}
	if(type==4){
		position = inPosition*2-1;
		pos4 = model*vec4(getMySombrero(position), 1.0);
		gl_Position = projection * view * pos4;
		normal = mat3(view)* mat3(model)*getSombreroNormal(position);
	}
	if(type==5){
		position = inPosition*2-1;
		pos4 = model*vec4(getMyCylindric(position), 1.0);
		gl_Position = projection * view * pos4;
		normal = mat3(view)*mat3(model)* getCylindricNormal(position);
	}
	if(type==6){
		position = inPosition*2-1;
		pos4 = model*vec4(getKart(position), 1.0);
		gl_Position = projection * view * pos4;
		normal = mat3(view)* mat3(model)*getKartNormal(position);
	}
	if(type==7){
		position = inPosition*2-1;
		pos4 = model*vec4(getSun(position), 1.0);
		gl_Position = projection * view * pos4;
		normal = mat3(view)* mat3(model)*getSunNormal(position);
	}
	vec3 lightPos = vec3(1, 1, 0);
	light = lightPos - (view * pos4).xyz;

	texCoord = inPosition;

	viewDirection = -(view* pos4).xyz;
	depthTextureCoord = lightViewProjection * pos4;
	depthTextureCoord.xyz = depthTextureCoord.xyz/depthTextureCoord.w;
	depthTextureCoord.xyz = (depthTextureCoord.xyz + 1) / 2;




} 
