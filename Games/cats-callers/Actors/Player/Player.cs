using Godot;
using System;

public class Player : KinematicBody2D
{
  public int MOVE_SPEED = 500;
  public int JUMP_FORCE = 1000;
  public int GRAVITY = 50;
  public int MAX_FALL_SPEED = 1000;

  private AnimationPlayer _animationPlayer;
  private Sprite _sprite;
  private int _yVelocity;
  private bool _facingRight;

  public override void _Ready()
  {
    _animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
    _sprite = GetNode<Sprite>("player");
    _yVelocity = 0;
    _facingRight = false;
  }

  public override void _PhysicsProcess(float delta)
  {
    var moveDir = 0;

    if (Input.IsActionPressed("move_right")) moveDir += 1;

    if (Input.IsActionPressed("move_left")) moveDir -= 1;


    MoveAndSlide(new Vector2(moveDir * MOVE_SPEED, _yVelocity), new Vector2(0, -1));

    var grounded = IsOnFloor();
    _yVelocity += GRAVITY;

    if (grounded && Input.IsActionJustPressed("jump")) _yVelocity = -JUMP_FORCE;
    if (grounded && _yVelocity >= 0) _yVelocity = 5;
    if (_yVelocity > MAX_FALL_SPEED) _yVelocity = MAX_FALL_SPEED;

    if (_facingRight && moveDir < 0) flip();
    if (!_facingRight && moveDir > 0) flip();

    if (grounded)
    {
      if (moveDir == 0) playAnimation("idle");
      else playAnimation("walk");
    }
    else playAnimation("jump");
  }

  public void flip()
  {
    _facingRight = !_facingRight;
    _sprite.FlipH = _sprite.FlipH;
  }

  public void playAnimation(string name)
  {
    if (_animationPlayer.IsPlaying() && _animationPlayer.CurrentAnimation == name) return;
    _animationPlayer.Play(name);
  }
}
