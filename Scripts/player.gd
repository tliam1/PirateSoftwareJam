extends CharacterBody2D

enum AnimationState {
	IDLE,
	RUN,
	JUMP,
	LAND,
}
@export var movementData : PlayerMovementData;

#@onready var slide_time = $slideTime
# ProjectSettings.get_setting("physics/2d/default_gravity");
@onready var anim = $AnimatedSprite2D;
@onready var coyoteJumpTimer = $Timers/CoyoteJumpTimer;
@onready var jumpBufferTimer = $Timers/JumpBufferTimer;
@onready var player = $".";
var world;
#@onready var landPart1 = $landParticle1
#@onready var landPart2 = $landParticle2
#@onready var death_particle = $DeathParticle
@onready var wallcastright = $RayCasts/WallCastRight
@onready var wallcastleft = $RayCasts/WallCastLeft
#@onready var shoot_reset_time = $ShootResetTime
@onready var wallJumpResetTimer = $Timers/wallJumpResetTimer
@onready var wallJumpCoyoteJumpTimer = $Timers/wallJumpCoyoteJumpTimer
@onready var col = $CollisionShape2D
#@onready var ice_detector = $IceDetector
#@onready var cam = $PhysicsCam
#@onready var slide_particles = $SlideParticles

var gravity = 0;
var currentAnimationState := AnimationState.IDLE;
var spr_scale;
var potionResource = preload("res://Scenes/Prefabs/Potions/Bottle.tscn")

func _ready():
	world = get_parent();
	movementData.alive = true;
	movementData.canMove = true;
	anim.visible = true;
	spr_scale = anim.scale;
	
func _physics_process(delta):
	movementData.prevOnFloor = movementData.onfloor;
	movementData.onfloor = is_on_floor();
	movementData.prevOnWall = movementData.onWall;
	var dir = Input.get_axis("ui_left", "ui_right");
	if(movementData.alive and movementData.canMove): # and !world.levelOver 
		frameChecks(delta);
#		SlidyFloor();
#		GunForce(delta, false);
		LaunchPotion()
		WallSliding(dir);
		JumpCheck(delta, false);
		Movement(delta, dir);
		ApplyGravity(delta);
		AnimationController(dir);
		SpeedControl(delta);
		# cellData(delta);
		squishAndStretch(delta);
	elif(!movementData.alive and anim.visible):
		gravity = 0;
		velocity = Vector2.ZERO;
		anim.visible = false;

	elif(movementData.alive): # world.levelOver and
		movementData.canMove = false;
		gravity = 0;
		velocity = Vector2.ZERO;
		modulate.a = move_toward(modulate.a, 0, delta * 1);
#		player.global_position.x = move_toward(player.global_position.x,portal_pos.x,delta*8);
#		player.global_position.y = move_toward(player.global_position.y,portal_pos.y,delta*8);
		anim.scale.y = move_toward(anim.scale.y, spr_scale.y, delta * 1.5);
		anim.scale.x = move_toward(anim.scale.x, spr_scale.x,  delta * 1.5);
#		gun.modulate.a = move_toward(gun.modulate.a, 0, delta * 1);
#		cam.position.x = move_toward(cam.position.x, 0, delta);
#		cam.position.y = move_toward(cam.position.y, 0, delta);
#		cam.drag_left_margin = move_toward(cam.drag_left_margin, 0, delta * 3);
#		cam.drag_right_margin = move_toward(cam.drag_right_margin, 0, delta * 3);
#		cam.drag_top_margin = move_toward(cam.drag_top_margin, 0, delta * 3);
#		cam.drag_bottom_margin = move_toward(cam.drag_bottom_margin, 0, delta * 3);
	move_and_slide();
		
		
func SpeedControl(delta):
	if(abs(velocity.y) > 500):
		velocity.y = move_toward(velocity.y, 500 * sign(velocity.y), movementData.friction * delta);
	if(abs(velocity.x) > 500):
		# velocity.x = 250* sign(velocity.x);
		velocity.x = move_toward(velocity.x, 500 * sign(velocity.x), movementData.friction * delta);
		
func ApplyGravity(delta):
	# print(velocity.x);
	if not is_on_floor() and not movementData.wallSliding:
		gravity = move_toward(gravity,movementData.maxGravity, movementData.gravityAccel * delta);
		velocity.y += gravity * delta;
	elif not is_on_floor() and movementData.wallSliding:
		gravity = movementData.maxGravity * 3.2;
		velocity.y = gravity * delta;
	if is_on_floor():
		gravity = 0;

func WallSliding(dir):
	if !movementData.onWall:
		if movementData.wallSliding:
			movementData.wallSliding = false;
			gravity = 0;
			velocity.y = 0;
		return;
	var wallDir = -movementData.wallNormal.x;
	if sign(wallDir) == sign(dir) and dir != 0 and velocity.y > 0 and !movementData.wallSliding:
		movementData.wallSliding = true;
		#movementData.sliding = false;
		gravity = 0;
		velocity.y = 0;
		if(anim.scale != spr_scale):
			anim.scale = spr_scale;
		# play some animation or something
	elif movementData.wallSliding and (sign(wallDir) != sign(dir) or dir == 0 or velocity.y < -0.3 or is_on_floor()): 
		movementData.wallSliding = false;
		gravity = 0;
		velocity.y = 0;
		
func WallCasting():
	if(wallcastright.get_collider() or wallcastleft.get_collider() and !movementData.onWall):
		movementData.onWall = true;
		if(wallcastright.get_collider()):
			movementData.wallNormal=wallcastright.get_collision_normal();
		else:
			movementData.wallNormal=wallcastleft.get_collision_normal();
	elif(movementData.onWall and !wallcastright.get_collider() and !wallcastleft.get_collider()):
		movementData.onWall = false;


func GetTileSet(tileset):
	movementData.floorWallTiles = tileset;


func LaunchPotion():
	if Input.is_action_just_pressed("LeftMouseClick"):
		print("THROWN")
		var potionInst = potionResource.instantiate();
		get_tree().get_root().add_child(potionInst);
		potionInst.global_position = global_position
		var direction : Vector2 = get_global_mouse_position() - global_position
		potionInst.InitializeForce(direction.normalized(), movementData.throwForce)


func AddForces(dir : Vector2, speed : float):
	velocity += dir * speed
	pass
	
#func GunForce(delta, override):
#
#	#print(gun.rotation_degrees);
#	if Input.is_action_just_pressed("MouseClick0") or override:
##		if(movementData.avaliableBullets <= 0 || !shoot_reset_time.is_stopped()): # can add like UI visuals for being out of bullets
##			if(!shoot_buffer_time.is_stopped()):
##				shoot_buffer_time.stop();
##			shoot_buffer_time.start();
##			return;
#		movementData.wallSliding=false;
#		gravity = 0;
#		var dist = (gun.get_child(1).global_position - global_position).normalized();
#		if is_on_floor():
#			if(gun.rotation_degrees > 180 - movementData.straightShotDeadzone and gun.rotation_degrees < 180 + movementData.straightShotDeadzone):
#				dist.x = 1 * sign(dist.x)/1.5;
#				dist.y = 0;
#			elif(gun.rotation_degrees > 360 - movementData.straightShotDeadzone or gun.rotation_degrees < 0 + movementData.straightShotDeadzone):
#				dist.x = 1 * sign(dist.x)/1.5;
#				dist.y = 0;
#			elif(gun.rotation_degrees > 90 - (movementData.straightShotDeadzone+5) and gun.rotation_degrees < 90 + (movementData.straightShotDeadzone+5)):
#				dist.x = 0;
#				dist.y = 1 * sign(dist.y);
#
#		if(gun.rotation_degrees > 270 - movementData.straightShotDeadzone and gun.rotation_degrees < 270 + movementData.straightShotDeadzone):
#			dist.x = 0;
#			dist.y = 1 * sign(dist.y);
#
#
#		velocity.y = 0;
#		if (sign(velocity.x) != sign(-dist.x) and dist.x != 0):
#			velocity.x = 0;
#
#		dist.x *= movementData.shootForceX;
#		dist.y *= movementData.shootForceY;
#		slide_time.paused = false;
#		movementData.sliding = true;
#		slide_time.wait_time = movementData.defaultSlideWaitTime; # note: define default constant :)
#		if(!slide_time.is_stopped()):
#			slide_time.stop();
#		slide_time.start();
#		shoot_reset_time.start();
#		velocity += -dist * delta;
#		gun.Shoot();
#		movementData.avaliableBullets -= 1;
		
func JumpCheck(delta, override):
#	if is_on_wall() and Input.is_action_just_pressed("ui_accept"):
#		print("Attempted Wall Jump");
	var coyoteJumpped = false;
	if is_on_floor() or coyoteJumpTimer.time_left > 0.0:
		if Input.is_action_just_pressed("Jump") or override:
			velocity.y = movementData.jumpVel;
			movementData.jumping = true;
			if(anim.scale != spr_scale):
				anim.scale = spr_scale;
			if (override):
				coyoteJumpped = true;
				# print("COYOTE"); 
			return;
				# TODO: THE ISSUE IS THAT THE PLAY CAN DO A COYOTE AND A WALL JUMP BUFFER WITH ONE INPUT, EITHER BE SMART WITH OBJECT PLACEMENTS OR RETURN HERE
	if !is_on_floor() and (movementData.onWall or wallJumpCoyoteJumpTimer.time_left > 0.0):
		if Input.is_action_just_pressed("Jump") or (override and movementData.onWall):
			if(wallJumpCoyoteJumpTimer.time_left > 0.0):
				coyoteJumpped = true;
				# print("wall coyote");
			if(anim.scale != spr_scale):
				anim.scale = spr_scale;
			# remember this might cause issues if commented (come back to this)
			# print("WALL JUMPED with override:", override, " and wallJumpCoyoteJumpTimer.time_left > 0.0: ", wallJumpCoyoteJumpTimer.time_left > 0.0);
			movementData.wallSliding = false;
			velocity.x = 0;
			gravity = 0;
			velocity.y = movementData.jumpVel;
			velocity.x = -movementData.wallNormal.x * movementData.jumpVel/1.8;
			movementData.jumping = true;
			if !wallJumpResetTimer.is_stopped():
				wallJumpResetTimer.stop();
			wallJumpResetTimer.start();
			return;
			
	if !is_on_floor() and !movementData.onWall:
		if !Input.is_action_pressed("Jump") and velocity.y < movementData.jumpVel/3:
			velocity.y = move_toward(velocity.y,movementData.jumpVel/3, movementData.friction * 10 * delta);
		if Input.is_action_just_pressed("Jump") and !coyoteJumpped:
			if(!jumpBufferTimer.is_stopped()):
				jumpBufferTimer.stop();
			jumpBufferTimer.start();
			
func Movement(delta, dir):
	if wallJumpResetTimer.is_stopped():
		if sign(dir) != sign(velocity.x) and dir and velocity.x != 0:
			velocity.x = move_toward(velocity.x,0, (movementData.friction/1.2) * delta);
		elif dir:
			velocity.x = move_toward(velocity.x,dir * movementData.speed, movementData.accel * delta);
		elif dir == 0:
			velocity.x = move_toward(velocity.x,0, movementData.friction * delta);

func AnimationController(dir):
	if velocity.x > 0: 
		anim.flip_h = false
	elif velocity.x < 0:
		anim.flip_h = true
		
	if(velocity.x != 0 and currentAnimationState != AnimationState.LAND and is_on_floor_only()):
		currentAnimationState = AnimationState.RUN
		anim.play("Run");
	elif(is_on_floor() and currentAnimationState != AnimationState.LAND):
		currentAnimationState = AnimationState.IDLE
		anim.play("Idle");
	elif (!is_on_floor()):
		currentAnimationState = AnimationState.JUMP
		anim.play("Jump");
		
func frameChecks(delta):
	# WALL CASTING NEEDS TO BE BEFORE THE FRAME CHECKS AT ALL TIMES
	WallCasting();
	
	if movementData.prevOnFloor and !movementData.onfloor and !movementData.jumping:
		if !coyoteJumpTimer.is_stopped():
			coyoteJumpTimer.stop();
		coyoteJumpTimer.start();
		anim.scale = spr_scale;
	
	if movementData.onfloor and !movementData.prevOnFloor:
		currentAnimationState = AnimationState.LAND;
		anim.play("Land");
		if(!wallJumpCoyoteJumpTimer.is_stopped()):
			wallJumpCoyoteJumpTimer.stop();
#		landPart1.restart();
#		landPart2.restart();

		movementData.jumping = false;
		if(anim.scale != spr_scale):
			anim.scale.y = spr_scale.y/1.35;
			anim.scale.x = spr_scale.x*1.35;
		if (jumpBufferTimer.time_left > 0.0):
			JumpCheck(delta, true);
			anim.scale = spr_scale;
			if(!jumpBufferTimer.is_stopped()):
				jumpBufferTimer.stop();
#		elif (movementData.sliding and slide_time.paused):
#			slide_time.stop();
#			slide_time.wait_time = Get_Landing_SlideTime(abs(velocity.x));
#			slide_time.start();
#			slide_time.paused = false;
				
	if(movementData.onWall and !movementData.prevOnWall and !movementData.onfloor):
		if(!wallJumpCoyoteJumpTimer.is_stopped()):
			wallJumpCoyoteJumpTimer.stop();
		if (jumpBufferTimer.time_left > 0.0):
			JumpCheck(delta, true);
			if(!jumpBufferTimer.is_stopped()):
				jumpBufferTimer.stop();
				
	if(!movementData.onWall and movementData.prevOnWall and !movementData.onfloor and wallJumpResetTimer.is_stopped()):
		if(!wallJumpCoyoteJumpTimer.is_stopped()):
			wallJumpCoyoteJumpTimer.stop();
		wallJumpCoyoteJumpTimer.start();
		
#	if (!is_on_floor() and movementData.sliding and !slide_time.paused):
#		slide_time.paused = true;
#	if is_on_floor() and movementData.sliding and slide_time.is_stopped():
#		movementData.sliding = false;
				
	# if (movementData.prevOnFloor and !movementData.onWall and !movementData.onfloor):
		# frame one of leaving the wall


# was used for conveyer belt 
#func cellData(delta, dir):
#	movementData.sliding = true;
#	slide_time.wait_time = 0.1;
#	if(!slide_time.is_stopped()):
#		slide_time.stop();
#	slide_time.start();
#	velocity += dir * delta;
	
func squishAndStretch(delta):
	if !movementData.onfloor and velocity.y > 275:
		anim.scale.y = move_toward(anim.scale.y, spr_scale.y * 1.5, 3 * delta);
		anim.scale.x = move_toward(anim.scale.x, spr_scale.x / 1.5, 3 * delta);
	elif movementData.onfloor and movementData.prevOnFloor:
		anim.scale.y = move_toward(anim.scale.y, spr_scale.y, 5 * delta);
		anim.scale.x = move_toward(anim.scale.x, spr_scale.x, 5 * delta);
	elif !movementData.onfloor and velocity.y < 0 and anim.scale != Vector2(1,1):
		anim.scale.y = move_toward(anim.scale.y, spr_scale.y, delta * 1.5);
		anim.scale.x = move_toward(anim.scale.x, spr_scale.x,  delta * 1.5);
	


# func Get_Landing_SlideTime(xVel):
#	var bonus = 1;
#	if(movementData.onSlidyFloor):
#		bonus = 3;
#	if xVel > 300:
#		return 0.2 * bonus;
#	elif xVel > 200:
#		return 0.1  * bonus;
#	elif xVel > 100:
#		return 0.05  * bonus;
#	return 0.01;

func _on_animated_sprite_2d_animation_finished():
	if currentAnimationState == AnimationState.LAND:
		currentAnimationState = AnimationState.IDLE;

func _on_hazard_detector_body_entered(body):
	movementData.alive = false;
	# emit_signal("signalEnd");


func _on_hazard_detector_area_entered(area):
	movementData.alive = false;
	# emit_signal("signalEnd");


func AddForce(dir, speed):
	velocity += dir * speed;


# func SlidyFloor():
#	var prevNotOnSlidyFloor = movementData.onSlidyFloor;
#	if (movementData.onSlidyFloor):
#		movementData.sliding = true;
#		if(!slide_time.is_stopped()):
#			slide_time.stop();
#		slide_time.start();
#		if(movementData.onSlidyFloor and !prevNotOnSlidyFloor):
#			movementData.slidyFloorMovementMod = 1.5;
#	elif (movementData.slidyFloorMovementMod != 1):
#		movementData.slidyFloorMovementMod = 1;
#
#	slide_particles.emitting = true if (movementData.sliding and movementData.onfloor) else false;
		

#func _on_ice_detector_body_entered(body):
#	movementData.onSlidyFloor = true;


#func _on_ice_detector_body_exited(body):
#	movementData.onSlidyFloor = false;
#	var normDir = velocity.normalized();
#	normDir.y = 0;
#	var bonus = Get_Ice_ReleaseSpeedBonus(velocity.x);
#	velocity += normDir * bonus;
#
#
#func Get_Ice_ReleaseSpeedBonus(xVel):
#	if xVel > 100:
#		return 50;
#	return 25;
#
#func GetCam() -> Node2D:
#	return cam;
