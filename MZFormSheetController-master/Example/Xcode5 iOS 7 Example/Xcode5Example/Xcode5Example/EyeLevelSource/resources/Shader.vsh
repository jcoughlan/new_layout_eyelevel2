attribute vec3		position;
attribute vec3		normal;
attribute vec4		color;
attribute vec2      texcoord;

uniform highp   mat4        viewMatrix;
uniform highp   mat4		projectionMatrix;
uniform highp	mat4		modelMatrix;
uniform float               u_Transparency;

varying float   v_Transparency;
varying	 vec2	myTexCoord;

const int cOne = 1;
const int cZero = 0;


void main()
{
    mat4 mvp = (projectionMatrix * (viewMatrix * modelMatrix));
    
    vec4 transformedPosition = mvp * vec4( position, cOne ); 
    //vec4 transformedNormal =   vec4(normal, cOne) * mvp;
    
    //vec3 lightDirection = vec3(  -cOne, -cOne, -cOne  );
    
    //pass data to fragment shader
    //lightIntensity = max(0.5, dot( transformedNormal.xyz, lightDirection ) );
    
    gl_Position = transformedPosition;
    myTexCoord = texcoord.st;
    v_Transparency = u_Transparency;
}