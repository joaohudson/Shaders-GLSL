/**
 * Practice 1
 */
vec4 light = vec4(1.0, 1.0, 0.0, 1.0);

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 coord = fragCoord.xy / iResolution.xy;
    vec4 color = texture(iChannel0, coord) * 0.5  + abs(cos(iTime + coord.x)) * 0.5 * light;
    
    fragColor = color;
}

/**
 * Pratice 2
 */
float velocity = 0.25;
float distorcion = 0.5;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    distorcion = sin(3.14 * iTime * velocity) * .5 + .5;
    uv.x = sin(uv.x * 6.28 + iTime) *.5 + distorcion;
    
    float a = abs(sin(iTime * 3.14 * velocity + uv.x));
    float b = abs(cos(iTime * 3.14 * velocity + uv.x));
    
    vec4 color = texture(iChannel0, uv);
    color = color * a + color.x * b;

    // Output to screen
    fragColor = color;
}

/**
 * Wave shader
 */

float velocity = 0.6;
float distorcion = 0.4;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
	
    uv.y += sin(uv.x * 8.0 + iTime) * distorcion;
    uv.x += iTime * velocity;
    
    fragColor = texture(iChannel1, uv);
    
}

/**
 * Light shader
 */
vec4 color = vec4(1.0, 1.0, 1.0, 1.0);
vec2 center = vec2(0.5, 0.5);
float velocity = 0.5;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    float light;
    float radius;
    
    radius = sin(iTime * velocity) * .5 + .5;
    light = radius - length(uv - center);

    color.rgb = vec3(light, light, light) * color.rgb;
    
	fragColor = color;    
}

/**
 * Simple Fractal
 */
float velocity = 10.0;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    float a = atan(uv.x, uv.y);
    

    // Output to screen
    fragColor = vec4(cos(a*iTime * velocity), sin(a*iTime*velocity), 1.0, 1.0);
}

float velocity = 4.0;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
	uv.x += sin(uv.y * 4.0 + iTime * velocity) * .05;
    float color = sin(6.28 * uv.x + 4.5) * (1.0 - uv.y * uv.y * uv.y + .5) * (sin(iTime)/ uv.y);
    
    // Output to screen
    fragColor = vec4(color, color, color, color);
}

/**
* Shader chama de vela.
*/

float intensity = 4.0;
float distorcion = 8.0;
float velocity = 8.0;
vec4 color = vec4(0.0, 1.0, 1.0, 1.0);

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    //aplica distorção no fogo:
    uv.x += sin(velocity * iTime - uv.y * distorcion) * .01 + .01;
	//calcula a cor com base na região do fogo:
    float result = sin(uv.x * 6.28 + 4.8) * (pow(2.1, -(uv.y * uv.y)) /sqrt(6.28)) * intensity;
    
    // Output to screen
    fragColor = vec4(result) * color;
}

/**
* Fire shader.
*/

float velocity = 4.0;
vec4 colorA = vec4(1.0, .0, .0, 1.0);
vec4 colorB = vec4(1.0, 1.0, .0, 1.0);
float ruido = 0.6;

vec4 lerp(vec4 a, vec4 b, float f)
{
    return a * f + (1.0 - f) * b;
}

float rand(vec2 seed)
{
    return fract(sin(dot(seed, vec2(12.5721654, 13.084405))) * 14.1375941);
}

float norm(float x)
{
    return sin(x) * .5 + .5;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
	uv.x += (sin(iTime * velocity + (uv.y - .5)  * 36.0) * .05 + .05) * rand(vec2(norm(iTime * uv.x), norm((uv.y - .5) * iTime))) * .05;
    float color = sin(6.28 * uv.x + 4.5) * (3.0 - uv.y * uv.y * uv.y) * (sin(28.0) * 4.0/ uv.y);
    vec4 t = texture(iChannel0, uv + vec2(.0, -iTime)) * (1.0 - ruido) +  ruido * texture(iChannel1, uv + vec2(iTime * .5, -iTime * .9));
    vec4 l = lerp(colorA, colorB, .7);
    
    // Output to screen1
    fragColor = vec4(color) * vec4(t.x * ruido) * l;
}

/**
* Transform simulation.
*/

float velocity = 2.0;

mat3 rotate(float angle)
{
    return mat3(cos(angle), -sin(angle), .0,
                sin(angle), cos(angle), .0,
                .0, .0, 1.
               );
}

mat3 translate(vec2 d)
{
    return mat3(1., .0, d.x,
                .0, 1., d.y,
                .0, .0, 1.);
}

mat3 scale(vec2 factor)
{
    return mat3(factor.x, .0, .0,
               	.0, factor.y, .0,
                .0, .0, 1.);
}

void applyTransform(mat3 transform, inout vec2 point)
{
    vec3 aux = vec3(point.x, point.y, 1.0);
    aux = transform * aux;
    point = vec2(aux.x, aux.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    
    //transforms...
    vec2 center = vec2(.5);
    mat3 transform = translate(-center * iTime);// * rotate(iTime);
    applyTransform(transform, uv);
    
    float d = distance(uv, vec2(.5));
    float color = .0;
    
    if(d > .2 && d < .4)
        color = 1.;

    // Output to screen
    fragColor = vec4(color);
}

/**
 * Distorcion Effect
 */

vec4 firstColor = vec4(.5, .9, .2, 1.);
vec4 secondColor = vec4(.5, .4, .9, 1.);

float distorcion(vec2 point)
{
    float angle = atan(point.x - .5, point.y - .5);
    float dc = length(point - .5);
    return dc * (sin(angle * 16.0) * .5 + .5);
}

vec2 rotateInCenter(vec2 point, float angle)
{
    return ( mat2(cos(angle), -sin(angle), sin(angle), cos(angle)) * (point - vec2(.5)) ) + vec2(.5);
}

vec4 lerp(vec4 c0, vec4 c1, float factor)
{
    return c0 * factor + (1. - c1) * factor;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    vec4 color = lerp(firstColor, secondColor, sin(iTime));
    uv = rotateInCenter(uv, iTime) * length(uv - vec2(.5));
    float factor = length(uv - vec2(.5));
    vec4 mask = 2. - vec4(clamp(factor, 0.1, 0.8));
     
	vec4 col = vec4(factor);

    // Output to screen
    fragColor = col * mask * color + distorcion(uv);
}

/**
 * Hypnosis effect
 */

//inputs:
vec4 color0 = vec4(1.0, 0.0, 1.0, 1.0); 
vec4 color1 = vec4(1.0, .5, 0.2, 1.0);
float distorcion = 32.0;
float units = 8.0;
float speed = 1.5;

//interpolates between c0 and c1
vec4 lerp(vec4 c0, vec4 c1, float factor)
{
    return c0 * factor + (1. - factor) * c1;
}
//oscillates between 0 and 1
float pingpong(float value)
{
    return sin(value) * .5 + .5;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    float dteta = -iTime * speed;
    uv = uv - vec2(.5);
    uv = mat2(cos(dteta), -sin(dteta), sin(dteta), cos(dteta)) * uv;
    //compute coordinates:
    float angle = atan(uv.x, uv.y);
    float radius = length(uv);
    //compute color:
    vec4 col = vec4(sin(angle * units + radius * distorcion));
    //change to screen coordinate:
	uv = uv + vec2(.5);
    // Output to screen
    fragColor = col * lerp(color0, color1, pingpong(iTime * speed));
}

/**
 * Energy effect
 */

//inputs:
vec4 effectColor = vec4(.4, 0., .6, 1.);
float distorcion = 16.0;
float units = 4.0;
float speed = 1.5;

//interpolates between c0 and c1
vec4 lerp(vec4 c0, vec4 c1, float factor)
{
    return c0 * factor + (1. - factor) * c1;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    float dteta = -iTime * speed;
    uv = uv - vec2(.5);
    uv = mat2(cos(dteta), -sin(dteta), sin(dteta), cos(dteta)) * uv;
    //compute coordinates:
    float angle = atan(uv.x, uv.y);
    float radius = length(uv);
    //compute color:
    vec4 col = vec4(sin(angle * units + radius * distorcion));
    col = effectColor - col;
    //change to screen coordinate:
	uv = uv + vec2(.5);
    // Output to screen
    fragColor = col * col.a + (1. - col.a)*texture(iChannel0, fragCoord/iResolution.xy);
}

/**
 * Magic effect
 */

//inputs:
vec4 effectColor = vec4(.4, .0, 1., 1.);
vec4 mixColor = vec4(0.0, 1.0, 1.0, 1.0);
float distorcion = 16.0;
float units = 4.0;
float speed = 1.5;

//interpolates between c0 and c1
vec4 lerp(vec4 c0, vec4 c1, float factor)
{
    return c0 * factor + (1. - factor) * c1;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    vec2 center = iMouse.xy / iResolution.xy;
    float dteta = -iTime * speed;
    uv = uv - center;
    uv = mat2(cos(dteta), -sin(dteta), sin(dteta), cos(dteta)) * uv;
    //compute coordinates:
    float angle = atan(uv.x, uv.y);
    float radius = length(uv);
    //compute color:
    vec4 col = vec4(sin(angle * units + radius * distorcion));
    col = effectColor - col;
    col = lerp(col, mixColor, sin(iTime) * .5 + .5);
    //change to screen coordinate:
	uv = uv + center;
    // Output to screen
    fragColor = col * col.a + (1. - col.a)*texture(iChannel0, fragCoord/iResolution.xy);
}

/**
 * Black Hole
 */

//inputs:
vec4 effectColor = vec4(.4, .0, 1., 1.);
float distorcion = 180.0;
float units = 8.0;
float speed = 1.5;

vec4 blackHole(vec2 pos)
{
    float fac = pow(length(pos * 2.), 2.);
    return normalize(vec4(fac, fac, fac, 1.));
}

vec4 lerp(vec4 c0, vec4 c1, float factor)
{
    factor = clamp(factor, 0.0, 1.0);
    return c0*factor + (1. - factor)*c1;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    vec4 ct = texture(iChannel0, uv);
    vec2 center = iMouse.xy / iResolution.xy;
    float dteta = iTime * speed;
    vec4 col = ct;
    uv = uv - center;
    uv = mat2(cos(dteta), -sin(dteta), sin(dteta), cos(dteta)) * uv;
    
    //compute coordinates:
    float angle = atan(uv.x, uv.y);
    float radius = length(uv);
    //compute color:
    float light = sin(angle * units + radius * distorcion) * 0.3;
    col = vec4(light);
    col = effectColor - col;
    col = (col * col.a + (1. - col.a)) * blackHole(uv)  * length(1.5 * texture(iChannel1, uv + vec2(.5)));
    col.a = pow(length(uv), 3.);
    //mix texture:
    col = lerp(ct, col, pow(length(uv) * 2.5, 2.));
    
    //change to screen coordinate:
	uv = uv + center;
    // Output to screen
    fragColor = col;
}

/**
 * Simple primitive drawing
 */

//draw circle
float circle(vec2 pos, float radius)
{
    if(length(pos) <= radius)
        return 1.;
    else
        return .0;
}
//draw square
float square(vec2 pos, vec2 res)
{
    if(pos.x < res.x && pos.x > -res.x && pos.y < res.y && pos.y > -res.y)
        return 1.;
    else
        return .0;
}
//rotate point
vec2 rotation(vec2 pos, float angle)
{
    vec3 aux = vec3(pos.x, pos.y, 1.);
    aux = mat3(cos(angle), -sin(angle), .0, sin(angle), cos(angle), .0, .0, .0, 1.) * aux;
    
    return vec2(aux.x, aux.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    //center of the drawing
    vec2 center = iMouse.xy / iResolution.xy;
    //correction scale
    vec2 screenScale = vec2(iResolution.x / iResolution.y, 1.);
    //uv coordinates
    vec2 uv = fragCoord/iResolution.xy;
    //corrected uv coordinates from the center
    vec2 uvd = (uv - center) * screenScale;
    //polar coordinates
    vec2 polar = vec2(length(uvd), atan(uvd));
    float col = square(rotation(uvd, iTime) + vec2(.25), vec2(.2)) + 
        square(rotation(uvd, iTime + 1.6) + vec2(.25), vec2(.2)) +
        square(rotation(uvd, iTime + 3.14) + vec2(.25), vec2(.2)) +
    	square(rotation(uvd, iTime + 4.74) + vec2(.25), vec2(.2));

    // Output to screen
    fragColor = vec4(circle(uvd, 0.4), col, col, 1.0);
}

/**
 * Black Hole Powerful
 */

//inputs:
vec4 effectColor = vec4(.4, .0, 1., 1.);
float distorcion = 180.0;
float units = 8.0;
float speed = 1.5;

vec4 blackHole(vec2 pos)
{
    float fac = pow(length(pos * 2.), 2.);
    return normalize(vec4(fac, fac, fac, 1.));
}

vec4 lerp(vec4 c0, vec4 c1, float factor)
{
    factor = clamp(factor, 0.0, 1.0);
    return c0*factor + (1. - factor)*c1;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    vec4 ct = texture(iChannel0, uv);
    vec2 center = iMouse.xy / iResolution.xy;
    float dteta = iTime * speed;
    vec4 col = ct;
    uv = uv - center;
    uv = mat2(cos(dteta), -sin(dteta), sin(dteta), cos(dteta)) * uv;
    
    //compute coordinates:
    float angle = atan(uv.x, uv.y);
    float radius = length(uv);
    //compute color:
    float light = sin(angle * units + radius * distorcion) * 0.3;
    col = vec4(light);
    col = effectColor - col;
    col = (col * col.a + (1. - col.a)) * blackHole(uv)  * length(1.5 * texture(iChannel1, uv * mod(iTime * 8., 1.) + vec2(.5)));
    col.a = pow(length(uv), 3.);
    //mix texture:
    col = lerp(ct, col, pow(length(uv) * 2.5, 2.));
    
    //change to screen coordinate:
	uv = uv + center;
    // Output to screen
    fragColor = col;
}

/**
 * Draw smoothed circle
 */
vec4 color = vec4(.3, .7, .6, 1.);

//draw circle
float circle(vec2 pos, float radius)
{
    if(length(pos) <= radius)
        return 1.;
    else
        return .0;
}

//draw smooth circle
float circleSmooth(vec2 pos, float radius, int smoothFactor)
{
    vec2 d = vec2(0.0005, 0.0005);
    float r = 0.0;
    float factor = float(smoothFactor) * .5;
    
    for(int i = 0; i < smoothFactor; i++)
        for(int j = 0; j < smoothFactor; j++)
        {
            r = r + circle(pos + d * vec2(factor - float(i), factor - float(j)), radius);
        }
    
    return r / float(smoothFactor*smoothFactor);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    //draw center
    vec2 center = iMouse.xy / iResolution.xy;
    vec2 uv = ( fragCoord/iResolution.xy - center ) * vec2(iResolution.x / iResolution.y, 1.);

    // Time varying pixel color
    vec3 col = vec3(circleSmooth(uv, 0.4, 8));

    // Output to screen
    fragColor = vec4(col,1.0) * color;
}