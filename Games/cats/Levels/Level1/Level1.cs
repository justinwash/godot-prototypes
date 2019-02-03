using System;
using Godot;

public class Level1 : Node {
	private Vector2 _screenSize;
	private Area2D _player;
	private Sprite _background;
	private int _scrollMin = 300;
	private int _scrollMax = 700;

	public override void _Ready() {
		_screenSize = GetViewport().GetSize();
		_player = GetNode<Area2D>("Player");
		_background = GetNode<Sprite>("Background");
	}

	public override void _Process(float delta) {
		// do stuff
	}
}