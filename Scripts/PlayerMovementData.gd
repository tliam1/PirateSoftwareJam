class_name PlayerMovementData
extends Resource


@export var speed = 100.0;
@export var accel = 700.0; 
@export var friction = 700.0;
@export var jumpVel = -250.0;
@export var maxGravity = 1000;
@export var gravityAccel = 10000.0;
@export var wallJumpBuffer = 1.0;
@export var maxWallJumpBuffer = 10.0;
@export var throwForce = 10.0;
var canMove = true;
var onfloor;
var prevOnFloor = false;
var onWall = false;
var wallNormal;
var prevOnWall = false;
var jumping = false;
var wallSliding = false;
var floorWallTiles;
var alive = true;
