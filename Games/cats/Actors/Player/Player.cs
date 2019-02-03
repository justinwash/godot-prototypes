using System;
using Godot;

public class Player : Area2D {
  [Signal]
  public delegate void OnGround();

  [Export]
  public int Speed = 180;

  [Export]
  new public float Gravity = 2;

  [Export]
  public float JumpForce = -3.5f;

  private Vector2 _screenSize;
  private Sprite _sprite;
  private AnimationPlayer _animationPlayer;
  private Camera2D _camera;
  private Boolean _onGround = false;
  private Boolean _jumping = false;

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

    if (_jumping && JumpForce < -Gravity * 0.75) {
      velocity.y = JumpForce;
      JumpForce -= JumpForce * 0.025f;
    } else {
      _jumping = false;
      JumpForce = -3.5f;
    }

    if (Input.IsActionJustPressed("ui_up")) {
      _jumping = true;
      velocity.y = JumpForce;
    }

    if (Input.IsActionJustReleased("ui_up")) {
      _jumping = false;
    }

    velocity.y += ApplyGravity();

    if (velocity.Length() > 0) velocity = velocity * Speed;

    if (velocity.x > 0 && _animationPlayer.CurrentAnimation != "right" && velocity.y == 0) _animationPlayer.Play("right");
    else if (velocity.x > 0 && velocity.y == 0) _animationPlayer.CurrentAnimation = "right";

    else if (velocity.x < 0 && _animationPlayer.CurrentAnimation != "left" && velocity.y == 0) _animationPlayer.Play("left");
    else if (velocity.x < 0 && velocity.y == 0) _animationPlayer.CurrentAnimation = "left";

    else if (velocity.y == 0) _animationPlayer.Play("idle");

    else if (velocity.x > 0) _animationPlayer.Play("jump_right");
    else if (velocity.x < 0) _animationPlayer.Play("jump_left");

    Position += velocity * delta;
    Position = new Vector2(
      x: Mathf.Clamp(Position.x, _camera.LimitLeft, _camera.LimitRight),
      y : Mathf.Clamp(Position.y, 0, _screenSize.y)
    );
  }

  private float ApplyGravity() {
    if (_onGround) return 0;
    else return Gravity;
  }

  private void OnAreaEntered(Area2D area) {
    if (area.GetName() == "Floor") _onGround = true;
  }

  private void OnAreaExited(Area2D area) {
    if (area.GetName() == "Floor") _onGround = false;
  }

}