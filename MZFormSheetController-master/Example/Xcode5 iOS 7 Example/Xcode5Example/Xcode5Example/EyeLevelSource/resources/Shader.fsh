//  Shader.fsh
//  EaglApp
//
//  Created by Jamie Stewart on 21/06/10.
//  Copyright Fluid Pixel 2010. All rights reserved.
//

uniform			sampler2D	s_shapeTexture;

varying mediump vec2	myTexCoord;
varying highp float v_Transparency;


void main()
{
	gl_FragColor = vec4( ( texture2D(s_shapeTexture, myTexCoord) ).rgb, v_Transparency); 
}
