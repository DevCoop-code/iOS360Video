precision mediump float;

in vec2 textureCoordinate;
in vec4 colorFromPosition;

out vec4 fragmentColor;

void main(){
    fragmentColor = colorFromPosition;
}
