shader_type canvas_item;
uniform bool red;

void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	
	if (red)
	{
		COLOR = vec4(1, 0, 0, color.a);
	}
	else
	{
		COLOR = color;
	}
}