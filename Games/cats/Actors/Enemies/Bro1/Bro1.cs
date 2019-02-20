using Godot;
using System;

public class Bro1 : Area2D
{
	private Area2D _player;
	private Polygon2D _playerHealthBar;
  	private Sprite _sprite;
	private AnimationPlayer _animationPlayer;
	
  	public override void _Ready() {
		_player = GetNode<Area2D>("../Player");
		_playerHealthBar = GetNode<Polygon2D>("../Player/Camera2D/MoodMeter/Meter");
    	_sprite = GetNode<Sprite>("Sprite");
		_animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
  	}

  	public override void _Process(float delta) {
		if (_player.Position.x < Position.x - 100 && _animationPlayer.CurrentAnimation != "idle_left") {
      		_animationPlayer.Play("idle_left");
		}
		if (_player.Position.x > Position.x + 20 && _animationPlayer.CurrentAnimation != "idle_right") {
      		_animationPlayer.Play("idle_right");
		}
		
		if (Position.x - 100 - _player.Position.x < 100) {
			//_playerHealthBar.Scale(null);
		}
	}
}
