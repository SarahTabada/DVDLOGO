def tick args
  # Restart the application when the spacebar is pressed
  if args.inputs.keyboard.key_down.space
    args.state.clear! # Reset the game state
    return
  end

  args.state.block ||= { x: 640,
                         y: 360,
                         w: 64,
                         h: 64,
                         path: "sprites/block.png",
                         dx: 5,
                         dy: 5 }

  args.state.boundaries ||= [
    { target: {x: 0, y: 0, w: 5, h: 720}, growth_direction: {x: 0, y: 0, w: 2, h: 0}, min_size: {w:5, h: 720}, bouncedir: {x: 5, y: 0}, x: 0, y: 0, w: 5, h: 720, path: :solid, r: 100, g: 149, b: 237, maxclicks:65 },
    { target: {x: 1275, y: 0, w: 5, h: 720}, growth_direction: {x: -2, y: 0, w: 2, h: 0}, min_size: {w:5, h: 720}, bouncedir: {x: -5, y: 0}, x: 1275, y: 0, w: 5, h: 720, path: :solid, r: 100, g: 149, b: 237, maxclicks:65 },
    { target: {x: 0, y: 0, w: 1280, h: 5}, growth_direction: {x: 0, y: 0, w: 0, h: 2}, min_size: {w:1280, h: 5}, bouncedir: {x: 0, y: 5}, x: 0, y: 0, w: 1280, h: 5, path: :solid, r: 141, g: 79, b: 58, maxclicks:100000 },
    { target: {x: 0, y: 715, w: 1280, h: 5}, growth_direction: {x: 0, y: -2, w: 0, h: 2}, min_size: {w:1280, h: 5}, bouncedir: {x: 0, y: -5}, x: 0, y: 715, w: 1280, h: 5, path: :solid, r: 100, g: 149, b: 237, maxclicks:100000 },
  ]

  args.state.numclicks ||= 0
  args.outputs.sprites << args.state.boundaries
  args.outputs.sprites << args.state.block

  block = args.state.block

  # Check if any boundaries are still shrinking
  any_boundary_shrinking = false
  
  args.state.boundaries.each do |boundary|
    # Calculate where this boundary should stop based on block position
    should_shrink = true
    
    if boundary.bouncedir[:x] == 5  # Left wall
      # Stop when the right edge would touch the block's left edge
      should_shrink = (boundary.target.x + boundary.target.w + boundary.growth_direction.w) < block.x
    elsif boundary.bouncedir[:x] == -5  # Right wall  
      # Stop when the left edge would touch the block's right edge
      should_shrink = (boundary.target.x + boundary.growth_direction.x) > (block.x + block.w) - 2
    elsif boundary.bouncedir[:y] == 5  # Bottom wall
      # Stop when the top edge would touch the block's bottom edge  
      should_shrink = (boundary.target.y + boundary.target.h + boundary.growth_direction.h) < block.y 
    elsif boundary.bouncedir[:y] == -5  # Top wall
      # Stop when the bottom edge would touch the block's top edge
      should_shrink = (boundary.target.y + boundary.growth_direction.y) > (block.y + block.h)
    end

    # Only shrink if we haven't reached the block and we're above minimum size
    if should_shrink && 
       boundary.target.w + boundary.growth_direction.w >= boundary.min_size[:w] &&
       boundary.target.h + boundary.growth_direction.h >= boundary.min_size[:h]
      boundary.target.x += boundary.growth_direction.x
      boundary.target.y += boundary.growth_direction.y
      boundary.target.w += boundary.growth_direction.w
      boundary.target.h += boundary.growth_direction.h
      any_boundary_shrinking = true
    end
  end

  # Only move and bounce block if boundaries are still shrinking
  if any_boundary_shrinking
    # Move block first
    args.state.block.x += args.state.block.dx
    args.state.block.y += args.state.block.dy

    # Check for collisions with the actual boundary positions (not targets)
    args.state.boundaries.each do |boundary|
      if Geometry.intersect_rect?(args.state.block, boundary)
        if boundary.bouncedir.x != 0
          args.state.block.dx = boundary.bouncedir.x 
        else
          args.state.block.dy = boundary.bouncedir.y
        end
      end
    end
  end
    
  args.state.boundaries.each do |boundary|
    boundary.x = boundary.x.lerp(boundary.target.x, 0.1)
    boundary.y = boundary.y.lerp(boundary.target.y, 0.1)
    boundary.w = boundary.w.lerp(boundary.target.w, 0.1)
    boundary.h = boundary.h.lerp(boundary.target.h, 0.1)
  end
end