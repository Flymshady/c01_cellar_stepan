#version 150
in vec2 inPosition; // input from the vertex buffer

uniform mat4 view;
uniform mat4 projection;
uniform float time;
uniform float type;


float getZ(vec2 vec) {
    return sin(time + vec.y * 3.14 *2)-1.5;
}
float getFValue(vec2 xy){
    return 0;
}

vec3 getElephant(vec2 vec) {
    float az = vec.x * 3.14;
    float ze = vec.y * 3.14 / 2;
    float r = 1+cos(4*az);

    float x = r*cos(az)*cos(ze);
    float y = r*sin(az)*cos(ze)+2;
    float z = r*sin(ze) +1.5;

    return vec3(x,y,z);
}


vec3 getMySpheric(vec2 vec) {
    float az = vec.x * 3.14;
    float ze = vec.y * 3.14 / 2;
    float r = 1+sin(ze)+cos(az);

    float x = r*cos(az)*cos(ze)-2;
    float y = r*sin(az)*cos(ze); //2pryc
    float z = r*sin(ze); //0.5pryc

    return vec3(x,y,z);
}

vec3 getMySombrero(vec2 vec) {
    float az = vec.x*3.14*2;//theta=s
    float r = vec.y*3.14;//r=t
    float v = cos(2*r)+1;

    float x = r*cos(az);
    float y = r*sin(az)+5;
    float z = v;

    return vec3(x, y, z);
}

vec3 getMyCylindric(vec2 vec) {
    float az = vec.x*2*3.14;//theta=s
    float r = vec.y*2*3.14;
    float v = r;

    float x = r*cos(az);
    float y = r*sin(az)-5;
    float z = v;

    return vec3(x, y, z);
}

void main() {
    if(type==0){
        //metoda na rozvetveni objektu pres type == 1 ...
        vec2 position;
        position = inPosition * 2 - 1;
        //  vec4 pos4 = vec4(position, getZ(position), 1.0);
        vec4 pos4 = vec4(getMySpheric(position), 1.0);
        gl_Position = projection * view * pos4;
    }
    if(type==1){
        //metoda na rozvetveni objektu pres type == 1 ...
        vec2 position;
        position = inPosition * 2 - 1;
        //  vec4 pos4 = vec4(position, getZ(position), 1.0);
        vec4 pos4 = vec4(getElephant(position), 1.0);
        gl_Position = projection * view * pos4;
    }
    if(type==2){
        vec2 position = inPosition * 2 - 1;
        vec4(position, getZ(position) , 1.0);
        vec4 pos4 = vec4(position, getZ(position), 1.0);
        gl_Position = projection * view * pos4;



    }
    if(type==3){
        vec2 position = inPosition * 2 - 1;
        vec4(position, getFValue(position) , 1.0);
        vec4 pos4 = vec4(position, getFValue(position), 1.0);
        gl_Position = projection * view * pos4;
    }
    if(type==4){
        //metoda na rozvetveni objektu pres type == 1 ...
        vec2 position;
        position = inPosition * 2 - 1;
        vec4 pos4 = vec4(getMySombrero(position), 1.0);
        gl_Position = projection * view * pos4;
    }
    if(type==5){
        //metoda na rozvetveni objektu pres type == 1 ...
        vec2 position;
        position = inPosition * 2 - 1;
        vec4 pos4 = vec4(getMyCylindric(position), 1.0);
        gl_Position = projection * view * pos4;
    }

} 
