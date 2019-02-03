using System;
using Godot;

public class Player : Area2D {
	[Signal]
	public delegate void Hit();

	[Export]
	public int Speed = 400;

	private Vector2 _screenSize;
	private Sprite _sprite;
	private AnimationPlayer _animationPlayer;
	private Camera2D _camera;

	public override void _Ready() {
		_screenSize = GetViewport().GetSize();
		_sprite = GetNode<Sprite>("Sprite");
		_animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		_camera = GetNode<Camera2D>("Camera2D");
	}

	public override void _Process(float delta) {
		var velocity = new Vector2();

		if (Input.IsActionPressed("ui_right")) velocity.x += 1;
		if (Input.IsActionPressed("ui_left")) velocity.x -= 1;

		if (velocity.Length() > 0) velocity = velocity.Normalized() * Speed;

		if (velocity.x > 0 && _animationPlayer.CurrentAnimation != "right") _animationPlayer.Play("right");
		else if (velocity.x > 0) _animationPlayer.CurrentAnimation = "right";

		else if (velocity.x < 0 && _animationPlayer.CurrentAnimation != "left") _animationPlayer.Play("left");
		else if (velocity.x < 0) _animationPlayer.CurrentAnimation = "left";

		else _animationPlayer.Play("idle_right");

		Position += velocity * delta;
		Position = new Vector2(
			x: Mathf.Clamp(Position.x, _camera.LimitLeft, _camera.LimitRight),
			y : Mathf.Clamp(Position.y, 0, _screenSize.y)
		);
	}

	private void OnPlayerBodyEntered(object body) {
		EmitSignal("Hit");
	}
}