def tick args
  args.state.star ||= { x: 640,
                       y: 360,
                       w: 40,
                       h: 40,
                       path: "sprites/star.png",
                       source_x: 64,      # Start further in to skip transparent padding
                       source_y: 64,      # Start further in to skip transparent padding
                       source_w: 704,     # Use the actual star width (adjust as needed)
                       source_h: 704,     # Use the actual star height (adjust as needed)
                       dx: 5,
                       dy: 5}

  args.state.boundaries ||= [
    { target: {x: 0, y: 0, w: 5, h: 720}, growth_direction: {x: 0, y: 0, w: 2, h: 0}, min_size: {w:5, h: 720}, bouncedir: {x: 5, y: 0}, x: 0, y: 0, w: 5, h: 720, path: :solid, r: 0, g: 0, b: 0, maxclicks:65},
    { target: {x: 1275, y: 0, w: 5, h: 720}, growth_direction: {x: -2, y: 0, w: 2, h: 0}, min_size: {w:5, h: 720}, bouncedir: {x: -5, y: 0}, x: 1275, y: 0, w: 5, h: 720, path: :solid, r: 0, g: 0, b: 0, maxclicks:65},
    { target: {x: 0, y: 0, w: 1280, h: 5}, growth_direction: {x: 0, y: 0, w: 0, h: 2}, min_size: {w:1280, h: 5}, bouncedir: {x: 0, y: 5}, x: 0, y: 0, w: 1280, h: 5, path: :solid, r: 0, g: 0, b: 0, maxclicks:100000},
    { target: {x: 0, y: 715, w: 1280, h: 5}, growth_direction: {x: 0, y: -2, w: 0, h: 2}, min_size: {w:1280, h: 5}, bouncedir: {x: 0, y: -5}, x: 0, y: 715, w: 1280, h: 5, path: :solid, r: 0, g: 0, b: 0, maxclicks:100000},
  ] 

  args.state.numclicks ||= 0
  args.outputs.sprites << args.state.boundaries
  args.outputs.sprites << args.state.star

  star = args.state.star

  # Check if any boundaries are still shrinking
  any_boundary_shrinking = false
  
  args.state.boundaries.each do |boundary|
    # Calculate where this boundary should stop based on star position
    should_shrink = true
    
    if boundary.bouncedir[:x] == 5  # Left wall
      # Stop when the right edge would touch the star's left edge
      should_shrink = (boundary.target.x + boundary.target.w + boundary.growth_direction.w) < star.x
    elsif boundary.bouncedir[:x] == -5  # Right wall  
      # Stop when the left edge would touch the star's right edge
      should_shrink = (boundary.target.x + boundary.growth_direction.x) > (star.x + star.w)
    elsif boundary.bouncedir[:y] == 5  # Bottom wall
      # Stop when the top edge would touch the star's bottom edge  
      should_shrink = (boundary.target.y + boundary.target.h + boundary.growth_direction.h) < star.y
    elsif boundary.bouncedir[:y] == -5  # Top wall
      # Stop when the bottom edge would touch the star's top edge
      should_shrink = (boundary.target.y + boundary.growth_direction.y) > (star.y + star.h)
    end

    # Only shrink if we haven't reached the star and we're above minimum size
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

  # Only move and bounce star if boundaries are still shrinking
  if any_boundary_shrinking
    # Move star first
    args.state.star.x += args.state.star.dx
    args.state.star.y += args.state.star.dy

    # Check for collisions with the actual boundary positions (not targets)
    args.state.boundaries.each do |boundary|
      if Geometry.intersect_rect?(args.state.star, boundary)
        if boundary.bouncedir.x != 0
          args.state.star.dx = boundary.bouncedir.x 
        else
          args.state.star.dy = boundary.bouncedir.y
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