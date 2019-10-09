uniform mat4 modelViewProjectionMatrix;

in vec4 position;
in vec2 texCoord;

out vec4 colorFromPosition;
out vec2 textureCoordinate;

void main(){
    colorFromPosition = position;
    textureCoordinate = texCoord;
    
    gl_Position = modelViewProjectionMatrix * position;
}
