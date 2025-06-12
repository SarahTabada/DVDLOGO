def tick args

  #args.outputs.solids << {
  #  x: 0,
  #  y: 0,
  #  w: args.grid.w,
  #  h: args.grid.h,
  #  r: 48,
  #  g: 25,
  #  b: 52, 
  #}

  args.state.player_x ||= 200
  args.state.player_y ||= 280
  args.state.velocity_x ||= 2
  args.state.velocity_y ||= 2
  player_w = 100
  player_h = 80

  args.state.player_x += args.state.velocity_x
  args.state.player_y += args.state.velocity_y

  if args.state.player_x + player_w > args.grid.w || args.state.player_x < 0
    args.state.velocity_x = -args.state.velocity_x
  end
  
  if args.state.player_y + player_h > args.grid.h || args.state.player_y < 0
    args.state.velocity_y = -args.state.velocity_y
  end

  if args.state.player_x +  player_w > args.grid.w
    args.state.player_x = args.grid.w - player_w
  end

  if args.state.player_x < 0
    args.state.player_x = 0
  end

  if args.state.player_y + player_h > args.grid.h
    args.state.player_y = args.grid.h - player_h
  end

  if args.state.player_y < 0
    args.state.player_y = 0
  end

  if args.inputs.keyboard.key_up.space
    args.grid.w -= 20
    args.grid.h -= 20
  end

args.outputs.sprites << [args.state.player_x, args.state.player_y, player_w, player_h, 'sprites/dvdlogo.png']
end
